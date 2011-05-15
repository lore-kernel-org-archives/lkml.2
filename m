Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab1EOLfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:35:47 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59509 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759980Ab1EOLfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:35:44 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 13/15] [orion] Refactor the MPP code. Common code in the orion platform.
Date: Sun, 15 May 2011 13:32:52 +0200
Message-Id: <1305459174-25517-14-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mv78xx0 and kirkwood use identical mpp code. It should also be
possible to rewrite the orion5x mpp to use this platform code.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-kirkwood/mpp.c           |   58 +---------------------
 arch/arm/mach-kirkwood/mpp.h           |    6 --
 arch/arm/mach-mv78xx0/mpp.c            |   58 +---------------------
 arch/arm/mach-mv78xx0/mpp.h            |    6 --
 arch/arm/plat-orion/Makefile           |    2 +-
 arch/arm/plat-orion/include/plat/mpp.h |   34 +++++++++++++
 arch/arm/plat-orion/mpp.c              |   81 ++++++++++++++++++++++++++++++++
 7 files changed, 122 insertions(+), 123 deletions(-)
 create mode 100644 arch/arm/plat-orion/include/plat/mpp.h
 create mode 100644 arch/arm/plat-orion/mpp.c

diff --git a/arch/arm/mach-kirkwood/mpp.c b/arch/arm/mach-kirkwood/mpp.c
index 7ce2018..b0a7d97 100644
--- a/arch/arm/mach-kirkwood/mpp.c
+++ b/arch/arm/mach-kirkwood/mpp.c
@@ -14,6 +14,7 @@
 #include <linux/io.h>
 #include <asm/gpio.h>
 #include <mach/hardware.h>
+#include <plat/mpp.h>
 #include "common.h"
 #include "mpp.h"
 
@@ -36,61 +37,8 @@ static unsigned int __init kirkwood_variant(void)
 	return 0;
 }
 
-#define MPP_CTRL(i)	(DEV_BUS_VIRT_BASE + (i) * 4)
-#define MPP_NR_REGS	(1 + MPP_MAX/8)
-
 void __init kirkwood_mpp_conf(unsigned int *mpp_list)
 {
-	u32 mpp_ctrl[MPP_NR_REGS];
-	unsigned int variant_mask;
-	int i;
-
-	variant_mask = kirkwood_variant();
-	if (!variant_mask)
-		return;
-
-	printk(KERN_DEBUG "initial MPP regs:");
-	for (i = 0; i < MPP_NR_REGS; i++) {
-		mpp_ctrl[i] = readl(MPP_CTRL(i));
-		printk(" %08x", mpp_ctrl[i]);
-	}
-	printk("\n");
-
-	for ( ; *mpp_list; mpp_list++) {
-		unsigned int num = MPP_NUM(*mpp_list);
-		unsigned int sel = MPP_SEL(*mpp_list);
-		int shift, gpio_mode;
-
-		if (num > MPP_MAX) {
-			printk(KERN_ERR "kirkwood_mpp_conf: invalid MPP "
-					"number (%u)\n", num);
-			continue;
-		}
-		if (!(*mpp_list & variant_mask)) {
-			printk(KERN_WARNING
-			       "kirkwood_mpp_conf: requested MPP%u config "
-			       "unavailable on this hardware\n", num);
-			continue;
-		}
-
-		shift = (num & 7) << 2;
-		mpp_ctrl[num / 8] &= ~(0xf << shift);
-		mpp_ctrl[num / 8] |= sel << shift;
-
-		gpio_mode = 0;
-		if (*mpp_list & MPP_INPUT_MASK)
-			gpio_mode |= GPIO_INPUT_OK;
-		if (*mpp_list & MPP_OUTPUT_MASK)
-			gpio_mode |= GPIO_OUTPUT_OK;
-		if (sel != 0)
-			gpio_mode = 0;
-		orion_gpio_set_valid(num, gpio_mode);
-	}
-
-	printk(KERN_DEBUG "  final MPP regs:");
-	for (i = 0; i < MPP_NR_REGS; i++) {
-		writel(mpp_ctrl[i], MPP_CTRL(i));
-		printk(" %08x", mpp_ctrl[i]);
-	}
-	printk("\n");
+	orion_mpp_conf(mpp_list, kirkwood_variant(),
+		       MPP_MAX, DEV_BUS_VIRT_BASE);
 }
diff --git a/arch/arm/mach-kirkwood/mpp.h b/arch/arm/mach-kirkwood/mpp.h
index 9b0a94d..ac78795 100644
--- a/arch/arm/mach-kirkwood/mpp.h
+++ b/arch/arm/mach-kirkwood/mpp.h
@@ -22,14 +22,8 @@
 	/* available on F6281 */	((!!(_F6281)) << 17) | \
 	/* available on F6282 */	((!!(_F6282)) << 18))
 
