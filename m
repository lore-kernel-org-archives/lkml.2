Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2KTI5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:57:18 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:51317 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2KTI5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:57:17 -0500
Message-ID: <50AB45EA.2050507@monom.org>
Date: Tue, 20 Nov 2012 09:57:14 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] netprio_cgroup: allow nesting and inherit config
 on cgroup creation
References: <1353400211-5182-1-git-send-email-tj@kernel.org> <1353400211-5182-8-git-send-email-tj@kernel.org>
In-Reply-To: <1353400211-5182-8-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 20.11.2012 09:30, Tejun Heo wrote:
> Inherit netprio configuration from ->css_online(), allow nesting and
> remove .broken_hierarchy marking.  This makes netprio_cgroup's
> behavior match netcls_cgroup's.
>
> Note that this patch changes userland-visible behavior.  Nesting is
> allowed and the first level cgroups below the root cgroup behave
> differently - they inherit priorities from the root cgroup on creation
> instead of starting with 0.  This is unfortunate but not doing so is
> much crazier.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Tested and Acked-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

> ---
>   Documentation/cgroups/net_prio.txt |  2 ++
>   net/core/netprio_cgroup.c          | 42 ++++++++++++++++++++++----------------
>   2 files changed, 26 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/cgroups/net_prio.txt b/Documentation/cgroups/net_prio.txt
> index 01b3226..a82cbd2 100644
> --- a/Documentation/cgroups/net_prio.txt
> +++ b/Documentation/cgroups/net_prio.txt
> @@ -51,3 +51,5 @@ One usage for the net_prio cgroup is with mqprio qdisc allowing application
>   traffic to be steered to hardware/driver based traffic classes. These mappings
>   can then be managed by administrators or other networking protocols such as
>   DCBX.
> +
> +A new net_prio cgroup inherits the parent's configuration.
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index b2af0d0..bde53da 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -136,9 +136,6 @@ static struct cgroup_subsys_state *cgrp_css_alloc(struct cgroup *cgrp)
>   {
>   	struct cgroup_netprio_state *cs;
>
> -	if (cgrp->parent && cgrp->parent->id)
> -		return ERR_PTR(-EINVAL);
> -
>   	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
>   	if (!cs)
>   		return ERR_PTR(-ENOMEM);
> @@ -146,16 +143,34 @@ static struct cgroup_subsys_state *cgrp_css_alloc(struct cgroup *cgrp)
>   	return &cs->css;
>   }
>
> -static void cgrp_css_free(struct cgroup *cgrp)
> +static int cgrp_css_online(struct cgroup *cgrp)
>   {
> -	struct cgroup_netprio_state *cs = cgrp_netprio_state(cgrp);
> +	struct cgroup *parent = cgrp->parent;
>   	struct net_device *dev;
> +	int ret = 0;
> +
> +	if (!parent)
> +		return 0;

BTW, parent is always != NULL, because the root cgroup will be attached 
to the dummytop cgroup.

This is the reason why there are this check in netprio_prio()

static u32 netprio_prio(struct cgroup *cgrp, struct net_device *dev)
{
	struct netprio_map *map = rcu_dereference_rtnl(dev->priomap);

	if (map && cgrp->id < map->priomap_len)
		return map->priomap[cgrp->id];

is necessary.

cheer,
daniel
