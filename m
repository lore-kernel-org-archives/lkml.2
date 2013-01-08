Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3AHCR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:17:26 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62846 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3AHCJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:09 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 11/33] rcu: Restart the tick on non-responding full dynticks CPUs
Date: Tue,  8 Jan 2013 03:08:11 +0100
Message-Id: <1357610913-1080-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU in full dynticks mode doesn't respond to complete
a grace period, issue it a specific IPI so that it restarts
the tick and chases a quiescent state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..302d360 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -53,6 +53,7 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 #include <linux/random.h>
+#include <linux/tick.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -743,6 +744,12 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
 	return (rdp->dynticks_snap & 0x1) == 0;
 }
 
+static void rcu_kick_nohz_cpu(int cpu)
+{
+	if (tick_nohz_full_cpu(cpu))
+		smp_send_reschedule(cpu);
+}
+
 /*
  * Return true if the specified CPU has passed through a quiescent
  * state by virtue of being in or having passed through an dynticks
@@ -790,6 +797,9 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 		rdp->offline_fqs++;
 		return 1;
 	}
+
+	rcu_kick_nohz_cpu(rdp->cpu);
+
 	return 0;
 }
 
-- 
1.7.5.4

