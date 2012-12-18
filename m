Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2LRNMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:12:32 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54073 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857Ab2LRNM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:12:27 -0500
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Linus Walleij <linus.walleij@linaro.org>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH 1/9] mailbox: OMAP: introduce mailbox framework
Date: Tue, 18 Dec 2012 14:10:04 +0100
Message-ID: <1355836212-17956-2-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually moving it from plat-omap, as this framework/driver code is
supposed to be under drivers/ folder. The framework should work with
the current supported OMAP processors (OMAP1+) that have mailbox and
can be used as a method of interprocessor communication.

The mailbox hardware (in OMAP) uses a queued mailbox-interrupt mechanism
that provides a communication channel between processors through a set of
registers and their associated interrupt signals by sending and receiving
messages.

As part of the migration from plat and mach code:
- Kconfig symbols have been renamed to build OMAP1 or OMAP2+ drivers.
- mailbox.h has been changed from plat to a dedicated drivers/ folder.
- soc.h has been changed for plat/cpu.h, since there are dependencies in
  the cpu_is_XXXX() macro.

Module names have changed too, instead of mailbox_mach:
- OMAP1: mailbox-omap1.ko
- OMAP2+: mailbox-omap2.ko

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/configs/omap1_defconfig                   |   3 +-
 arch/arm/mach-omap1/Makefile                       |   4 -
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/devices.c                      |   4 +-
 arch/arm/plat-omap/Kconfig                         |  16 ---
 arch/arm/plat-omap/Makefile                        |   3 -
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/mailbox/Kconfig                            |  37 +++++
 drivers/mailbox/Makefile                           |   4 +
 .../mailbox.c => drivers/mailbox/mailbox-omap1.c   |  65 ++++-----
 .../mailbox.c => drivers/mailbox/mailbox-omap2.c   | 160 ++++++++++-----------
 {arch/arm/plat-omap => drivers/mailbox}/mailbox.c  |  18 +--
 .../include/plat => drivers/mailbox}/mailbox.h     |  58 ++++----
 14 files changed, 199 insertions(+), 179 deletions(-)
 create mode 100644 drivers/mailbox/Kconfig
 create mode 100644 drivers/mailbox/Makefile
 rename arch/arm/mach-omap1/mailbox.c => drivers/mailbox/mailbox-omap1.c (75%)
 rename arch/arm/mach-omap2/mailbox.c => drivers/mailbox/mailbox-omap2.c (69%)
 rename {arch/arm/plat-omap => drivers/mailbox}/mailbox.c (97%)
 rename {arch/arm/plat-omap/include/plat => drivers/mailbox}/mailbox.h (57%)

diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index dde2a1a..37894db 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -26,7 +26,8 @@ CONFIG_ARCH_OMAP=y
 CONFIG_ARCH_OMAP1=y
 CONFIG_OMAP_RESET_CLOCKS=y
 # CONFIG_OMAP_MUX is not set
-CONFIG_OMAP_MBOX_FWK=y
+CONFIG_MAILBOX=y
+CONFIG_OMAP1_MBOX=y
 CONFIG_OMAP_32K_TIMER=y
 CONFIG_OMAP_DM_TIMER=y
 CONFIG_ARCH_OMAP730=y
diff --git a/arch/arm/mach-omap1/Makefile b/arch/arm/mach-omap1/Makefile
index cd169c3..48275f8 100644
--- a/arch/arm/mach-omap1/Makefile
+++ b/arch/arm/mach-omap1/Makefile
@@ -18,10 +18,6 @@ obj-$(CONFIG_ARCH_OMAP16XX) += ocpi.o
 # Power Management
 obj-$(CONFIG_PM) += pm.o sleep.o
 
-# DSP
-obj-$(CONFIG_OMAP_MBOX_FWK)	+= mailbox_mach.o
-mailbox_mach-objs		:= mailbox.o
-
 i2c-omap-$(CONFIG_I2C_OMAP)		:= i2c.o
 obj-y					+= $(i2c-omap-m) $(i2c-omap-y)
 
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index fe40d9e..3907fc5 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -181,9 +181,6 @@ obj-$(CONFIG_ARCH_OMAP4)		+= omap_hwmod_44xx_data.o
 obj-$(CONFIG_OMAP3_EMU)			+= emu.o
 obj-$(CONFIG_HW_PERF_EVENTS)		+= pmu.o
 
