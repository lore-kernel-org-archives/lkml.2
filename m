Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab2KHEm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:42:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42193 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2KHEmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:42:55 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509B382E.4030707@jp.fujitsu.com>
Date: Thu, 08 Nov 2012 13:42:22 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 7/9] cgroup_freezer: introduce CGROUP_FREEZING_[SELF|PARENT]
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-8-git-send-email-tj@kernel.org>
In-Reply-To: <1351931915-1701-8-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/03 17:38), Tejun Heo wrote:
> Introduce FREEZING_SELF and FREEZING_PARENT and make FREEZING OR of
> the two flags.  This is to prepare for full hierarchy support.
>
> freezer_apply_date() is updated such that it can handle setting and
> clearing of both flags.  The two flags are also exposed to userland
> via read-only files self_freezing and parent_freezing.
>
> Other than the added cgroupfs files, this patch doesn't introduce any
> behavior change.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

What is the purpose of FREEZING_SELG/PARENT, having 2 flags and
make it visible to users ?

Thanks,
-Kame



> ---
>   kernel/cgroup_freezer.c | 55 ++++++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 47 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index e76aa9f..b8ad93c 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -23,8 +23,12 @@
>   #include <linux/seq_file.h>
>
>   enum freezer_state_flags {
> -	CGROUP_FREEZING		= (1 << 1), /* this freezer is freezing */
> +	CGROUP_FREEZING_SELF	= (1 << 1), /* this freezer is freezing */
> +	CGROUP_FREEZING_PARENT	= (1 << 2), /* the parent freezer is freezing */
>   	CGROUP_FROZEN		= (1 << 3), /* this and its descendants frozen */
> +
> +	/* mask for all FREEZING flags */
> +	CGROUP_FREEZING		= CGROUP_FREEZING_SELF | CGROUP_FREEZING_PARENT,
>   };
>
>   struct freezer {
> @@ -245,8 +249,13 @@ static void unfreeze_cgroup(struct freezer *freezer)
>    * freezer_apply_state - apply state change to a single cgroup_freezer
>    * @freezer: freezer to apply state change to
>    * @freeze: whether to freeze or unfreeze
> + * @state: CGROUP_FREEZING_* flag to set or clear
> + *
> + * Set or clear @state on @cgroup according to @freeze, and perform
> + * freezing or thawing as necessary.
>    */
> -static void freezer_apply_state(struct freezer *freezer, bool freeze)
> +static void freezer_apply_state(struct freezer *freezer, bool freeze,
> +				unsigned int state)
>   {
>   	/* also synchronizes against task migration, see freezer_attach() */
>   	lockdep_assert_held(&freezer->lock);
> @@ -254,13 +263,19 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze)
>   	if (freeze) {
>   		if (!(freezer->state & CGROUP_FREEZING))
>   			atomic_inc(&system_freezing_cnt);
> -		freezer->state |= CGROUP_FREEZING;
> +		freezer->state |= state;
>   		freeze_cgroup(freezer);
>   	} else {
> -		if (freezer->state & CGROUP_FREEZING)
> -			atomic_dec(&system_freezing_cnt);
> -		freezer->state &= ~(CGROUP_FREEZING | CGROUP_FROZEN);
> -		unfreeze_cgroup(freezer);
> +		bool was_freezing = freezer->state & CGROUP_FREEZING;
> +
> +		freezer->state &= ~state;
> +
> +		if (!(freezer->state & CGROUP_FREEZING)) {
> +			if (was_freezing)
> +				atomic_dec(&system_freezing_cnt);
> +			freezer->state &= ~CGROUP_FROZEN;
> +			unfreeze_cgroup(freezer);
> +		}
>   	}
>   }
>
> @@ -275,7 +290,7 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
>   {
>   	/* update @freezer */
>   	spin_lock_irq(&freezer->lock);
> -	freezer_apply_state(freezer, freeze);
> +	freezer_apply_state(freezer, freeze, CGROUP_FREEZING_SELF);
>   	spin_unlock_irq(&freezer->lock);
>   }
>
> @@ -295,6 +310,20 @@ static int freezer_write(struct cgroup *cgroup, struct cftype *cft,
>   	return 0;
>   }
>
> +static u64 freezer_self_freezing_read(struct cgroup *cgroup, struct cftype *cft)
> +{
> +	struct freezer *freezer = cgroup_freezer(cgroup);
> +
> +	return (bool)(freezer->state & CGROUP_FREEZING_SELF);
> +}
> +
> +static u64 freezer_parent_freezing_read(struct cgroup *cgroup, struct cftype *cft)
> +{
> +	struct freezer *freezer = cgroup_freezer(cgroup);
> +
> +	return (bool)(freezer->state & CGROUP_FREEZING_PARENT);
> +}
> +
>   static struct cftype files[] = {
>   	{
>   		.name = "state",
> @@ -302,6 +331,16 @@ static struct cftype files[] = {
>   		.read_seq_string = freezer_read,
>   		.write_string = freezer_write,
>   	},
> +	{
> +		.name = "self_freezing",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.read_u64 = freezer_self_freezing_read,
> +	},
> +	{
> +		.name = "parent_freezing",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.read_u64 = freezer_parent_freezing_read,
> +	},
>   	{ }	/* terminate */
>   };
>
>


