Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1GLQDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:03:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:63201 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1GLQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:03:40 -0400
Date: Tue, 12 Jul 2011 12:03:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712160324.GA1186@dumpdata.com>
References: <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712144936.GD2326@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E1C7057.00B3:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > http://darnok.org/xen/cpu1.log
> 
> OK, a fair amount of variety, then lots and lots of task_waking_fair(),
> so I still feel good about asking you for the following.
.. snup..
> Hmmm...  Given that this is persisting for many many seconds, it might
> be better to check for at least 10,000,000 passes.  In contrast, 1000
> passes might elapse just waiting for a cache miss to complete.

Changed it to that large number. This is the diff I used:

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 433491c..e185c04 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1392,14 +1392,19 @@ static void task_waking_fair(struct task_struct *p)
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 	u64 min_vruntime;
+	u64 loop_cnt = 0UL;
 
 #ifndef CONFIG_64BIT
 	u64 min_vruntime_copy;
-
+	loop_cnt = 0UL;
 	do {
 		min_vruntime_copy = cfs_rq->min_vruntime_copy;
 		smp_rmb();
 		min_vruntime = cfs_rq->min_vruntime;
+		if (loop_cnt++ > 10000000) {
+			printk(KERN_INFO "POKE!\n");
+			loop_cnt = 0UL;
+		}
 	} while (min_vruntime != min_vruntime_copy);
 #else
 	min_vruntime = cfs_rq->min_vruntime;

And the log is:
http://darnok.org/xen/loop_cnt.log

which seems to imply that we are indeed stuck in that loop
forever.

> 
> Other possible causes include:

What is really strange is that I can only reproduce this on 32-bit builds.
> 
> o	A mismatch between Xen's and RCU's ideas of how CONFIG_NO_HZ
> 	works.  If Xen thinks that the CPU is in CONFIG_NO_HZ's
> 	dyntick-idle mode, but RCU thinks otherwise, the grace period
> 	might stall.

One sure way to figure this out is to disable CONFIG_NO_HZ right?
Or will that take away task_waking_fair case as well?
> 
> o	Problems due to portions of the code attempting to use
> 	RCU read-side critical sections while in dyntick-idle mode.
> 	Frederic Weisbecker has located some of these, (though not yet
> 	in Xen) and he has some diagnositics which may be found at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> 
> 	on branch eqscheck.2011.07.08a.
> 
> 	You need to enable CONFIG_PROVE_RCU for these diagnostics to
> 	be executed.

Ok, let me try those too.
> 
> o	As always, there might be bugs in RCU.  ;-)
> 
> But the loop in task_waking_fair() looks like the most prominent smoking
> gun at the moment.
