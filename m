Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030543Ab2HWO7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:59:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45198 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2HWO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:59:14 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        "3.2.x.." <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 10/11] score: Add missing RCU idle APIs on idle loop
Date: Thu, 23 Aug 2012 16:58:34 +0200
Message-Id: <1345733915-20040-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
References: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the old times, the whole idle task was considered
as an RCU quiescent state. But as RCU became more and
more successful overtime, some RCU read side critical
section have been added even in the code of some
architectures idle tasks, for tracing for example.

So nowadays, rcu_idle_enter() and rcu_idle_exit() must
be called by the architecture to tell RCU about the part
in the idle loop that doesn't make use of rcu read side
critical sections, typically the part that puts the CPU
in low power mode.

This is necessary for RCU to find the quiescent states in
idle in order to complete grace periods.

Add this missing pair of calls in the scores's idle loop.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: 3.2.x.. <stable@vger.kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/score/kernel/process.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
index 2707023..637970c 100644
--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -27,6 +27,7 @@
 #include <linux/reboot.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
+#include <linux/rcupdate.h>
 
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
@@ -50,9 +51,10 @@ void __noreturn cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			barrier();
-
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }
-- 
1.7.5.4

