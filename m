Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2BUR7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:59:06 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55220 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2BUR7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:59:03 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/4] rcu: Eliminate softirq-mediated RCU_FAST_NO_HZ idle-entry loop
Date: Tue, 21 Feb 2012 09:58:26 -0800
Message-Id: <1329847110-10897-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120221175810.GA10708@linux.vnet.ibm.com>
References: <20120221175810.GA10708@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022117-3352-0000-0000-000002CB3C6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

If a softirq is pending, the current CPU has RCU callbacks pending,
and RCU does not immediately need anything from this CPU, then the
current code resets the RCU_FAST_NO_HZ state machine.  This means that
upon exit from the subsequent softirq handler, RCU_FAST_NO_HZ will
try really hard to force RCU into dyntick-idle mode.  And if the same
conditions hold after a few tries (determined by RCU_IDLE_OPT_FLUSHES),
the same situation can repeat, possibly endlessly.  This scenario is
not particularly good for battery lifetime.

This commit therefore suppresses the early exit from the RCU_FAST_NO_HZ
state machine in the case where there is a softirq pending.  This change
forces the state machine to retain its memory, and to enter holdoff if
this condition persists.

Reported-by: "Abou Gazala, Neven M" <neven.m.abou.gazala@intel.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f7ceadf..392a651 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2133,7 +2133,8 @@ static void rcu_prepare_for_idle(int cpu)
 		/* First time through, initialize the counter. */
 		per_cpu(rcu_dyntick_drain, cpu) = RCU_IDLE_FLUSHES;
 	} else if (per_cpu(rcu_dyntick_drain, cpu) <= RCU_IDLE_OPT_FLUSHES &&
-		   !rcu_pending(cpu)) {
+		   !rcu_pending(cpu) &&
+		   !local_softirq_pending()) {
 		/* Can we go dyntick-idle despite still having callbacks? */
 		trace_rcu_prep_idle("Dyntick with callbacks");
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
-- 
1.7.8

