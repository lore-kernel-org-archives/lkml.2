Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1BMWLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:11:45 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46659 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1BMWLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:11:18 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Subject: [PATCH 3/6] sisfb: add subroutine for detecting XGI Z9
Date: Mon, 14 Feb 2011 00:11:25 +0200
Message-Id: <1297635088-13224-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Z7 and Z9 have the same PCI ID, so additional checking is needed to
detect Z9. The method was "documented" in XGI's xgifb driver.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis.h      |    1 +
 drivers/video/sis/sis_main.c |   18 ++++++++++++++++++
 drivers/video/sis/vgatypes.h |    1 +
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/video/sis/sis.h b/drivers/video/sis/sis.h
index eac7a01..1987f1b 100644
--- a/drivers/video/sis/sis.h
+++ b/drivers/video/sis/sis.h
@@ -495,6 +495,7 @@ struct sis_video_info {
 	unsigned int	refresh_rate;
 
 	unsigned int	chip;
+	unsigned int	chip_real_id;
 	u8		revision_id;
 	int		sisvga_enabled;		/* PCI device was enabled */
 
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 364559b..f0c48e8 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4563,6 +4563,11 @@ sisfb_post_sis315330(struct pci_dev *pdev)
 }
 #endif
 
+static inline int sisfb_xgi_is21(struct sis_video_info *ivideo)
+{
+	return ivideo->chip_real_id == XGI_21;
+}
+
 static void __devinit
 sisfb_post_xgi_delay(struct sis_video_info *ivideo, int delay)
 {
@@ -5802,6 +5807,7 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 
 	ivideo->chip = chipinfo->chip;
+	ivideo->chip_real_id = chipinfo->chip;
 	ivideo->sisvga_engine = chipinfo->vgaengine;
 	ivideo->hwcursor_size = chipinfo->hwcursor_size;
 	ivideo->CRT2_write_enable = chipinfo->CRT2_write_enable;
@@ -6035,6 +6041,18 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		sisfb_detect_custom_timing(ivideo);
 	}
 
+#ifdef CONFIG_FB_SIS_315
+	if (ivideo->chip == XGI_20) {
+		/* Check if our Z7 chip is actually Z9 */
+		SiS_SetRegOR(SISCR, 0x4a, 0x40);	/* GPIOG EN */
+		reg = SiS_GetReg(SISCR, 0x48);
+		if (reg & 0x02) {			/* GPIOG */
+			ivideo->chip_real_id = XGI_21;
+			dev_info(&pdev->dev, "Z9 detected\n");
+		}
+	}
+#endif
+
 	/* POST card in case this has not been done by the BIOS */
 	if( (!ivideo->sisvga_enabled)
 #if !defined(__i386__) && !defined(__x86_64__)
diff --git a/drivers/video/sis/vgatypes.h b/drivers/video/sis/vgatypes.h
index 12c0dfa..e3f9976 100644
--- a/drivers/video/sis/vgatypes.h
+++ b/drivers/video/sis/vgatypes.h
@@ -87,6 +87,7 @@ typedef enum _SIS_CHIP_TYPE {
     SIS_341,
     SIS_342,
     XGI_20  = 75,
+    XGI_21,
     XGI_40,
     MAX_SIS_CHIP
 } SIS_CHIP_TYPE;
-- 
1.5.6.5

