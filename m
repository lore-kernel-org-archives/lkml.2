Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0DNPC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:02:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:53793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab0DNPCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:02:23 -0400
Date: Wed, 14 Apr 2010 15:01:31 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270852752-25278-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1270852752-25278-3-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Update docs for rcu_access_pointer and rcu_dereference_protected
Message-ID: <tip-50aec0024eccb1d5f540ab64a1958eebcdb9340c@git.kernel.org>
Git-Commit-ID: 50aec0024eccb1d5f540ab64a1958eebcdb9340c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 15:01:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50aec0024eccb1d5f540ab64a1958eebcdb9340c
Gitweb:     http://git.kernel.org/tip/50aec0024eccb1d5f540ab64a1958eebcdb9340c
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 9 Apr 2010 15:39:12 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 12:20:12 +0200

rcu: Update docs for rcu_access_pointer and rcu_dereference_protected

Update examples and lists of APIs to include these new
primitives.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: eric.dumazet@gmail.com
LKML-Reference: <1270852752-25278-3-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
