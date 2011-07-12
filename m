Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1GLRWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:22:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60626 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab1GLRWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:22:10 -0400
Date: Tue, 12 Jul 2011 09:39:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712163947.GF2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712160324.GA1186@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712160324.GA1186@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 12:03:24PM -0400, Konrad Rzeszutek Wilk wrote:
> > > http://darnok.org/xen/cpu1.log
> > 
> > OK, a fair amount of variety, then lots and lots of task_waking_fair(),
> > so I still feel good about asking you for the following.
> .. snup..
> > Hmmm...  Given that this is persisting for many many seconds, it might
> > be better to check for at least 10,000,000 passes.  In contrast, 1000
> > passes might elapse just waiting for a cache miss to complete.
> 
> Changed it to that large number. This is the diff I used:
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 433491c..e185c04 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1392,14 +1392,19 @@ static void task_waking_fair(struct task_struct *p)
>  	struct sched_entity *se = &p->se;
>  	struct cfs_rq *cfs_rq = cfs_rq_of(se);
>  	u64 min_vruntime;
> +	u64 loop_cnt = 0UL;
> 
>  #ifndef CONFIG_64BIT
>  	u64 min_vruntime_copy;
> -
> +	loop_cnt = 0UL;
>  	do {
>  		min_vruntime_copy = cfs_rq->min_vruntime_copy;
>  		smp_rmb();
>  		min_vruntime = cfs_rq->min_vruntime;
> +		if (loop_cnt++ > 10000000) {
> +			printk(KERN_INFO "POKE!\n");
> +			loop_cnt = 0UL;
> +		}
>  	} while (min_vruntime != min_vruntime_copy);
>  #else
>  	min_vruntime = cfs_rq->min_vruntime;
> 
> And the log is:
> http://darnok.org/xen/loop_cnt.log
> 
> which seems to imply that we are indeed stuck in that loop
> forever.

It does indeed, thank you!  Also it looks like interrupts are
disabled, and that timekeeping is similarly out of action.

> > Other possible causes include:
> 
> What is really strange is that I can only reproduce this on 32-bit builds.

Not strange at all.  If you have a 64-bit build, the function doesn't
have a loop.  ;-)

> > o	A mismatch between Xen's and RCU's ideas of how CONFIG_NO_HZ
> > 	works.  If Xen thinks that the CPU is in CONFIG_NO_HZ's
> > 	dyntick-idle mode, but RCU thinks otherwise, the grace period
> > 	might stall.
> 
> One sure way to figure this out is to disable CONFIG_NO_HZ right?
> Or will that take away task_waking_fair case as well?

Disabling CONFIG_NO_HZ would be an interesting test case.

> > o	Problems due to portions of the code attempting to use
> > 	RCU read-side critical sections while in dyntick-idle mode.
> > 	Frederic Weisbecker has located some of these, (though not yet
> > 	in Xen) and he has some diagnositics which may be found at:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > 
> > 	on branch eqscheck.2011.07.08a.
> > 
> > 	You need to enable CONFIG_PROVE_RCU for these diagnostics to
> > 	be executed.
> 
> Ok, let me try those too.

Thank you!

> > o	As always, there might be bugs in RCU.  ;-)
> > 
> > But the loop in task_waking_fair() looks like the most prominent smoking
> > gun at the moment.

And could you also please try out the patch that I posted earlier?

							Thaxn, Paul