-obj-$(CONFIG_OMAP_MBOX_FWK)		+= mailbox_mach.o
-mailbox_mach-objs			:= mailbox.o
-
 obj-$(CONFIG_OMAP_IOMMU)		+= iommu2.o
 
 iommu-$(CONFIG_OMAP_IOMMU)		:= omap-iommu.o
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c72b5a7..5ef4004 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -273,7 +273,7 @@ int __init omap4_keyboard_init(struct omap4_keypad_platform_data
 	return 0;
 }
 
-#if defined(CONFIG_OMAP_MBOX_FWK) || defined(CONFIG_OMAP_MBOX_FWK_MODULE)
+#if defined(CONFIG_OMAP2PLUS_MBOX) || defined(CONFIG_OMAP2PLUS_MBOX_MODULE)
 static inline void __init omap_init_mbox(void)
 {
 	struct omap_hwmod *oh;
@@ -291,7 +291,7 @@ static inline void __init omap_init_mbox(void)
 }
 #else
 static inline void omap_init_mbox(void) { }
-#endif /* CONFIG_OMAP_MBOX_FWK */
+#endif /* CONFIG_OMAP2PLUS_MBOX */
 
 static inline void omap_init_sti(void) {}
 
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 82fcb20..419648f 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -116,22 +116,6 @@ config OMAP_MUX_WARNINGS
 	  to change the pin multiplexing setup.	 When there are no warnings
 	  printed, it's safe to deselect OMAP_MUX for your product.
 
-config OMAP_MBOX_FWK
-	tristate "Mailbox framework support"
-	depends on ARCH_OMAP
-	help
-	  Say Y here if you want to use OMAP Mailbox framework support for
-	  DSP, IVA1.0 and IVA2 in OMAP1/2/3.
-
-config OMAP_MBOX_KFIFO_SIZE
-	int "Mailbox kfifo default buffer size (bytes)"
-	depends on OMAP_MBOX_FWK
-	default 256
-	help
-	  Specify the default size of mailbox's kfifo buffers (bytes).
-	  This can also be changed at runtime (via the mbox_kfifo_size
-	  module parameter).
-
 config OMAP_IOMMU_IVA2
 	bool
 
diff --git a/arch/arm/plat-omap/Makefile b/arch/arm/plat-omap/Makefile
index dacaee0..304fa78 100644
--- a/arch/arm/plat-omap/Makefile
+++ b/arch/arm/plat-omap/Makefile
@@ -17,7 +17,4 @@ obj-$(CONFIG_OMAP_DEBUG_LEDS) += debug-leds.o
 i2c-omap-$(CONFIG_I2C_OMAP) := i2c.o
 obj-y += $(i2c-omap-m) $(i2c-omap-y)
 
-# OMAP mailbox framework
-obj-$(CONFIG_OMAP_MBOX_FWK) += mailbox.o
-
 obj-$(CONFIG_OMAP_PM_NOOP) += omap-pm-noop.o
diff --git a/drivers/Kconfig b/drivers/Kconfig
index dbdefa3..7a4fb98 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -134,6 +134,8 @@ source "drivers/hwspinlock/Kconfig"
 
 source "drivers/clocksource/Kconfig"
 
+source "drivers/mailbox/Kconfig"
+
 source "drivers/iommu/Kconfig"
 
 source "drivers/remoteproc/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index a16a8d0..78f2bf0 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -132,6 +132,7 @@ obj-y				+= clk/
 
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
 obj-$(CONFIG_NFC)		+= nfc/
+obj-$(CONFIG_MAILBOX)		+= mailbox/
 obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
 obj-$(CONFIG_REMOTEPROC)	+= remoteproc/
 obj-$(CONFIG_RPMSG)		+= rpmsg/
diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
new file mode 100644
index 0000000..e98ca6c
--- /dev/null
+++ b/drivers/mailbox/Kconfig
@@ -0,0 +1,37 @@
+menuconfig MAILBOX
+       bool "Mailbox Hardware Support"
+       help
+         Mailbox is a framework to control hardware communication between
+         on-chip processors through queued messages and interrupt driven
+         signals. Say Y if your platform supports hardware mailboxes.
+
+if MAILBOX
+
+config OMAP1_MBOX
+       tristate "OMAP1 Mailbox framework support"
+       depends on ARCH_OMAP
+       help
+         Mailbox implementation for OMAP chips with hardware for
+         interprocessor communication involving DSP in OMAP1. Say Y here
+         if you want to use OMAP1 Mailbox framework support.
+
+config OMAP2PLUS_MBOX
+       tristate "OMAP2+ Mailbox framework support"
+       depends on ARCH_OMAP
+       help
+         Mailbox implementation for OMAP family chips with hardware for
+         interprocessor communication involving DSP, IVA1.0 and IVA2 in
+         OMAP2/3; or IPU, IVA HD and DSP in OMAP4. Say Y here if you want
+         to use OMAP2+ Mailbox framework support.
+
+
+config OMAP_MBOX_KFIFO_SIZE
+       int "Mailbox kfifo default buffer size (bytes)"
+       depends on OMAP1_MBOX || OMAP2PLUS_MBOX
+       default 256
+       help
+         Specify the default size of mailbox's kfifo buffers (bytes).
+         This can also be changed at runtime (via the mbox_kfifo_size
+         module parameter).
+
+endif
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
new file mode 100644
index 0000000..4085b71
--- /dev/null
+++ b/drivers/mailbox/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_MAILBOX) += mailbox.o
+
+obj-$(CONFIG_OMAP1_MBOX)       += mailbox-omap1.o
+obj-$(CONFIG_OMAP2PLUS_MBOX)   += mailbox-omap2.o
diff --git a/arch/arm/mach-omap1/mailbox.c b/drivers/mailbox/mailbox-omap1.c
similarity index 75%
rename from arch/arm/mach-omap1/mailbox.c
rename to drivers/mailbox/mailbox-omap1.c
index e962926..d681d4e 100644
--- a/arch/arm/mach-omap1/mailbox.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -13,17 +13,18 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <plat/mailbox.h>
-
-#define MAILBOX_ARM2DSP1		0x00
-#define MAILBOX_ARM2DSP1b		0x04
-#define MAILBOX_DSP2ARM1		0x08
-#define MAILBOX_DSP2ARM1b		0x0c
-#define MAILBOX_DSP2ARM2		0x10
-#define MAILBOX_DSP2ARM2b		0x14
-#define MAILBOX_ARM2DSP1_Flag		0x18
-#define MAILBOX_DSP2ARM1_Flag		0x1c
-#define MAILBOX_DSP2ARM2_Flag		0x20
+
+#include "mailbox.h"
+
+#define MAILBOX_ARM2DSP1               0x00
+#define MAILBOX_ARM2DSP1b              0x04
+#define MAILBOX_DSP2ARM1               0x08
+#define MAILBOX_DSP2ARM1b              0x0c
+#define MAILBOX_DSP2ARM2               0x10
+#define MAILBOX_DSP2ARM2b              0x14
+#define MAILBOX_ARM2DSP1_Flag          0x18
+#define MAILBOX_DSP2ARM1_Flag          0x1c
+#define MAILBOX_DSP2ARM2_Flag          0x20
 
 static void __iomem *mbox_base;
 
@@ -108,14 +109,14 @@ omap1_mbox_is_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
 }
 
 static struct omap_mbox_ops omap1_mbox_ops = {
-	.type		= OMAP_MBOX_TYPE1,
-	.fifo_read	= omap1_mbox_fifo_read,
-	.fifo_write	= omap1_mbox_fifo_write,
-	.fifo_empty	= omap1_mbox_fifo_empty,
-	.fifo_full	= omap1_mbox_fifo_full,
-	.enable_irq	= omap1_mbox_enable_irq,
-	.disable_irq	= omap1_mbox_disable_irq,
-	.is_irq		= omap1_mbox_is_irq,
+	.type           = OMAP_MBOX_TYPE1,
+	.fifo_read      = omap1_mbox_fifo_read,
+	.fifo_write     = omap1_mbox_fifo_write,
+	.fifo_empty     = omap1_mbox_fifo_empty,
+	.fifo_full      = omap1_mbox_fifo_full,
+	.enable_irq     = omap1_mbox_enable_irq,
+	.disable_irq    = omap1_mbox_disable_irq,
+	.is_irq         = omap1_mbox_is_irq,
 };
 
 /* FIXME: the following struct should be created automatically by the user id */
