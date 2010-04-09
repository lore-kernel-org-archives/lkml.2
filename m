Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0DIFri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:47:38 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44740 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab0DIFra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:47:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 3/4] rcu: Update docs for rcu_access_pointer and rcu_dereference_protected
Date: Thu,  8 Apr 2010 22:47:21 -0700
Message-Id: <1270792042-9358-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100409054701.GA8833@linux.vnet.ibm.com>
References: <20100409054701.GA8833@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update examples and lists of APIs to include these new primitives.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/NMI-RCU.txt   |   39 ++++++++++++++++++++++-----------------
 Documentation/RCU/checklist.txt |    7 ++++---
 Documentation/RCU/lockdep.txt   |   28 ++++++++++++++++++++++++++--
 Documentation/RCU/whatisRCU.txt |    6 ++++++
 4 files changed, 58 insertions(+), 22 deletions(-)

diff --git a/Documentation/RCU/NMI-RCU.txt b/Documentation/RCU/NMI-RCU.txt
index a6d32e6..a8536cb 100644
--- a/Documentation/RCU/NMI-RCU.txt
+++ b/Documentation/RCU/NMI-RCU.txt
@@ -34,7 +34,7 @@ NMI handler.
 		cpu = smp_processor_id();
 		++nmi_count(cpu);
 
-		if (!rcu_dereference(nmi_callback)(regs, cpu))
+		if (!rcu_dereference_sched(nmi_callback)(regs, cpu))
 			default_do_nmi(regs);
 
 		nmi_exit();
@@ -47,12 +47,13 @@ function pointer.  If this handler returns zero, do_nmi() invokes the
 default_do_nmi() function to handle a machine-specific NMI.  Finally,
 preemption is restored.
 
-Strictly speaking, rcu_dereference() is not needed, since this code runs
-only on i386, which does not need rcu_dereference() anyway.  However,
-it is a good documentation aid, particularly for anyone attempting to
-do something similar on Alpha.
+In theory, rcu_dereference_sched() is not needed, since this code runs
+only on i386, which in theory does not need rcu_dereference_sched()
+anyway.  However, in practice it is a good documentation aid, particularly
+for anyone attempting to do something similar on Alpha or on systems
+with aggressive optimizing compilers.
 
-Quick Quiz:  Why might the rcu_dereference() be necessary on Alpha,
+Quick Quiz:  Why might the rcu_dereference_sched() be necessary on Alpha,
 	     given that the code referenced by the pointer is read-only?
 
 
@@ -99,17 +100,21 @@ invoke irq_enter() and irq_exit() on NMI entry and exit, respectively.
 
 Answer to Quick Quiz
 
-	Why might the rcu_dereference() be necessary on Alpha, given
+	Why might the rcu_dereference_sched() be necessary on Alpha, given
 	that the code referenced by the pointer is read-only?
 
 	Answer: The caller to set_nmi_callback() might well have
-		initialized some data that is to be used by the
-		new NMI handler.  In this case, the rcu_dereference()
-		would be needed, because otherwise a CPU that received
-		an NMI just after the new handler was set might see
-		the pointer to the new NMI handler, but the old
-		pre-initialized version of the handler's data.
-
-		More important, the rcu_dereference() makes it clear
-		to someone reading the code that the pointer is being
-		protected by RCU.
+		initialized some data that is to be used by the new NMI
+		handler.  In this case, the rcu_dereference_sched() would
+		be needed, because otherwise a CPU that received an NMI
+		just after the new handler was set might see the pointer
+		to the new NMI handler, but the old pre-initialized
+		version of the handler's data.
+
+		This same sad story can happen on other CPUs when using
+		a compiler with aggressive pointer-value speculation
+		optimizations.
+
+		More important, the rcu_dereference_sched() makes it
+		clear to someone reading the code that the pointer is
+		being protected by RCU-sched.
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index cbc180f..790d1a8 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -260,7 +260,8 @@ over a rather long period of time, but improvements are always welcome!
 	The reason that it is permissible to use RCU list-traversal
 	primitives when the update-side lock is held is that doing so
 	can be quite helpful in reducing code bloat when common code is
-	shared between readers and updaters.
+	shared between readers and updaters.  Additional primitives
+	are provided for this case, as discussed in lockdep.txt.
 
 10.	Conversely, if you are in an RCU read-side critical section,
 	and you don't hold the appropriate update-side lock, you -must-
@@ -344,8 +345,8 @@ over a rather long period of time, but improvements are always welcome!
 	requiring SRCU's read-side deadlock immunity or low read-side
 	realtime latency.
 
-	Note that, rcu_assign_pointer() and rcu_dereference() relate to
-	SRCU just as they do to other forms of RCU.
+	Note that, rcu_assign_pointer() relates to SRCU just as they do
+	to other forms of RCU.
 
 15.	The whole point of call_rcu(), synchronize_rcu(), and friends
 	is to wait until all pre-existing readers have finished before
diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
index fe24b58..d7a49b2 100644
--- a/Documentation/RCU/lockdep.txt
+++ b/Documentation/RCU/lockdep.txt
@@ -32,9 +32,20 @@ checking of rcu_dereference() primitives:
 	srcu_dereference(p, sp):
 		Check for SRCU read-side critical section.
 	rcu_dereference_check(p, c):
-		Use explicit check expression "c".
+		Use explicit check expression "c".  This is useful in
+		code that is invoked by both readers and updaters.
 	rcu_dereference_raw(p)
 		Don't check.  (Use sparingly, if at all.)
+	rcu_dereference_protected(p, c):
+		Use explicit check expression "c", and omit all barriers
+		and compiler constraints.  This is useful when the data
+		structure cannot change, for example, in code that is
+		invoked only by updaters.
+	rcu_access_pointer(p):
+		Return the value of the pointer and omit all barriers,
+		but retain the compiler constraints that prevent duplicating
+		or coalescsing.  This is useful when when testing the
+		value of the pointer itself, for example, against NULL.
 
 The rcu_dereference_check() check expression can be any boolean
 expression, but would normally include one of the rcu_read_lock_held()
@@ -59,7 +70,20 @@ In case (1), the pointer is picked up in an RCU-safe manner for vanilla
 RCU read-side critical sections, in case (2) the ->file_lock prevents
 any change from taking place, and finally, in case (3) the current task
 is the only task accessing the file_struct, again preventing any change
-from taking place.
+from taking place.  If the above statement was invoked only from updater
+code, it could instead be written as follows:
+
+	file = rcu_dereference_protected(fdt->fd[fd],
+					 lockdep_is_held(&files->file_lock) ||
+					 atomic_read(&files->count) == 1);
+
+This would verify cases #2 and #3 above, and furthermore lockdep would
+complain if this was used in an RCU read-side critical section unless one
+of these two cases held.  Because rcu_dereference_protected() omits all
+barriers and compiler constraints, it generates better code than do the
+other flavors of rcu_dereference().  On the other hand, it is illegal
+to use rcu_dereference_protected() if either the RCU-protected pointer
+or the RCU-protected data that it points to can change concurrently.
 
 There are currently only "universal" versions of the rcu_assign_pointer()
 and RCU list-/tree-traversal primitives, which do not (yet) check for
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 1dc00ee..cfaac34 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -840,6 +840,12 @@ SRCU:	Initialization/cleanup
 	init_srcu_struct
 	cleanup_srcu_struct
 
+All:  lockdep-checked RCU-protected pointer access
+
+	rcu_dereference_check
+	rcu_dereference_protected
+	rcu_access_pointer
+
 See the comment headers in the source code (or the docbook generated
 from them) for more information.
 
-- 
1.7.0

