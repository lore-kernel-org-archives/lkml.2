Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2FOTBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:01:10 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45380 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab2FOTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:01:08 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/6] rcu: Update documentation to cover call_srcu() and srcu_barrier().
Date: Fri, 15 Jun 2012 11:57:49 -0700
Message-Id: <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120615185725.GA25163@linux.vnet.ibm.com>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061519-5518-0000-0000-00000533F264
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The advent of call_srcu() and srcu_barrier() obsoleted some of the
documentation, so this commit brings that up to date.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/checklist.txt  |   39 +++++++++++++++++++------------------
 Documentation/RCU/rcubarrier.txt |    6 +++-
 Documentation/RCU/torture.txt    |    9 ++++++++
 Documentation/RCU/whatisRCU.txt  |    6 ++--
 4 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 5c8d749..fc103d7 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -162,9 +162,9 @@ over a rather long period of time, but improvements are always welcome!
 		when publicizing a pointer to a structure that can
 		be traversed by an RCU read-side critical section.
 
-5.	If call_rcu(), or a related primitive such as call_rcu_bh() or
-	call_rcu_sched(), is used, the callback function must be
-	written to be called from softirq context.  In particular,
+5.	If call_rcu(), or a related primitive such as call_rcu_bh(),
+	call_rcu_sched(), or call_srcu() is used, the callback function
+	must be written to be called from softirq context.  In particular,
 	it cannot block.
 
 6.	Since synchronize_rcu() can block, it cannot be called from
@@ -202,11 +202,12 @@ over a rather long period of time, but improvements are always welcome!
 	updater uses call_rcu_sched() or synchronize_sched(), then
 	the corresponding readers must disable preemption, possibly
 	by calling rcu_read_lock_sched() and rcu_read_unlock_sched().
-	If the updater uses synchronize_srcu(), the the corresponding
-	readers must use srcu_read_lock() and srcu_read_unlock(),
-	and with the same srcu_struct.	The rules for the expedited
-	primitives are the same as for their non-expedited counterparts.
-	Mixing things up will result in confusion and broken kernels.
+	If the updater uses synchronize_srcu() or call_srcu(),
+	the the corresponding readers must use srcu_read_lock() and
+	srcu_read_unlock(), and with the same srcu_struct.  The rules for
+	the expedited primitives are the same as for their non-expedited
+	counterparts.  Mixing things up will result in confusion and
+	broken kernels.
 
 	One exception to this rule: rcu_read_lock() and rcu_read_unlock()
 	may be substituted for rcu_read_lock_bh() and rcu_read_unlock_bh()
@@ -333,14 +334,14 @@ over a rather long period of time, but improvements are always welcome!
 	victim CPU from ever going offline.)
 
 14.	SRCU (srcu_read_lock(), srcu_read_unlock(), srcu_dereference(),
-	synchronize_srcu(), and synchronize_srcu_expedited()) may only
-	be invoked from process context.  Unlike other forms of RCU, it
-	-is- permissible to block in an SRCU read-side critical section
-	(demarked by srcu_read_lock() and srcu_read_unlock()), hence the
-	"SRCU": "sleepable RCU".  Please note that if you don't need
-	to sleep in read-side critical sections, you should be using
-	RCU rather than SRCU, because RCU is almost always faster and
-	easier to use than is SRCU.
+	synchronize_srcu(), synchronize_srcu_expedited(), and call_srcu())
+	may only be invoked from process context.  Unlike other forms of
+	RCU, it -is- permissible to block in an SRCU read-side critical
+	section (demarked by srcu_read_lock() and srcu_read_unlock()),
+	hence the "SRCU": "sleepable RCU".  Please note that if you
+	don't need to sleep in read-side critical sections, you should be
+	using RCU rather than SRCU, because RCU is almost always faster
+	and easier to use than is SRCU.
 
 	If you need to enter your read-side critical section in a
 	hardirq or exception handler, and then exit that same read-side
@@ -353,8 +354,8 @@ over a rather long period of time, but improvements are always welcome!
 	cleanup_srcu_struct().	These are passed a "struct srcu_struct"
 	that defines the scope of a given SRCU domain.	Once initialized,
 	the srcu_struct is passed to srcu_read_lock(), srcu_read_unlock()
-	synchronize_srcu(), and synchronize_srcu_expedited().  A given
-	synchronize_srcu() waits only for SRCU read-side critical
+	synchronize_srcu(), synchronize_srcu_expedited(), and call_srcu().
+	A given synchronize_srcu() waits only for SRCU read-side critical
 	sections governed by srcu_read_lock() and srcu_read_unlock()
 	calls that have been passed the same srcu_struct.  This property
 	is what makes sleeping read-side critical sections tolerable --
@@ -374,7 +375,7 @@ over a rather long period of time, but improvements are always welcome!
 	requiring SRCU's read-side deadlock immunity or low read-side
 	realtime latency.
 
-	Note that, rcu_assign_pointer() relates to SRCU just as they do
+	Note that, rcu_assign_pointer() relates to SRCU just as it does
 	to other forms of RCU.
 
 15.	The whole point of call_rcu(), synchronize_rcu(), and friends
diff --git a/Documentation/RCU/rcubarrier.txt b/Documentation/RCU/rcubarrier.txt
index e439a0e..a511fe6 100644
--- a/Documentation/RCU/rcubarrier.txt
+++ b/Documentation/RCU/rcubarrier.txt
@@ -261,8 +261,10 @@ Answers to Quick Quizzes
 
 Quick Quiz #1: Why is there no srcu_barrier()?
 
-Answer: Since there is no call_srcu(), there can be no outstanding SRCU
-	callbacks. Therefore, there is no need to wait for them.
+Answer: There really is an srcu_barrier() now that there is a call_srcu().
+	Before call_srcu(), there were no SRCU callbacks, and there was
+	therefore no need to wait for them, and therefore there was
+	no srcu_barrier().
 
 Quick Quiz #2: Is there any other situation where rcu_barrier() might
 	be required?
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 4ddf391..7dce8a1 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -174,11 +174,20 @@ torture_type	The type of RCU to test, with string values as follows:
 			and synchronize_rcu_bh_expedited().
 
 		"srcu": srcu_read_lock(), srcu_read_unlock() and
+			call_srcu().
+
+		"srcu_sync": srcu_read_lock(), srcu_read_unlock() and
 			synchronize_srcu().
 
 		"srcu_expedited": srcu_read_lock(), srcu_read_unlock() and
 			synchronize_srcu_expedited().
 
+		"srcu_raw": srcu_read_lock_raw(), srcu_read_unlock_raw(),
+			and call_srcu().
+
+		"srcu_raw_sync": srcu_read_lock_raw(), srcu_read_unlock_raw(),
+			and synchronize_srcu().
+
 		"sched": preempt_disable(), preempt_enable(), and
 			call_rcu_sched().
 
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 6bbe8dc..69ee188 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -833,9 +833,9 @@ sched:	Critical sections	Grace period		Barrier
 
 SRCU:	Critical sections	Grace period		Barrier
 
-	srcu_read_lock		synchronize_srcu	N/A
-	srcu_read_unlock	synchronize_srcu_expedited
-	srcu_read_lock_raw
+	srcu_read_lock		synchronize_srcu	srcu_barrier
+	srcu_read_unlock	call_srcu
+	srcu_read_lock_raw	synchronize_srcu_expedited
 	srcu_read_unlock_raw
 	srcu_dereference
 
-- 
1.7.8

