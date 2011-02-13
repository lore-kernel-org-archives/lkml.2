Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1BMWLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:11:35 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:57764 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab1BMWLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:11:18 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Subject: [PATCH 6/6] sisfb: add support for XGI Z9 DDR2 POST
Date: Mon, 14 Feb 2011 00:11:28 +0200
Message-Id: <1297635088-13224-7-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for ZGI Z9 DDR2 POST. The init sequence is from XGI's
xgifb driver.

Tested with ARM board using a PCI card with XGI Z9s and 32 MB DDR2
memory. After a cold reset the POST succeeds.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |   77 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 9c52d7b..7525984 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4983,6 +4983,48 @@ sisfb_post_xgi_ddr2_mrs_default(struct sis_video_info *ivideo, u8 regb)
 }
 
 static void __devinit
+sisfb_post_xgi_ddr2_mrs_xg21(struct sis_video_info *ivideo)
+{
+	sisfb_post_xgi_setclocks(ivideo, 1);
+
+	SiS_SetReg(SISCR, 0x97, 0x11);
+	sisfb_post_xgi_delay(ivideo, 0x46);
+
+	SiS_SetReg(SISSR, 0x18, 0x00);	/* EMRS2 */
+	SiS_SetReg(SISSR, 0x19, 0x80);
+	SiS_SetReg(SISSR, 0x16, 0x05);
+	SiS_SetReg(SISSR, 0x16, 0x85);
+
+	SiS_SetReg(SISSR, 0x18, 0x00);	/* EMRS3 */
+	SiS_SetReg(SISSR, 0x19, 0xc0);
+	SiS_SetReg(SISSR, 0x16, 0x05);
+	SiS_SetReg(SISSR, 0x16, 0x85);
+
+	SiS_SetReg(SISSR, 0x18, 0x00);	/* EMRS1 */
+	SiS_SetReg(SISSR, 0x19, 0x40);
+	SiS_SetReg(SISSR, 0x16, 0x05);
+	SiS_SetReg(SISSR, 0x16, 0x85);
+
+	SiS_SetReg(SISSR, 0x18, 0x42);	/* MRS1 */
+	SiS_SetReg(SISSR, 0x19, 0x02);
+	SiS_SetReg(SISSR, 0x16, 0x05);
+	SiS_SetReg(SISSR, 0x16, 0x85);
+	sisfb_post_xgi_delay(ivideo, 1);
+
+	SiS_SetReg(SISSR, 0x1b, 0x04);
+	sisfb_post_xgi_delay(ivideo, 1);
+
+	SiS_SetReg(SISSR, 0x1b, 0x00);
+	sisfb_post_xgi_delay(ivideo, 1);
+
+	SiS_SetReg(SISSR, 0x18, 0x42);	/* MRS1 */
+	SiS_SetReg(SISSR, 0x19, 0x00);
+	SiS_SetReg(SISSR, 0x16, 0x05);
+	SiS_SetReg(SISSR, 0x16, 0x85);
+	sisfb_post_xgi_delay(ivideo, 1);
+}
+
+static void __devinit
 sisfb_post_xgi_ddr2(struct sis_video_info *ivideo, u8 regb)
 {
 	unsigned char *bios = ivideo->bios_abase;
@@ -5000,6 +5042,7 @@ sisfb_post_xgi_ddr2(struct sis_video_info *ivideo, u8 regb)
 	u8 v2;
 	u8 v3;
 
+	SiS_SetReg(SISCR, 0xb0, 0x80); /* DDR2 dual frequency mode */
 	SiS_SetReg(SISCR, 0x82, 0x77);
 	SiS_SetReg(SISCR, 0x86, 0x00);
 	reg = SiS_GetReg(SISCR, 0x86);
@@ -5021,7 +5064,10 @@ sisfb_post_xgi_ddr2(struct sis_video_info *ivideo, u8 regb)
 	SiS_SetReg(SISCR, 0x82, v3);
 	SiS_SetReg(SISCR, 0x98, 0x01);
 	SiS_SetReg(SISCR, 0x9a, 0x02);
-	sisfb_post_xgi_ddr2_default(ivideo, regb);
+	if (sisfb_xgi_is21(ivideo))
+		sisfb_post_xgi_ddr2_mrs_xg21(ivideo);
+	else
+		sisfb_post_xgi_ddr2_mrs_default(ivideo, regb);
 }
 
 static u8 __devinit
@@ -5346,9 +5392,23 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetReg(SISCR, 0x77, v1);
 	}
 
-	/* RAM type */
-
-	regb = 0;	/* ! */
+	/* RAM type:
+	 *
+	 * 0 == DDR1, 1 == DDR2, 2..7 == reserved?
+	 *
+	 * The code seems to written so that regb should equal ramtype,
+	 * however, so far it has been hardcoded to 0. Enable other values only
+	 * on XGI Z9, as it passes the POST, and add a warning for others.
+	 */
+	ramtype = sisfb_post_xgi_ramtype(ivideo);
+	if (!sisfb_xgi_is21(ivideo) && ramtype) {
+		dev_warn(&pdev->dev,
+			 "RAM type something else than expected: %d\n",
+			 ramtype);
+		regb = 0;
+	} else {
+		regb = ramtype;
+	}
 
 	v1 = 0xff;
 	if(ivideo->haveXGIROM) {
@@ -5500,7 +5560,10 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		}
 	}
 
-	SiS_SetReg(SISSR, 0x17, 0x00);
+	if (regb == 1)
+		SiS_SetReg(SISSR, 0x17, 0x80);		/* DDR2 */
+	else
+		SiS_SetReg(SISSR, 0x17, 0x00);		/* DDR1 */
 	SiS_SetReg(SISSR, 0x1a, 0x87);
 
 	if(ivideo->chip == XGI_20) {
@@ -5508,10 +5571,6 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetReg(SISSR, 0x1c, 0x00);
 	}
 
-	ramtype = sisfb_post_xgi_ramtype(ivideo);
-
-	regb = 0;	/* ! */
-
 	switch(ramtype) {
 	case 0:
 		sisfb_post_xgi_setclocks(ivideo, regb);
-- 
1.5.6.5

