Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0LPGyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 01:54:38 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29752 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0LPGye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 01:54:34 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66835759"
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
Subject: [PATCH v5 4/5] msm: hotplug: support cpu hotplug on msm
Date: Wed, 15 Dec 2010 22:54:15 -0800
Message-Id: <1292482456-22690-5-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292482456-22690-1-git-send-email-johlstei@codeaurora.org>
References: <1292482456-22690-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/Makefile  |    2 +
 arch/arm/mach-msm/hotplug.c |   91 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 0 deletions(-)
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
index 0000000..4c45776
--- /dev/null
+++ b/arch/arm/mach-msm/hotplug.c
@@ -0,0 +1,91 @@
+/*
+ *  Copyright (C) 2002 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/smp.h>
+
+#include <asm/cacheflush.h>
+
+extern volatile int pen_release;
+
+static inline void cpu_enter_lowpower(void)
+{
+	/* Just flush the cache. Changing the coherency is not yet
+	 * available on msm. */
+	flush_cache_all();
+}
+
+static inline void cpu_leave_lowpower(void)
+{
+}
+
+static inline void platform_do_lowpower(unsigned int cpu)
+{
+	/* Just enter wfi for now. TODO: Properly shut off the cpu. */
+	for (;;) {
+		/*
+		 * here's the WFI
+		 */
+		asm(".word	0xe320f003\n"
+		    :
+		    :
+		    : "memory", "cc");
+
+		if (pen_release == cpu) {
+			/*
+			 * OK, proper wakeup, we're done
+			 */
+			break;
+		}
+
+		/*
+		 * getting here, means that we have come out of WFI without
+		 * having been woken up - this shouldn't happen
+		 *
+		 * The trouble is, letting people know about this is not really
+		 * possible, since we are currently running incoherently, and
+		 * therefore cannot safely call printk() or anything else
+		 */
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

