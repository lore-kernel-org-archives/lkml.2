Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0KUTnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 14:43:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38538 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0KUTnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 14:43:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ao8E8sGKvkYjH+dn1Ykl5M+5H/kyayWVBi0k7iQe4XVmqK3zZ2bvX925Uz+helTHF7
         6KrMuE/8chZSGUE5hztodGlE7jdnAjY3TGG9HteAGdIfhJs+/XN9qHbIh6hMCj66tWqA
         y8gJ+gfsB4QPOTNkgvZq8qydj0mQRKcasBqw4=
From: mkl0301@gmail.com
To: cbouatmailru@gmail.com, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Cc: Mac Lin <mkl0301@gmail.com>
Subject: [PATCH 1/3] ARM: cns3xxx: Add new and export the old power management functions
Date: Mon, 22 Nov 2010 03:43:36 +0800
Message-Id: <1290368618-13689-2-git-send-email-mkl0301@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1290368618-13689-1-git-send-email-mkl0301@gmail.com>
References: <1290368618-13689-1-git-send-email-mkl0301@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mac Lin <mkl0301@gmail.com>

This patch add cns3xxx_pwr_clk_dis, and export thoes power management functions
that may be used by many other device drivers on CNS3XXX.

Signed-off-by: Mac Lin <mkl0301@gmail.com>
---
 arch/arm/mach-cns3xxx/core.h            |    4 ++--
 arch/arm/mach-cns3xxx/include/mach/pm.h |   19 +++++++++++++++++++
 arch/arm/mach-cns3xxx/pm.c              |   17 +++++++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-cns3xxx/include/mach/pm.h

diff --git a/arch/arm/mach-cns3xxx/core.h b/arch/arm/mach-cns3xxx/core.h
index 6b33ec1..c6636bd 100644
--- a/arch/arm/mach-cns3xxx/core.h
+++ b/arch/arm/mach-cns3xxx/core.h
@@ -11,13 +11,13 @@
 #ifndef __CNS3XXX_CORE_H
 #define __CNS3XXX_CORE_H
 
+#include <mach/pm.h>
+
 extern void __iomem *gic_cpu_base_addr;
 extern struct sys_timer cns3xxx_timer;
 
 void __init cns3xxx_map_io(void);
 void __init cns3xxx_init_irq(void);
 void cns3xxx_power_off(void);
-void cns3xxx_pwr_power_up(unsigned int block);
-void cns3xxx_pwr_power_down(unsigned int block);
 
 #endif /* __CNS3XXX_CORE_H */
diff --git a/arch/arm/mach-cns3xxx/include/mach/pm.h b/arch/arm/mach-cns3xxx/include/mach/pm.h
new file mode 100644
index 0000000..102617b
--- /dev/null
+++ b/arch/arm/mach-cns3xxx/include/mach/pm.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright 2000 Deep Blue Solutions Ltd
+ * Copyright 2004 ARM Limited
+ * Copyright 2008 Cavium Networks
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, Version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __CNS3XXX_PM_H
+#define __CNS3XXX_PM_H
+
+void cns3xxx_pwr_clk_en(unsigned int block);
+void cns3xxx_pwr_clk_dis(unsigned int block);
+void cns3xxx_pwr_power_up(unsigned int block);
+void cns3xxx_pwr_power_down(unsigned int block);
+
+#endif /* __CNS3XXX_PM_H */
diff --git a/arch/arm/mach-cns3xxx/pm.c b/arch/arm/mach-cns3xxx/pm.c
index 38e4470..a4495e6 100644
--- a/arch/arm/mach-cns3xxx/pm.c
+++ b/arch/arm/mach-cns3xxx/pm.c
@@ -6,6 +6,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/init.h>
+#include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <mach/system.h>
@@ -18,6 +20,16 @@ void cns3xxx_pwr_clk_en(unsigned int block)
 	reg |= (block & PM_CLK_GATE_REG_MASK);
 	__raw_writel(reg, PM_CLK_GATE_REG);
 }
+EXPORT_SYMBOL(cns3xxx_pwr_clk_en);
+
+void cns3xxx_pwr_clk_dis(unsigned int block)
+{
+	u32 reg = __raw_readl(PM_CLK_GATE_REG);
+
+	reg &= ~(block & PM_CLK_GATE_REG_MASK);
+	__raw_writel(reg, PM_CLK_GATE_REG);
+}
+EXPORT_SYMBOL(cns3xxx_pwr_clk_dis);
 
 void cns3xxx_pwr_power_up(unsigned int block)
 {
@@ -29,6 +41,7 @@ void cns3xxx_pwr_power_up(unsigned int block)
 	/* Wait for 300us for the PLL output clock locked. */
 	udelay(300);
 };
+EXPORT_SYMBOL(cns3xxx_pwr_power_up);
 
 void cns3xxx_pwr_power_down(unsigned int block)
 {
@@ -38,6 +51,7 @@ void cns3xxx_pwr_power_down(unsigned int block)
 	reg |= (block & CNS3XXX_PWR_PLL_ALL);
 	__raw_writel(reg, PM_PLL_HM_PD_CTRL_REG);
 };
+EXPORT_SYMBOL(cns3xxx_pwr_power_down);
 
 static void cns3xxx_pwr_soft_rst_force(unsigned int block)
 {
@@ -56,6 +70,7 @@ static void cns3xxx_pwr_soft_rst_force(unsigned int block)
 
 	__raw_writel(reg, PM_SOFT_RST_REG);
 }
+EXPORT_SYMBOL(cns3xxx_pwr_soft_rst_force);
 
 void cns3xxx_pwr_soft_rst(unsigned int block)
 {
@@ -69,6 +84,7 @@ void cns3xxx_pwr_soft_rst(unsigned int block)
 	}
 	cns3xxx_pwr_soft_rst_force(block);
 }
+EXPORT_SYMBOL(cns3xxx_pwr_soft_rst);
 
 void arch_reset(char mode, const char *cmd)
 {
@@ -99,3 +115,4 @@ int cns3xxx_cpu_clock(void)
 
 	return cpu;
 }
+EXPORT_SYMBOL(cns3xxx_cpu_clock);
-- 
1.7.3

