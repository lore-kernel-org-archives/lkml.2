Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1IGGVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:21:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50105 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab1IGGVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:12 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/55] rcu: Update rcutorture documentation
Date: Tue,  6 Sep 2011 11:00:00 -0700
Message-Id: <1315332049-2604-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Update rcutorture documentation to account for boosting, new types of
RCU torture testing that have been added over the past few years, and
the memory-barrier testing that was added an embarrassingly long time
ago.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/torture.txt |  134 ++++++++++++++++++++++++++++++-----------
 1 files changed, 99 insertions(+), 35 deletions(-)

diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 5d90167..4205ed1 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -42,7 +42,7 @@ fqs_holdoff	Holdoff time (in microseconds) between consecutive calls
 fqs_stutter	Wait time (in seconds) between consecutive bursts
 		of calls to force_quiescent_state().
 
-irqreaders	Says to invoke RCU readers from irq level.  This is currently
+irqreader	Says to invoke RCU readers from irq level.  This is currently
 		done via timers.  Defaults to "1" for variants of RCU that
 		permit this.  (Or, more accurately, variants of RCU that do
 		-not- permit this know to ignore this variable.)
@@ -79,19 +79,65 @@ stutter		The length of time to run the test before pausing for this
 		Specifying "stutter=0" causes the test to run continuously
 		without pausing, which is the old default behavior.
 
+test_boost	Whether or not to test the ability of RCU to do priority
+		boosting.  Defaults to "test_boost=1", which performs
+		RCU priority-inversion testing only if the selected
+		RCU implementation supports priority boosting.  Specifying
+		"test_boost=0" never performs RCU priority-inversion
+		testing.  Specifying "test_boost=2" performs RCU
+		priority-inversion testing even if the selected RCU
+		implementation does not support RCU priority boosting,
+		which can be used to test rcutorture's ability to
+		carry out RCU priority-inversion testing.
+
+test_boost_interval
+		The number of seconds in an RCU priority-inversion test
+		cycle.	Defaults to "test_boost_interval=7".  It is
+		usually wise for this value to be relatively prime to
+		the value selected for "stutter".
+
+test_boost_duration
+		The number of seconds to do RCU priority-inversion testing
+		within any given "test_boost_interval".  Defaults to
+		"test_boost_duration=4".
+
 test_no_idle_hz	Whether or not to test the ability of RCU to operate in
 		a kernel that disables the scheduling-clock interrupt to
 		idle CPUs.  Boolean parameter, "1" to test, "0" otherwise.
 		Defaults to omitting this test.
 
-torture_type	The type of RCU to test: "rcu" for the rcu_read_lock() API,
-		"rcu_sync" for rcu_read_lock() with synchronous reclamation,
-		"rcu_bh" for the rcu_read_lock_bh() API, "rcu_bh_sync" for
-		rcu_read_lock_bh() with synchronous reclamation, "srcu" for
-		the "srcu_read_lock()" API, "sched" for the use of
-		preempt_disable() together with synchronize_sched(),
-		and "sched_expedited" for the use of preempt_disable()
-		with synchronize_sched_expedited().
+torture_type	The type of RCU to test, with string values as follows:
+
+		"rcu":  rcu_read_lock(), rcu_read_unlock() and call_rcu().
+
+		"rcu_sync":  rcu_read_lock(), rcu_read_unlock(), and
+			synchronize_rcu().
+
+		"rcu_expedited": rcu_read_lock(), rcu_read_unlock(), and
+			synchronize_rcu_expedited().
+
+		"rcu_bh": rcu_read_lock_bh(), rcu_read_unlock_bh(), and
+			call_rcu_bh().
+
+		"rcu_bh_sync": rcu_read_lock_bh(), rcu_read_unlock_bh(),
+			and synchronize_rcu_bh().
+
+		"srcu": srcu_read_lock(), srcu_read_unlock() and
+			synchronize_srcu().
+
+		"srcu_expedited": srcu_read_lock(), srcu_read_unlock() and
+			synchronize_srcu_expedited().
+
+		"sched": preempt_disable(), preempt_enable(), and
+			call_rcu_sched().
+
+		"sched_sync": preempt_disable(), preempt_enable(), and
+			synchronize_sched().
+
+		"sched_expedited": preempt_disable(), preempt_enable(), and
+			synchronize_sched_expedited().
+
+		Defaults to "rcu".
 
 verbose		Enable debug printk()s.  Default is disabled.
 
@@ -100,12 +146,12 @@ OUTPUT
 
 The statistics output is as follows:
 
-	rcu-torture: --- Start of test: nreaders=16 stat_interval=0 verbose=0
-	rcu-torture: rtc: 0000000000000000 ver: 1916 tfle: 0 rta: 1916 rtaf: 0 rtf: 1915
-	rcu-torture: Reader Pipe:  1466408 9747 0 0 0 0 0 0 0 0 0
-	rcu-torture: Reader Batch:  1464477 11678 0 0 0 0 0 0 0 0
-	rcu-torture: Free-Block Circulation:  1915 1915 1915 1915 1915 1915 1915 1915 1915 1915 0
-	rcu-torture: --- End of test
+	rcu-torture:--- Start of test: nreaders=16 nfakewriters=4 stat_interval=30 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
+	rcu-torture: rtc:           (null) ver: 155441 tfle: 0 rta: 155441 rtaf: 8884 rtf: 155440 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3055767
+	rcu-torture: Reader Pipe:  727860534 34213 0 0 0 0 0 0 0 0 0
+	rcu-torture: Reader Batch:  727877838 17003 0 0 0 0 0 0 0 0 0
+	rcu-torture: Free-Block Circulation:  155440 155440 155440 155440 155440 155440 155440 155440 155440 155440 0
+	rcu-torture:--- End of test: SUCCESS: nreaders=16 nfakewriters=4 stat_interval=30 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
 
 The command "dmesg | grep torture:" will extract this information on
 most systems.  On more esoteric configurations, it may be necessary to
