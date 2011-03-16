Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab1CPG7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:59:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab1CPG7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:59:00 -0400
Date: Wed, 16 Mar 2011 07:58:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v2.6.39
Message-ID: <20110316065835.GA29204@elte.hu>
References: <20110315194216.GA2508@elte.hu>
 <AANLkTikZ9jNMC7qDa3DGVjtSuXjWO-oXqSYX22Sj4xiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikZ9jNMC7qDa3DGVjtSuXjWO-oXqSYX22Sj4xiQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Mar 15, 2011 at 12:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest core-locking-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus
> 
> Something screwed up? This was the core-locking pull request, not the
> RCU pull. And there's no shortlog or diff..

Oops, indeed. The right one is:

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-rcu-for-linus

 Thanks,

	Ingo

------------------>
Amerigo Wang (1):
      rcupdate: remove dead code

Jesper Juhl (1):
      rcutorture: Get rid of duplicate sched.h include

Lai Jiangshan (1):
      rcu: call __rcu_read_unlock() in exit_rcu for tiny RCU

Paul E. McKenney (3):
      rcu: add documentation saying which RCU flavor to choose
      rcu: add comment saying why DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT.
      smp: Document transitivity for memory barriers.


 Documentation/RCU/whatisRCU.txt   |   31 +++++++++++++++++++
 Documentation/memory-barriers.txt |   58 +++++++++++++++++++++++++++++++++++++
 kernel/rcupdate.c                 |   10 +++---
 kernel/rcutiny_plugin.h           |    2 +-
 kernel/rcutorture.c               |    1 -
 5 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index cfaac34..6ef6926 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -849,6 +849,37 @@ All:  lockdep-checked RCU-protected pointer access
 See the comment headers in the source code (or the docbook generated
 from them) for more information.
 
+However, given that there are no fewer than four families of RCU APIs
+in the Linux kernel, how do you choose which one to use?  The following
+list can be helpful:
+
+a.	Will readers need to block?  If so, you need SRCU.
+
+b.	What about the -rt patchset?  If readers would need to block
+	in an non-rt kernel, you need SRCU.  If readers would block
+	in a -rt kernel, but not in a non-rt kernel, SRCU is not
+	necessary.
+
+c.	Do you need to treat NMI handlers, hardirq handlers,
+	and code segments with preemption disabled (whether
+	via preempt_disable(), local_irq_save(), local_bh_disable(),
+	or some other mechanism) as if they were explicit RCU readers?
+	If so, you need RCU-sched.
+
+d.	Do you need RCU grace periods to complete even in the face
+	of softirq monopolization of one or more of the CPUs?  For
+	example, is your code subject to network-based denial-of-service
+	attacks?  If so, you need RCU-bh.
+
+e.	Is your workload too update-intensive for normal use of
+	RCU, but inappropriate for other synchronization mechanisms?
+	If so, consider SLAB_DESTROY_BY_RCU.  But please be careful!
+
+f.	Otherwise, use RCU.
+
+Of course, this all assumes that you have determined that RCU is in fact
+the right tool for your job.
+
 
 8.  ANSWERS TO QUICK QUIZZES
 
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 631ad2f..f0d3a80 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -21,6 +21,7 @@ Contents:
      - SMP barrier pairing.
      - Examples of memory barrier sequences.
      - Read memory barriers vs load speculation.
+     - Transitivity
 
  (*) Explicit kernel barriers.
 
@@ -959,6 +960,63 @@ the speculation will be cancelled and the value reloaded:
 	retrieved                               :       :       +-------+
 
 
+TRANSITIVITY
+------------
+
+Transitivity is a deeply intuitive notion about ordering that is not
+always provided by real computer systems.  The following example
+demonstrates transitivity (also called "cumulativity"):
+
+	CPU 1			CPU 2			CPU 3
+	=======================	=======================	=======================
+		{ X = 0, Y = 0 }
+	STORE X=1		LOAD X			STORE Y=1
+				<general barrier>	<general barrier>
+				LOAD Y			LOAD X
+
+Suppose that CPU 2's load from X returns 1 and its load from Y returns 0.
+This indicates that CPU 2's load from X in some sense follows CPU 1's
+store to X and that CPU 2's load from Y in some sense preceded CPU 3's
+store to Y.  The question is then "Can CPU 3's load from X return 0?"
+
+Because CPU 2's load from X in some sense came after CPU 1's store, it
+is natural to expect that CPU 3's load from X must therefore return 1.
+This expectation is an example of transitivity: if a load executing on
+CPU A follows a load from the same variable executing on CPU B, then
+CPU A's load must either return the same value that CPU B's load did,
+or must return some later value.
+
+In the Linux kernel, use of general memory barriers guarantees
+transitivity.  Therefore, in the above example, if CPU 2's load from X
+returns 1 and its load from Y returns 0, then CPU 3's load from X must
+also return 1.
+
+However, transitivity is -not- guaranteed for read or write barriers.
+For example, suppose that CPU 2's general barrier in the above example
+is changed to a read barrier as shown below:
+
+	CPU 1			CPU 2			CPU 3
+	=======================	=======================	=======================
+		{ X = 0, Y = 0 }
+	STORE X=1		LOAD X			STORE Y=1
+				<read barrier>		<general barrier>
+				LOAD Y			LOAD X
+
+This substitution destroys transitivity: in this example, it is perfectly
+legal for CPU 2's load from X to return 1, its load from Y to return 0,
+and CPU 3's load from X to return 0.
+
+The key point is that although CPU 2's read barrier orders its pair
+of loads, it does not guarantee to order CPU 1's store.  Therefore, if
+this example runs on a system where CPUs 1 and 2 share a store buffer
+or a level of cache, CPU 2 might have early access to CPU 1's writes.
+General barriers are therefore required to ensure that all CPUs agree
+on the combined order of CPU 1's and CPU 2's accesses.
+
+To reiterate, if your code requires transitivity, use general barriers
+throughout.
+
+
 ========================
 EXPLICIT KERNEL BARRIERS
 ========================
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a23a57a..f3240e9 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -214,11 +214,12 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
+		 * Note that the machinery to reliably determine whether
+		 * or not we are in an RCU read-side critical section
+		 * exists only in the preemptible RCU implementations
+		 * (TINY_PREEMPT_RCU and TREE_PREEMPT_RCU), which is why
+		 * DEBUG_OBJECTS_RCU_HEAD is disallowed if !PREEMPT.
 		 */
-#ifndef CONFIG_PREEMPT
-		WARN_ON(1);
-		return 0;
-#else
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
 			WARN_ON(1);
@@ -229,7 +230,6 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
 		rcu_barrier_bh();
 		debug_object_free(head, &rcuhead_debug_descr);
 		return 1;
-#endif
 	default:
 		return 0;
 	}
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 015abae..3cb8e36 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -852,7 +852,7 @@ void exit_rcu(void)
 	if (t->rcu_read_lock_nesting == 0)
 		return;
 	t->rcu_read_lock_nesting = 1;
-	rcu_read_unlock();
+	__rcu_read_unlock();
 }
 
 #else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 89613f9..c224da4 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -47,7 +47,6 @@
 #include <linux/srcu.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
-#include <linux/sched.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
