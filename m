Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1CLVbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:31:41 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52891 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755687Ab1CLVbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:31:10 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19GSFc4q2lGyK69niTEsVYrLD2W3N9z9912zrpEeu
	Jfn9gJm8c/6yJL
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: always return the best possible clock
Date: Sat, 12 Mar 2011 21:46:24 +0000
Message-Id: <1299966386-3439-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1299966386-3439-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1299966386-3439-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch only clocks that perfectly match were used and if
none existed this was not handled properly. This patch changes this
to always use the closest clock supported. This should behave like
before for clocks that have a perfect match but be much saner for
clocks which are slightly off.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |   60 ++++++++++++++++++++++-------------------------
 drivers/video/via/hw.h |    2 -
 2 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 8c1393e..a7a5614 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1677,40 +1677,36 @@ static u32 vx855_encode_pll(struct pll_config pll)
 u32 viafb_get_clk_value(int clk)
 {
 	u32 value = 0;
-	int i = 0;
+	int i, best = 0;
 
-	while (i < NUM_TOTAL_PLL_TABLE && clk != pll_value[i].clk)
-		i++;
-
-	if (i == NUM_TOTAL_PLL_TABLE) {
-		printk(KERN_WARNING "viafb_get_clk_value: PLL lookup failed!");
-	} else {
-		switch (viaparinfo->chip_info->gfx_chip_name) {
-		case UNICHROME_CLE266:
-		case UNICHROME_K400:
-			value = cle266_encode_pll(pll_value[i].cle266_pll);
-			break;
-
-		case UNICHROME_K800:
-		case UNICHROME_PM800:
-		case UNICHROME_CN700:
-			value = k800_encode_pll(pll_value[i].k800_pll);
-			break;
-
-		case UNICHROME_CX700:
-		case UNICHROME_CN750:
-		case UNICHROME_K8M890:
-		case UNICHROME_P4M890:
-		case UNICHROME_P4M900:
-		case UNICHROME_VX800:
-			value = k800_encode_pll(pll_value[i].cx700_pll);
-			break;
+	for (i = 1; i < ARRAY_SIZE(pll_value); i++) {
+		if (abs(pll_value[i].clk - clk)
+			< abs(pll_value[best].clk - clk))
+			best = i;
+	}
 
-		case UNICHROME_VX855:
-		case UNICHROME_VX900:
-			value = vx855_encode_pll(pll_value[i].vx855_pll);
-			break;
-		}
+	switch (viaparinfo->chip_info->gfx_chip_name) {
+	case UNICHROME_CLE266:
+	case UNICHROME_K400:
+		value = cle266_encode_pll(pll_value[best].cle266_pll);
+		break;
+	case UNICHROME_K800:
+	case UNICHROME_PM800:
+	case UNICHROME_CN700:
+		value = k800_encode_pll(pll_value[best].k800_pll);
+		break;
+	case UNICHROME_CX700:
+	case UNICHROME_CN750:
+	case UNICHROME_K8M890:
+	case UNICHROME_P4M890:
+	case UNICHROME_P4M900:
+	case UNICHROME_VX800:
+		value = k800_encode_pll(pll_value[best].cx700_pll);
+		break;
+	case UNICHROME_VX855:
+	case UNICHROME_VX900:
+		value = vx855_encode_pll(pll_value[best].vx855_pll);
+		break;
 	}
 
 	return value;
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 668d534..7295263 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -893,8 +893,6 @@ struct iga2_crtc_timing {
 /* VT3410 chipset*/
 #define VX900_FUNCTION3     0x3410
 
-#define NUM_TOTAL_PLL_TABLE ARRAY_SIZE(pll_value)
-
 struct IODATA {
 	u8 Index;
 	u8 Mask;
-- 
1.6.3.2

