Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2EAQod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:44:33 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45383 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab2EAQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:44:30 -0400
Date: Tue, 1 May 2012 09:43:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
Message-ID: <20120501164343.GI2441@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120427161727.27082.43096.stgit@abhimanyu>
 <20120427162401.27082.59387.stgit@abhimanyu>
 <4F9D32B4.8040002@redhat.com>
 <1335865176.13683.120.camel@twins>
 <4F9FBF38.2060903@redhat.com>
 <1335869827.13683.133.camel@twins>
 <4F9FD337.5010908@redhat.com>
 <1335885292.13683.150.camel@twins>
 <4FA002F4.8000508@redhat.com>
 <1335889006.13683.162.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335889006.13683.162.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050116-4242-0000-0000-00000183745B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 06:16:46PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-01 at 18:36 +0300, Avi Kivity wrote:
> 
> > > > What bounds the amount of memory waiting to be freed during an rcu grace
> > > > period?
> > >
> > > Most RCU implementations don't have limits, so that could be quite a
> > > lot. I think preemptible RCU has a batch limit at which point it tries
> > > rather hard to force a grace period, but I'm not sure if even that
> > > provides a hard limit.

All the TREE_RCU variants will get more aggressive about forcing grace
periods if any given CPU has more than 10,000 callbacks posted.  When this
happens, the call_rcu() variants will try to push things ahead.

> > > Practically though, I haven't had reports of PPC/Sparc going funny
> > > because of this.
> > 
> > It could be considered a DoS if a user is able to free page tables
> > faster than rcu is able to recycle them, possibly triggering the oom
> > killer (should that force a grace period before firing from the hip?)
> 
> One would think that would be a good thing, yes. However I cannot seem
> to find anything like that in the current OOM killer. David, Paul, I
> seem to have vague recollections of a discussion about RCU vs OOM, what
> was the resolution (if anything) and would something like the below make
> sense?
> 
> ---
>  mm/oom_kill.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 46bf2ed5..244a371 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -607,6 +607,9 @@ int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
>  	struct zone *zone;
>  	int ret = 1;
>  
> +	synchronize_sched();
> +	synchronize_rcu();

This will wait for a grace period, but not for the callbacks, which are
the things that actually free the memory.  Given that, should we instead
do something like:

	rcu_barrier();

Note that rcu_barrier() and rcu_barrier_sched() are one and the same
for CONFIG_PREEMPT=n kernels, and there seems to be a lot more
call_rcu() than call_rcu_sched(), so I left out the rcu_barrier_sched().

That said, this does have the effect of delaying the startup of the OOM
killer, and it does nothing to tell RCU that accelerating grace periods
would be a good thing.  If DoS attack is a theoretical possibility rather
than a real bug, is a pure wait on RCU the right approach.

Alternative approaches include:

1.	OOM killer calls into RCU, which arranges to become more
	aggressive about forcing grace periods.  (For example, RCU
	could set a flag that caused it to act as if there were
	lots of callbacks posted.)

2.	RCU provides an API that forces grace periods, perhaps
	invoked from a separate kthread so that the OOM killer can
	proceed in parallel with RCU's grace-period forcing.

3.	Like #2, but invoke it a bit earlier than the OOM killer
	would normally start running.

						Thanx, Paul

>  	spin_lock(&zone_scan_lock);
>  	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
>  		if (zone_is_oom_locked(zone)) {
> 