@@ -123,21 +124,21 @@ static struct omap_mbox_ops omap1_mbox_ops = {
 /* DSP */
 static struct omap_mbox1_priv omap1_mbox_dsp_priv = {
 	.tx_fifo = {
-		.cmd	= MAILBOX_ARM2DSP1b,
-		.data	= MAILBOX_ARM2DSP1,
-		.flag	= MAILBOX_ARM2DSP1_Flag,
+		.cmd    = MAILBOX_ARM2DSP1b,
+		.data   = MAILBOX_ARM2DSP1,
+		.flag   = MAILBOX_ARM2DSP1_Flag,
 	},
 	.rx_fifo = {
-		.cmd	= MAILBOX_DSP2ARM1b,
-		.data	= MAILBOX_DSP2ARM1,
-		.flag	= MAILBOX_DSP2ARM1_Flag,
+		.cmd    = MAILBOX_DSP2ARM1b,
+		.data   = MAILBOX_DSP2ARM1,
+		.flag   = MAILBOX_DSP2ARM1_Flag,
 	},
 };
 
 static struct omap_mbox mbox_dsp_info = {
-	.name	= "dsp",
-	.ops	= &omap1_mbox_ops,
-	.priv	= &omap1_mbox_dsp_priv,
+	.name   = "dsp",
+	.ops    = &omap1_mbox_ops,
+	.priv   = &omap1_mbox_dsp_priv,
 };
 
 static struct omap_mbox *omap1_mboxes[] = { &mbox_dsp_info, NULL };
@@ -173,10 +174,10 @@ static int __devexit omap1_mbox_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver omap1_mbox_driver = {
-	.probe	= omap1_mbox_probe,
-	.remove	= __devexit_p(omap1_mbox_remove),
-	.driver	= {
-		.name	= "omap-mailbox",
+	.probe  = omap1_mbox_probe,
+	.remove = __devexit_p(omap1_mbox_remove),
+	.driver = {
+		.name   = "omap-mailbox",
 	},
 };
 
diff --git a/arch/arm/mach-omap2/mailbox.c b/drivers/mailbox/mailbox-omap2.c
similarity index 69%
rename from arch/arm/mach-omap2/mailbox.c
rename to drivers/mailbox/mailbox-omap2.c
index 0d97456..7dcffa8 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -17,30 +17,30 @@
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
 
-#include <plat/mailbox.h>
+#include <plat/cpu.h>
 
-#include "soc.h"
+#include "mailbox.h"
 
-#define MAILBOX_REVISION		0x000
-#define MAILBOX_MESSAGE(m)		(0x040 + 4 * (m))
-#define MAILBOX_FIFOSTATUS(m)		(0x080 + 4 * (m))
-#define MAILBOX_MSGSTATUS(m)		(0x0c0 + 4 * (m))
-#define MAILBOX_IRQSTATUS(u)		(0x100 + 8 * (u))
-#define MAILBOX_IRQENABLE(u)		(0x104 + 8 * (u))
+#define MAILBOX_REVISION               0x000
+#define MAILBOX_MESSAGE(m)             (0x040 + 4 * (m))
+#define MAILBOX_FIFOSTATUS(m)          (0x080 + 4 * (m))
+#define MAILBOX_MSGSTATUS(m)           (0x0c0 + 4 * (m))
+#define MAILBOX_IRQSTATUS(u)           (0x100 + 8 * (u))
+#define MAILBOX_IRQENABLE(u)           (0x104 + 8 * (u))
 
-#define OMAP4_MAILBOX_IRQSTATUS(u)	(0x104 + 0x10 * (u))
-#define OMAP4_MAILBOX_IRQENABLE(u)	(0x108 + 0x10 * (u))
-#define OMAP4_MAILBOX_IRQENABLE_CLR(u)	(0x10c + 0x10 * (u))
+#define OMAP4_MAILBOX_IRQSTATUS(u)     (0x104 + 0x10 * (u))
+#define OMAP4_MAILBOX_IRQENABLE(u)     (0x108 + 0x10 * (u))
+#define OMAP4_MAILBOX_IRQENABLE_CLR(u) (0x10c + 0x10 * (u))
 
-#define MAILBOX_IRQ_NEWMSG(m)		(1 << (2 * (m)))
-#define MAILBOX_IRQ_NOTFULL(m)		(1 << (2 * (m) + 1))
+#define MAILBOX_IRQ_NEWMSG(m)          (1 << (2 * (m)))
+#define MAILBOX_IRQ_NOTFULL(m)         (1 << (2 * (m) + 1))
 
-#define MBOX_REG_SIZE			0x120
+#define MBOX_REG_SIZE                  0x120
 
-#define OMAP4_MBOX_REG_SIZE		0x130
+#define OMAP4_MBOX_REG_SIZE            0x130
 
-#define MBOX_NR_REGS			(MBOX_REG_SIZE / sizeof(u32))
-#define OMAP4_MBOX_NR_REGS		(OMAP4_MBOX_REG_SIZE / sizeof(u32))
+#define MBOX_NR_REGS                   (MBOX_REG_SIZE / sizeof(u32))
+#define OMAP4_MBOX_NR_REGS             (OMAP4_MBOX_REG_SIZE / sizeof(u32))
 
 static void __iomem *mbox_base;
 
@@ -62,7 +62,7 @@ struct omap_mbox2_priv {
 };
 
 static void omap2_mbox_enable_irq(struct omap_mbox *mbox,
-				  omap_mbox_type_t irq);
+		omap_mbox_type_t irq);
 
 static inline unsigned int mbox_read_reg(size_t ofs)
 {
@@ -183,7 +183,7 @@ static void omap2_mbox_save_ctx(struct omap_mbox *mbox)
 		p->ctx[i] = mbox_read_reg(i * sizeof(u32));
 
 		dev_dbg(mbox->dev, "%s: [%02x] %08x\n", __func__,
-			i, p->ctx[i]);
+				i, p->ctx[i]);
 	}
 }
 
