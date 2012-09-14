Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2INMu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:50:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57042 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab2INMux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:50:53 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 12/14] dm365: vpss: add vpss helper functions to be used in the main driver for setting hardware parameters
Date: Fri, 14 Sep 2012 18:16:42 +0530
Message-Id: <1347626804-5703-13-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

add function to set sync polarity , interrupt completion and
pageframe size in vpss to be used by the main driver.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpss.c |   32 ++++++++++++++++++++++++++++++++
 include/media/davinci/vpss.h          |   16 ++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 49bb045..3c195c0 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -97,6 +97,12 @@ struct vpss_hw_ops {
 	void (*select_ccdc_source)(enum vpss_ccdc_source_sel src_sel);
 	/* clear wbl overflow bit */
 	int (*clear_wbl_overflow)(enum vpss_wbl_sel wbl_sel);
+	/* set sync polarity */
+	void (*set_sync_pol)(struct vpss_sync_pol);
+	/* set the PG_FRAME_SIZE register*/
+	void (*set_pg_frame_size)(struct vpss_pg_frame_size);
+	/* check and clear interrupt if occured */
+	int (*dma_complete_interrupt)(void);
 };
 
 /* vpss configuration */
@@ -161,6 +167,14 @@ static void dm355_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
 	bl_regw(src_sel << VPSS_HSSISEL_SHIFT, DM355_VPSSBL_CCDCMUX);
 }
 
+int vpss_dma_complete_interrupt(void)
+{
+	if (!oper_cfg.hw_ops.dma_complete_interrupt)
+		return 2;
+	return oper_cfg.hw_ops.dma_complete_interrupt();
+}
+EXPORT_SYMBOL(vpss_dma_complete_interrupt);
+
 int vpss_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
 {
 	if (!oper_cfg.hw_ops.select_ccdc_source)
@@ -186,6 +200,15 @@ static int dm644x_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
 	return 0;
 }
 
+void vpss_set_sync_pol(struct vpss_sync_pol sync)
+{
+	if (!oper_cfg.hw_ops.set_sync_pol)
+		return;
+
+	oper_cfg.hw_ops.set_sync_pol(sync);
+}
+EXPORT_SYMBOL(vpss_set_sync_pol);
+
 int vpss_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
 {
 	if (!oper_cfg.hw_ops.clear_wbl_overflow)
@@ -351,6 +374,15 @@ void dm365_vpss_set_sync_pol(struct vpss_sync_pol sync)
 }
 EXPORT_SYMBOL(dm365_vpss_set_sync_pol);
 
+void vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
+{
+	if (!oper_cfg.hw_ops.set_pg_frame_size)
+		return;
+
+	oper_cfg.hw_ops.set_pg_frame_size(frame_size);
+}
+EXPORT_SYMBOL(vpss_set_pg_frame_size);
+
 void dm365_vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
 {
 	int current_reg = ((frame_size.hlpfr >> 1) - 1) << 16;
diff --git a/include/media/davinci/vpss.h b/include/media/davinci/vpss.h
index b586495..c5f6d9a 100644
--- a/include/media/davinci/vpss.h
+++ b/include/media/davinci/vpss.h
@@ -105,4 +105,20 @@ enum vpss_wbl_sel {
 };
 /* clear wbl overflow flag for DM6446 */
 int vpss_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel);
+
+/* set sync polarity*/
+void vpss_set_sync_pol(struct vpss_sync_pol sync);
+/* set the PG_FRAME_SIZE register */
+void vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size);
+/**
+ * vpss_check_and_clear_interrupt - check and clear interrupt
+ * @irq - common enumerator for IRQ
+ *
+ * Following return values used:-
+ * 0 - interrupt occured and cleared
+ * 1 - interrupt not occured
+ * 2 - interrupt status not available
+ */
+int vpss_dma_complete_interrupt(void);
+
 #endif
-- 
1.7.4.1

