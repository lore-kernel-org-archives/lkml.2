Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0KGCGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:06:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36692 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab0KGCFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 05/12] rcu: document TINY_RCU and TINY_PREEMPT_RCU tracing.
Date: Sat,  6 Nov 2010 19:05:25 -0700
Message-Id: <1289095532-5398-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |  132 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 124 insertions(+), 8 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index a851118..ff6d3f1 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -1,18 +1,22 @@
 CONFIG_RCU_TRACE debugfs Files and Formats
 
 
-The rcutree implementation of RCU provides debugfs trace output that
-summarizes counters and state.  This information is useful for debugging
-RCU itself, and can sometimes also help to debug abuses of RCU.
-The following sections describe the debugfs files and formats.
+The rcutree and rcutiny implementations of RCU provide debugfs trace
+output that summarizes counters and state.  This information is useful for
+debugging RCU itself, and can sometimes also help to debug abuses of RCU.
+The following sections describe the debugfs files and formats, first
+for rcutree and next for rcutiny.
 
 
-Hierarchical RCU debugfs Files and Formats
+CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
 
-This implementation of RCU provides three debugfs files under the
+These implementations of RCU provides five debugfs files under the
 top-level directory RCU: rcu/rcudata (which displays fields in struct
-rcu_data), rcu/rcugp (which displays grace-period counters), and
-rcu/rcuhier (which displays the struct rcu_node hierarchy).
+rcu_data), rcu/rcudata.csv (which is a .csv spreadsheet version of
+rcu/rcudata), rcu/rcugp (which displays grace-period counters),
+rcu/rcuhier (which displays the struct rcu_node hierarchy), and
+rcu/rcu_pending (which displays counts of the reasons that the
+rcu_pending() function decided that there was core RCU work to do).
 
 The output of "cat rcu/rcudata" looks as follows:
 
@@ -326,3 +330,115 @@ o	"nn" is the number of times that this CPU needed nothing.  Alert
 	readers will note that the rcu "nn" number for a given CPU very
 	closely matches the rcu_bh "np" number for that same CPU.  This
 	is due to short-circuit evaluation in rcu_pending().
+
+
+CONFIG_TINY_RCU and CONFIG_TINY_PREEMPT_RCU debugfs Files and Formats
+
+These implementations of RCU provides a single debugfs file under the
+top-level directory RCU, namely rcu/rcudata, which displays fields in
+rcu_bh_ctrlblk, rcu_sched_ctrlblk and, for CONFIG_TINY_PREEMPT_RCU,
+rcu_preempt_ctrlblk.
+
+The output of "cat rcu/rcudata" is as follows:
+
+rcu_preempt: qlen=24 gp=1097669 g197/p197/c197 tasks=...
+             ttb=. btg=no ntb=184 neb=0 nnb=183 j=01f7 bt=0274
+             normal balk: nt=1097669 gt=0 bt=371 b=0 ny=25073378 nos=0
+             exp balk: bt=0 nos=0
+rcu_sched: qlen: 0
+rcu_bh: qlen: 0
+
+This is split into rcu_preempt, rcu_sched, and rcu_bh sections, with the
+rcu_preempt section appearing only in CONFIG_TINY_PREEMPT_RCU builds.
+The last three lines of the rcu_preempt section appear only in
+CONFIG_RCU_BOOST kernel builds.  The fields are as follows:
+
+o	"qlen" is the number of RCU callbacks currently waiting either
+	for an RCU grace period or waiting to be invoked.  This is the
+	only field present for rcu_sched and rcu_bh, due to the
+	short-circuiting of grace period in those two cases.
+
+o	"gp" is the number of grace periods that have completed.
+
+o	"g197/p197/c197" displays the grace-period state, with the
+	"g" number being the number of grace periods that have started
+	(mod 256), the "p" number being the number of grace periods
+	that the CPU has responded to (also mod 256), and the "c"
+	number being the number of grace periods that have completed
+	(once again mode 256).
+
+	Why have both "gp" and "g"?  Because the data flowing into
+	"gp" is only present in a CONFIG_RCU_TRACE kernel.
+
+o	"tasks" is a set of bits.  The first bit is "T" if there are
+	currently tasks that have recently blocked within an RCU
+	read-side critical section, the second bit is "N" if any of the
+	aforementioned tasks are blocking the current RCU grace period,
+	and the third bit is "E" if any of the aforementioned tasks are
+	blocking the current expedited grace period.  Each bit is "."
+	if the corresponding condition does not hold.
+
+o	"ttb" is a single bit.  It is "B" if any of the blocked tasks
+	need to be priority boosted and "." otherwise.
+
+o	"btg" indicates whether boosting has been carried out during
+	the current grace period, with "exp" indicating that boosting
+	is in progress for an expedited grace period, "no" indicating
+	that boosting has not yet started for a normal grace period,
+	"begun" indicating that boosting has bebug for a normal grace
+	period, and "done" indicating that boosting has completed for
+	a normal grace period.
+
+o	"ntb" is the total number of tasks subjected to RCU priority boosting
+	periods since boot.
+
+o	"neb" is the number of expedited grace periods that have had
+	to resort to RCU priority boosting since boot.
+
+o	"nnb" is the number of normal grace periods that have had
+	to resort to RCU priority boosting since boot.
+
+o	"j" is the low-order 12 bits of the jiffies counter in hexadecimal.
+
+o	"bt" is the low-order 12 bits of the value that the jiffies counter
+	will have at the next time that boosting is scheduled to begin.
+
+o	In the line beginning with "normal balk", the fields are as follows:
+
+	o	"nt" is the number of times that the system balked from
+		boosting because there were no blocked tasks to boost.
+		Note that the system will balk from boosting even if the
+		grace period is overdue when the currently running task
+		is looping within an RCU read-side critical section.
+		There is no point in boosting in this case, because
+		boosting a running task won't make it run any faster.
+
+	o	"gt" is the number of times that the system balked
+		from boosting because, although there were blocked tasks,
+		none of them were preventing the current grace period
+		from completing.
+
+	o	"bt" is the number of times that the system balked
+		from boosting because boosting was already in progress.
+
+	o	"b" is the number of times that the system balked from
+		boosting because boosting had already completed for
+		the grace period in question.
+
+	o	"ny" is the number of times that the system balked from
+		boosting because it was not yet time to start boosting
+		the grace period in question.
+
+	o	"nos" is the number of times that the system balked from
+		boosting for inexplicable ("not otherwise specified")
+		reasons.  This can actually happen due to races involving
+		increments of the jiffies counter.
+
+o	In the line beginning with "exp balk", the fields are as follows:
+
+	o	"bt" is the number of times that the system balked from
+		boosting because there were no blocked tasks to boost.
+
+	o	"nos" is the number of times that the system balked from
+		 boosting for inexplicable ("not otherwise specified")
+		 reasons.
-- 
1.7.0.6