@@ -200,24 +200,24 @@ static void omap2_mbox_restore_ctx(struct omap_mbox *mbox)
 		mbox_write_reg(p->ctx[i], i * sizeof(u32));
 
 		dev_dbg(mbox->dev, "%s: [%02x] %08x\n", __func__,
-			i, p->ctx[i]);
+				i, p->ctx[i]);
 	}
 }
 
 static struct omap_mbox_ops omap2_mbox_ops = {
-	.type		= OMAP_MBOX_TYPE2,
-	.startup	= omap2_mbox_startup,
-	.shutdown	= omap2_mbox_shutdown,
-	.fifo_read	= omap2_mbox_fifo_read,
-	.fifo_write	= omap2_mbox_fifo_write,
-	.fifo_empty	= omap2_mbox_fifo_empty,
-	.fifo_full	= omap2_mbox_fifo_full,
-	.enable_irq	= omap2_mbox_enable_irq,
-	.disable_irq	= omap2_mbox_disable_irq,
-	.ack_irq	= omap2_mbox_ack_irq,
-	.is_irq		= omap2_mbox_is_irq,
-	.save_ctx	= omap2_mbox_save_ctx,
-	.restore_ctx	= omap2_mbox_restore_ctx,
+	.type           = OMAP_MBOX_TYPE2,
+	.startup        = omap2_mbox_startup,
+	.shutdown       = omap2_mbox_shutdown,
+	.fifo_read      = omap2_mbox_fifo_read,
+	.fifo_write     = omap2_mbox_fifo_write,
+	.fifo_empty     = omap2_mbox_fifo_empty,
+	.fifo_full      = omap2_mbox_fifo_full,
+	.enable_irq     = omap2_mbox_enable_irq,
+	.disable_irq    = omap2_mbox_disable_irq,
+	.ack_irq        = omap2_mbox_ack_irq,
+	.is_irq         = omap2_mbox_is_irq,
+	.save_ctx       = omap2_mbox_save_ctx,
+	.restore_ctx    = omap2_mbox_restore_ctx,
 };
 
 /*
@@ -233,24 +233,24 @@ static struct omap_mbox_ops omap2_mbox_ops = {
 /* DSP */
 static struct omap_mbox2_priv omap2_mbox_dsp_priv = {
 	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE(0),
-		.fifo_stat	= MAILBOX_FIFOSTATUS(0),
+		.msg            = MAILBOX_MESSAGE(0),
+		.fifo_stat      = MAILBOX_FIFOSTATUS(0),
 	},
 	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE(1),
-		.msg_stat	= MAILBOX_MSGSTATUS(1),
+		.msg            = MAILBOX_MESSAGE(1),
+		.msg_stat       = MAILBOX_MSGSTATUS(1),
 	},
