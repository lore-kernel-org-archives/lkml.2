Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2HEOq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:46:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46126 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2HEOq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:46:26 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: kirkwood: DT board setup for Seagate FreeAgent Dockstar
Date: Sun,  5 Aug 2012 16:46:12 +0200
Message-Id: <1344177973-6505-1-git-send-email-sebastian.hesselbarth@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add a DT compatible board specific setup for the Seagate
FreeAgent Dockstar.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-kirkwood/Kconfig          |    7 ++++
 arch/arm/mach-kirkwood/Makefile         |    1 +
 arch/arm/mach-kirkwood/board-dockstar.c |   61 +++++++++++++++++++++++++++++++
 arch/arm/mach-kirkwood/board-dt.c       |    4 ++
 arch/arm/mach-kirkwood/common.h         |    6 +++
 5 files changed, 79 insertions(+)
 create mode 100644 arch/arm/mach-kirkwood/board-dockstar.c

diff --git a/arch/arm/mach-kirkwood/Kconfig b/arch/arm/mach-kirkwood/Kconfig
index ca5c15a..4eaeb93 100644
--- a/arch/arm/mach-kirkwood/Kconfig
+++ b/arch/arm/mach-kirkwood/Kconfig
@@ -94,6 +94,13 @@ config MACH_TS219_DT
 	  or MV6282. If you have the wrong one, the buttons will not
 	  work.
 
+config MACH_DOCKSTAR_DT
+	bool "Seagate FreeAgent Dockstar (Flattened Device Tree)"
+	select ARCH_KIRKWOOD_DT
+	help
+	  Say 'Y' here if you want your kernel to support the
+	  Seagate FreeAgent Dockstar (Flattened Device Tree).
+
 config MACH_GOFLEXNET_DT
 	bool "Seagate GoFlex Net (Flattened Device Tree)"
 	select ARCH_KIRKWOOD_DT
diff --git a/arch/arm/mach-kirkwood/Makefile b/arch/arm/mach-kirkwood/Makefile
index 055c85a..42e48cf 100644
--- a/arch/arm/mach-kirkwood/Makefile
+++ b/arch/arm/mach-kirkwood/Makefile
@@ -26,5 +26,6 @@ obj-$(CONFIG_MACH_ICONNECT_DT)		+= board-iconnect.o
 obj-$(CONFIG_MACH_DLINK_KIRKWOOD_DT)	+= board-dnskw.o
 obj-$(CONFIG_MACH_IB62X0_DT)		+= board-ib62x0.o
 obj-$(CONFIG_MACH_TS219_DT)		+= board-ts219.o tsx1x-common.o
+obj-$(CONFIG_MACH_DOCKSTAR_DT)		+= board-dockstar.o
 obj-$(CONFIG_MACH_GOFLEXNET_DT)		+= board-goflexnet.o
 obj-$(CONFIG_MACH_LSXL_DT)		+= board-lsxl.o
diff --git a/arch/arm/mach-kirkwood/board-dockstar.c b/arch/arm/mach-kirkwood/board-dockstar.c
new file mode 100644
index 0000000..6b9560b
--- /dev/null
+++ b/arch/arm/mach-kirkwood/board-dockstar.c
@@ -0,0 +1,61 @@
+/*
+ * arch/arm/mach-kirkwood/board-dockstar.c
+ *
+ * Seagate FreeAgent Dockstar Board Init for drivers not converted to
+ * flattened device tree yet.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * Copied and modified for Seagate GoFlex Net support by
+ * Joshua Coombs <josh.coombs@gmail.com> based on ArchLinux ARM's
+ * GoFlex kernel patches.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/ata_platform.h>
+#include <linux/mv643xx_eth.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_fdt.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/gpio.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <mach/kirkwood.h>
+#include <mach/bridge-regs.h>
+#include <plat/mvsdio.h>
+#include "common.h"
+#include "mpp.h"
+
+static struct mv643xx_eth_platform_data dockstar_ge00_data = {
+	.phy_addr	= MV643XX_ETH_PHY_ADDR(0),
+};
+
+static unsigned int dockstar_mpp_config[] __initdata = {
+	MPP29_GPIO,	/* USB Power Enable */
+	MPP46_GPIO,	/* LED green */
+	MPP47_GPIO,	/* LED orange */
+	0
+};
+
+void __init dockstar_init(void)
+{
+	/*
+	 * Basic setup. Needs to be called early.
+	 */
+	kirkwood_mpp_conf(dockstar_mpp_config);
+
+	if (gpio_request(29, "USB Power Enable") != 0 ||
+	    gpio_direction_output(29, 1) != 0)
+		pr_err("can't setup GPIO 29 (USB Power Enable)\n");
+	kirkwood_ehci_init();
+
+	kirkwood_ge00_init(&dockstar_ge00_data);
+}
diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index e4eb450..4693fad 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -81,6 +81,9 @@ static void __init kirkwood_dt_init(void)
 	if (of_machine_is_compatible("qnap,ts219"))
 		qnap_dt_ts219_init();
 
+	if (of_machine_is_compatible("seagate,dockstar"))
+		dockstar_init();
+
 	if (of_machine_is_compatible("seagate,goflexnet"))
 		goflexnet_init();
 
@@ -98,6 +101,7 @@ static const char *kirkwood_dt_board_compat[] = {
 	"iom,iconnect",
 	"raidsonic,ib-nas62x0",
 	"qnap,ts219",
+	"seagate,dockstar",
 	"seagate,goflexnet",
 	"buffalo,lsxl",
 	NULL
diff --git a/arch/arm/mach-kirkwood/common.h b/arch/arm/mach-kirkwood/common.h
index 304dd1a..dc73ff3 100644
--- a/arch/arm/mach-kirkwood/common.h
+++ b/arch/arm/mach-kirkwood/common.h
@@ -82,6 +82,12 @@ void ib62x0_init(void);
 static inline void ib62x0_init(void) {};
 #endif
 
+#ifdef CONFIG_MACH_DOCKSTAR_DT
+void dockstar_init(void);
+#else
+static inline void dockstar_init(void) {};
+#endif
+
 #ifdef CONFIG_MACH_GOFLEXNET_DT
 void goflexnet_init(void);
 #else
-- 
1.7.10.4

