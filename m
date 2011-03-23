Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1CWWUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:20:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33366 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756777Ab1CWWUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:20:03 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX196izExL41618kyMCz1pXEjzgSMcNYoKXvYUDn9rJ
	DBTa93MAEom5LQ
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: call viafb_get_clk_value only in viafb_set_vclock
Date: Wed, 23 Mar 2011 22:35:32 +0000
Message-Id: <1300919734-3931-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1300919734-3931-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1300919734-3931-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As no caller is interested in the result call viafb_get_clk_value
directly from viafb_set_vclock to encapsulate the hardware dependend
stuff there.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c  |   32 +++++++++++++++++---------------
 drivers/video/via/hw.h  |    1 -
 drivers/video/via/lcd.c |    7 ++-----
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 063ff65..c28ae2e 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1474,7 +1474,7 @@ static struct pll_config get_pll_config(struct pll_limit *limits, int size,
 	return best;
 }
 
-u32 viafb_get_clk_value(int clk)
+static u32 viafb_get_clk_value(int clk)
 {
 	u32 value = 0;
 
@@ -1512,6 +1512,10 @@ u32 viafb_get_clk_value(int clk)
 /* Set VCLK*/
 void viafb_set_vclock(u32 clk, int set_iga)
 {
+	u32 value = viafb_get_clk_value(clk);
+
+	DEBUG_MSG(KERN_INFO "PLL=0x%x", value);
+
 	/* H.W. Reset : ON */
 	viafb_write_reg_mask(CR17, VIACR, 0x00, BIT7);
 
@@ -1520,8 +1524,8 @@ void viafb_set_vclock(u32 clk, int set_iga)
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_CLE266:
 		case UNICHROME_K400:
-			via_write_reg(VIASR, SR46, (clk & 0x00FF));
-			via_write_reg(VIASR, SR47, (clk & 0xFF00) >> 8);
+			via_write_reg(VIASR, SR46, (value & 0x00FF));
+			via_write_reg(VIASR, SR47, (value & 0xFF00) >> 8);
 			break;
 
 		case UNICHROME_K800:
@@ -1535,9 +1539,9 @@ void viafb_set_vclock(u32 clk, int set_iga)
 		case UNICHROME_VX800:
 		case UNICHROME_VX855:
 		case UNICHROME_VX900:
-			via_write_reg(VIASR, SR44, (clk & 0x0000FF));
-			via_write_reg(VIASR, SR45, (clk & 0x00FF00) >> 8);
-			via_write_reg(VIASR, SR46, (clk & 0xFF0000) >> 16);
+			via_write_reg(VIASR, SR44, (value & 0x0000FF));
+			via_write_reg(VIASR, SR45, (value & 0x00FF00) >> 8);
+			via_write_reg(VIASR, SR46, (value & 0xFF0000) >> 16);
 			break;
 		}
 	}
@@ -1547,8 +1551,8 @@ void viafb_set_vclock(u32 clk, int set_iga)
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_CLE266:
 		case UNICHROME_K400:
-			via_write_reg(VIASR, SR44, (clk & 0x00FF));
-			via_write_reg(VIASR, SR45, (clk & 0xFF00) >> 8);
+			via_write_reg(VIASR, SR44, (value & 0x00FF));
+			via_write_reg(VIASR, SR45, (value & 0xFF00) >> 8);
 			break;
 
 		case UNICHROME_K800:
@@ -1562,9 +1566,9 @@ void viafb_set_vclock(u32 clk, int set_iga)
 		case UNICHROME_VX800:
 		case UNICHROME_VX855:
 		case UNICHROME_VX900:
-			via_write_reg(VIASR, SR4A, (clk & 0x0000FF));
-			via_write_reg(VIASR, SR4B, (clk & 0x00FF00) >> 8);
-			via_write_reg(VIASR, SR4C, (clk & 0xFF0000) >> 16);
+			via_write_reg(VIASR, SR4A, (value & 0x0000FF));
+			via_write_reg(VIASR, SR4B, (value & 0x00FF00) >> 8);
+			via_write_reg(VIASR, SR4C, (value & 0xFF0000) >> 16);
 			break;
 		}
 	}
@@ -1827,7 +1831,7 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	int i;
 	int index = 0;
 	int h_addr, v_addr;
-	u32 pll_D_N, clock, refresh = viafb_refresh;
+	u32 clock, refresh = viafb_refresh;
 
 	if (viafb_SAMM_ON && set_iga == IGA2)
 		refresh = viafb_refresh1;
@@ -1884,9 +1888,7 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 
 	clock = crt_reg.hor_total * crt_reg.ver_total
 		* crt_table[index].refresh_rate;
-	pll_D_N = viafb_get_clk_value(clock);
-	DEBUG_MSG(KERN_INFO "PLL=%x", pll_D_N);
-	viafb_set_vclock(pll_D_N, set_iga);
+	viafb_set_vclock(clock, set_iga);
 
 }
 
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 63d8d37..2cdce9b 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -935,7 +935,6 @@ void viafb_lock_crt(void);
 void viafb_unlock_crt(void);
 void viafb_load_fetch_count_reg(int h_addr, int bpp_byte, int set_iga);
 void viafb_write_regx(struct io_reg RegTable[], int ItemNum);
-u32 viafb_get_clk_value(int clk);
 void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active);
 void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 					*p_gfx_dpa_setting);
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 64bc7e7..284e681 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -562,7 +562,7 @@ void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 	int set_vres = plvds_setting_info->v_active;
 	int panel_hres = plvds_setting_info->lcd_panel_hres;
 	int panel_vres = plvds_setting_info->lcd_panel_vres;
-	u32 pll_D_N, clock;
+	u32 clock;
 	struct display_timing mode_crt_reg, panel_crt_reg;
 	struct crt_mode_table *panel_crt_table = NULL;
 	struct VideoModeTable *vmode_tbl = viafb_get_mode(panel_hres,
@@ -613,10 +613,7 @@ void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 		viafb_load_FIFO_reg(set_iga, set_hres, set_vres);
 
 	fill_lcd_format();
-
-	pll_D_N = viafb_get_clk_value(clock);
-	DEBUG_MSG(KERN_INFO "PLL=0x%x", pll_D_N);
-	viafb_set_vclock(pll_D_N, set_iga);
+	viafb_set_vclock(clock, set_iga);
 	lcd_patch_skew(plvds_setting_info, plvds_chip_info);
 
 	/* If K8M800, enable LCD Prefetch Mode. */
-- 
1.6.3.2