-	.irqenable	= MAILBOX_IRQENABLE(0),
-	.irqstatus	= MAILBOX_IRQSTATUS(0),
-	.notfull_bit	= MAILBOX_IRQ_NOTFULL(0),
-	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(1),
-	.irqdisable	= MAILBOX_IRQENABLE(0),
+	.irqenable      = MAILBOX_IRQENABLE(0),
+	.irqstatus      = MAILBOX_IRQSTATUS(0),
+	.notfull_bit    = MAILBOX_IRQ_NOTFULL(0),
+	.newmsg_bit     = MAILBOX_IRQ_NEWMSG(1),
+	.irqdisable     = MAILBOX_IRQENABLE(0),
 };
 
 struct omap_mbox mbox_dsp_info = {
-	.name	= "dsp",
-	.ops	= &omap2_mbox_ops,
-	.priv	= &omap2_mbox_dsp_priv,
+	.name   = "dsp",
+	.ops    = &omap2_mbox_ops,
+	.priv   = &omap2_mbox_dsp_priv,
 };
 #endif
 
@@ -262,24 +262,24 @@ struct omap_mbox *omap3_mboxes[] = { &mbox_dsp_info, NULL };
 /* IVA */
 static struct omap_mbox2_priv omap2_mbox_iva_priv = {
 	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE(2),
-		.fifo_stat	= MAILBOX_FIFOSTATUS(2),
+		.msg            = MAILBOX_MESSAGE(2),
+		.fifo_stat      = MAILBOX_FIFOSTATUS(2),
 	},
 	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE(3),
-		.msg_stat	= MAILBOX_MSGSTATUS(3),
+		.msg            = MAILBOX_MESSAGE(3),
+		.msg_stat       = MAILBOX_MSGSTATUS(3),
 	},
-	.irqenable	= MAILBOX_IRQENABLE(3),
-	.irqstatus	= MAILBOX_IRQSTATUS(3),
-	.notfull_bit	= MAILBOX_IRQ_NOTFULL(2),
-	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(3),
-	.irqdisable	= MAILBOX_IRQENABLE(3),
+	.irqenable      = MAILBOX_IRQENABLE(3),
+	.irqstatus      = MAILBOX_IRQSTATUS(3),
+	.notfull_bit    = MAILBOX_IRQ_NOTFULL(2),
+	.newmsg_bit     = MAILBOX_IRQ_NEWMSG(3),
+	.irqdisable     = MAILBOX_IRQENABLE(3),
 };
 
 static struct omap_mbox mbox_iva_info = {
-	.name	= "iva",
-	.ops	= &omap2_mbox_ops,
-	.priv	= &omap2_mbox_iva_priv,
+	.name   = "iva",
+	.ops    = &omap2_mbox_ops,
+	.priv   = &omap2_mbox_iva_priv,
 };
 #endif
 
@@ -297,46 +297,46 @@ struct omap_mbox *omap2_mboxes[] = {
 /* OMAP4 */
 static struct omap_mbox2_priv omap2_mbox_1_priv = {
 	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE(0),
-		.fifo_stat	= MAILBOX_FIFOSTATUS(0),
+		.msg            = MAILBOX_MESSAGE(0),
+		.fifo_stat      = MAILBOX_FIFOSTATUS(0),
 	},
 	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE(1),
-		.msg_stat	= MAILBOX_MSGSTATUS(1),
+		.msg            = MAILBOX_MESSAGE(1),
+		.msg_stat       = MAILBOX_MSGSTATUS(1),
 	},
-	.irqenable	= OMAP4_MAILBOX_IRQENABLE(0),
-	.irqstatus	= OMAP4_MAILBOX_IRQSTATUS(0),
-	.notfull_bit	= MAILBOX_IRQ_NOTFULL(0),
-	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(1),
-	.irqdisable	= OMAP4_MAILBOX_IRQENABLE_CLR(0),
+	.irqenable      = OMAP4_MAILBOX_IRQENABLE(0),
+	.irqstatus      = OMAP4_MAILBOX_IRQSTATUS(0),
+	.notfull_bit    = MAILBOX_IRQ_NOTFULL(0),
+	.newmsg_bit     = MAILBOX_IRQ_NEWMSG(1),
+	.irqdisable     = OMAP4_MAILBOX_IRQENABLE_CLR(0),
 };
 
 struct omap_mbox mbox_1_info = {
-	.name	= "mailbox-1",
-	.ops	= &omap2_mbox_ops,
-	.priv	= &omap2_mbox_1_priv,
+	.name   = "mailbox-1",
+	.ops    = &omap2_mbox_ops,
+	.priv   = &omap2_mbox_1_priv,
 };
 
 static struct omap_mbox2_priv omap2_mbox_2_priv = {
 	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE(3),
-		.fifo_stat	= MAILBOX_FIFOSTATUS(3),
+		.msg            = MAILBOX_MESSAGE(3),
+		.fifo_stat      = MAILBOX_FIFOSTATUS(3),
 	},
 	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE(2),
