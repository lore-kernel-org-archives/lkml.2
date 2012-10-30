Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab2J3Qjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:39:40 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60385 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab2J3Qjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/6] rcu: Accelerate callbacks for CPU initiating a grace period
Date: Tue, 30 Oct 2012 09:27:50 -0700
Message-Id: <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20121030162728.GA22648@linux.vnet.ibm.com>
References: <20121030162728.GA22648@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-5406-0000-0000-0000018E50D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because grace-period initialization is carried out by a separate
kthread, it might happen on a different CPU than the one that
had the callback needing a grace period -- which is where the
callback acceleration needs to happen.

Fortunately, rcu_start_gp() holds the root rcu_node structure's
->lock, which prevents a new grace period from starting.  This
allows this function to safely determine that a grace period has
not yet started, which in turn allows it to fully accelerate any
callbacks that it has pending.  This commit adds this acceleration.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..93d6871 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1404,15 +1404,37 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	    !cpu_needs_another_gp(rsp, rdp)) {
 		/*
 		 * Either we have not yet spawned the grace-period
-		 * task or this CPU does not need another grace period.
+		 * task, this CPU does not need another grace period,
+		 * or a grace period is already in progress.
 		 * Either way, don't start a new grace period.
 		 */
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 
+	/*
+	 * Because there is no grace period in progress right now,
+	 * any callbacks we have up to this point will be satisfied
+	 * by the next grace period.  So promote all callbacks to be
+	 * handled after the end of the next grace period.  If the
+	 * CPU is not yet aware of the end of the previous grace period,
+	 * we need to allow for the callback advancement that will
+	 * occur when it does become aware.  Deadlock prevents us from
+	 * making it aware at this point: We cannot acquire a leaf
+	 * rcu_node ->lock while holding the root rcu_node ->lock.
+	 */
+	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	if (rdp->completed == rsp->completed)
+		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock(&rnp->lock); /* Interrupts remain disabled. */
+
+	/* Ensure that CPU is aware of completion of last grace period. */
+	rcu_process_gp_end(rsp, rdp);
+	local_irq_restore(flags);
+
+	/* Wake up rcu_gp_kthread() to start the grace period. */
 	wake_up(&rsp->gp_wq);
 }
 
-- 
1.7.8

