Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1HOPxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:51 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab1HOPxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 20/32] nohz/cpuset: Restart the tick if printk needs it
Date: Mon, 15 Aug 2011 17:52:17 +0200
Message-Id: <1313423549-27093-21-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are in nohz adaptive mode and printk is called, the tick is
missing to wake up the logger. We need to restart the tick when that
happens.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/printk.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..aff07f0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -41,6 +41,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/rculist.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 
@@ -1220,8 +1221,22 @@ int printk_needs_cpu(int cpu)
 
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
+		 * If we enable nohz adaptive mode concurrently, we'll the
+		 * printk_pending value and thus keep a periodic tick behaviour.
+		 * Unless it's possible tick_nohz_adaptive_mode() reads its value
+		 * before the barrier() ?
+		 */
+		if (tick_nohz_adaptive_mode())
+			smp_cpuset_update_nohz(smp_processor_id());
+	}
 }
 
 /**
-- 
1.7.5.4