-		.msg_stat	= MAILBOX_MSGSTATUS(2),
+		.msg            = MAILBOX_MESSAGE(2),
+		.msg_stat       = MAILBOX_MSGSTATUS(2),
 	},
-	.irqenable	= OMAP4_MAILBOX_IRQENABLE(0),
-	.irqstatus	= OMAP4_MAILBOX_IRQSTATUS(0),
-	.notfull_bit	= MAILBOX_IRQ_NOTFULL(3),
-	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(2),
+	.irqenable      = OMAP4_MAILBOX_IRQENABLE(0),
+	.irqstatus      = OMAP4_MAILBOX_IRQSTATUS(0),
+	.notfull_bit    = MAILBOX_IRQ_NOTFULL(3),
+	.newmsg_bit     = MAILBOX_IRQ_NEWMSG(2),
 	.irqdisable     = OMAP4_MAILBOX_IRQENABLE_CLR(0),
 };
 
 struct omap_mbox mbox_2_info = {
-	.name	= "mailbox-2",
-	.ops	= &omap2_mbox_ops,
-	.priv	= &omap2_mbox_2_priv,
+	.name   = "mailbox-2",
+	.ops    = &omap2_mbox_ops,
+	.priv   = &omap2_mbox_2_priv,
 };
 
 struct omap_mbox *omap4_mboxes[] = { &mbox_1_info, &mbox_2_info, NULL };
diff --git a/arch/arm/plat-omap/mailbox.c b/drivers/mailbox/mailbox.c
similarity index 97%
rename from arch/arm/plat-omap/mailbox.c
rename to drivers/mailbox/mailbox.c
index 42377ef..aec291d0 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -31,7 +31,7 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 
-#include <plat/mailbox.h>
+#include "mailbox.h"
 
 static struct omap_mbox **mboxes;
 
@@ -130,7 +130,7 @@ static void mbox_tx_tasklet(unsigned long tx_data)
 		}
 
 		ret = kfifo_out(&mq->fifo, (unsigned char *)&msg,
-								sizeof(msg));
+				sizeof(msg));
 		WARN_ON(ret != sizeof(msg));
 
 		mbox_fifo_write(mbox, msg);
@@ -143,7 +143,7 @@ static void mbox_tx_tasklet(unsigned long tx_data)
 static void mbox_rx_work(struct work_struct *work)
 {
 	struct omap_mbox_queue *mq =
-			container_of(work, struct omap_mbox_queue, work);
+		container_of(work, struct omap_mbox_queue, work);
 	mbox_msg_t msg;
 	int len;
 
@@ -152,7 +152,7 @@ static void mbox_rx_work(struct work_struct *work)
 		WARN_ON(len != sizeof(msg));
 
 		blocking_notifier_call_chain(&mq->mbox->notifier, len,
-								(void *)msg);
+				(void *)msg);
 		spin_lock_irq(&mq->lock);
 		if (mq->full) {
 			mq->full = false;
@@ -214,8 +214,8 @@ static irqreturn_t mbox_interrupt(int irq, void *p)
 }
 
 static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
-					void (*work) (struct work_struct *),
-					void (*tasklet)(unsigned long))
+		void (*work) (struct work_struct *),
+		void (*tasklet)(unsigned long))
 {
 	struct omap_mbox_queue *mq;
 
@@ -262,10 +262,10 @@ static int omap_mbox_startup(struct omap_mbox *mbox)
 
 	if (!mbox->use_count++) {
 		ret = request_irq(mbox->irq, mbox_interrupt, IRQF_SHARED,
-							mbox->name, mbox);
+				mbox->name, mbox);
 		if (unlikely(ret)) {
 			pr_err("failed to register mailbox interrupt:%d\n",
-									ret);
+					ret);
 			goto fail_request_irq;
 		}
 		mq = mbox_queue_alloc(mbox, NULL, mbox_tx_tasklet);
