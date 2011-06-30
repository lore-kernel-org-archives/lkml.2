Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab1F3Ht4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:49:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40951 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1F3Hth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:49:37 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-3a-4e0c2a8fa3d0
Date: Thu, 30 Jun 2011 16:49:31 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v3 2/6] Samsung SoC ADC: Channel selection for S5PV210,
 S5PC110, and Exynos4
In-reply-to: <1309420175-10301-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Changhwan Youn <chaos.youn@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jassi Brar <jassi.brar@samsung.com>,
        Seungwhan Youn <sw.youn@samsung.com>, linux-kernel@vger.kernel.org,
        myungjoo.ham@gmail.com
Message-id: <1309420175-10301-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1309420175-10301-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 30 Jun 2011 07:49:50.0157 (UTC)
 FILETIME=[4A3457D0:01CC36FA]
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
updates from v2
- Renamed internal device names.
---
 arch/arm/plat-samsung/adc.c                   |   29 ++++++++++++++++--------
 arch/arm/plat-samsung/include/plat/regs-adc.h |    1 +
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
index 2224128..45cc7e6 100644
--- a/arch/arm/plat-samsung/adc.c
+++ b/arch/arm/plat-samsung/adc.c
@@ -40,8 +40,9 @@
  */
 
 enum s3c_cpu_type {
-	TYPE_S3C24XX,
-	TYPE_S3C64XX
+	TYPE_ADCV1, /* S3C24XX */
+	TYPE_ADCV2, /* S3C64XX, S5P64X0, S5PC100 */
+	TYPE_ADCV3, /* S5PV210, S5PC110, EXYNOS4210 */
 };
 
 struct s3c_adc_client {
@@ -93,6 +94,7 @@ static inline void s3c_adc_select(struct adc_device *adc,
 				  struct s3c_adc_client *client)
 {
 	unsigned con = readl(adc->regs + S3C2410_ADCCON);
+	enum s3c_cpu_type cpu = platform_get_device_id(adc->pdev)->driver_data;
 
 	client->select_cb(client, 1);
 
@@ -100,8 +102,12 @@ static inline void s3c_adc_select(struct adc_device *adc,
 	con &= ~S3C2410_ADCCON_STDBM;
 	con &= ~S3C2410_ADCCON_STARTMASK;
 
-	if (!client->is_ts)
-		con |= S3C2410_ADCCON_SELMUX(client->channel);
+	if (!client->is_ts) {
+		if (cpu == TYPE_ADCV3)
+			writel(client->channel & 0xf, adc->regs + S5P_ADCMUX);
+		else
+			con |= S3C2410_ADCCON_SELMUX(client->channel);
+	}
 
 	writel(con, adc->regs + S3C2410_ADCCON);
 }
@@ -287,8 +293,8 @@ static irqreturn_t s3c_adc_irq(int irq, void *pw)
 
 	client->nr_samples--;
 
-	if (cpu == TYPE_S3C64XX) {
-		/* S3C64XX ADC resolution is 12-bit */
+	if (cpu != TYPE_ADCV1) {
+		/* S3C64XX/S5P ADC resolution is 12-bit */
 		data0 &= 0xfff;
 		data1 &= 0xfff;
 	} else {
@@ -314,7 +320,7 @@ static irqreturn_t s3c_adc_irq(int irq, void *pw)
 	}
 
 exit:
-	if (cpu == TYPE_S3C64XX) {
+	if (cpu != TYPE_ADCV1) {
 		/* Clear ADC interrupt */
 		writel(0, adc->regs + S3C64XX_ADCCLRINT);
 	}
@@ -388,7 +394,7 @@ static int s3c_adc_probe(struct platform_device *pdev)
 	clk_enable(adc->clk);
 
 	tmp = adc->prescale | S3C2410_ADCCON_PRSCEN;
-	if (platform_get_device_id(pdev)->driver_data == TYPE_S3C64XX) {
+	if (platform_get_device_id(pdev)->driver_data != TYPE_ADCV1) {
 		/* Enable 12-bit ADC resolution */
 		tmp |= S3C64XX_ADCCON_RESSEL;
 	}
@@ -476,10 +482,13 @@ static int s3c_adc_resume(struct platform_device *pdev)
 static struct platform_device_id s3c_adc_driver_ids[] = {
 	{
 		.name           = "s3c24xx-adc",
-		.driver_data    = TYPE_S3C24XX,
+		.driver_data    = TYPE_ADCV1,
 	}, {
 		.name           = "s3c64xx-adc",
-		.driver_data    = TYPE_S3C64XX,
+		.driver_data    = TYPE_ADCV2,
+	}, {
+		.name		= "samsung-adc-v3",
+		.driver_data	= TYPE_ADCV3,
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

