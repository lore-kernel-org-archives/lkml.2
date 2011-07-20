Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1GTATL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:19:11 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36666 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab1GTASf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:18:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 7/7] signal: align __lock_task_sighand() irq disabling and RCU
Date: Tue, 19 Jul 2011 17:18:23 -0700
Message-Id: <1311121103-16978-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110720001738.GA16369@linux.vnet.ibm.com>
References: <20110720001738.GA16369@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The __lock_task_sighand() function calls rcu_read_lock() with interrupts
and preemption enabled, but later calls rcu_read_unlock() with interrupts
disabled.  It is therefore possible that this RCU read-side critical
section will be preempted and later RCU priority boosted, which means that
rcu_read_unlock() will call rt_mutex_unlock() in order to deboost itself, but
with interrupts disabled. This results in lockdep splats, so this commit
nests the RCU read-side critical section within the interrupt-disabled
region of code.  This prevents the RCU read-side critical section from
being preempted, and thus prevents the attempt to deboost with interrupts
disabled.

It is quite possible that a better long-term fix is to make rt_mutex_unlock()
disable irqs when acquiring the rt_mutex structure's ->wait_lock.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/signal.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ff76786..a0eb019 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1178,18 +1178,24 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 {
 	struct sighand_struct *sighand;
 
-	rcu_read_lock();
 	for (;;) {
+		local_irq_save(*flags);
+		rcu_read_lock();
 		sighand = rcu_dereference(tsk->sighand);
-		if (unlikely(sighand == NULL))
+		if (unlikely(sighand == NULL)) {
+			rcu_read_unlock();
+			local_irq_restore(*flags);
 			break;
+		}
 
-		spin_lock_irqsave(&sighand->siglock, *flags);
-		if (likely(sighand == tsk->sighand))
+		spin_lock(&sighand->siglock);
+		if (likely(sighand == tsk->sighand)) {
+			rcu_read_unlock();
 			break;
+		}
+		rcu_read_unlock();
 		spin_unlock_irqrestore(&sighand->siglock, *flags);
 	}
-	rcu_read_unlock();
 
 	return sighand;
 }
-- 
1.7.3.2

