Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1BMWSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:18:13 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34921 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab1BMWSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:18:02 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Feb 2011 17:18:02 EST
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Subject: [PATCH 1/6] sisfb: POST should fail if R/W test fails
Date: Mon, 14 Feb 2011 00:11:23 +0200
Message-Id: <1297635088-13224-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no indication if R/W test fails during POST. This can
happen e.g. when user plugs in a card with unsupported type of memory.
Since the driver will be unusable, it's better to fail the whole POST
if the memory cannot be configured properly.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 2fb8c5a..2c5de66 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4627,11 +4627,11 @@ sisfb_post_xgi_rwtest(struct sis_video_info *ivideo, int starta,
 	return 1;
 }
 
-static void __devinit
+static int __devinit
 sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 {
 	unsigned int buswidth, ranksize, channelab, mapsize;
-	int i, j, k, l;
+	int i, j, k, l, status;
 	u8 reg, sr14;
 	static const u8 dramsr13[12 * 5] = {
 		0x02, 0x0e, 0x0b, 0x80, 0x5d,
@@ -4673,7 +4673,7 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 		SiS_SetReg(SISSR, 0x13, 0x35);
 		SiS_SetReg(SISSR, 0x14, 0x41);
 		/* TODO */
-		return;
+		return -ENOMEM;
 	}
 
 	/* Non-interleaving */
@@ -4835,6 +4835,7 @@ bail_out:
 
 	j = (ivideo->chip == XGI_20) ? 5 : 9;
 	k = (ivideo->chip == XGI_20) ? 12 : 4;
+	status = -EIO;
 
 	for(i = 0; i < k; i++) {
 
@@ -4868,11 +4869,15 @@ bail_out:
 		SiS_SetRegANDOR(SISSR, 0x14, 0x0f, (reg & 0xf0));
 		sisfb_post_xgi_delay(ivideo, 1);
 
-		if(sisfb_post_xgi_rwtest(ivideo, j, ((reg >> 4) + channelab - 2 + 20), mapsize))
+		if (sisfb_post_xgi_rwtest(ivideo, j, ((reg >> 4) + channelab - 2 + 20), mapsize)) {
+			status = 0;
 			break;
+		}
 	}
 
 	iounmap(ivideo->video_vbase);
+
+	return status;
 }
 
 static void __devinit
@@ -5648,6 +5653,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetReg(SISSR, 0x14, bios[regb + 0xe0 + 8]);
 
 	} else {
+		int err;
 
 		/* Set default mode, don't clear screen */
 		ivideo->SiS_Pr.SiS_UseOEM = false;
@@ -5661,10 +5667,16 @@ sisfb_post_xgi(struct pci_dev *pdev)
 
 		/* Disable read-cache */
 		SiS_SetRegAND(SISSR, 0x21, 0xdf);
-		sisfb_post_xgi_ramsize(ivideo);
+		err = sisfb_post_xgi_ramsize(ivideo);
 		/* Enable read-cache */
 		SiS_SetRegOR(SISSR, 0x21, 0x20);
 
+		if (err) {
+			dev_err(&pdev->dev,
+				"%s: RAM size detection failed: %d\n",
+				__func__, err);
+			return 0;
+		}
 	}
 
 #if 0
-- 
1.5.6.5

