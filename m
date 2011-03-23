Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab1CWWUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:20:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33394 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756792Ab1CWWUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:20:04 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX192nAZqmQZ22KTjP+Uro9MMCSz70Vc90rfIn4xVkt
	glh5uaXcdONZ5t
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/4] viafb: prepare for PLL separation
Date: Wed, 23 Mar 2011 22:35:33 +0000
Message-Id: <1300919734-3931-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1300919734-3931-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1300919734-3931-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits some functionality to extra functions.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |  127 +++++++++++++++++++++++++++++++----------------
 1 files changed, 84 insertions(+), 43 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index c28ae2e..bd28e13 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1430,6 +1430,70 @@ static u32 vx855_encode_pll(struct pll_config pll)
 		| pll.multiplier;
 }
 
+static inline void cle266_set_primary_pll_encoded(u32 data)
+{
+	via_write_reg_mask(VIASR, 0x40, 0x02, 0x02); /* enable reset */
+	via_write_reg(VIASR, 0x46, data & 0xFF);
+	via_write_reg(VIASR, 0x47, (data >> 8) & 0xFF);
+	via_write_reg_mask(VIASR, 0x40, 0x00, 0x02); /* disable reset */
+}
+
+static inline void k800_set_primary_pll_encoded(u32 data)
+{
+	via_write_reg_mask(VIASR, 0x40, 0x02, 0x02); /* enable reset */
+	via_write_reg(VIASR, 0x44, data & 0xFF);
+	via_write_reg(VIASR, 0x45, (data >> 8) & 0xFF);
+	via_write_reg(VIASR, 0x46, (data >> 16) & 0xFF);
+	via_write_reg_mask(VIASR, 0x40, 0x00, 0x02); /* disable reset */
+}
+
+static inline void cle266_set_secondary_pll_encoded(u32 data)
+{
+	via_write_reg_mask(VIASR, 0x40, 0x04, 0x04); /* enable reset */
+	via_write_reg(VIASR, 0x44, data & 0xFF);
+	via_write_reg(VIASR, 0x45, (data >> 8) & 0xFF);
+	via_write_reg_mask(VIASR, 0x40, 0x00, 0x04); /* disable reset */
+}
+
+static inline void k800_set_secondary_pll_encoded(u32 data)
+{
+	via_write_reg_mask(VIASR, 0x40, 0x04, 0x04); /* enable reset */
+	via_write_reg(VIASR, 0x4A, data & 0xFF);
+	via_write_reg(VIASR, 0x4B, (data >> 8) & 0xFF);
+	via_write_reg(VIASR, 0x4C, (data >> 16) & 0xFF);
+	via_write_reg_mask(VIASR, 0x40, 0x00, 0x04); /* disable reset */
+}
+
+static void cle266_set_primary_pll(struct pll_config config)
+{
+	cle266_set_primary_pll_encoded(cle266_encode_pll(config));
+}
+
+static void k800_set_primary_pll(struct pll_config config)
+{
+	k800_set_primary_pll_encoded(k800_encode_pll(config));
+}
+
+static void vx855_set_primary_pll(struct pll_config config)
+{
+	k800_set_primary_pll_encoded(vx855_encode_pll(config));
+}
+
+static void cle266_set_secondary_pll(struct pll_config config)
+{
+	cle266_set_secondary_pll_encoded(cle266_encode_pll(config));
+}
+
+static void k800_set_secondary_pll(struct pll_config config)
+{
+	k800_set_secondary_pll_encoded(k800_encode_pll(config));
+}
+
+static void vx855_set_secondary_pll(struct pll_config config)
+{
+	k800_set_secondary_pll_encoded(vx855_encode_pll(config));
+}
+
 static inline u32 get_pll_internal_frequency(u32 ref_freq,
 	struct pll_config pll)
 {
@@ -1474,21 +1538,21 @@ static struct pll_config get_pll_config(struct pll_limit *limits, int size,
 	return best;
 }
 
-static u32 viafb_get_clk_value(int clk)
+static struct pll_config get_best_pll_config(int clk)
 {
-	u32 value = 0;
+	struct pll_config config;
 
 	switch (viaparinfo->chip_info->gfx_chip_name) {
 	case UNICHROME_CLE266:
 	case UNICHROME_K400:
-		value = cle266_encode_pll(get_pll_config(cle266_pll_limits,
-			ARRAY_SIZE(cle266_pll_limits), clk));
+		config = get_pll_config(cle266_pll_limits,
+			ARRAY_SIZE(cle266_pll_limits), clk);
 		break;
 	case UNICHROME_K800:
 	case UNICHROME_PM800:
 	case UNICHROME_CN700:
-		value = k800_encode_pll(get_pll_config(k800_pll_limits,
-			ARRAY_SIZE(k800_pll_limits), clk));
+		config = get_pll_config(k800_pll_limits,
+			ARRAY_SIZE(k800_pll_limits), clk);
 		break;
 	case UNICHROME_CX700:
 	case UNICHROME_CN750:
@@ -1496,38 +1560,31 @@ static u32 viafb_get_clk_value(int clk)
 	case UNICHROME_P4M890:
 	case UNICHROME_P4M900:
 	case UNICHROME_VX800:
-		value = k800_encode_pll(get_pll_config(cx700_pll_limits,
-			ARRAY_SIZE(cx700_pll_limits), clk));
+		config = get_pll_config(cx700_pll_limits,
+			ARRAY_SIZE(cx700_pll_limits), clk);
 		break;
 	case UNICHROME_VX855:
 	case UNICHROME_VX900:
-		value = vx855_encode_pll(get_pll_config(vx855_pll_limits,
-			ARRAY_SIZE(vx855_pll_limits), clk));
+		config = get_pll_config(vx855_pll_limits,
+			ARRAY_SIZE(vx855_pll_limits), clk);
 		break;
 	}
 
-	return value;
+	return config;
 }
 
 /* Set VCLK*/
 void viafb_set_vclock(u32 clk, int set_iga)
 {
-	u32 value = viafb_get_clk_value(clk);
-
-	DEBUG_MSG(KERN_INFO "PLL=0x%x", value);
-
-	/* H.W. Reset : ON */
-	viafb_write_reg_mask(CR17, VIACR, 0x00, BIT7);
+	struct pll_config config = get_best_pll_config(clk);
 
 	if (set_iga == IGA1) {
 		/* Change D,N FOR VCLK */
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_CLE266:
 		case UNICHROME_K400:
-			via_write_reg(VIASR, SR46, (value & 0x00FF));
-			via_write_reg(VIASR, SR47, (value & 0xFF00) >> 8);
+			cle266_set_primary_pll(config);
 			break;
-
 		case UNICHROME_K800:
 		case UNICHROME_PM800:
 		case UNICHROME_CN700:
@@ -1537,11 +1594,11 @@ void viafb_set_vclock(u32 clk, int set_iga)
 		case UNICHROME_P4M890:
 		case UNICHROME_P4M900:
 		case UNICHROME_VX800:
+			k800_set_primary_pll(config);
+			break;
 		case UNICHROME_VX855:
 		case UNICHROME_VX900:
-			via_write_reg(VIASR, SR44, (value & 0x0000FF));
-			via_write_reg(VIASR, SR45, (value & 0x00FF00) >> 8);
-			via_write_reg(VIASR, SR46, (value & 0xFF0000) >> 16);
+			vx855_set_primary_pll(config);
 			break;
 		}
 	}
@@ -1551,10 +1608,8 @@ void viafb_set_vclock(u32 clk, int set_iga)
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_CLE266:
 		case UNICHROME_K400:
-			via_write_reg(VIASR, SR44, (value & 0x00FF));
-			via_write_reg(VIASR, SR45, (value & 0xFF00) >> 8);
+			cle266_set_secondary_pll(config);
 			break;
-
 		case UNICHROME_K800:
 		case UNICHROME_PM800:
 		case UNICHROME_CN700:
@@ -1564,29 +1619,15 @@ void viafb_set_vclock(u32 clk, int set_iga)
 		case UNICHROME_P4M890:
 		case UNICHROME_P4M900:
 		case UNICHROME_VX800:
+			k800_set_secondary_pll(config);
+			break;
 		case UNICHROME_VX855:
 		case UNICHROME_VX900:
-			via_write_reg(VIASR, SR4A, (value & 0x0000FF));
-			via_write_reg(VIASR, SR4B, (value & 0x00FF00) >> 8);
-			via_write_reg(VIASR, SR4C, (value & 0xFF0000) >> 16);
+			vx855_set_secondary_pll(config);
 			break;
 		}
 	}
 
-	/* H.W. Reset : OFF */
-	viafb_write_reg_mask(CR17, VIACR, 0x80, BIT7);
-
-	/* Reset PLL */
-	if (set_iga == IGA1) {
-		viafb_write_reg_mask(SR40, VIASR, 0x02, BIT1);
-		viafb_write_reg_mask(SR40, VIASR, 0x00, BIT1);
-	}
-
-	if (set_iga == IGA2) {
-		viafb_write_reg_mask(SR40, VIASR, 0x04, BIT2);
-		viafb_write_reg_mask(SR40, VIASR, 0x00, BIT2);
-	}
-
 	/* Fire! */
 	via_write_misc_reg_mask(0x0C, 0x0C); /* select external clock */
 }
-- 
1.6.3.2