-#define MPP_NUM(x)	((x) & 0xff)
-#define MPP_SEL(x)	(((x) >> 8) & 0xf)
-
 				/*   num sel  i  o  6180 6190 6192 6281 6282 */
 
-#define MPP_INPUT_MASK		MPP(  0, 0x0, 1, 0, 0,   0,   0,   0,   0 )
-#define MPP_OUTPUT_MASK		MPP(  0, 0x0, 0, 1, 0,   0,   0,   0,   0 )
-
 #define MPP_F6180_MASK		MPP(  0, 0x0, 0, 0, 1,   0,   0,   0,   0 )
 #define MPP_F6190_MASK		MPP(  0, 0x0, 0, 0, 0,   1,   0,   0,   0 )
 #define MPP_F6192_MASK		MPP(  0, 0x0, 0, 0, 0,   0,   1,   0,   0 )
diff --git a/arch/arm/mach-mv78xx0/mpp.c b/arch/arm/mach-mv78xx0/mpp.c
index 65b72c4..59b7686 100644
--- a/arch/arm/mach-mv78xx0/mpp.c
+++ b/arch/arm/mach-mv78xx0/mpp.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/mbus.h>
 #include <linux/io.h>
+#include <plat/mpp.h>
 #include <asm/gpio.h>
 #include <mach/hardware.h>
 #include "common.h"
@@ -31,61 +32,8 @@ static unsigned int __init mv78xx0_variant(void)
 	return 0;
 }
 
-#define MPP_CTRL(i)	(DEV_BUS_VIRT_BASE + (i) * 4)
-#define MPP_NR_REGS	(1 + MPP_MAX/8)
-
 void __init mv78xx0_mpp_conf(unsigned int *mpp_list)
 {
-	u32 mpp_ctrl[MPP_NR_REGS];
-	unsigned int variant_mask;
-	int i;
-
-	variant_mask = mv78xx0_variant();
-	if (!variant_mask)
-		return;
-
-	printk(KERN_DEBUG "initial MPP regs:");
-	for (i = 0; i < MPP_NR_REGS; i++) {
-		mpp_ctrl[i] = readl(MPP_CTRL(i));
-		printk(" %08x", mpp_ctrl[i]);
-	}
-	printk("\n");
-
-	for ( ; *mpp_list; mpp_list++) {
-		unsigned int num = MPP_NUM(*mpp_list);
-		unsigned int sel = MPP_SEL(*mpp_list);
-		int shift, gpio_mode;
-
-		if (num > MPP_MAX) {
-			printk(KERN_ERR "mv78xx0_mpp_conf: invalid MPP "
-					"number (%u)\n", num);
-			continue;
-		}
-		if (!(*mpp_list & variant_mask)) {
-			printk(KERN_WARNING
-					"mv78xx0_mpp_conf: requested MPP%u config "
-					"unavailable on this hardware\n", num);
-			continue;
-		}
-
-		shift = (num & 7) << 2;
-		mpp_ctrl[num / 8] &= ~(0xf << shift);
-		mpp_ctrl[num / 8] |= sel << shift;
-
-		gpio_mode = 0;
-		if (*mpp_list & MPP_INPUT_MASK)
-			gpio_mode |= GPIO_INPUT_OK;
-		if (*mpp_list & MPP_OUTPUT_MASK)
-			gpio_mode |= GPIO_OUTPUT_OK;
-		if (sel != 0)
-			gpio_mode = 0;
-		orion_gpio_set_valid(num, gpio_mode);
-	}
-
-	printk(KERN_DEBUG "  final MPP regs:");
-	for (i = 0; i < MPP_NR_REGS; i++) {
-		writel(mpp_ctrl[i], MPP_CTRL(i));
-		printk(" %08x", mpp_ctrl[i]);
-	}
-	printk("\n");
+	orion_mpp_conf(mpp_list, mv78xx0_variant(),
+		       MPP_MAX, DEV_BUS_VIRT_BASE);
 }
diff --git a/arch/arm/mach-mv78xx0/mpp.h b/arch/arm/mach-mv78xx0/mpp.h
index 80840b7..b61b509 100644
--- a/arch/arm/mach-mv78xx0/mpp.h
+++ b/arch/arm/mach-mv78xx0/mpp.h
@@ -19,14 +19,8 @@
     /* may be output signal */    ((!!(_out)) << 13) | \
     /* available on A0 */    ((!!(_78100_A0)) << 14))
 
-#define MPP_NUM(x)    ((x) & 0xff)
-#define MPP_SEL(x)    (((x) >> 8) & 0xf)
-
                 /*   num sel  i  o  78100_A0  */
 
-#define MPP_INPUT_MASK        MPP(0, 0x0, 1, 0, 0)
-#define MPP_OUTPUT_MASK        MPP(0, 0x0, 0, 1, 0)
-
 #define MPP_78100_A0_MASK    MPP(0, 0x0, 0, 0, 1)
 
 #define MPP0_GPIO        MPP(0, 0x0, 1, 1, 1)
