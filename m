Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2KTIq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:46:26 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:51279 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2KTIqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:46:24 -0500
Message-ID: <50AB435E.8060901@monom.org>
Date: Tue, 20 Nov 2012 09:46:22 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] netprio_cgroup: reimplement priomap expansion
References: <1353400211-5182-1-git-send-email-tj@kernel.org> <1353400211-5182-5-git-send-email-tj@kernel.org>
In-Reply-To: <1353400211-5182-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 20.11.2012 09:30, Tejun Heo wrote:
> netprio kept track of the highest prioidx allocated and resized
> priomaps accordingly when necessary.  This makes it necessary to keep
> track of prioidx allocation and may end up resizing on every new
> prioidx.
> 
> Update extend_netdev_table() such that it takes @target_idx which the
> priomap should be able to accomodate.  If the priomap is large enough,
> nothing happens; otherwise, the size is doubled until @target_idx can
> be accomodated.
> 
> This makes max_prioidx and write_update_netdev_table() unnecessary.
> write_priomap() now calls extend_netdev_table() directly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
>   net/core/netprio_cgroup.c | 56 ++++++++++++++++++++++++++++-------------------
>   1 file changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index 92cc54c..569d83d 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -27,11 +27,11 @@
>   
>   #include <linux/fdtable.h>
>   
> +#define PRIOMAP_MIN_SZ		128
>   #define PRIOIDX_SZ 128
>   
>   static unsigned long prioidx_map[PRIOIDX_SZ];
>   static DEFINE_SPINLOCK(prioidx_map_lock);
> -static atomic_t max_prioidx = ATOMIC_INIT(0);
>   
>   static inline struct cgroup_netprio_state *cgrp_netprio_state(struct cgroup *cgrp)
>   {
> @@ -51,8 +51,6 @@ static int get_prioidx(u32 *prio)
>   		return -ENOSPC;
>   	}
>   	set_bit(prioidx, prioidx_map);
> -	if (atomic_read(&max_prioidx) < prioidx)
> -		atomic_set(&max_prioidx, prioidx);
>   	spin_unlock_irqrestore(&prioidx_map_lock, flags);
>   	*prio = prioidx;
>   	return 0;
> @@ -67,15 +65,40 @@ static void put_prioidx(u32 idx)
>   	spin_unlock_irqrestore(&prioidx_map_lock, flags);
>   }
>   
> -static int extend_netdev_table(struct net_device *dev, u32 new_len)
> +/*
> + * Extend @dev->priomap so that it's large enough to accomodate
> + * @target_idx.  @dev->priomap.priomap_len > @target_idx after successful
> + * return.  Must be called under rtnl lock.
> + */
> +static int extend_netdev_table(struct net_device *dev, u32 target_idx)
>   {
> -	size_t new_size = sizeof(struct netprio_map) +
> -			   ((sizeof(u32) * new_len));
> -	struct netprio_map *new = kzalloc(new_size, GFP_KERNEL);
> -	struct netprio_map *old;
> +	struct netprio_map *old, *new;
> +	size_t new_sz, new_len;
>   
> +	/* is the existing priomap large enough? */
>   	old = rtnl_dereference(dev->priomap);
> +	if (old && old->priomap_len > target_idx)
> +		return 0;
> +
> +	/*
> +	 * Determine the new size.  Let's keep it power-of-two.  We start
> +	 * from PRIOMAP_MIN_SZ and double it until it's large enough to
> +	 * accommodate @target_idx.
> +	 */
> +	new_sz = PRIOMAP_MIN_SZ;
> +	while (true) {
> +		new_len = (new_sz - offsetof(struct netprio_map, priomap)) /
> +			sizeof(new->priomap[0]);
> +		if (new_len > target_idx)
> +			break;
> +		new_sz *= 2;
> +		/* overflowed? */
> +		if (WARN_ON(new_sz < PRIOMAP_MIN_SZ))
> +			return -ENOSPC;
> +	}
>   
> +	/* allocate & copy */
> +	new = kzalloc(new_sz, GFP_KERNEL);
>   	if (!new) {
>   		pr_warn("Unable to alloc new priomap!\n");
>   		return -ENOMEM;
> @@ -87,26 +110,13 @@ static int extend_netdev_table(struct net_device *dev, u32 new_len)
>   
>   	new->priomap_len = new_len;
>   
> +	/* install the new priomap */
>   	rcu_assign_pointer(dev->priomap, new);
>   	if (old)
>   		kfree_rcu(old, rcu);
>   	return 0;
>   }

Okay, I might be just to stupid to see the beauty in what you are doing. So
please bear with me when I ask these question.

struct netprio_map {
	struct rcu_head rcu;
	struct netprio_aux *aux;	/* auxiliary config array */
	u32 priomap_len;
	u32 priomap[];
};

Is there a specific reason why aux and priomap is handled differently? Couldn't you 
just use same approach for both variables, e.g. re/allocating only them here and
leave the allocation struct netprio_map in cgrp_css_alloc()?

Also the algorithm to figure out the size of the array might be a bit too aggressive
in my opinion. So you always start at PRIOMAP_MIN_SIZE and then try to double
the size until target_idx fits. Wouldn't it make sense to start to look
for the new size beginning at old->priomap_len and then do the power-of-two
increase?

cheers,
daniel
