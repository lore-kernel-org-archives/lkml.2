Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1FUB6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:58:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15927 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1FUB6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:58:50 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-c6-4dfffad8496e
Date: Tue, 21 Jun 2011 10:58:44 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 2/5] Samsung SoC ADC: Channel selection for S5PV210,
 S5PC110, and Exynos4
In-reply-to: <1308621527-2457-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, dg77.kim@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1308621527-2457-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <20110620101737.GA31864@opensource.wolfsonmicro.com>
 <1308621527-2457-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 21 Jun 2011 01:58:11.0834 (UTC)
 FILETIME=[ACE7FDA0:01CC2FB6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In S5PV210/S5PC110/Exynos4, ADCMUX channel selection uses ADCMUX
register, not ADCCON register. This patch corrects the behavior of
Samsung-ADC for such cpus.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
--
v2: No changes from v1. Resubmitted as a series of patches
---
 arch/arm/plat-samsung/adc.c                   |   24 +++++++++++++++++-------
 arch/arm/plat-samsung/include/plat/regs-adc.h |    1 +
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
index 938f6e9..0233c69 100644
--- a/arch/arm/plat-samsung/adc.c
+++ b/arch/arm/plat-samsung/adc.c
@@ -41,8 +41,10 @@
 
 enum s3c_cpu_type {
 	TYPE_S3C24XX,
-	TYPE_S3C64XX
+	TYPE_S3C64XX,
+	TYPE_S5P,
 };
+#define S3C64XX_OR_LATER(type)	((type) == TYPE_S3C64XX || (type) == TYPE_S5P)
 
 struct s3c_adc_client {
 	struct platform_device	*pdev;
@@ -93,6 +95,7 @@ static inline void s3c_adc_select(struct adc_device *adc,
 				  struct s3c_adc_client *client)
 {
 	unsigned con = readl(adc->regs + S3C2410_ADCCON);
+	enum s3c_cpu_type cpu = platform_get_device_id(adc->pdev)->driver_data;
 
 	client->select_cb(client, 1);
 
@@ -100,8 +103,12 @@ static inline void s3c_adc_select(struct adc_device *adc,
 	con &= ~S3C2410_ADCCON_STDBM;
 	con &= ~S3C2410_ADCCON_STARTMASK;
 
-	if (!client->is_ts)
-		con |= S3C2410_ADCCON_SELMUX(client->channel);
+	if (!client->is_ts) {
+		if (cpu == TYPE_S5P)
+			writel(client->channel & 0xf, adc->regs + S5P_ADCMUX);
+		else
+			con |= S3C2410_ADCCON_SELMUX(client->channel);
+	}
 
 	writel(con, adc->regs + S3C2410_ADCCON);
 }
@@ -287,8 +294,8 @@ static irqreturn_t s3c_adc_irq(int irq, void *pw)
 
 	client->nr_samples--;
 
-	if (cpu == TYPE_S3C64XX) {
-		/* S3C64XX ADC resolution is 12-bit */
+	if (S3C64XX_OR_LATER(cpu)) {
+		/* S3C64XX/S5P ADC resolution is 12-bit */
 		data0 &= 0xfff;
 		data1 &= 0xfff;
 	} else {
@@ -314,7 +321,7 @@ static irqreturn_t s3c_adc_irq(int irq, void *pw)
 	}
 
 exit:
-	if (cpu == TYPE_S3C64XX) {
+	if (S3C64XX_OR_LATER(cpu)) {
 		/* Clear ADC interrupt */
 		writel(0, adc->regs + S3C64XX_ADCCLRINT);
 	}
@@ -388,7 +395,7 @@ static int s3c_adc_probe(struct platform_device *pdev)
 	clk_enable(adc->clk);
 
 	tmp = adc->prescale | S3C2410_ADCCON_PRSCEN;
-	if (platform_get_device_id(pdev)->driver_data == TYPE_S3C64XX) {
+	if (S3C64XX_OR_LATER(platform_get_device_id(pdev)->driver_data)) {
 		/* Enable 12-bit ADC resolution */
 		tmp |= S3C64XX_ADCCON_RESSEL;
 	}
@@ -478,6 +485,9 @@ static struct platform_device_id s3c_adc_driver_ids[] = {
 	}, {
 		.name           = "s3c64xx-adc",
 		.driver_data    = TYPE_S3C64XX,
+	}, {
+		.name		= "s5p-adc",
+		.driver_data	= TYPE_S5P,
 	},
 	{ }
 };
diff --git a/arch/arm/plat-samsung/include/plat/regs-adc.h b/arch/arm/plat-samsung/include/plat/regs-adc.h
index 7554c4f..035e8c3 100644
--- a/arch/arm/plat-samsung/include/plat/regs-adc.h
+++ b/arch/arm/plat-samsung/include/plat/regs-adc.h
@@ -21,6 +21,7 @@
 #define S3C2410_ADCDAT1	   S3C2410_ADCREG(0x10)
 #define S3C64XX_ADCUPDN		S3C2410_ADCREG(0x14)
 #define S3C64XX_ADCCLRINT	S3C2410_ADCREG(0x18)
+#define S5P_ADCMUX		S3C2410_ADCREG(0x1C)
 #define S3C64XX_ADCCLRINTPNDNUP	S3C2410_ADCREG(0x20)
 
 
-- 
1.7.4.1

