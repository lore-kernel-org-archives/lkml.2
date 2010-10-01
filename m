Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab0JAL7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:59:14 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:55839 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180Ab0JAL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:58:33 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: [PATCH V2 63/69] ST SPEAr3xx: Updating plgpio and emi source to make it compliant with single image strategy
Date: Fri,  1 Oct 2010 17:26:23 +0530
Message-Id: <ea27f60aea71a84a2c42e0c8c24144398c7e757b.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/emi.c               |   18 ++++++++++-
 arch/arm/mach-spear3xx/include/mach/emi.h  |   19 ++++++-----
 arch/arm/mach-spear3xx/include/mach/gpio.h |   27 ++++++++--------
 arch/arm/plat-spear/plgpio.c               |   46 ++++++++++++++++++++-------
 4 files changed, 75 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-spear3xx/emi.c b/arch/arm/mach-spear3xx/emi.c
index 7b62ff0..7d7cea7 100644
--- a/arch/arm/mach-spear3xx/emi.c
+++ b/arch/arm/mach-spear3xx/emi.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <asm/mach-types.h>
 #include <mach/emi.h>
 
 int __init emi_init(struct platform_device *pdev, unsigned long base,
@@ -23,8 +24,23 @@ int __init emi_init(struct platform_device *pdev, unsigned long base,
 	void __iomem *emi_reg_base;
 	struct clk *clk;
 	int ret;
+	u32 ack_reg, max_banks;
+	/* u32 timeout_reg, irq_reg; */
+
+	/* fixing machine dependent values */
+	if (machine_is_spear310()) {
+		ack_reg = SPEAR310_ACK_REG;
+		max_banks = SPEAR310_EMI_MAX_BANKS;
+		/* timeout_reg = SPEAR310_TIMEOUT_REG; */
+		/* irq_reg = SPEAR310_IRQ_REG; */
+	} else {
+		ack_reg = SPEAR320_ACK_REG;
+		max_banks = SPEAR320_EMI_MAX_BANKS;
+		/* timeout_reg = SPEAR320_TIMEOUT_REG; */
+		/* irq_reg = SPEAR320_IRQ_REG; */
+	}
 
-	if (bank > (EMI_MAX_BANKS - 1))
+	if (bank > (max_banks - 1))
 		return -EINVAL;
 
 	emi_reg_base = ioremap(base, EMI_REG_SIZE);
diff --git a/arch/arm/mach-spear3xx/include/mach/emi.h b/arch/arm/mach-spear3xx/include/mach/emi.h
index b620bf5..59f69c4 100644
--- a/arch/arm/mach-spear3xx/include/mach/emi.h
+++ b/arch/arm/mach-spear3xx/include/mach/emi.h
@@ -33,18 +33,19 @@
 #define CTRL_REG		(0x14)
 
 #if defined(CONFIG_MACH_SPEAR310)
-#define TIMEOUT_REG		(0x90)
-#define ACK_REG			(0x94)
-#define IRQ_REG			(0x98)
+#define SPEAR310_TIMEOUT_REG	(0x90)
+#define SPEAR310_ACK_REG	(0x94)
+#define SPEAR310_IRQ_REG	(0x98)
 
-#define EMI_MAX_BANKS		6
+#define SPEAR310_EMI_MAX_BANKS	6
+#endif
 
-#elif defined(CONFIG_MACH_SPEAR320)
-#define TIMEOUT_REG		(0x60)
-#define ACK_REG			(0x64)
-#define IRQ_REG			(0x68)
+#if defined(CONFIG_MACH_SPEAR320)
+#define SPEAR320_TIMEOUT_REG	(0x60)
+#define SPEAR320_ACK_REG	(0x64)
+#define SPEAR320_IRQ_REG	(0x68)
 
-#define EMI_MAX_BANKS		4
+#define SPEAR320_EMI_MAX_BANKS	4
 
 #endif
 
diff --git a/arch/arm/mach-spear3xx/include/mach/gpio.h b/arch/arm/mach-spear3xx/include/mach/gpio.h
index f15248c..0c13d8c 100644
--- a/arch/arm/mach-spear3xx/include/mach/gpio.h
+++ b/arch/arm/mach-spear3xx/include/mach/gpio.h
@@ -17,20 +17,21 @@
 #include <plat/gpio.h>
 
 #ifdef CONFIG_MACH_SPEAR310
-#define PLGPIO_ENB		0x0010
-#define PLGPIO_WDATA		0x0020
-#define PLGPIO_DIR		0x0030
-#define PLGPIO_IE		0x0040
-#define PLGPIO_RDATA		0x0050
-#define PLGPIO_MIS		0x0060
+#define SPEAR310_PLGPIO_ENB		0x0010
+#define SPEAR310_PLGPIO_WDATA		0x0020
+#define SPEAR310_PLGPIO_DIR		0x0030
+#define SPEAR310_PLGPIO_IE		0x0040
+#define SPEAR310_PLGPIO_RDATA		0x0050
+#define SPEAR310_PLGPIO_MIS		0x0060
+#endif
 
-#elif defined(CONFIG_MACH_SPEAR320)
-#define PLGPIO_ENB		0x0024
-#define PLGPIO_WDATA		0x0034
-#define PLGPIO_DIR		0x0044
-#define PLGPIO_RDATA		0x0054
-#define PLGPIO_IE		0x0064
-#define PLGPIO_MIS		0x0074
+#if defined(CONFIG_MACH_SPEAR320)
+#define SPEAR320_PLGPIO_ENB		0x0024
+#define SPEAR320_PLGPIO_WDATA		0x0034
+#define SPEAR320_PLGPIO_DIR		0x0044
+#define SPEAR320_PLGPIO_RDATA		0x0054
+#define SPEAR320_PLGPIO_IE		0x0064
+#define SPEAR320_PLGPIO_MIS		0x0074
 #endif
 
 #define BASIC_GPIO_0		0
diff --git a/arch/arm/plat-spear/plgpio.c b/arch/arm/plat-spear/plgpio.c
index 3080178..f5220c0 100644
--- a/arch/arm/plat-spear/plgpio.c
+++ b/arch/arm/plat-spear/plgpio.c
@@ -22,12 +22,16 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
+#include <asm/mach-types.h>
 
 #define MAX_GPIO_PER_REG		32
 #define PIN_OFFSET(pin)			(pin % MAX_GPIO_PER_REG)
 #define REG_OFFSET(base, reg, pin)	(base + reg + (pin / MAX_GPIO_PER_REG)\
 		* sizeof(int *))
 
+static u32 plgpio_enb, plgpio_wdata, plgpio_dir, plgpio_rdata, plgpio_ie,
+	   plgpio_mis;
+
 /*
  * struct plgpio: plgpio driver specific structure
  *
@@ -96,7 +100,7 @@ static int plgpio_direction_input(struct gpio_chip *chip, unsigned offset)
 	}
 
 	spin_lock_irqsave(&plgpio->lock, flags);
-	plgpio_reg_set(plgpio->base, offset, PLGPIO_DIR);
+	plgpio_reg_set(plgpio->base, offset, plgpio_dir);
 	spin_unlock_irqrestore(&plgpio->lock, flags);
 
 	return 0;
@@ -125,11 +129,11 @@ static int plgpio_direction_output(struct gpio_chip *chip, unsigned offset,
 	}
 
 	spin_lock_irqsave(&plgpio->lock, flags);
-	plgpio_reg_reset(plgpio->base, dir_offset, PLGPIO_DIR);
+	plgpio_reg_reset(plgpio->base, dir_offset, plgpio_dir);
 	if (value)
-		plgpio_reg_set(plgpio->base, wdata_offset, PLGPIO_WDATA);
+		plgpio_reg_set(plgpio->base, wdata_offset, plgpio_wdata);
 	else
-		plgpio_reg_reset(plgpio->base, wdata_offset, PLGPIO_WDATA);
+		plgpio_reg_reset(plgpio->base, wdata_offset, plgpio_wdata);
 	spin_unlock_irqrestore(&plgpio->lock, flags);
 
 	return 0;
@@ -149,7 +153,7 @@ static int plgpio_get_value(struct gpio_chip *chip, unsigned offset)
 			return -EINVAL;
 	}
 
-	return is_plgpio_set(plgpio->base, offset, PLGPIO_RDATA);
+	return is_plgpio_set(plgpio->base, offset, plgpio_rdata);
 }
 
 static void plgpio_set_value(struct gpio_chip *chip, unsigned offset, int value)
@@ -167,9 +171,9 @@ static void plgpio_set_value(struct gpio_chip *chip, unsigned offset, int value)
 	}
 
 	if (value)
-		plgpio_reg_set(plgpio->base, offset, PLGPIO_WDATA);
+		plgpio_reg_set(plgpio->base, offset, plgpio_wdata);
 	else
-		plgpio_reg_reset(plgpio->base, offset, PLGPIO_WDATA);
+		plgpio_reg_reset(plgpio->base, offset, plgpio_wdata);
 }
 
 static int plgpio_request(struct gpio_chip *chip, unsigned offset)
@@ -196,7 +200,7 @@ static int plgpio_request(struct gpio_chip *chip, unsigned offset)
 	}
 
 	spin_lock_irqsave(&plgpio->lock, flags);
-	plgpio_reg_set(plgpio->base, offset, PLGPIO_ENB);
+	plgpio_reg_set(plgpio->base, offset, plgpio_enb);
 	spin_unlock_irqrestore(&plgpio->lock, flags);
 
 	return 0;
@@ -218,7 +222,7 @@ static void plgpio_free(struct gpio_chip *chip, unsigned offset)
 	}
 
 	spin_lock_irqsave(&plgpio->lock, flags);
-	plgpio_reg_reset(plgpio->base, offset, PLGPIO_ENB);
+	plgpio_reg_reset(plgpio->base, offset, plgpio_enb);
 	spin_unlock_irqrestore(&plgpio->lock, flags);
 }
 
@@ -247,7 +251,7 @@ static void plgpio_irq_mask(unsigned irq)
 	}
 
 	spin_lock_irqsave(&plgpio->lock, flags);
-	plgpio_reg_set(plgpio->base, offset, PLGPIO_IE);
+	plgpio_reg_set(plgpio->base, offset, plgpio_ie);
 	spin_unlock_irqrestore(&plgpio->lock, flags);
 }
 
@@ -265,7 +269,7 @@ static void plgpio_irq_unmask(unsigned irq)
 	}
 
 	spin_lock_irqsave(&plgpio->lock, flags);
-	plgpio_reg_reset(plgpio->base, offset, PLGPIO_IE);
+	plgpio_reg_reset(plgpio->base, offset, plgpio_ie);
 	spin_unlock_irqrestore(&plgpio->lock, flags);
 }
 
@@ -298,7 +302,7 @@ static void plgpio_irq_handler(unsigned irq, struct irq_desc *desc)
 
 	/* check all plgpio MIS registers for a possible interrupt */
 	for (; i < regs_count; i++) {
-		pending = readl(plgpio->base + PLGPIO_MIS + i * sizeof(int *));
+		pending = readl(plgpio->base + plgpio_mis + i * sizeof(int *));
 		if (!pending)
 			continue;
 
@@ -443,6 +447,24 @@ static struct platform_driver plgpio_driver = {
 
 static int __init plgpio_init(void)
 {
+	if (machine_is_spear310()) {
+		plgpio_enb = SPEAR310_PLGPIO_ENB;
+		plgpio_wdata = SPEAR310_PLGPIO_WDATA;
+		plgpio_dir = SPEAR310_PLGPIO_DIR;
+		plgpio_rdata = SPEAR310_PLGPIO_IE;
+		plgpio_ie = SPEAR310_PLGPIO_RDATA;
+		plgpio_mis = SPEAR310_PLGPIO_MIS;
+	} else if (machine_is_spear320()) {
+		plgpio_enb = SPEAR320_PLGPIO_ENB;
+		plgpio_wdata = SPEAR320_PLGPIO_WDATA;
+		plgpio_dir = SPEAR320_PLGPIO_DIR;
+		plgpio_rdata = SPEAR320_PLGPIO_IE;
+		plgpio_ie = SPEAR320_PLGPIO_RDATA;
+		plgpio_mis = SPEAR320_PLGPIO_MIS;
+	} else {
+		return 0;
+	}
+
 	return platform_driver_register(&plgpio_driver);
 }
 subsys_initcall(plgpio_init);
-- 
1.7.2.2

