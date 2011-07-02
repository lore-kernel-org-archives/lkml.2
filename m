Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1GBVSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:18:53 -0400
Received: from mail.southpole.se ([193.12.106.18]:45885 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab1GBVQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:16:17 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v2 11/19] OpenRISC: Idle/Power management
Date: Sat,  2 Jul 2011 23:15:44 +0200
Message-Id: <1309641352-18714-12-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309641352-18714-1-git-send-email-jonas@southpole.se>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Minimal functionality...

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/kernel/idle.c |   77 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/kernel/idle.c

diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
new file mode 100644
index 0000000..495a772
--- /dev/null
+++ b/arch/openrisc/kernel/idle.c
@@ -0,0 +1,77 @@
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
+void (*powersave) (void) = NULL;
+
+static inline void pm_idle(void)
+{
+	barrier();
+}
+
+void cpu_idle(void)
+{
+	set_thread_flag(TIF_POLLING_NRFLAG);
+
+	/* endless idle loop with no priority at all */
+	while (1) {
+		tick_nohz_stop_sched_tick(1);
+
+		while (!need_resched()) {
+			check_pgt_cache();
+			rmb();
+
+			clear_thread_flag(TIF_POLLING_NRFLAG);
+
+			local_irq_disable();
+			/* Don't trace irqs off for idle */
+			stop_critical_timings();
+			if (powersave != NULL)
+				powersave();
+			start_critical_timings();
+			local_irq_enable();
+			set_thread_flag(TIF_POLLING_NRFLAG);
+		}
+
+		tick_nohz_restart_sched_tick();
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
-- 
1.7.4.1

