Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1BMWLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:11:55 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46662 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1BMWLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:11:18 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Subject: [PATCH 5/6] sisfb: move XGI POST DDR2 bootup code into subroutines
Date: Mon, 14 Feb 2011 00:11:27 +0200
Message-Id: <1297635088-13224-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move DDR2 register setting code into separate subroutines. No changes
in functionality.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |  139 +++++++++++++++++++++++++-----------------
 1 files changed, 84 insertions(+), 55 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index de03567..9c52d7b 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4941,6 +4941,89 @@ sisfb_post_xgi_setclocks(struct sis_video_info *ivideo, u8 regb)
 	sisfb_post_xgi_delay(ivideo, 0x43);
 }
 
+static void __devinit
+sisfb_post_xgi_ddr2_mrs_default(struct sis_video_info *ivideo, u8 regb)
+{
+	unsigned char *bios = ivideo->bios_abase;
+	u8 v1;
+
+	SiS_SetReg(SISSR, 0x28, 0x64);
+	SiS_SetReg(SISSR, 0x29, 0x63);
+	sisfb_post_xgi_delay(ivideo, 15);
+	SiS_SetReg(SISSR, 0x18, 0x00);
+	SiS_SetReg(SISSR, 0x19, 0x20);
+	SiS_SetReg(SISSR, 0x16, 0x00);
+	SiS_SetReg(SISSR, 0x16, 0x80);
+	SiS_SetReg(SISSR, 0x18, 0xc5);
+	SiS_SetReg(SISSR, 0x19, 0x23);
+	SiS_SetReg(SISSR, 0x16, 0x00);
+	SiS_SetReg(SISSR, 0x16, 0x80);
+	sisfb_post_xgi_delay(ivideo, 1);
+	SiS_SetReg(SISCR, 0x97, 0x11);
+	sisfb_post_xgi_setclocks(ivideo, regb);
+	sisfb_post_xgi_delay(ivideo, 0x46);
+	SiS_SetReg(SISSR, 0x18, 0xc5);
+	SiS_SetReg(SISSR, 0x19, 0x23);
+	SiS_SetReg(SISSR, 0x16, 0x00);
+	SiS_SetReg(SISSR, 0x16, 0x80);
+	sisfb_post_xgi_delay(ivideo, 1);
+	SiS_SetReg(SISSR, 0x1b, 0x04);
+	sisfb_post_xgi_delay(ivideo, 1);
+	SiS_SetReg(SISSR, 0x1b, 0x00);
+	sisfb_post_xgi_delay(ivideo, 1);
+	v1 = 0x31;
+	if (ivideo->haveXGIROM) {
+		v1 = bios[0xf0];
+	}
+	SiS_SetReg(SISSR, 0x18, v1);
+	SiS_SetReg(SISSR, 0x19, 0x06);
+	SiS_SetReg(SISSR, 0x16, 0x04);
+	SiS_SetReg(SISSR, 0x16, 0x84);
+	sisfb_post_xgi_delay(ivideo, 1);
+}
+
+static void __devinit
+sisfb_post_xgi_ddr2(struct sis_video_info *ivideo, u8 regb)
+{
+	unsigned char *bios = ivideo->bios_abase;
+	static const u8 cs158[8] = {
+		0x88, 0xaa, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+	static const u8 cs160[8] = {
+		0x44, 0x77, 0x77, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+	static const u8 cs168[8] = {
+		0x48, 0x78, 0x88, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+	u8 reg;
+	u8 v1;
+	u8 v2;
+	u8 v3;
+
+	SiS_SetReg(SISCR, 0x82, 0x77);
+	SiS_SetReg(SISCR, 0x86, 0x00);
+	reg = SiS_GetReg(SISCR, 0x86);
+	SiS_SetReg(SISCR, 0x86, 0x88);
+	reg = SiS_GetReg(SISCR, 0x86);
+	v1 = cs168[regb]; v2 = cs160[regb]; v3 = cs158[regb];
+	if (ivideo->haveXGIROM) {
+		v1 = bios[regb + 0x168];
+		v2 = bios[regb + 0x160];
+		v3 = bios[regb + 0x158];
+	}
+	SiS_SetReg(SISCR, 0x86, v1);
+	SiS_SetReg(SISCR, 0x82, 0x77);
+	SiS_SetReg(SISCR, 0x85, 0x00);
+	reg = SiS_GetReg(SISCR, 0x85);
+	SiS_SetReg(SISCR, 0x85, 0x88);
+	reg = SiS_GetReg(SISCR, 0x85);
+	SiS_SetReg(SISCR, 0x85, v2);
+	SiS_SetReg(SISCR, 0x82, v3);
+	SiS_SetReg(SISCR, 0x98, 0x01);
+	SiS_SetReg(SISCR, 0x9a, 0x02);
+	sisfb_post_xgi_ddr2_default(ivideo, regb);
+}
+
 static u8 __devinit
 sisfb_post_xgi_ramtype(struct sis_video_info *ivideo)
 {
@@ -5514,61 +5597,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		SiS_SetReg(SISSR, 0x1b, 0x00);
 		break;
 	case 1:
-		SiS_SetReg(SISCR, 0x82, 0x77);
-		SiS_SetReg(SISCR, 0x86, 0x00);
-		reg = SiS_GetReg(SISCR, 0x86);
-		SiS_SetReg(SISCR, 0x86, 0x88);
-		reg = SiS_GetReg(SISCR, 0x86);
-		v1 = cs168[regb]; v2 = cs160[regb]; v3 = cs158[regb];
-		if(ivideo->haveXGIROM) {
-			v1 = bios[regb + 0x168];
-			v2 = bios[regb + 0x160];
-			v3 = bios[regb + 0x158];
-		}
-		SiS_SetReg(SISCR, 0x86, v1);
-		SiS_SetReg(SISCR, 0x82, 0x77);
-		SiS_SetReg(SISCR, 0x85, 0x00);
-		reg = SiS_GetReg(SISCR, 0x85);
-		SiS_SetReg(SISCR, 0x85, 0x88);
-		reg = SiS_GetReg(SISCR, 0x85);
-		SiS_SetReg(SISCR, 0x85, v2);
-		SiS_SetReg(SISCR, 0x82, v3);
-		SiS_SetReg(SISCR, 0x98, 0x01);
-		SiS_SetReg(SISCR, 0x9a, 0x02);
-
-		SiS_SetReg(SISSR, 0x28, 0x64);
-		SiS_SetReg(SISSR, 0x29, 0x63);
-		sisfb_post_xgi_delay(ivideo, 15);
-		SiS_SetReg(SISSR, 0x18, 0x00);
-		SiS_SetReg(SISSR, 0x19, 0x20);
-		SiS_SetReg(SISSR, 0x16, 0x00);
-		SiS_SetReg(SISSR, 0x16, 0x80);
-		SiS_SetReg(SISSR, 0x18, 0xc5);
-		SiS_SetReg(SISSR, 0x19, 0x23);
-		SiS_SetReg(SISSR, 0x16, 0x00);
-		SiS_SetReg(SISSR, 0x16, 0x80);
-		sisfb_post_xgi_delay(ivideo, 1);
-		SiS_SetReg(SISCR, 0x97, 0x11);
-		sisfb_post_xgi_setclocks(ivideo, regb);
-		sisfb_post_xgi_delay(ivideo, 0x46);
-		SiS_SetReg(SISSR, 0x18, 0xc5);
-		SiS_SetReg(SISSR, 0x19, 0x23);
-		SiS_SetReg(SISSR, 0x16, 0x00);
-		SiS_SetReg(SISSR, 0x16, 0x80);
-		sisfb_post_xgi_delay(ivideo, 1);
-		SiS_SetReg(SISSR, 0x1b, 0x04);
-		sisfb_post_xgi_delay(ivideo, 1);
-		SiS_SetReg(SISSR, 0x1b, 0x00);
-		sisfb_post_xgi_delay(ivideo, 1);
-		v1 = 0x31;
-		if(ivideo->haveXGIROM) {
-			v1 = bios[0xf0];
-		}
-		SiS_SetReg(SISSR, 0x18, v1);
-		SiS_SetReg(SISSR, 0x19, 0x06);
-		SiS_SetReg(SISSR, 0x16, 0x04);
-		SiS_SetReg(SISSR, 0x16, 0x84);
-		sisfb_post_xgi_delay(ivideo, 1);
+		sisfb_post_xgi_ddr2(ivideo, regb);
 		break;
 	default:
 		sisfb_post_xgi_setclocks(ivideo, regb);
-- 
1.5.6.5

