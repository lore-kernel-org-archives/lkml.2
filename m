Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2KPOr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:47:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40122 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2KPOrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:47:23 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 08/12] davinci: vpss: dm365: enable ISP registers
Date: Fri, 16 Nov 2012 20:15:10 +0530
Message-Id: <1353077114-19296-9-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

enable PPCR, enbale ISIF out on BCR and disable all events to
get the correct operation from ISIF.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpss.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 146e4b0..34ad7bd 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -52,9 +52,11 @@ MODULE_AUTHOR("Texas Instruments");
 #define DM355_VPSSBL_EVTSEL_DEFAULT	0x4
 
 #define DM365_ISP5_PCCR 		0x04
+#define DM365_ISP5_BCR			0x08
 #define DM365_ISP5_INTSEL1		0x10
 #define DM365_ISP5_INTSEL2		0x14
 #define DM365_ISP5_INTSEL3		0x18
+#define DM365_ISP5_EVTSEL		0x1c
 #define DM365_ISP5_CCDCMUX 		0x20
 #define DM365_ISP5_PG_FRAME_SIZE 	0x28
 #define DM365_VPBE_CLK_CTRL 		0x00
@@ -357,6 +359,10 @@ void dm365_vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
 }
 EXPORT_SYMBOL(dm365_vpss_set_pg_frame_size);
 
+#define DM365_ISP5_EVTSEL_EVT_DISABLE	0x00000000
+#define DM365_ISP5_BCR_ISIF_OUT_ENABLE	0x00000002
+#define DM365_ISP5_PCCR_CLK_ENABLE	0x0000007f
+
 static int __devinit vpss_probe(struct platform_device *pdev)
 {
 	struct resource		*r1, *r2;
@@ -426,9 +432,16 @@ static int __devinit vpss_probe(struct platform_device *pdev)
 		oper_cfg.hw_ops.enable_clock = dm365_enable_clock;
 		oper_cfg.hw_ops.select_ccdc_source = dm365_select_ccdc_source;
 		/* Setup vpss interrupts */
+		isp5_write((isp5_read(DM365_ISP5_PCCR) |
+				DM365_ISP5_PCCR_CLK_ENABLE), DM365_ISP5_PCCR);
+		isp5_write((isp5_read(DM365_ISP5_BCR) |
+			     DM365_ISP5_BCR_ISIF_OUT_ENABLE), DM365_ISP5_BCR);
 		isp5_write(DM365_ISP5_INTSEL1_DEFAULT, DM365_ISP5_INTSEL1);
 		isp5_write(DM365_ISP5_INTSEL2_DEFAULT, DM365_ISP5_INTSEL2);
 		isp5_write(DM365_ISP5_INTSEL3_DEFAULT, DM365_ISP5_INTSEL3);
+		/* No event selected */
+		isp5_write((isp5_read(DM365_ISP5_EVTSEL) |
+			DM365_ISP5_EVTSEL_EVT_DISABLE), DM365_ISP5_EVTSEL);
 	} else
 		oper_cfg.hw_ops.clear_wbl_overflow = dm644x_clear_wbl_overflow;
 
-- 
1.7.4.1

