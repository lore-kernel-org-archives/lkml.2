Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1KBUge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:36:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51202 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1KBUba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 05/28] lockdep: Update documentation for lock-class leak detection
Date: Wed,  2 Nov 2011 13:30:26 -0700
Message-Id: <1320265849-5744-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-1976-0000-0000-000000ABAC89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of bugs that can leak or overuse lock classes,
which can cause the maximum number of lock classes (currently 8191)
to be exceeded.  However, the documentation does not tell you how to
track down these problems.  This commit addresses this shortcoming.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/lockdep-design.txt |   61 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index abf768c..383bb23 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -221,3 +221,64 @@ when the chain is validated for the first time, is then put into a hash
 table, which hash-table can be checked in a lockfree manner. If the
 locking chain occurs again later on, the hash table tells us that we
 dont have to validate the chain again.
+
+Troubleshooting:
+----------------
+
+The validator tracks a maximum of MAX_LOCKDEP_KEYS number of lock classes.
+Exceeding this number will trigger the following lockdep warning:
+
+	(DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
+
+By default, MAX_LOCKDEP_KEYS is currently set to 8191, and typical
+desktop systems have less than 1,000 lock classes, so this warning
+normally results from lock-class leakage or failure to properly
+initialize locks.  These two problems are illustrated below:
+
+1.	Repeated module loading and unloading while running the validator
+	will result in lock-class leakage.  The issue here is that each
+	load of the module will create a new set of lock classes for that
+	module's locks, but module unloading does not remove old classes.
+	Therefore, if that module is loaded and unloaded repeatedly,
+	the number of lock classes will eventually reach the maximum.
+
+2.	Using structures such as arrays that have large numbers of
+	locks that are not explicitly initialized.  For example,
+	a hash table with 8192 buckets where each bucket has its
+	own spinlock_t will consume 8192 lock classes -unless- each
+	spinlock is initialized, for example, using spin_lock_init().
+	Failure to properly initialize the per-bucket spinlocks would
+	guarantee lock-class overflow.	In contrast, a loop that called
+	spin_lock_init() on each lock would place all 8192 locks into a
+	single lock class.
+
+	The moral of this story is that you should always explicitly
+	initialize your locks.
+
+One might argue that the validator should be modified to allow lock
+classes to be reused.  However, if you are tempted to make this argument,
+first review the code and think through the changes that would be
+required, keeping in mind that the lock classes to be removed are likely
+to be linked into the lock-dependency graph.  This turns out to be a
+harder to do than to say.
+
+Of course, if you do run out of lock classes, the next thing to do is
+to find the offending lock classes.  First, the following command gives
+you the number of lock classes currently in use along with the maximum:
+
+	grep "lock-classes" /proc/lockdep_stats
+
+This command produces the following output on a modest Power system:
+
+	 lock-classes:                          748 [max: 8191]
+
+If the number allocated (748 above) increases continually over time,
+then there is likely a leak.  The following command can be used to
+identify the leaking lock classes:
+
+	grep "BD" /proc/lockdep
+
+Run the command and save the output, then compare against the output
+from a later run of this command to identify the leakers.  This same
+output can also help you find situations where lock initialization
+has been omitted.
-- 
1.7.3.2

