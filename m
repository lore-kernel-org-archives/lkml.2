Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1DEVlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:41:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45364 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1DEVlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:41:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6307"; a="84158248"
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
To: davidb@codeaurora.org, dwalker@fifo99.com
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm-owner@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Thomas Glexiner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andres Salomon <dilinger@queued.net>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PM8921 MFD V5 6/6] msm: board-8960: Add support for pm8921
Date: Tue,  5 Apr 2011 14:40:57 -0700
Message-Id: <1302039657-19395-7-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
References: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device structure declarations to the msm8960 board file
for PMIC 8921 chip and its subdevices.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Signed-off-by: David Collins <collinsd@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8960.c          |   40 +++++++++++++++++++++++++---
 arch/arm/mach-msm/include/mach/irqs-8960.h |    9 +++---
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 8d2384a..e7e8613 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -15,12 +15,14 @@
  * 02110-1301, USA.
  *
  */
+
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/clkdev.h>
 #include <linux/msm_ssbi.h>
+#include <linux/mfd/pm8xxx/pm8921.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -28,9 +30,18 @@
 
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
+#include <mach/irqs.h>
 
 #include "devices.h"
 
+/* Macros assume PMIC GPIOs and MPPs start at 1 */
+#define PM8921_GPIO_BASE		NR_GPIO_IRQS
+#define PM8921_GPIO_PM_TO_SYS(pm_gpio)	(pm_gpio - 1 + PM8921_GPIO_BASE)
+#define PM8921_MPP_BASE			(PM8921_GPIO_BASE + PM8921_NR_GPIOS)
+#define PM8921_MPP_PM_TO_SYS(pm_gpio)	(pm_gpio - 1 + PM8921_MPP_BASE)
+#define PM8921_IRQ_BASE			(NR_MSM_IRQS + NR_GPIO_IRQS)
+#define PM8921_MPP_IRQ_BASE		(PM8921_IRQ_BASE + NR_GPIO_IRQS)
+
 static void __init msm8960_map_io(void)
 {
 	msm_map_msm8960_io();
@@ -71,15 +82,36 @@ static struct platform_device *rumi3_devices[] __initdata = {
 	&msm8960_device_uart_gsbi5,
 };
 
+static struct pm8xxx_irq_platform_data pm8xxx_irq_pdata __devinitdata = {
+	.irq_base		= PM8921_IRQ_BASE,
+	.devirq			= MSM_GPIO_TO_INT(104),
+	.irq_trigger_flag	= IRQF_TRIGGER_LOW,
+};
+
+static struct pm8xxx_gpio_platform_data pm8xxx_gpio_pdata __devinitdata = {
+	.gpio_base	= PM8921_GPIO_PM_TO_SYS(1),
+};
+
+static struct pm8xxx_mpp_platform_data pm8xxx_mpp_pdata __devinitdata = {
+	.mpp_base	= PM8921_MPP_PM_TO_SYS(1),
+};
+
+static struct pm8921_platform_data pm8921_platform_data __devinitdata = {
+	.irq_pdata		= &pm8xxx_irq_pdata,
+	.gpio_pdata		= &pm8xxx_gpio_pdata,
+	.mpp_pdata		= &pm8xxx_mpp_pdata,
+};
+
 static struct platform_device *devices[] __initdata = {
 	&msm8960_device_dmov,
 	&msm8960_device_ssbi_pm8921,
 };
 
-static struct msm_ssbi_platform_data msm8960_ssbi_pm8921_pdata = {
-	.controller_type = MSM_SBI_CTRL_PMIC_ARBITER,
-	.slave	= {
-		.name		= "pm8921-core",
+static struct msm_ssbi_platform_data msm8960_ssbi_pm8921_pdata __initdata = {
+	.controller_type	= MSM_SBI_CTRL_PMIC_ARBITER,
+	.slave			= {
+		.name			= "pm8921-core",
+		.platform_data		= &pm8921_platform_data,
 	},
 };
 
diff --git a/arch/arm/mach-msm/include/mach/irqs-8960.h b/arch/arm/mach-msm/include/mach/irqs-8960.h
index 81ab2a6..0a5b9c5 100644
--- a/arch/arm/mach-msm/include/mach/irqs-8960.h
+++ b/arch/arm/mach-msm/include/mach/irqs-8960.h
@@ -267,11 +267,10 @@
 #define PM8921_SEC_IRQ_104			(GIC_SPI_START + 225)
 #define PM8018_SEC_IRQ_107			(GIC_SPI_START + 226)
 
-/* For now, use the maximum number of interrupts until a pending GIC issue
- * is sorted out */
-#define NR_MSM_IRQS 1020
-#define NR_BOARD_IRQS 0
-#define NR_GPIO_IRQS 0
+#define NR_MSM_IRQS 256
+#define NR_GPIO_IRQS 150
+#define NR_PM8921_IRQS 256
+#define NR_BOARD_IRQS (NR_PM8921_IRQS)
 
 #endif
 
-- 
1.7.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
