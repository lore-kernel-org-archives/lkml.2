Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab1BKPTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:19:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1BKPTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:19:52 -0500
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>
To: kernel@avr32linux.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>,
        linux-fbdev@vger.kernel.org (open list:ATMEL LCDFB DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] atmel_lcdfb: implement inverted contrast pwm
Date: Fri, 11 Feb 2011 16:19:43 +0100
Message-Id: <1297437584-14048-1-git-send-email-biessmann@corscience.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:puJARSqB17480wyzWoW+QAhCSmIiYLsph7SN6wA2Ori
 McBgNCuWyAqpHmzQLxpQmriOt76c0beTrI3AQg8nDDGkSttpDd
 fZ/mZALdnQkJ+T22ZupYLUQeqhjV0X7o2UzKSDfMwzKP0Bm5aO
 1zTivGe04ksvLV98kSOf+jIYFxKAuc2ADZHs4azID6RNIGsUfL
 dc+h1vUWXMy+h4EjoEQ5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch introduces lcdc->lcdcon_pol_negative which set CONTRAST_CTR
 register to inverted polarity.

Signed-off-by: Andreas Bießmann <biessmann@corscience.de>
---
These are some older patches which are used in some of our systems. Heavy
merging pointed out these functionality was missed to push upstream.

 drivers/video/atmel_lcdfb.c |    7 ++++++-
 include/video/atmel_lcdc.h  |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index bac16345..16da8af 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -68,7 +68,7 @@ static void atmel_lcdfb_update_dma2d(struct atmel_lcdfb_info *sinfo,
 }
 #endif
 
-static const u32 contrast_ctr = ATMEL_LCDC_PS_DIV8
+static u32 contrast_ctr = ATMEL_LCDC_PS_DIV8
 		| ATMEL_LCDC_POL_POSITIVE
 		| ATMEL_LCDC_ENA_PWMENABLE;
 
@@ -163,6 +163,10 @@ static void exit_backlight(struct atmel_lcdfb_info *sinfo)
 
 static void init_contrast(struct atmel_lcdfb_info *sinfo)
 {
+	/* contrast pwm can be 'inverted' */
+	if (sinfo->lcdcon_pol_negative)
+			contrast_ctr &= ~(ATMEL_LCDC_POL_POSITIVE);
+
 	/* have some default contrast/backlight settings */
 	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, contrast_ctr);
 	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_VAL, ATMEL_LCDC_CVAL_DEFAULT);
@@ -816,6 +820,7 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 		sinfo->guard_time = pdata_sinfo->guard_time;
 		sinfo->smem_len = pdata_sinfo->smem_len;
 		sinfo->lcdcon_is_backlight = pdata_sinfo->lcdcon_is_backlight;
+		sinfo->lcdcon_pol_negative = pdata_sinfo->lcdcon_pol_negative;
 		sinfo->lcd_wiring_mode = pdata_sinfo->lcd_wiring_mode;
 	} else {
 		dev_err(dev, "cannot get default configuration\n");
diff --git a/include/video/atmel_lcdc.h b/include/video/atmel_lcdc.h
index 0c864db..28447f1 100644
--- a/include/video/atmel_lcdc.h
+++ b/include/video/atmel_lcdc.h
@@ -52,6 +52,7 @@ struct atmel_lcdfb_info {
 	u8			bl_power;
 #endif
 	bool			lcdcon_is_backlight;
+	bool			lcdcon_pol_negative;
 	u8			saved_lcdcon;
 
 	u8			default_bpp;
-- 
1.7.2.3

