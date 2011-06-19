Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1FSLrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:47:42 -0400
Received: from mail.southpole.se ([193.12.106.18]:37748 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1FSLpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:21 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 11/19] OpenRISC: Idle/Power management
Date: Sun, 19 Jun 2011 13:43:37 +0200
Message-Id: <1308483825-6023-12-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Minimal functionality...

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/kernel/idle.c |   81 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/kernel/idle.c

diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
new file mode 100644
index 0000000..6909325
--- /dev/null
+++ b/arch/openrisc/kernel/idle.c
@@ -0,0 +1,81 @@
+/*
+ * OpenRISC idle.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ * Idle daemon for or32.  Idle daemon will handle any action
+ * that needs to be taken when the system becomes idle.
+ */
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/tick.h>
+
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/mmu.h>
+#include <asm/cache.h>
+#include <asm/pgalloc.h>
+
+void (*powersave)(void) = NULL;
+
+static inline void pm_idle(void) {
+	barrier();
+}
+
+void cpu_idle(void)
+{
+        unsigned int cpu = smp_processor_id();
+
+        set_thread_flag(TIF_POLLING_NRFLAG);
+
+        /* endless idle loop with no priority at all */
+        while (1) {
+                tick_nohz_stop_sched_tick(1);
+
+                while (!need_resched()) {
+                        check_pgt_cache();
+                        rmb();
+
+/*                        if (cpu_is_offline(cpu))
+                                play_dead();
+*/
+			clear_thread_flag(TIF_POLLING_NRFLAG);
+
+                        local_irq_disable();
+                        /* Don't trace irqs off for idle */
+                        stop_critical_timings();
+			if (powersave != NULL )
+				powersave();
+			start_critical_timings();
+			local_irq_enable();
+		        set_thread_flag(TIF_POLLING_NRFLAG);
+                }
+
+                tick_nohz_restart_sched_tick();
+                preempt_enable_no_resched();
+                schedule();
+                preempt_disable();
+        }
+}
-- 
1.7.4.1

