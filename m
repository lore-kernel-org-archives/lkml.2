Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab0LNEva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:51:30 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51645 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078Ab0LNEum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:50:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6196"; a="66513331"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v4 4/5] msm: hotplug: support cpu hotplug on msm
Date: Mon, 13 Dec 2010 20:50:32 -0800
Message-Id: <1292302233-16194-5-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292302233-16194-1-git-send-email-johlstei@codeaurora.org>
References: <1292302233-16194-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/Makefile  |    2 +
 arch/arm/mach-msm/hotplug.c |   88 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/hotplug.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 34cd0a8..7a11b4a 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -20,6 +20,8 @@ obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
 obj-$(CONFIG_MSM_SMD) += last_radio_log.o
 obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
 
+obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
+
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
diff --git a/arch/arm/mach-msm/hotplug.c b/arch/arm/mach-msm/hotplug.c
new file mode 100644
index 0000000..3e40a50
--- /dev/null
+++ b/arch/arm/mach-msm/hotplug.c
@@ -0,0 +1,88 @@
+/*
+ *  Copyright (C) 2002 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/smp.h>
+#include <linux/completion.h>
+#include <linux/irq.h>
+
+#include <asm/cacheflush.h>
+
+#include <mach/smp.h>
+
+static inline void cpu_enter_lowpower(void)
+{
+	flush_cache_all();
+}
+
+static inline void cpu_leave_lowpower(void)
+{
+	pen_release = -1;
+	smp_wmb();
+}
+
+static inline void platform_do_lowpower(unsigned int cpu)
+{
+	/* Just enter wfe for now. */
+	for (;;) {
+		asm("wfe" : : : "memory");
+		if (pen_release == cpu) {
+			/*
+			 * OK, proper wakeup, we're done
+			 */
+			break;
+		}
+		smp_rmb();
+
+		/*
+		 * getting here, means that we have come out of WFI without
+		 * having been woken up - this shouldn't happen
+		 *
+		 * The trouble is, letting people know about this is not really
+		 * possible, since we are currently running incoherently, and
+		 * therefore cannot safely call printk() or anything else
+		*/
+		pr_debug("CPU%u: spurious wakeup call\n", cpu);
+	}
+}
+
+int platform_cpu_kill(unsigned int cpu)
+{
+	return 1;
+}
+
+/*
+ * platform-specific code to shutdown a CPU
+ *
+ * Called with IRQs disabled
+ */
+void platform_cpu_die(unsigned int cpu)
+{
+	/*
+	 * we're ready for shutdown now, so do it
+	 */
+	cpu_enter_lowpower();
+	platform_do_lowpower(cpu);
+
+	/*
+	 * bring this CPU back into the world of cache
+	 * coherency, and then restore interrupts
+	 */
+	cpu_leave_lowpower();
+}
+
+int platform_cpu_disable(unsigned int cpu)
+{
+	/*
+	 * we don't allow CPU 0 to be shutdown (it is still too special
+	 * e.g. clock tick interrupts)
+	 */
+	return cpu == 0 ? -EPERM : 0;
+}
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

