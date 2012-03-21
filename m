Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031026Ab2CUN7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:59:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61813 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030946Ab2CUN7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:59:42 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: [PATCH 15/32] nohz/cpuset: Restart the tick if printk needs it
Date: Wed, 21 Mar 2012 14:58:21 +0100
Message-Id: <1332338318-5958-17-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are in nohz adaptive mode and printk is called, the tick is
missing to wake up the logger. We need to restart the tick when that
happens. Do this asynchronously by issuing a tick restart self IPI
to avoid deadlocking with the current random locking chain.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zen Lin <zen@openhuawei.org>
---
 kernel/printk.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 32690a0..a32f291 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -41,6 +41,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/rculist.h>
+#include <linux/cpuset.h>
 
 #include <asm/uaccess.h>
 
@@ -1230,8 +1231,20 @@ int printk_needs_cpu(int cpu)
 
 void wake_up_klogd(void)
 {
-	if (waitqueue_active(&log_wait))
+	unsigned long flags;
+
+	if (waitqueue_active(&log_wait)) {
 		this_cpu_write(printk_pending, 1);
+		/* Make it visible from any interrupt from now */
+		barrier();
+		/*
+		 * It's safe to check that even if interrupts are not disabled.
+		 * If we enable nohz adaptive mode concurrently, we'll see the
+		 * printk_pending value and thus keep a periodic tick behaviour.
+		 */
+		if (cpuset_adaptive_nohz())
+			smp_cpuset_update_nohz(smp_processor_id());
+	}
 }
 
 /**
-- 
1.7.5.4