diff --git a/arch/arm/plat-orion/Makefile b/arch/arm/plat-orion/Makefile
index 0f048c5..95a5fc5 100644
--- a/arch/arm/plat-orion/Makefile
+++ b/arch/arm/plat-orion/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y	:= irq.o pcie.o time.o common.o
+obj-y	:= irq.o pcie.o time.o common.o mpp.o
 obj-m	:=
 obj-n	:=
 obj-	:=
diff --git a/arch/arm/plat-orion/include/plat/mpp.h b/arch/arm/plat-orion/include/plat/mpp.h
new file mode 100644
index 0000000..723adce
--- /dev/null
+++ b/arch/arm/plat-orion/include/plat/mpp.h
@@ -0,0 +1,34 @@
+/*
+ * arch/arm/plat-orion/include/plat/mpp.h
+ *
+ * Marvell Orion SoC MPP handling.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __PLAT_MPP_H
+#define __PLAT_MPP_H
+
+#define MPP_NUM(x)	((x) & 0xff)
+#define MPP_SEL(x)	(((x) >> 8) & 0xf)
+
+/* This is the generic MPP macro, without any variant information.
+   Each machine architecture is expected to extend this with further
+   bit fields indicating which MPP configurations are valid for a
+   specific variant. */
+
+#define GENERIC_MPP(_num, _sel, _in, _out) ( \
+	/* MPP number */		((_num) & 0xff) | \
+	/* MPP select value */		(((_sel) & 0xf) << 8) | \
+	/* may be input signal */	((!!(_in)) << 12) | \
+	/* may be output signal */	((!!(_out)) << 13))
+
+#define MPP_INPUT_MASK		GENERIC_MPP(0, 0x0, 1, 0)
+#define MPP_OUTPUT_MASK		GENERIC_MPP(0, 0x0, 0, 1)
+
+void __init orion_mpp_conf(unsigned int *mpp_list, unsigned int variant_mask,
+			   unsigned int mpp_max, unsigned int dev_bus);
+
+#endif
diff --git a/arch/arm/plat-orion/mpp.c b/arch/arm/plat-orion/mpp.c
new file mode 100644
index 0000000..248c022
--- /dev/null
+++ b/arch/arm/plat-orion/mpp.c
@@ -0,0 +1,81 @@
+/*
+ * arch/arm/plat-orion/mpp.c
+ *
+ * MPP functions for Marvell orion SoCs
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/mbus.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <mach/hardware.h>
+#include <plat/mpp.h>
+
+/* Address of the ith MPP control register */
+static __init unsigned long mpp_ctrl_addr(unsigned int i,
+					  unsigned long dev_bus)
+{
+	return dev_bus + (i) * 4;
+}
+
+
+void __init orion_mpp_conf(unsigned int *mpp_list, unsigned int variant_mask,
+			   unsigned int mpp_max, unsigned int dev_bus)
+{
+	unsigned int mpp_nr_regs = (1 + mpp_max/8);
+	u32 mpp_ctrl[mpp_nr_regs];
+	int i;
+
+	if (!variant_mask)
+		return;
+
+	printk(KERN_DEBUG "initial MPP regs:");
+	for (i = 0; i < mpp_nr_regs; i++) {
+		mpp_ctrl[i] = readl(mpp_ctrl_addr(i, dev_bus));
+		printk(" %08x", mpp_ctrl[i]);
+	}
+	printk("\n");
+
+	for ( ; *mpp_list; mpp_list++) {
+		unsigned int num = MPP_NUM(*mpp_list);
+		unsigned int sel = MPP_SEL(*mpp_list);
+		int shift, gpio_mode;
+
+		if (num > mpp_max) {
+			printk(KERN_ERR "orion_mpp_conf: invalid MPP "
+					"number (%u)\n", num);
+			continue;
+		}
+		if (!(*mpp_list & variant_mask)) {
+			printk(KERN_WARNING
+			       "orion_mpp_conf: requested MPP%u config "
+			       "unavailable on this hardware\n", num);
+			continue;
+		}
+
+		shift = (num & 7) << 2;
+		mpp_ctrl[num / 8] &= ~(0xf << shift);
+		mpp_ctrl[num / 8] |= sel << shift;
+
+		gpio_mode = 0;
+		if (*mpp_list & MPP_INPUT_MASK)
+			gpio_mode |= GPIO_INPUT_OK;
+		if (*mpp_list & MPP_OUTPUT_MASK)
+			gpio_mode |= GPIO_OUTPUT_OK;
+		if (sel != 0)
+			gpio_mode = 0;
+		orion_gpio_set_valid(num, gpio_mode);
+	}
+
+	printk(KERN_DEBUG "  final MPP regs:");
+	for (i = 0; i < mpp_nr_regs; i++) {
+		writel(mpp_ctrl[i], mpp_ctrl_addr(i, dev_bus));
+		printk(" %08x", mpp_ctrl[i]);
+	}
+	printk("\n");
+}
-- 
1.7.4.4

