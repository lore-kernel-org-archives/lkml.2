Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1GUQcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:32:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:39999 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1GUQct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:32:49 -0400
Subject: Re: sched: fix/optimise some issues
From: Peter Zijlstra <peterz@infradead.org>
To: Stephan =?ISO-8859-1?Q?B=E4rwolf?= 
	<stephan.baerwolf@tu-ilmenau.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4E28557A.7040704@tu-ilmenau.de>
References: <4E26DB41.9070002@tu-ilmenau.de>
	 <1311260895.29152.153.camel@twins>  <4E28557A.7040704@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 18:32:47 +0200
Message-ID: <1311265967.29152.160.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 18:36 +0200, Stephan Bärwolf wrote:
> > Right, so I've often wanted a [us]128 type, and gcc has some (broken?)
> > support for that, but overhead has always kept me from it.
> 128bit sched_vruntime_t support seems to be running fine, when compiled with
> gcc (Gentoo 4.4.5 p1.2, pie-0.4.5) 4.4.5.
> Of course overhead is a problem (but there is also overhead using u64 on
> x86),

Yeah, I know, but luckily all 32bit computing shall die sooner rather
than later. But there really wasn't much choice there anyway, 32bit
simply won't do.

> that is why it should be Kconfig selectable (for servers with many
> processes,
> deep cgroups and many different priorities?).

Sadly that's not how things work in practice, distro's will have to
enable the option and that means that pretty much everybody runs it. The
whole cgroup crap is already _way_ too expensive. 

> But I think also abstracting the whole vruntime-stuff into a seperate
> collection
> simplifies further evaluations and adpations. (Think of central
> statistics collection
> for example maximum timeslice seen or happened overflows - without changing
> all the lines of code with the risk of missing sth.)

It made rather a mess of things,

> > There's also the non-atomicy thing to consider, see min_vruntime_copy
> > etc.
> I think atomicy is not an (great) issue, because of two reasons:
>     a) on x86 the u64 wouldn't be atomic, too (vruntime is u64 not
> atomic64_t)

atomic64_t isn't needed in order to guarantee consistent loads, Linux
depends on the fact that all naturally aligned loads are complete loads
(no partials etc.).

>     b) every operation on cfs_rq->min_vruntime should happen, when
>         holding the runqueue-lock?. 

---
commit 3fe1698b7fe05aeb063564e71e40d09f28d8e80c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue Apr 5 17:23:48 2011 +0200

    sched: Deal with non-atomic min_vruntime reads on 32bits
    
    In order to avoid reading partial updated min_vruntime values on 32bit
    implement a seqcount like solution.
    
    Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Nick Piggin <npiggin@kernel.dk>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Link: http://lkml.kernel.org/r/20110405152729.111378493@chello.nl
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
index 46f42ca..7a5eb26 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -312,6 +312,9 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
+#endif
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ad4c414f..054cebb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -358,6 +358,10 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 	}
 
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+#ifndef CONFIG_64BIT
+	smp_wmb();
+	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
+#endif
 }
 
 /*
@@ -1376,10 +1380,21 @@ static void task_waking_fair(struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 min_vruntime;
 
-	lockdep_assert_held(&task_rq(p)->lock);
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
 
-	se->vruntime -= cfs_rq->min_vruntime;
+	do {
+		min_vruntime_copy = cfs_rq->min_vruntime_copy;
+		smp_rmb();
+		min_vruntime = cfs_rq->min_vruntime;
+	} while (min_vruntime != min_vruntime_copy);
+#else
+	min_vruntime = cfs_rq->min_vruntime;
+#endif
+
+	se->vruntime -= min_vruntime;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED

