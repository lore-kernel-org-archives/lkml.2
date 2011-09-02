Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab1IBAoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:44:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43953 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773Ab1IBAoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:44:05 -0400
Date: Thu, 1 Sep 2011 17:42:31 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state
 setting	bug in freezer_change_state()
Message-ID: <20110902004231.GF1919@count0.beaverton.ibm.com>
References: <20110831102100.GA2828@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831102100.GA2828@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11090200-6078-0000-0000-0000004EE97F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 12:21:07PM +0200, Tejun Heo wrote:
> d02f52811d0e "cgroup_freezer: prepare for removal of TIF_FREEZE" moved
> setting of freezer->state into freezer_change_state(); unfortunately,
> while doing so, when it's beginning to freeze tasks, it sets the state
> to CGROUP_FROZEN instead of CGROUP_FREEZING ending up skipping the
> whole freezing state.  Fix it.
> 
> -v2: Oleg pointed out that re-freezing FROZEN cgroup could increment
>      system_freezing_cnt.  Fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
> I'm in the process of moving and can only use a quite old laptop.  I
> tested compile but couldn't really do much else, so please proceed
> with caution.  Oleg, can you please ack the patches if you agree with
> the updated versions?
> 
> Thanks.
> 
>  kernel/cgroup_freezer.c |   20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> Index: work/kernel/cgroup_freezer.c
> ===================================================================
> --- work.orig/kernel/cgroup_freezer.c
> +++ work/kernel/cgroup_freezer.c
> @@ -308,24 +308,26 @@ static int freezer_change_state(struct c
>  	spin_lock_irq(&freezer->lock);
> 
>  	update_if_frozen(cgroup, freezer);
> -	if (goal_state == freezer->state)
> -		goto out;
> -
> -	freezer->state = goal_state;
> 
>  	switch (goal_state) {
>  	case CGROUP_THAWED:
> -		atomic_dec(&system_freezing_cnt);
> -		unfreeze_cgroup(cgroup, freezer);
> +		if (freezer->state != CGROUP_THAWED) {
> +			freezer->state = CGROUP_THAWED;
> +			atomic_dec(&system_freezing_cnt);
> +			unfreeze_cgroup(cgroup, freezer);
> +		}
>  		break;
>  	case CGROUP_FROZEN:
> -		atomic_inc(&system_freezing_cnt);
> -		retval = try_to_freeze_cgroup(cgroup, freezer);
> +		if (freezer->state == CGROUP_THAWED) {
> +			freezer->state = CGROUP_FREEZING;
> +			atomic_inc(&system_freezing_cnt);
> +			retval = try_to_freeze_cgroup(cgroup, freezer);

This still doesn't look quite right. If the cgroup is FREEZING it should
also call try_to_freeze_cgroup(). I think this is what's needed:

		if (freezer->state == CGROUP_THAWED)
			atomic_inc(&system_freezing_cnt);
		freezer->state = CGROUP_FREEZING;
		retval = try_to_freeze_cgroup(cgroup, freezer);

> +		}
>  		break;
>  	default:
>  		BUG();
>  	}

Cheers,
	-Matt Helsley

