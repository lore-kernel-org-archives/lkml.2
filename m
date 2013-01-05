Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3AERtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:49:25 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57818 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab3AERtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:49:20 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/14] rcu: Rearrange locking in rcu_start_gp()
Date: Sat,  5 Jan 2013 09:48:59 -0800
Message-Id: <1357408144-15830-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-7182-0000-0000-0000043672A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

If CPUs are to give prior notice of needed grace periods, it will be
necessary to invoke rcu_start_gp() without dropping the root rcu_node
structure's ->lock.  This commit takes a first step in this direction
by moving the release of this lock to the end of rcu_start_gp().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4b8d91c..7207435 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1559,16 +1559,14 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
-	raw_spin_unlock(&rnp->lock); /* Interrupts remain disabled. */
 
 	/* Ensure that CPU is aware of completion of last grace period. */
-	rcu_process_gp_end(rsp, rdp);
-	local_irq_restore(flags);
+	__rcu_process_gp_end(rsp, rdp->mynode, rdp);
 
 	/* Wake up rcu_gp_kthread() to start the grace period. */
 	wake_up(&rsp->gp_wq);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
-- 
1.7.8

