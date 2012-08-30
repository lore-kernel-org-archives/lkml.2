Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2H3SqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:46:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54524 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab2H3Sp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:45:58 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/5] rcu: Document SRCU dead-CPU capabilities, emphasize read-side limits
Date: Thu, 30 Aug 2012 11:45:10 -0700
Message-Id: <1346352312-31987-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-2398-0000-0000-000009EA384B
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00169860; UDB=6.00038509; UTC=2012-08-30
 18:45:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current documentation did not help someone grepping for SRCU to
learn that disabling preemption is not a replacement for srcu_read_lock(),
so upgrade the documentation to bring this out, not just for SRCU,
but also for RCU-bh.  Also document the fact that SRCU readers are
respected on CPUs executing in user mode, idle CPUs, and even on
offline CPUs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/checklist.txt |    6 ++++++
 Documentation/RCU/whatisRCU.txt |    9 +++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index fc103d7..cdb20d4 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -310,6 +310,12 @@ over a rather long period of time, but improvements are always welcome!
 	code under the influence of preempt_disable(), you instead
 	need to use synchronize_irq() or synchronize_sched().
 
+	This same limitation also applies to synchronize_rcu_bh()
+	and synchronize_srcu(), as well as to the asynchronous and
+	expedited forms of the three primitives, namely call_rcu(),
+	call_rcu_bh(), call_srcu(), synchronize_rcu_expedited(),
+	synchronize_rcu_bh_expedited(), and synchronize_srcu_expedited().
+
 12.	Any lock acquired by an RCU callback must be acquired elsewhere
 	with softirq disabled, e.g., via spin_lock_irqsave(),
 	spin_lock_bh(), etc.  Failing to disable irq on a given
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 69ee188..bf0f6de 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -873,7 +873,7 @@ d.	Do you need to treat NMI handlers, hardirq handlers,
 	and code segments with preemption disabled (whether
 	via preempt_disable(), local_irq_save(), local_bh_disable(),
 	or some other mechanism) as if they were explicit RCU readers?
-	If so, you need RCU-sched.
+	If so, RCU-sched is the only choice that will work for you.
 
 e.	Do you need RCU grace periods to complete even in the face
 	of softirq monopolization of one or more of the CPUs?  For
@@ -884,7 +884,12 @@ f.	Is your workload too update-intensive for normal use of
 	RCU, but inappropriate for other synchronization mechanisms?
 	If so, consider SLAB_DESTROY_BY_RCU.  But please be careful!
 
-g.	Otherwise, use RCU.
+g.	Do you need read-side critical sections that are respected
+	even though they are in the middle of the idle loop, during
+	user-mode execution, or on an offlined CPU?  If so, SRCU is the
+	only choice that will work for you.
+
+h.	Otherwise, use RCU.
 
 Of course, this all assumes that you have determined that RCU is in fact
 the right tool for your job.
-- 
1.7.8