@@ -113,26 +159,55 @@ use other commands to access the output of the printk()s used by
 the RCU torture test.  The printk()s use KERN_ALERT, so they should
 be evident.  ;-)
 
+The first and last lines show the rcutorture module parameters, and the
+last line shows either "SUCCESS" or "FAILURE", based on rcutorture's
+automatic determination as to whether RCU operated correctly.
+
 The entries are as follows:
 
 o	"rtc": The hexadecimal address of the structure currently visible
 	to readers.
 
-o	"ver": The number of times since boot that the rcutw writer task
+o	"ver": The number of times since boot that the RCU writer task
 	has changed the structure visible to readers.
 
 o	"tfle": If non-zero, indicates that the "torture freelist"
-	containing structure to be placed into the "rtc" area is empty.
+	containing structures to be placed into the "rtc" area is empty.
 	This condition is important, since it can fool you into thinking
 	that RCU is working when it is not.  :-/
 
 o	"rta": Number of structures allocated from the torture freelist.
 
 o	"rtaf": Number of allocations from the torture freelist that have
-	failed due to the list being empty.
+	failed due to the list being empty.  It is not unusual for this
+	to be non-zero, but it is bad for it to be a large fraction of
+	the value indicated by "rta".
 
 o	"rtf": Number of frees into the torture freelist.
 
+o	"rtmbe": A non-zero value indicates that rcutorture believes that
+	rcu_assign_pointer() and rcu_dereference() are not working
+	correctly.  This value should be zero.
+
+o	"rtbke": rcutorture was unable to create the real-time kthreads
+	used to force RCU priority inversion.  This value should be zero.
+
+o	"rtbre": Although rcutorture successfully created the kthreads
+	used to force RCU priority inversion, it was unable to set them
+	to the real-time priority level of 1.  This value should be zero.
+
+o	"rtbf": The number of times that RCU priority boosting failed
+	to resolve RCU priority inversion.
+
+o	"rtb": The number of times that rcutorture attempted to force
+	an RCU priority inversion condition.  If you are testing RCU
+	priority boosting via the "test_boost" module parameter, this
+	value should be non-zero.
+
+o	"nt": The number of times rcutorture ran RCU read-side code from
+	within a timer handler.  This value should be non-zero only
+	if you specified the "irqreader" module parameter.
+
 o	"Reader Pipe": Histogram of "ages" of structures seen by readers.
 	If any entries past the first two are non-zero, RCU is broken.
 	And rcutorture prints the error flag string "!!!" to make sure
@@ -162,26 +237,15 @@ o	"Free-Block Circulation": Shows the number of torture structures
 	somehow gets incremented farther than it should.
 
 Different implementations of RCU can provide implementation-specific
-additional information.  For example, SRCU provides the following:
+additional information.  For example, SRCU provides the following
+additional line:
 
-	srcu-torture: rtc: f8cf46a8 ver: 355 tfle: 0 rta: 356 rtaf: 0 rtf: 346 rtmbe: 0
-	srcu-torture: Reader Pipe:  559738 939 0 0 0 0 0 0 0 0 0
-	srcu-torture: Reader Batch:  560434 243 0 0 0 0 0 0 0 0
-	srcu-torture: Free-Block Circulation:  355 354 353 352 351 350 349 348 347 346 0
 	srcu-torture: per-CPU(idx=1): 0(0,1) 1(0,1) 2(0,0) 3(0,1)
 
-The first four lines are similar to those for RCU.  The last line shows
-the per-CPU counter state.  The numbers in parentheses are the values
-of the "old" and "current" counters for the corresponding CPU.  The
-"idx" value maps the "old" and "current" values to the underlying array,
-and is useful for debugging.
-
-Similarly, sched_expedited RCU provides the following:
-
-	sched_expedited-torture: rtc: d0000000016c1880 ver: 1090796 tfle: 0 rta: 1090796 rtaf: 0 rtf: 1090787 rtmbe: 0 nt: 27713319
-	sched_expedited-torture: Reader Pipe:  12660320201 95875 0 0 0 0 0 0 0 0 0
-	sched_expedited-torture: Reader Batch:  12660424885 0 0 0 0 0 0 0 0 0 0
-	sched_expedited-torture: Free-Block Circulation:  1090795 1090795 1090794 1090793 1090792 1090791 1090790 1090789 1090788 1090787 0
+This line shows the per-CPU counter state.  The numbers in parentheses are
+the values of the "old" and "current" counters for the corresponding CPU.
+The "idx" value maps the "old" and "current" values to the underlying
+array, and is useful for debugging.
 
 
 USAGE
-- 
1.7.3.2

