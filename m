Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1HRVvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:51:38 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:52008 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754545Ab1HRVvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:51:01 -0400
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com
Cc: James Nuss <jamesnuss@nanometrics.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ARM: davinci: da850, omapl138: introduce new board-omapl138-heliosv1
Date: Thu, 18 Aug 2011 17:50:51 -0400
Message-Id: <f31e949dcaac301b40a0f6c0b611e84f57636ef0.1313702401.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1313702401.git.bengardiner@nanometrics.ca>
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
In-Reply-To: <cover.1313702401.git.bengardiner@nanometrics.ca>
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Nanometrics Helios Platform V1 Hardware. Initially
support includes only serial console and watchdog support.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: James Nuss <jamesnuss@nanometrics.ca>
---
 arch/arm/mach-davinci/Kconfig                   |    9 ++++
 arch/arm/mach-davinci/Makefile                  |    1 +
 arch/arm/mach-davinci/board-omapl138-heliosv1.c |   51 +++++++++++++++++++++++
 3 files changed, 61 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-davinci/board-omapl138-heliosv1.c

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index c0deaca..21a8ce9 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -224,6 +224,15 @@ config MACH_OMAPL138_HAWKBOARD
 	  Information of this board may be found at
 	  http://www.hawkboard.org/
 
+config MACH_HELIOS_V1
+	bool "Nanometrics OMAPL-138 Helios V1 platform"
+	depends on ARCH_DAVINCI_DA850
+	help
+	  Say Y here to select the Nanometrics OMAPL-138 Helios V1 platform.
+	  This is a development system based on the DA850 EVM baseboard.
+	  It is the first Helios hardware platform upon which other platforms in the
+	  Helios product family are based.
+
 config DAVINCI_MUX
 	bool "DAVINCI multiplexing support"
 	depends on ARCH_DAVINCI
diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 9a01441..96d74c9 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_MACH_DAVINCI_DA850_EVM)	+= board-da850-evm.o
 obj-$(CONFIG_MACH_TNETV107X)		+= board-tnetv107x-evm.o
 obj-$(CONFIG_MACH_MITYOMAPL138)		+= board-mityomapl138.o
 obj-$(CONFIG_MACH_OMAPL138_HAWKBOARD)	+= board-omapl138-hawk.o
+obj-$(CONFIG_MACH_HELIOS_V1)		+= board-omapl138-heliosv1.o
 
 # Power Management
 obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o
diff --git a/arch/arm/mach-davinci/board-omapl138-heliosv1.c b/arch/arm/mach-davinci/board-omapl138-heliosv1.c
new file mode 100644
index 0000000..73cc0a9
--- /dev/null
+++ b/arch/arm/mach-davinci/board-omapl138-heliosv1.c
@@ -0,0 +1,51 @@
+/*
+ * Nanometrics OMAPL-138 Helios V1 platform.
+ *
+ * Copyright (C) 2011 Nanometrics Inc.
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of
+ * any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/gpio.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+#include <mach/cp_intc.h>
+#include <mach/da8xx.h>
+#include <mach/da850-reference.h>
+
+static __init void helios_v1_init(void)
+{
+	int ret;
+
+	da850_reference_serial_init();
+
+	ret = da8xx_register_watchdog();
+	if (ret)
+		pr_warning("%s: watchdog registration failed: %d\n",
+			__func__, ret);
+}
+
+#ifdef CONFIG_SERIAL_8250_CONSOLE
+static int __init helios_v1_console_init(void)
+{
+	if (!machine_is_helios_v1())
+		return 0;
+
+	return da850_reference_add_preferred_console();
+}
+console_initcall(helios_v1_console_init);
+#endif
+
+MACHINE_START(HELIOS_V1, "Nanometrics OMAPL-138 Helios V1 platform")
+	.boot_params	= DA850_REFERENCE_BOOT_PARAMS,
+	.map_io		= da850_reference_map_io,
+	.init_irq	= cp_intc_init,
+	.timer		= &davinci_timer,
+	.init_machine	= helios_v1_init,
+MACHINE_END
-- 
1.7.4.1

