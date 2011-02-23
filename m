Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1BWBjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:39:53 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37583 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab1BWBju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 03/11] rcu: add documentation saying which RCU flavor to choose
Date: Tue, 22 Feb 2011 17:39:32 -0800
Message-Id: <1298425183-21265-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/whatisRCU.txt |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

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
 
-- 
1.7.3.2

