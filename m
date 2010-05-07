Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab0EGQWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:22:21 -0400
Received: from www.tglx.de ([62.245.132.106]:38812 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab0EGQWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:22:20 -0400
Date: Fri, 7 May 2010 18:20:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/4] futex: Add FUTEX_LOCK with optional adaptive
 spinning
In-Reply-To: <1273127060-30375-5-git-send-email-dvhltc@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain>
References: <1273127060-30375-1-git-send-email-dvhltc@us.ibm.com> <1273127060-30375-5-git-send-email-dvhltc@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Darren Hart wrote:

> Add a non-pi TID value based futex locking mechanism. This enables the
> use of adaptive spinning which was problematic with the basic FUTEX_WAIT
> operation.

You still do way too much work in that spin code with way too much
code lines.

Can you try the following (completely uncompiled/untested) patch ?

Thanks,

	tglx
Subject: futex-simplify.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 07 May 2010 17:56:38 +0200

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   42 ++++++++++++------------------------
 kernel/sched.c |   66 ---------------------------------------------------------
 2 files changed, 14 insertions(+), 94 deletions(-)

Index: linux-2.6-tip/kernel/futex.c
===================================================================
--- linux-2.6-tip.orig/kernel/futex.c
+++ linux-2.6-tip/kernel/futex.c
@@ -2406,11 +2406,10 @@ out:
  *  1 - Futex lock acquired
  * <0 - On error
  */
-static int trylock_futex_adaptive(u32 __user *uaddr, ktime_t *timeout)
+static int trylock_futex_adaptive(u32 __user *uaddr, struct hrtimer_sleeper *to)
 {
 	struct thread_info *owner = NULL;
 	pid_t curtid, ownertid = 0;
-	ktime_t now;
 	int ret = 0;
 	u32 curval;
 
@@ -2425,43 +2424,32 @@ static int trylock_futex_adaptive(u32 __
 		/*
 		 * Try to acquire the lock.
 		 */
-		if (curval == 0)
+		if (curval == 0) {
 			curval = cmpxchg_futex_value_locked(uaddr, 0, curtid);
 
-		if (curval == 0) {
-			ret = 1;
-			break;
-		}
+			if (curval == 0) {
+				ret = 1;
+				break;
+			}
 
-		if (unlikely(curval == -EFAULT)) {
-			ret = -EFAULT;
-			break;
+			if (unlikely(curval == -EFAULT)) {
+				ret = -EFAULT;
+				break;
+			}
 		}
 
-		/*
-		 * Futex locks manage the owner atomically. We are not in
-		 * danger of deadlock by preempting a pending owner. Abort the
-		 * loop if our time slice has expired.  RT Threads can spin
-		 * until they preempt the owner, at which point they will break
-		 * out of the loop anyway.
-		 */
-		if (need_resched())
+		if (to && !to->task) {
+			ret = -ETIMEOUT;
 			break;
-
-		if (timeout) {
-			now = ktime_get();
-			if (timeout->tv64 < now.tv64)
-				break;
 		}
 
-		cpu_relax();
-
 		if ((curval & FUTEX_TID_MASK) != ownertid) {
 			if (owner)
 				put_task_struct(owner->task);
 			owner = futex_owner(uaddr);
 		}
-		if (owner && !futex_spin_on_owner(uaddr, owner))
+
+		if (!owner->oncpu)
 			break;
 	}
 
@@ -2510,9 +2498,7 @@ static int futex_lock(u32 __user *uaddr,
 retry:
 #ifdef CONFIG_SMP
 	if (flags & FLAGS_ADAPTIVE) {
-		preempt_disable();
 		ret = trylock_futex_adaptive(uaddr, time);
-		preempt_enable();
 
 		/* We got the lock. */
 		if (ret == 1) {
Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -3821,72 +3821,6 @@ out:
 }
 #endif
 
-#ifdef CONFIG_FUTEX
-#include <linux/futex.h>
-
-int futex_spin_on_owner(u32 __user *uaddr, struct thread_info *owner)
-{
-	u32 ownertid, uval;
-	unsigned int cpu;
-	struct rq *rq;
-
-	if (!sched_feat(OWNER_SPIN))
-		return 0;
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	/*
-	 * Need to access the cpu field knowing that
-	 * DEBUG_PAGEALLOC could have unmapped it if
-	 * the mutex owner just released it and exited.
-	 */
-	if (probe_kernel_address(&owner->cpu, cpu))
-		goto out;
-#else
-	cpu = owner->cpu;
-#endif
-
-	/*
-	 * Even if the access succeeded (likely case),
-	 * the cpu field may no longer be valid.
-	 */
-	if (cpu >= nr_cpumask_bits)
-		goto out;
-
-	/*
-	 * We need to validate that we can do a
-	 * get_cpu() and that we have the percpu area.
-	 */
-	if (!cpu_online(cpu))
-		goto out;
-
-	rq = cpu_rq(cpu);
-
-	if (get_user(ownertid, uaddr))
-		return -EFAULT;
-	ownertid &= FUTEX_TID_MASK;
-
-	for (;;) {
-		/*
-		 * Owner changed, break to re-assess state.
-		 */
-		if (get_user(uval, uaddr))
-			return -EFAULT;
-		if ((uval & FUTEX_TID_MASK) != ownertid)
-			break;
-
-		/*
-		 * Is that owner really running on that cpu?
-		 */
-		if (task_thread_info(rq->curr) != owner || need_resched())
-			return 0;
-
-		cpu_relax();
-	}
-out:
-	return 1;
-}
-#endif
-
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
