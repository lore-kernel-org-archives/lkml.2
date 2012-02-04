Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab2BDBr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:47:29 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38134 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757751Ab2BDBrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:47:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/47] rcu: Improve synchronize_rcu() diagnostics
Date: Fri,  3 Feb 2012 17:44:37 -0800
Message-Id: <1328319922-30828-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-6078-0000-0000-0000077492F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Although TREE_PREEMPT_RCU indirectly uses might_sleep() to detect illegal
use of synchronize_sched() and synchronize_rcu_bh() from within an RCU
read-side critical section, this might_sleep() check is bypassed when
there is only a single CPU (for example, when running an SMP kernel on
a single-CPU system).  This patch therefore adds a might_sleep() call
to the rcu_blocking_is_gp() check that is unconditionally invoked from
both synchronize_sched() and synchronize_rcu_bh().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutree.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 6745846..73e7195 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -83,6 +83,7 @@ extern void rcu_sched_force_quiescent_state(void);
 /* A context switch is a grace period for RCU-sched and RCU-bh. */
 static inline int rcu_blocking_is_gp(void)
 {
+	might_sleep();  /* Check for RCU read-side critical section. */
 	return num_online_cpus() == 1;
 }
 
-- 
1.7.8

