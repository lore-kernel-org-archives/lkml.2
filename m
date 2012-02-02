Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2BBAnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:43:39 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58776 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab2BBAnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:43:37 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Mike Frysinger <vapier@gentoo.org>,
        linux-sh@vger.kernel.org
Subject: [PATCH RFC idle 3/3] sh: Avoid invoking RCU when CPU is idle
Date: Wed,  1 Feb 2012 16:43:24 -0800
Message-Id: <1328143404-11038-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328143404-11038-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120202004253.GA10946@linux.vnet.ibm.com>
 <1328143404-11038-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020200-7182-0000-0000-000000A4202C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The idle loop is a quiscent state for RCU, which means that RCU ignores
CPUs that have told RCU that they are idle via rcu_idle_enter().
There are nevertheless quite a few places where idle CPUs use RCU, most
commonly indirectly via tracing.  This patch fixes these problems for SH.

Many of these bugs have been in the kernel for quite some time, but
Frederic's recent change now gives warnings.

This patch takes the straightforward approach of pushing the
rcu_idle_enter()/rcu_idle_exit() pair further down into the core of the
idle loop.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/idle.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 406508d..d125668 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -53,8 +53,10 @@ static inline int hlt_works(void)
 static void poll_idle(void)
 {
 	local_irq_enable();
+	rcu_idle_enter();
 	while (!need_resched())
 		cpu_relax();
+	rcu_idle_exit();
 }
 
 void default_idle(void)
@@ -66,9 +68,14 @@ void default_idle(void)
 		set_bl_bit();
 		if (!need_resched()) {
 			local_irq_enable();
+			rcu_idle_enter();
 			cpu_sleep();
-		} else
+			rcu_idle_exit();
+		} else {
 			local_irq_enable();
+			rcu_idle_enter();
+			rcu_idle_exit();
+		}
 
 		set_thread_flag(TIF_POLLING_NRFLAG);
 		clear_bl_bit();
@@ -90,7 +97,6 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_idle_enter();
-		rcu_idle_enter();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -112,7 +118,6 @@ void cpu_idle(void)
 			start_critical_timings();
 		}
 
-		rcu_idle_exit();
 		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
-- 
1.7.8