@@ -417,7 +417,7 @@ static int __init omap_mbox_init(void)
 	/* kfifo size sanity check: alignment and minimal size */
 	mbox_kfifo_size = ALIGN(mbox_kfifo_size, sizeof(mbox_msg_t));
 	mbox_kfifo_size = max_t(unsigned int, mbox_kfifo_size,
-							sizeof(mbox_msg_t));
+			sizeof(mbox_msg_t));
 
 	return 0;
 }
diff --git a/arch/arm/plat-omap/include/plat/mailbox.h b/drivers/mailbox/mailbox.h
similarity index 57%
rename from arch/arm/plat-omap/include/plat/mailbox.h
rename to drivers/mailbox/mailbox.h
index cc3921e..88a9f6a 100644
--- a/arch/arm/plat-omap/include/plat/mailbox.h
+++ b/drivers/mailbox/mailbox.h
@@ -21,43 +21,43 @@ typedef int __bitwise omap_mbox_type_t;
 #define OMAP_MBOX_TYPE2 ((__force omap_mbox_type_t) 2)
 
 struct omap_mbox_ops {
-	omap_mbox_type_t	type;
-	int		(*startup)(struct omap_mbox *mbox);
-	void		(*shutdown)(struct omap_mbox *mbox);
+	omap_mbox_type_t        type;
+	int             (*startup)(struct omap_mbox *mbox);
+	void            (*shutdown)(struct omap_mbox *mbox);
 	/* fifo */
-	mbox_msg_t	(*fifo_read)(struct omap_mbox *mbox);
-	void		(*fifo_write)(struct omap_mbox *mbox, mbox_msg_t msg);
-	int		(*fifo_empty)(struct omap_mbox *mbox);
-	int		(*fifo_full)(struct omap_mbox *mbox);
+	mbox_msg_t      (*fifo_read)(struct omap_mbox *mbox);
+	void            (*fifo_write)(struct omap_mbox *mbox, mbox_msg_t msg);
+	int             (*fifo_empty)(struct omap_mbox *mbox);
+	int             (*fifo_full)(struct omap_mbox *mbox);
 	/* irq */
-	void		(*enable_irq)(struct omap_mbox *mbox,
-						omap_mbox_irq_t irq);
-	void		(*disable_irq)(struct omap_mbox *mbox,
-						omap_mbox_irq_t irq);
-	void		(*ack_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-	int		(*is_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	void            (*enable_irq)(struct omap_mbox *mbox,
+			omap_mbox_irq_t irq);
+	void            (*disable_irq)(struct omap_mbox *mbox,
+			omap_mbox_irq_t irq);
+	void            (*ack_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	int             (*is_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
 	/* ctx */
-	void		(*save_ctx)(struct omap_mbox *mbox);
-	void		(*restore_ctx)(struct omap_mbox *mbox);
+	void            (*save_ctx)(struct omap_mbox *mbox);
+	void            (*restore_ctx)(struct omap_mbox *mbox);
 };
 
 struct omap_mbox_queue {
-	spinlock_t		lock;
-	struct kfifo		fifo;
-	struct work_struct	work;
-	struct tasklet_struct	tasklet;
-	struct omap_mbox	*mbox;
+	spinlock_t              lock;
+	struct kfifo            fifo;
+	struct work_struct      work;
+	struct tasklet_struct   tasklet;
+	struct omap_mbox        *mbox;
 	bool full;
 };
 
 struct omap_mbox {
-	char			*name;
-	unsigned int		irq;
-	struct omap_mbox_queue	*txq, *rxq;
-	struct omap_mbox_ops	*ops;
-	struct device		*dev;
-	void			*priv;
-	int			use_count;
+	char                    *name;
+	unsigned int            irq;
+	struct omap_mbox_queue  *txq, *rxq;
+	struct omap_mbox_ops    *ops;
+	struct device           *dev;
+	void                    *priv;
+	int                     use_count;
 	struct blocking_notifier_head   notifier;
 };
 
@@ -91,13 +91,13 @@ static inline void omap_mbox_restore_ctx(struct omap_mbox *mbox)
 }
 
 static inline void omap_mbox_enable_irq(struct omap_mbox *mbox,
-					omap_mbox_irq_t irq)
+		omap_mbox_irq_t irq)
 {
 	mbox->ops->enable_irq(mbox, irq);
 }
 
 static inline void omap_mbox_disable_irq(struct omap_mbox *mbox,
-					 omap_mbox_irq_t irq)
+		omap_mbox_irq_t irq)
 {
 	mbox->ops->disable_irq(mbox, irq);
 }
-- 
1.7.11.1

