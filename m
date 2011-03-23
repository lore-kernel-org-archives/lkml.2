Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1CWWVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:21:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33303 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756756Ab1CWWUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:20:01 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/8/tYUetD8VoDM9axNThKliEtX9BpM6PF/UIWj/R
	IVDUtwNo26xWHb
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/4] viafb: allow some pll calculations
Date: Wed, 23 Mar 2011 22:35:31 +0000
Message-Id: <1300919734-3931-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1300919734-3931-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1300919734-3931-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows calculating the pll multiplier within limits based
on the previous table. All available information supports that it
should be possible/sane to choose the multiplier free within some
ranges.
Storing the multiplier ranges instead of lots of pll configurations
reduces the memory needed and may as well improve the performance.
It is also expected to provide better pll values resulting in better
frequencies for the connected devices.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |  377 +++++++++++++-----------------------------------
 drivers/video/via/hw.h |   11 +-
 2 files changed, 106 insertions(+), 282 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index dc4c778..063ff65 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -22,272 +22,80 @@
 #include <linux/via-core.h>
 #include "global.h"
 
-static struct pll_config cle266_pll_config[] = {
-	{19, 4, 0},
-	{26, 5, 0},
-	{28, 5, 0},
-	{31, 5, 0},
-	{33, 5, 0},
-	{55, 5, 0},
-	{102, 5, 0},
-	{53, 6, 0},
-	{92, 6, 0},
-	{98, 6, 0},
-	{112, 6, 0},
-	{41, 7, 0},
-	{60, 7, 0},
-	{99, 7, 0},
-	{100, 7, 0},
-	{83, 8, 0},
-	{86, 8, 0},
-	{108, 8, 0},
-	{87, 9, 0},
-	{118, 9, 0},
-	{95, 12, 0},
-	{115, 12, 0},
-	{108, 13, 0},
-	{83, 17, 0},
-	{67, 20, 0},
-	{86, 20, 0},
-	{98, 20, 0},
-	{121, 24, 0},
-	{99, 29, 0},
-	{33, 3, 1},
-	{15, 4, 1},
-	{23, 4, 1},
-	{37, 5, 1},
-	{83, 5, 1},
-	{85, 5, 1},
-	{94, 5, 1},
-	{103, 5, 1},
-	{109, 5, 1},
-	{113, 5, 1},
-	{121, 5, 1},
-	{82, 6, 1},
-	{31, 7, 1},
-	{55, 7, 1},
-	{84, 7, 1},
-	{83, 8, 1},
-	{76, 9, 1},
-	{127, 9, 1},
-	{33, 4, 2},
-	{75, 4, 2},
-	{119, 4, 2},
-	{121, 4, 2},
-	{91, 5, 2},
-	{118, 5, 2},
-	{83, 6, 2},
-	{109, 6, 2},
-	{90, 7, 2},
-	{93, 2, 3},
-	{53, 3, 3},
-	{73, 4, 3},
-	{89, 4, 3},
-	{105, 4, 3},
-	{117, 4, 3},
-	{101, 5, 3},
-	{121, 5, 3},
-	{127, 5, 3},
-	{99, 7, 3}
+static struct pll_limit cle266_pll_limits[] = {
+	{19, 19, 4, 0},
+	{26, 102, 5, 0},
+	{53, 112, 6, 0},
+	{41, 100, 7, 0},
+	{83, 108, 8, 0},
+	{87, 118, 9, 0},
+	{95, 115, 12, 0},
+	{108, 108, 13, 0},
+	{83, 83, 17, 0},
+	{67, 98, 20, 0},
+	{121, 121, 24, 0},
+	{99, 99, 29, 0},
+	{33, 33, 3, 1},
+	{15, 23, 4, 1},
+	{37, 121, 5, 1},
+	{82, 82, 6, 1},
+	{31, 84, 7, 1},
+	{83, 83, 8, 1},
+	{76, 127, 9, 1},
+	{33, 121, 4, 2},
+	{91, 118, 5, 2},
+	{83, 109, 6, 2},
+	{90, 90, 7, 2},
+	{93, 93, 2, 3},
+	{53, 53, 3, 3},
+	{73, 117, 4, 3},
+	{101, 127, 5, 3},
+	{99, 99, 7, 3}
 };
 
-static struct pll_config k800_pll_config[] = {
-	{22, 2, 0},
-	{28, 3, 0},
-	{81, 3, 1},
-	{85, 3, 1},
-	{98, 3, 1},
-	{112, 3, 1},
-	{86, 4, 1},
-	{166, 4, 1},
-	{109, 5, 1},
-	{113, 5, 1},
-	{121, 5, 1},
-	{131, 5, 1},
-	{143, 5, 1},
-	{153, 5, 1},
-	{66, 3, 2},
-	{68, 3, 2},
-	{95, 3, 2},
-	{106, 3, 2},
-	{116, 3, 2},
-	{93, 4, 2},
-	{119, 4, 2},
-	{121, 4, 2},
-	{133, 4, 2},
-	{137, 4, 2},
-	{117, 5, 2},
-	{118, 5, 2},
-	{120, 5, 2},
-	{124, 5, 2},
-	{132, 5, 2},
-	{137, 5, 2},
-	{141, 5, 2},
-	{166, 5, 2},
-	{170, 5, 2},
-	{191, 5, 2},
-	{206, 5, 2},
-	{208, 5, 2},
-	{30, 2, 3},
-	{69, 3, 3},
-	{82, 3, 3},
-	{83, 3, 3},
-	{109, 3, 3},
-	{114, 3, 3},
-	{125, 3, 3},
-	{89, 4, 3},
-	{103, 4, 3},
-	{117, 4, 3},
-	{126, 4, 3},
-	{150, 4, 3},
-	{161, 4, 3},
-	{121, 5, 3},
-	{127, 5, 3},
-	{131, 5, 3},
-	{134, 5, 3},
-	{148, 5, 3},
-	{169, 5, 3},
-	{172, 5, 3},
-	{182, 5, 3},
-	{195, 5, 3},
-	{196, 5, 3},
-	{208, 5, 3},
-	{66, 2, 4},
-	{85, 3, 4},
-	{141, 4, 4},
-	{146, 4, 4},
-	{161, 4, 4},
-	{177, 5, 4}
+static struct pll_limit k800_pll_limits[] = {
+	{22, 22, 2, 0},
+	{28, 28, 3, 0},
+	{81, 112, 3, 1},
+	{86, 166, 4, 1},
+	{109, 153, 5, 1},
+	{66, 116, 3, 2},
+	{93, 137, 4, 2},
+	{117, 208, 5, 2},
+	{30, 30, 2, 3},
+	{69, 125, 3, 3},
+	{89, 161, 4, 3},
+	{121, 208, 5, 3},
+	{66, 66, 2, 4},
+	{85, 85, 3, 4},
+	{141, 161, 4, 4},
+	{177, 177, 5, 4}
 };
 
-static struct pll_config cx700_pll_config[] = {
-	{98, 3, 1},
-	{86, 4, 1},
-	{109, 5, 1},
-	{110, 5, 1},
-	{113, 5, 1},
-	{121, 5, 1},
-	{131, 5, 1},
-	{135, 5, 1},
-	{142, 5, 1},
-	{143, 5, 1},
-	{153, 5, 1},
-	{187, 5, 1},
-	{208, 5, 1},
-	{68, 2, 2},
-	{95, 3, 2},
-	{116, 3, 2},
-	{93, 4, 2},
-	{119, 4, 2},
-	{133, 4, 2},
-	{137, 4, 2},
-	{151, 4, 2},
-	{166, 4, 2},
-	{110, 5, 2},
-	{112, 5, 2},
-	{117, 5, 2},
-	{118, 5, 2},
-	{120, 5, 2},
-	{132, 5, 2},
-	{137, 5, 2},
-	{141, 5, 2},
-	{151, 5, 2},
-	{166, 5, 2},
-	{175, 5, 2},
-	{191, 5, 2},
-	{206, 5, 2},
-	{174, 7, 2},
-	{82, 3, 3},
-	{109, 3, 3},
-	{117, 4, 3},
-	{150, 4, 3},
-	{161, 4, 3},
-	{112, 5, 3},
-	{115, 5, 3},
-	{121, 5, 3},
-	{127, 5, 3},
-	{129, 5, 3},
-	{131, 5, 3},
-	{134, 5, 3},
-	{138, 5, 3},
-	{148, 5, 3},
-	{157, 5, 3},
-	{169, 5, 3},
-	{172, 5, 3},
-	{190, 5, 3},
-	{195, 5, 3},
-	{196, 5, 3},
-	{208, 5, 3},
-	{141, 5, 4},
-	{150, 5, 4},
-	{166, 5, 4},
-	{176, 5, 4},
-	{177, 5, 4},
-	{183, 5, 4},
-	{202, 5, 4}
+static struct pll_limit cx700_pll_limits[] = {
+	{98, 98, 3, 1},
+	{86, 86, 4, 1},
+	{109, 208, 5, 1},
+	{68, 68, 2, 2},
+	{95, 116, 3, 2},
+	{93, 166, 4, 2},
+	{110, 206, 5, 2},
+	{174, 174, 7, 2},
+	{82, 109, 3, 3},
+	{117, 161, 4, 3},
+	{112, 208, 5, 3},
+	{141, 202, 5, 4}
 };
 
-static struct pll_config vx855_pll_config[] = {
-	{86, 4, 1},
-	{108, 5, 1},
-	{110, 5, 1},
-	{113, 5, 1},
-	{121, 5, 1},
-	{131, 5, 1},
-	{135, 5, 1},
-	{142, 5, 1},
-	{143, 5, 1},
-	{153, 5, 1},
-	{164, 5, 1},
-	{187, 5, 1},
-	{208, 5, 1},
-	{110, 5, 2},
-	{112, 5, 2},
-	{117, 5, 2},
-	{118, 5, 2},
-	{124, 5, 2},
-	{132, 5, 2},
-	{137, 5, 2},
-	{141, 5, 2},
-	{149, 5, 2},
-	{151, 5, 2},
-	{159, 5, 2},
-	{166, 5, 2},
-	{167, 5, 2},
-	{172, 5, 2},
-	{189, 5, 2},
-	{191, 5, 2},
-	{194, 5, 2},
-	{206, 5, 2},
-	{208, 5, 2},
-	{83, 3, 3},
-	{88, 3, 3},
-	{109, 3, 3},
-	{112, 3, 3},
-	{103, 4, 3},
-	{105, 4, 3},
-	{161, 4, 3},
-	{112, 5, 3},
-	{115, 5, 3},
-	{121, 5, 3},
-	{127, 5, 3},
-	{134, 5, 3},
-	{137, 5, 3},
-	{148, 5, 3},
-	{157, 5, 3},
-	{169, 5, 3},
-	{172, 5, 3},
-	{182, 5, 3},
-	{191, 5, 3},
-	{195, 5, 3},
-	{209, 5, 3},
-	{142, 4, 4},
-	{146, 4, 4},
-	{161, 4, 4},
-	{141, 5, 4},
-	{150, 5, 4},
-	{165, 5, 4},
-	{176, 5, 4}
+static struct pll_limit vx855_pll_limits[] = {
+	{86, 86, 4, 1},
+	{108, 208, 5, 1},
+	{110, 208, 5, 2},
+	{83, 112, 3, 3},
+	{103, 161, 4, 3},
+	{112, 209, 5, 3},
+	{142, 161, 4, 4},
+	{141, 176, 5, 4}
 };
 
 /* according to VIA Technologies these values are based on experiment */
@@ -1633,17 +1441,34 @@ static inline u32 get_pll_output_frequency(u32 ref_freq, struct pll_config pll)
 	return get_pll_internal_frequency(ref_freq, pll)>>pll.rshift;
 }
 
-static struct pll_config get_pll_config(struct pll_config *config, int size,
+static struct pll_config get_pll_config(struct pll_limit *limits, int size,
 	int clk)
 {
-	struct pll_config best = config[0];
+	struct pll_config cur, up, down, best = {0, 1, 0};
 	const u32 f0 = 14318180; /* X1 frequency */
-	int i;
-
-	for (i = 1; i < size; i++) {
-		if (abs(get_pll_output_frequency(f0, config[i]) - clk)
-			< abs(get_pll_output_frequency(f0, best) - clk))
-			best = config[i];
+	int i, f;
+
+	for (i = 0; i < size; i++) {
+		cur.rshift = limits[i].rshift;
+		cur.divisor = limits[i].divisor;
+		cur.multiplier = clk / ((f0 / cur.divisor)>>cur.rshift);
+		f = abs(get_pll_output_frequency(f0, cur) - clk);
+		up = down = cur;
+		up.multiplier++;
+		down.multiplier--;
+		if (abs(get_pll_output_frequency(f0, up) - clk) < f)
+			cur = up;
+		else if (abs(get_pll_output_frequency(f0, down) - clk) < f)
+			cur = down;
+
+		if (cur.multiplier < limits[i].multiplier_min)
+			cur.multiplier = limits[i].multiplier_min;
+		else if (cur.multiplier > limits[i].multiplier_max)
+			cur.multiplier = limits[i].multiplier_max;
+
+		f = abs(get_pll_output_frequency(f0, cur) - clk);
+		if (f < abs(get_pll_output_frequency(f0, best) - clk))
+			best = cur;
 	}
 
 	return best;
@@ -1656,14 +1481,14 @@ u32 viafb_get_clk_value(int clk)
 	switch (viaparinfo->chip_info->gfx_chip_name) {
 	case UNICHROME_CLE266:
 	case UNICHROME_K400:
-		value = cle266_encode_pll(get_pll_config(cle266_pll_config,
-			ARRAY_SIZE(cle266_pll_config), clk));
+		value = cle266_encode_pll(get_pll_config(cle266_pll_limits,
+			ARRAY_SIZE(cle266_pll_limits), clk));
 		break;
 	case UNICHROME_K800:
 	case UNICHROME_PM800:
 	case UNICHROME_CN700:
-		value = k800_encode_pll(get_pll_config(k800_pll_config,
-			ARRAY_SIZE(k800_pll_config), clk));
+		value = k800_encode_pll(get_pll_config(k800_pll_limits,
+			ARRAY_SIZE(k800_pll_limits), clk));
 		break;
 	case UNICHROME_CX700:
 	case UNICHROME_CN750:
@@ -1671,13 +1496,13 @@ u32 viafb_get_clk_value(int clk)
 	case UNICHROME_P4M890:
 	case UNICHROME_P4M900:
 	case UNICHROME_VX800:
-		value = k800_encode_pll(get_pll_config(cx700_pll_config,
-			ARRAY_SIZE(cx700_pll_config), clk));
+		value = k800_encode_pll(get_pll_config(cx700_pll_limits,
+			ARRAY_SIZE(cx700_pll_limits), clk));
 		break;
 	case UNICHROME_VX855:
 	case UNICHROME_VX900:
-		value = vx855_encode_pll(get_pll_config(vx855_pll_config,
-			ARRAY_SIZE(vx855_pll_config), clk));
+		value = vx855_encode_pll(get_pll_config(vx855_pll_limits,
+			ARRAY_SIZE(vx855_pll_limits), clk));
 		break;
 	}
 
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 8858593..63d8d37 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -738,12 +738,11 @@ struct pll_config {
 	u8 rshift;
 };
 
-struct pll_map {
-	u32 clk;
-	struct pll_config cle266_pll;
-	struct pll_config k800_pll;
-	struct pll_config cx700_pll;
-	struct pll_config vx855_pll;
+struct pll_limit {
+	u16 multiplier_min;
+	u16 multiplier_max;
+	u8 divisor;
+	u8 rshift;
 };
 
 struct rgbLUT {
-- 
1.6.3.2

