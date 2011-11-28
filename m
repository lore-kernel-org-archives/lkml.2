Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1K1XdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:33:25 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40234 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab1K1XdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 10/13] rcu: Remove dynticks false positives and RCU failures
Date: Mon, 28 Nov 2011 15:33:02 -0800
Message-Id: <1322523185-456-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-7182-0000-0000-0000004575A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Assertions in rcu_init_percpu_data() unknowingly relied on outgoing
CPUs being turned off before reaching the idle loop.  Unfortunately,
when running under kvm/qemu on x86, CPUs really can get to idle before
begin shut off.  These CPUs are then born in dyntick-idle mode from an
RCU perspective, which results in splats in rcu_init_percpu_data() and
in RCU wrongly ignoring those CPUs despite them being active.  This in
turn can cause RCU to end grace periods prematurely, potentially freeing
up memory that the newly onlined CPUs were still using.  This is most
decidedly not what we need to see in an RCU implementation.

This commit therefore replaces the assertions in rcu_init_percpu_data()
with code that forces RCU's dyntick-idle view of newly onlined CPUs to
match reality.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 13fab4a..aab9ed5 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2054,8 +2054,9 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
-	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
-	WARN_ON_ONCE((atomic_read(&rdp->dynticks->dynticks) & 0x1) != 1);
+	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_NESTING;
+	atomic_set(&rdp->dynticks->dynticks,
+		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
-- 
1.7.3.2

