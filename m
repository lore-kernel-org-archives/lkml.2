Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab0LCPGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:06:42 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:35016 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807Ab0LCPGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:06:40 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 05/20] mach-ux500: add STMPE1601 platform data
Date: Fri, 3 Dec 2010 20:35:38 +0530
Message-ID: <1291388753-14662-6-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-keypads.c         |   32 ++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.c                 |    3 ++
 .../mach-ux500/include/mach/irqs-board-mop500.h    |   13 +++++++-
 3 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-keypads.c b/arch/arm/mach-ux500/board-mop500-keypads.c
index c1218c5..4acc4f1 100644
--- a/arch/arm/mach-ux500/board-mop500-keypads.c
+++ b/arch/arm/mach-ux500/board-mop500-keypads.c
@@ -128,7 +128,39 @@ static struct ske_keypad_platform_data ske_keypad_board = {
 	.debounce_ms    = 40,                   /* in millsecs */
 };
 
+/*
+ * STMPE1601
+ */
+static struct stmpe_keypad_platform_data stmpe1601_keypad_data = {
+	.debounce_ms    = 64,
+	.scan_count     = 8,
+	.no_autorepeat  = true,
+	.keymap_data    = &mop500_keymap_data,
+};
+
+static struct stmpe_platform_data stmpe1601_data = {
+	.id             = 1,
+	.blocks         = STMPE_BLOCK_KEYPAD,
+	.irq_trigger    = IRQF_TRIGGER_FALLING,
+	.irq_base       = MOP500_STMPE1601_IRQ(0),
+	.keypad         = &stmpe1601_keypad_data,
+	.autosleep      = true,
+	.autosleep_timeout = 1024,
+};
+
+static struct i2c_board_info __initdata mop500_i2c0_devices_stuib[] = {
+	{
+		I2C_BOARD_INFO("stmpe1601", 0x40),
+		.irq = NOMADIK_GPIO_TO_IRQ(218),
+		.platform_data = &stmpe1601_data,
+		.flags = I2C_CLIENT_WAKE,
+	},
+};
+
 void mop500_keypad_init(void)
 {
 	db8500_add_ske_keypad(&ske_keypad_board);
+
+	i2c_register_board_info(0, mop500_i2c0_devices_stuib,
+			ARRAY_SIZE(mop500_i2c0_devices_stuib));
 }
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 9b5e66e..8f4a955 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -19,6 +19,7 @@
 #include <linux/amba/pl022.h>
 #include <linux/spi/spi.h>
 #include <linux/mfd/ab8500.h>
+#include <linux/mfd/tc35892.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -71,6 +72,8 @@ static pin_cfg_t mop500_pins[] = {
 	GPIO168_KP_O0,
 
 	GPIO217_GPIO,		/* GPIO_EXP_INT */
+
+	GPIO218_GPIO    | PIN_INPUT_PULLUP, /* STMPE1601 IRQ */
 };
 
 static struct ab8500_platform_data ab8500_platdata = {
diff --git a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
index 7ee8aaa..c89ae0d 100644
--- a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
+++ b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
@@ -14,6 +14,7 @@
 #define MOP500_AB8500_IRQ_END		(MOP500_AB8500_IRQ_BASE \
 					 + AB8500_NR_IRQS)
 
+/* TC35892 */
 #define TC35892_NR_INTERNAL_IRQS	8
 #define TC35892_INT_GPIO(x)		(TC35892_NR_INTERNAL_IRQS + (x))
 #define TC35892_NR_GPIOS		24
@@ -24,8 +25,18 @@
 #define MOP500_EGPIO_IRQ_BASE		MOP500_AB8500_IRQ_END
 #define MOP500_EGPIO_IRQ_END		(MOP500_EGPIO_IRQ_BASE \
 					 + MOP500_EGPIO_NR_IRQS)
+/* STMPE1601 irqs */
+#define STMPE_NR_INTERNAL_IRQS          9
+#define STMPE_INT_GPIO(x)               (STMPE_NR_INTERNAL_IRQS + (x))
+#define STMPE_NR_GPIOS                  24
+#define STMPE_NR_IRQS                   STMPE_INT_GPIO(STMPE_NR_GPIOS)
 
-#define MOP500_IRQ_END			MOP500_EGPIO_IRQ_END
+#define MOP500_STMPE1601_IRQBASE        MOP500_EGPIO_IRQ_END
+#define MOP500_STMPE1601_IRQ(x)         (MOP500_STMPE1601_IRQBASE + (x))
+
+#define MOP500_NR_IRQS          MOP500_STMPE1601_IRQ(STMPE_NR_INTERNAL_IRQS)
+
+#define MOP500_IRQ_END          MOP500_NR_IRQS
 
 #if MOP500_IRQ_END > IRQ_BOARD_END
 #undef IRQ_BOARD_END
-- 
1.7.2.dirty

