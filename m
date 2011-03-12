Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1CLVbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:31:34 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52928 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755823Ab1CLVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:31:11 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/E0MFUYCbESAXyK1vKR27mHrJGYtFD9jlilRE5rV
	6NNFRjtKMA4e78
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/4] viafb: remove duplicated clock storage
Date: Sat, 12 Mar 2011 21:46:25 +0000
Message-Id: <1299966386-3439-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1299966386-3439-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1299966386-3439-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocks can be easily recalculated by the timing and refresh value.
This brings us one step closer to removing VIAs modetable and use
generic ones and being easier extensible.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/dvi.c     |    4 +-
 drivers/video/via/hw.c      |    6 +-
 drivers/video/via/lcd.c     |    8 +-
 drivers/video/via/share.h   |   72 ------------
 drivers/video/via/viamode.c |  255 ++++++++++++++++++++----------------------
 5 files changed, 133 insertions(+), 212 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index 84e21b3..41ca198 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -195,7 +195,9 @@ void viafb_dvi_set_mode(struct VideoModeTable *mode, int mode_bpp,
 	struct crt_mode_table *pDviTiming;
 	unsigned long desirePixelClock, maxPixelClock;
 	pDviTiming = mode->crtc;
-	desirePixelClock = pDviTiming->clk / 1000000;
+	desirePixelClock = pDviTiming->refresh_rate
+		* pDviTiming->crtc.hor_total * pDviTiming->crtc.ver_total
+		/ 1000000;
 	maxPixelClock = (unsigned long)viaparinfo->
 		tmds_setting_info->max_pixel_clock;
 
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index a7a5614..071e3a9 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2030,7 +2030,7 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	int i;
 	int index = 0;
 	int h_addr, v_addr;
-	u32 pll_D_N;
+	u32 pll_D_N, clock;
 
 	for (i = 0; i < video_mode->mode_array; i++) {
 		index = i;
@@ -2083,7 +2083,9 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	    && (viaparinfo->chip_info->gfx_chip_name != UNICHROME_K400))
 		viafb_load_FIFO_reg(set_iga, h_addr, v_addr);
 
-	pll_D_N = viafb_get_clk_value(crt_table[index].clk);
+	clock = crt_reg.hor_total * crt_reg.ver_total
+		* crt_table[index].refresh_rate;
+	pll_D_N = viafb_get_clk_value(clock);
 	DEBUG_MSG(KERN_INFO "PLL=%x", pll_D_N);
 	viafb_set_vclock(pll_D_N, set_iga);
 
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 2ca3bb8..fc76b27 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -612,7 +612,7 @@ void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 	int set_vres = plvds_setting_info->v_active;
 	int panel_hres = plvds_setting_info->lcd_panel_hres;
 	int panel_vres = plvds_setting_info->lcd_panel_vres;
-	u32 pll_D_N;
+	u32 pll_D_N, clock;
 	struct display_timing mode_crt_reg, panel_crt_reg;
 	struct crt_mode_table *panel_crt_table = NULL;
 	struct VideoModeTable *vmode_tbl = viafb_get_mode(panel_hres,
@@ -627,7 +627,9 @@ void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 	DEBUG_MSG(KERN_INFO "bellow viafb_lcd_set_mode!!\n");
 	if (VT1636_LVDS == plvds_chip_info->lvds_chip_name)
 		viafb_init_lvds_vt1636(plvds_setting_info, plvds_chip_info);
-	plvds_setting_info->vclk = panel_crt_table->clk;
+	clock = panel_crt_reg.hor_total * panel_crt_reg.ver_total
+		* panel_crt_table->refresh_rate;
+	plvds_setting_info->vclk = clock;
 	if (set_iga == IGA1) {
 		/* IGA1 doesn't have LCD scaling, so set it as centering. */
 		viafb_load_crtc_timing(lcd_centering_timging
@@ -662,7 +664,7 @@ void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 
 	fill_lcd_format();
 
-	pll_D_N = viafb_get_clk_value(panel_crt_table[0].clk);
+	pll_D_N = viafb_get_clk_value(clock);
 	DEBUG_MSG(KERN_INFO "PLL=0x%x", pll_D_N);
 	viafb_set_vclock(pll_D_N, set_iga);
 	lcd_patch_skew(plvds_setting_info, plvds_chip_info);
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index b04c047..4b7831f 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -627,77 +627,6 @@
 #define M2048x1536_R60_HSP      NEGATIVE
 #define M2048x1536_R60_VSP      POSITIVE
 
-/* define PLL index: */
-#define CLK_25_175M     25175000
-#define CLK_26_880M     26880000
-#define CLK_29_581M     29581000
-#define CLK_31_500M     31500000
-#define CLK_31_728M     31728000
-#define CLK_32_668M     32688000
-#define CLK_36_000M     36000000
-#define CLK_40_000M     40000000
-#define CLK_41_291M     41291000
-#define CLK_43_163M     43163000
-#define CLK_45_250M     45250000	/* 45.46MHz */
-#define CLK_46_000M     46000000
-#define CLK_46_996M     46996000
-#define CLK_48_000M     48000000
-#define CLK_48_875M     48875000
-#define CLK_49_500M     49500000
-#define CLK_52_406M     52406000
-#define CLK_52_977M     52977000
-#define CLK_56_250M     56250000
-#define CLK_57_275M     57275000
-#define CLK_60_466M     60466000
-#define CLK_61_500M     61500000
-#define CLK_65_000M     65000000
-#define CLK_65_178M     65178000
-#define CLK_66_750M     66750000	/* 67.116MHz */
-#define CLK_68_179M     68179000
-#define CLK_69_924M     69924000
-#define CLK_70_159M     70159000
-#define CLK_72_000M     72000000
-#define CLK_74_270M     74270000
-#define CLK_78_750M     78750000
-#define CLK_80_136M     80136000
-#define CLK_83_375M     83375000
-#define CLK_83_950M     83950000
-#define CLK_84_750M     84750000	/* 84.537Mhz */
-#define CLK_85_860M     85860000
-#define CLK_88_750M     88750000
-#define CLK_94_500M     94500000
-#define CLK_97_750M     97750000
-#define CLK_101_000M    101000000
-#define CLK_106_500M    106500000
-#define CLK_108_000M    108000000
-#define CLK_113_309M    113309000
-#define CLK_118_840M    118840000
-#define CLK_119_000M    119000000
-#define CLK_121_750M    121750000	/* 121.704MHz */
-#define CLK_125_104M    125104000
-#define CLK_135_000M    135000000
-#define CLK_136_700M    136700000
-#define CLK_138_400M    138400000
-#define CLK_146_760M    146760000
-#define CLK_148_500M    148500000
-
-#define CLK_153_920M    153920000
-#define CLK_156_000M    156000000
-#define CLK_157_500M    157500000
-#define CLK_162_000M    162000000
-#define CLK_187_000M    187000000
-#define CLK_193_295M    193295000
-#define CLK_202_500M    202500000
-#define CLK_204_000M    204000000
-#define CLK_218_500M    218500000
-#define CLK_234_000M    234000000
-#define CLK_267_250M    267250000
-#define CLK_297_500M    297500000
-#define CLK_74_481M     74481000
-#define CLK_172_798M    172798000
-#define CLK_122_614M    122614000
-
-
 /* Definition CRTC Timing Index */
 #define H_TOTAL_INDEX               0
 #define H_ADDR_INDEX                1
@@ -753,7 +682,6 @@ struct display_timing {
 
 struct crt_mode_table {
 	int refresh_rate;
-	unsigned long clk;
 	int h_sync_polarity;
 	int v_sync_polarity;
 	struct display_timing crtc;
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index ea0bc7a..1f24ee9 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -378,327 +378,320 @@ struct VPITTable VPIT = {
 
 /* 480x640 */
 static struct crt_mode_table CRTM480x640[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_25_175M, M480X640_R60_HSP, M480X640_R60_VSP,
+	{REFRESH_60, M480X640_R60_HSP, M480X640_R60_VSP,
 	 {624, 480, 480, 144, 504, 48, 663, 640, 640, 23, 641, 3} }	/* GTF*/
 };
 
 /* 640x480*/
 static struct crt_mode_table CRTM640x480[] = {
-	/*r_rate,vclk,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_25_175M, M640X480_R60_HSP, M640X480_R60_VSP,
+	{REFRESH_60, M640X480_R60_HSP, M640X480_R60_VSP,
 	 {800, 640, 648, 144, 656, 96, 525, 480, 480, 45, 490, 2} },
-	{REFRESH_75, CLK_31_500M, M640X480_R75_HSP, M640X480_R75_VSP,
+	{REFRESH_75, M640X480_R75_HSP, M640X480_R75_VSP,
 	 {840, 640, 640, 200, 656, 64, 500, 480, 480, 20, 481, 3} },
-	{REFRESH_85, CLK_36_000M, M640X480_R85_HSP, M640X480_R85_VSP,
+	{REFRESH_85, M640X480_R85_HSP, M640X480_R85_VSP,
 	 {832, 640, 640, 192, 696, 56, 509, 480, 480, 29, 481, 3} },
-	{REFRESH_100, CLK_43_163M, M640X480_R100_HSP, M640X480_R100_VSP,
+	{REFRESH_100, M640X480_R100_HSP, M640X480_R100_VSP,
 	 {848, 640, 640, 208, 680, 64, 509, 480, 480, 29, 481, 3} }, /*GTF*/
-	    {REFRESH_120, CLK_52_406M, M640X480_R120_HSP,
-	     M640X480_R120_VSP,
-	     {848, 640, 640, 208, 680, 64, 515, 480, 480, 35, 481,
-	      3} } /*GTF*/
+	{REFRESH_120, M640X480_R120_HSP, M640X480_R120_VSP,
+	 {848, 640, 640, 208, 680, 64, 515, 480, 480, 35, 481, 3} } /*GTF*/
 };
 
 /*720x480 (GTF)*/
 static struct crt_mode_table CRTM720x480[] = {
-	/*r_rate,vclk,hsp,vsp      */
+	/*r_rate,hsp,vsp      */
 	/*HT, HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_26_880M, M720X480_R60_HSP, M720X480_R60_VSP,
+	{REFRESH_60, M720X480_R60_HSP, M720X480_R60_VSP,
 	 {896, 720, 720, 176, 736, 72, 497, 480, 480, 17, 481, 3} }
 
 };
 
 /*720x576 (GTF)*/
 static struct crt_mode_table CRTM720x576[] = {
-	/*r_rate,vclk,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_32_668M, M720X576_R60_HSP, M720X576_R60_VSP,
+	{REFRESH_60, M720X576_R60_HSP, M720X576_R60_VSP,
 	 {912, 720, 720, 192, 744, 72, 597, 576, 576, 21, 577, 3} }
 };
 
 /* 800x480 (CVT) */
 static struct crt_mode_table CRTM800x480[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_29_581M, M800X480_R60_HSP, M800X480_R60_VSP,
+	{REFRESH_60, M800X480_R60_HSP, M800X480_R60_VSP,
 	 {992, 800, 800, 192, 824, 72, 500, 480, 480, 20, 483, 7} }
 };
 
 /* 800x600*/
 static struct crt_mode_table CRTM800x600[] = {
-	/*r_rate,vclk,hsp,vsp     */
+	/*r_rate,hsp,vsp     */
 	/*HT,   HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_40_000M, M800X600_R60_HSP, M800X600_R60_VSP,
+	{REFRESH_60, M800X600_R60_HSP, M800X600_R60_VSP,
 	 {1056, 800, 800, 256, 840, 128, 628, 600, 600, 28, 601, 4} },
-	{REFRESH_75, CLK_49_500M, M800X600_R75_HSP, M800X600_R75_VSP,
+	{REFRESH_75, M800X600_R75_HSP, M800X600_R75_VSP,
 	 {1056, 800, 800, 256, 816, 80, 625, 600, 600, 25, 601, 3} },
-	{REFRESH_85, CLK_56_250M, M800X600_R85_HSP, M800X600_R85_VSP,
+	{REFRESH_85, M800X600_R85_HSP, M800X600_R85_VSP,
 	 {1048, 800, 800, 248, 832, 64, 631, 600, 600, 31, 601, 3} },
-	{REFRESH_100, CLK_68_179M, M800X600_R100_HSP, M800X600_R100_VSP,
+	{REFRESH_100, M800X600_R100_HSP, M800X600_R100_VSP,
 	 {1072, 800, 800, 272, 848, 88, 636, 600, 600, 36, 601, 3} },
-	{REFRESH_120, CLK_83_950M, M800X600_R120_HSP,
-		  M800X600_R120_VSP,
-		  {1088, 800, 800, 288, 856, 88, 643, 600, 600, 43, 601,
-		   3} }
+	{REFRESH_120, M800X600_R120_HSP, M800X600_R120_VSP,
+	 {1088, 800, 800, 288, 856, 88, 643, 600, 600, 43, 601, 3} }
 };
 
 /* 848x480 (CVT) */
 static struct crt_mode_table CRTM848x480[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_31_500M, M848X480_R60_HSP, M848X480_R60_VSP,
+	{REFRESH_60, M848X480_R60_HSP, M848X480_R60_VSP,
 	 {1056, 848, 848, 208, 872, 80, 500, 480, 480, 20, 483, 5} }
 };
 
 /*856x480 (GTF) convert to 852x480*/
 static struct crt_mode_table CRTM852x480[] = {
-	/*r_rate,vclk,hsp,vsp     */
+	/*r_rate,hsp,vsp     */
 	/*HT,   HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_31_728M, M852X480_R60_HSP, M852X480_R60_VSP,
+	{REFRESH_60, M852X480_R60_HSP, M852X480_R60_VSP,
 	{1064, 856, 856, 208, 872, 88, 497, 480, 480, 17, 481, 3} }
 };
 
 /*1024x512 (GTF)*/
 static struct crt_mode_table CRTM1024x512[] = {
-	/*r_rate,vclk,hsp,vsp     */
+	/*r_rate,hsp,vsp     */
 	/*HT,   HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_41_291M, M1024X512_R60_HSP, M1024X512_R60_VSP,
+	{REFRESH_60, M1024X512_R60_HSP, M1024X512_R60_VSP,
 	 {1296, 1024, 1024, 272, 1056, 104, 531, 512, 512, 19, 513, 3} }
 
 };
 
 /* 1024x600*/
 static struct crt_mode_table CRTM1024x600[] = {
-	/*r_rate,vclk,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_48_875M, M1024X600_R60_HSP, M1024X600_R60_VSP,
+	{REFRESH_60, M1024X600_R60_HSP, M1024X600_R60_VSP,
 	 {1312, 1024, 1024, 288, 1064, 104, 622, 600, 600, 22, 601, 3} },
 };
 
 /* 1024x768*/
 static struct crt_mode_table CRTM1024x768[] = {
-	/*r_rate,vclk,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_65_000M, M1024X768_R60_HSP, M1024X768_R60_VSP,
+	{REFRESH_60, M1024X768_R60_HSP, M1024X768_R60_VSP,
 	{1344, 1024, 1024, 320, 1048, 136, 806, 768, 768, 38, 771, 6} },
-	{REFRESH_75, CLK_78_750M, M1024X768_R75_HSP, M1024X768_R75_VSP,
+	{REFRESH_75, M1024X768_R75_HSP, M1024X768_R75_VSP,
 	{1312, 1024, 1024, 288, 1040, 96, 800, 768, 768, 32, 769, 3} },
-	{REFRESH_85, CLK_94_500M, M1024X768_R85_HSP, M1024X768_R85_VSP,
+	{REFRESH_85, M1024X768_R85_HSP, M1024X768_R85_VSP,
 	{1376, 1024, 1024, 352, 1072, 96, 808, 768, 768, 40, 769, 3} },
-	{REFRESH_100, CLK_113_309M, M1024X768_R100_HSP, M1024X768_R100_VSP,
+	{REFRESH_100, M1024X768_R100_HSP, M1024X768_R100_VSP,
 	{1392, 1024, 1024, 368, 1096, 112, 814, 768, 768, 46, 769, 3} }
 };
 
 /* 1152x864*/
 static struct crt_mode_table CRTM1152x864[] = {
-	/*r_rate,vclk,hsp,vsp      */
+	/*r_rate,hsp,vsp      */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_75, CLK_108_000M, M1152X864_R75_HSP, M1152X864_R75_VSP,
+	{REFRESH_75, M1152X864_R75_HSP, M1152X864_R75_VSP,
 	 {1600, 1152, 1152, 448, 1216, 128, 900, 864, 864, 36, 865, 3} }
 
 };
 
 /* 1280x720 (HDMI 720P)*/
 static struct crt_mode_table CRTM1280x720[] = {
-	/*r_rate,vclk,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE      */
-	{REFRESH_60, CLK_74_481M, M1280X720_R60_HSP, M1280X720_R60_VSP,
+	{REFRESH_60, M1280X720_R60_HSP, M1280X720_R60_VSP,
 	 {1648, 1280, 1280, 368, 1392, 40, 750, 720, 720, 30, 725, 5} },
-	{REFRESH_50, CLK_60_466M, M1280X720_R50_HSP, M1280X720_R50_VSP,
+	{REFRESH_50, M1280X720_R50_HSP, M1280X720_R50_VSP,
 	 {1632, 1280, 1280, 352, 1328, 128, 741, 720, 720, 21, 721, 3} }
 };
 
 /*1280x768 (GTF)*/
 static struct crt_mode_table CRTM1280x768[] = {
-	/*r_rate,vclk,hsp,vsp     */
+	/*r_rate,hsp,vsp     */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_80_136M, M1280X768_R60_HSP, M1280X768_R60_VSP,
+	{REFRESH_60, M1280X768_R60_HSP, M1280X768_R60_VSP,
 	 {1680, 1280, 1280, 400, 1344, 136, 795, 768, 768, 27, 769, 3} },
-	{REFRESH_50, CLK_65_178M, M1280X768_R50_HSP, M1280X768_R50_VSP,
+	{REFRESH_50, M1280X768_R50_HSP, M1280X768_R50_VSP,
 	 {1648, 1280, 1280, 368, 1336, 128, 791, 768, 768, 23, 769, 3} }
 };
 
 /* 1280x800 (CVT) */
 static struct crt_mode_table CRTM1280x800[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_83_375M, M1280X800_R60_HSP, M1280X800_R60_VSP,
+	{REFRESH_60, M1280X800_R60_HSP, M1280X800_R60_VSP,
 	 {1680, 1280, 1280, 400, 1352, 128, 831, 800, 800, 31, 803, 6} }
 };
 
 /*1280x960*/
 static struct crt_mode_table CRTM1280x960[] = {
-	/*r_rate,vclk,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_108_000M, M1280X960_R60_HSP, M1280X960_R60_VSP,
+	{REFRESH_60, M1280X960_R60_HSP, M1280X960_R60_VSP,
 	 {1800, 1280, 1280, 520, 1376, 112, 1000, 960, 960, 40, 961, 3} }
 };
 
 /* 1280x1024*/
 static struct crt_mode_table CRTM1280x1024[] = {
-	/*r_rate,vclk,,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_108_000M, M1280X1024_R60_HSP, M1280X1024_R60_VSP,
+	{REFRESH_60, M1280X1024_R60_HSP, M1280X1024_R60_VSP,
 	 {1688, 1280, 1280, 408, 1328, 112, 1066, 1024, 1024, 42, 1025,
 	  3} },
-	{REFRESH_75, CLK_135_000M, M1280X1024_R75_HSP, M1280X1024_R75_VSP,
+	{REFRESH_75, M1280X1024_R75_HSP, M1280X1024_R75_VSP,
 	 {1688, 1280, 1280, 408, 1296, 144, 1066, 1024, 1024, 42, 1025,
 	  3} },
-	{REFRESH_85, CLK_157_500M, M1280X1024_R85_HSP, M1280X1024_R85_VSP,
+	{REFRESH_85, M1280X1024_R85_HSP, M1280X1024_R85_VSP,
 	 {1728, 1280, 1280, 448, 1344, 160, 1072, 1024, 1024, 48, 1025, 3} }
 };
 
 /* 1368x768 (GTF) */
 static struct crt_mode_table CRTM1368x768[] = {
-	/* r_rate,  vclk, hsp, vsp */
+	/* r_rate,  hsp, vsp */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_85_860M, M1368X768_R60_HSP, M1368X768_R60_VSP,
+	{REFRESH_60, M1368X768_R60_HSP, M1368X768_R60_VSP,
 	 {1800, 1368, 1368, 432, 1440, 144, 795, 768, 768, 27, 769, 3} }
 };
 
 /*1440x1050 (GTF)*/
 static struct crt_mode_table CRTM1440x1050[] = {
-	/*r_rate,vclk,hsp,vsp      */
+	/*r_rate,hsp,vsp      */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_125_104M, M1440X1050_R60_HSP, M1440X1050_R60_VSP,
+	{REFRESH_60, M1440X1050_R60_HSP, M1440X1050_R60_VSP,
 	 {1936, 1440, 1440, 496, 1536, 152, 1077, 1040, 1040, 37, 1041, 3} }
 };
 
 /* 1600x1200*/
 static struct crt_mode_table CRTM1600x1200[] = {
-	/*r_rate,vclk,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_162_000M, M1600X1200_R60_HSP, M1600X1200_R60_VSP,
+	{REFRESH_60, M1600X1200_R60_HSP, M1600X1200_R60_VSP,
 	 {2160, 1600, 1600, 560, 1664, 192, 1250, 1200, 1200, 50, 1201,
 	  3} },
-	{REFRESH_75, CLK_202_500M, M1600X1200_R75_HSP, M1600X1200_R75_VSP,
+	{REFRESH_75, M1600X1200_R75_HSP, M1600X1200_R75_VSP,
 	 {2160, 1600, 1600, 560, 1664, 192, 1250, 1200, 1200, 50, 1201, 3} }
 
 };
 
 /* 1680x1050 (CVT) */
 static struct crt_mode_table CRTM1680x1050[] = {
-	/* r_rate,          vclk,              hsp,             vsp  */
+	/* r_rate,              hsp,             vsp  */
 	/* HT,  HA,  HBS, HBE, HSS, HSE,    VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, CLK_146_760M, M1680x1050_R60_HSP, M1680x1050_R60_VSP,
+	{REFRESH_60, M1680x1050_R60_HSP, M1680x1050_R60_VSP,
 	 {2240, 1680, 1680, 560, 1784, 176, 1089, 1050, 1050, 39, 1053,
 	  6} },
-	{REFRESH_75, CLK_187_000M, M1680x1050_R75_HSP, M1680x1050_R75_VSP,
+	{REFRESH_75, M1680x1050_R75_HSP, M1680x1050_R75_VSP,
 	 {2272, 1680, 1680, 592, 1800, 176, 1099, 1050, 1050, 49, 1053, 6} }
 };
 
 /* 1680x1050 (CVT Reduce Blanking) */
 static struct crt_mode_table CRTM1680x1050_RB[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE,    VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, CLK_119_000M, M1680x1050_RB_R60_HSP,
-	 M1680x1050_RB_R60_VSP,
+	{REFRESH_60, M1680x1050_RB_R60_HSP, M1680x1050_RB_R60_VSP,
 	 {1840, 1680, 1680, 160, 1728, 32, 1080, 1050, 1050, 30, 1053, 6} }
 };
 
 /* 1920x1080 (CVT)*/
 static struct crt_mode_table CRTM1920x1080[] = {
-	/*r_rate,vclk,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_172_798M, M1920X1080_R60_HSP, M1920X1080_R60_VSP,
+	{REFRESH_60, M1920X1080_R60_HSP, M1920X1080_R60_VSP,
 	 {2576, 1920, 1920, 656, 2048, 200, 1120, 1080, 1080, 40, 1083, 5} }
 };
 
 /* 1920x1080 (CVT with Reduce Blanking) */
 static struct crt_mode_table CRTM1920x1080_RB[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_138_400M, M1920X1080_RB_R60_HSP,
-	 M1920X1080_RB_R60_VSP,
+	{REFRESH_60, M1920X1080_RB_R60_HSP, M1920X1080_RB_R60_VSP,
 	 {2080, 1920, 1920, 160, 1968, 32, 1111, 1080, 1080, 31, 1083, 5} }
 };
 
 /* 1920x1440*/
 static struct crt_mode_table CRTM1920x1440[] = {
-	/*r_rate,vclk,hsp,vsp */
+	/*r_rate,hsp,vsp */
 	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_234_000M, M1920X1440_R60_HSP, M1920X1440_R60_VSP,
+	{REFRESH_60, M1920X1440_R60_HSP, M1920X1440_R60_VSP,
 	 {2600, 1920, 1920, 680, 2048, 208, 1500, 1440, 1440, 60, 1441,
 	  3} },
-	{REFRESH_75, CLK_297_500M, M1920X1440_R75_HSP, M1920X1440_R75_VSP,
+	{REFRESH_75, M1920X1440_R75_HSP, M1920X1440_R75_VSP,
 	 {2640, 1920, 1920, 720, 2064, 224, 1500, 1440, 1440, 60, 1441, 3} }
 };
 
 /* 1400x1050 (CVT) */
 static struct crt_mode_table CRTM1400x1050[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, CLK_121_750M, M1400X1050_R60_HSP, M1400X1050_R60_VSP,
+	{REFRESH_60, M1400X1050_R60_HSP, M1400X1050_R60_VSP,
 	 {1864, 1400, 1400, 464, 1488, 144, 1089, 1050, 1050, 39, 1053,
 	  4} },
-	{REFRESH_75, CLK_156_000M, M1400X1050_R75_HSP, M1400X1050_R75_VSP,
+	{REFRESH_75, M1400X1050_R75_HSP, M1400X1050_R75_VSP,
 	 {1896, 1400, 1400, 496, 1504, 144, 1099, 1050, 1050, 49, 1053, 4} }
 };
 
 /* 1400x1050 (CVT Reduce Blanking) */
 static struct crt_mode_table CRTM1400x1050_RB[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, CLK_101_000M, M1400X1050_RB_R60_HSP,
-	 M1400X1050_RB_R60_VSP,
+	{REFRESH_60, M1400X1050_RB_R60_HSP, M1400X1050_RB_R60_VSP,
 	 {1560, 1400, 1400, 160, 1448, 32, 1080, 1050, 1050, 30, 1053, 4} }
 };
 
 /* 960x600 (CVT) */
 static struct crt_mode_table CRTM960x600[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,          hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_45_250M, M960X600_R60_HSP, M960X600_R60_VSP,
+	{REFRESH_60, M960X600_R60_HSP, M960X600_R60_VSP,
 	 {1216, 960, 960, 256, 992, 96, 624, 600, 600, 24, 603, 6} }
 };
 
 /* 1000x600 (GTF) */
 static struct crt_mode_table CRTM1000x600[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_48_000M, M1000X600_R60_HSP, M1000X600_R60_VSP,
+	{REFRESH_60, M1000X600_R60_HSP, M1000X600_R60_VSP,
 	 {1288, 1000, 1000, 288, 1040, 104, 622, 600, 600, 22, 601, 3} }
 };
 
 /* 1024x576 (GTF) */
 static struct crt_mode_table CRTM1024x576[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_46_996M, M1024X576_R60_HSP, M1024X576_R60_VSP,
+	{REFRESH_60, M1024X576_R60_HSP, M1024X576_R60_VSP,
 	 {1312, 1024, 1024, 288, 1064, 104, 597, 576, 576, 21, 577, 3} }
 };
 
 /* 1088x612 (CVT) */
 static struct crt_mode_table CRTM1088x612[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_52_977M, M1088X612_R60_HSP, M1088X612_R60_VSP,
+	{REFRESH_60, M1088X612_R60_HSP, M1088X612_R60_VSP,
 	 {1392, 1088, 1088, 304, 1136, 104, 636, 612, 612, 24, 615, 5} }
 };
 
 /* 1152x720 (CVT) */
 static struct crt_mode_table CRTM1152x720[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_66_750M, M1152X720_R60_HSP, M1152X720_R60_VSP,
+	{REFRESH_60, M1152X720_R60_HSP, M1152X720_R60_VSP,
 	 {1488, 1152, 1152, 336, 1208, 112, 748, 720, 720, 28, 723, 6} }
 };
 
 /* 1200x720 (GTF) */
 static struct crt_mode_table CRTM1200x720[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_70_159M, M1200X720_R60_HSP, M1200X720_R60_VSP,
+	{REFRESH_60, M1200X720_R60_HSP, M1200X720_R60_VSP,
 	 {1568, 1200, 1200, 368, 1256, 128, 746, 720, 720, 26, 721, 3} }
 };
 
 /* 1200x900 (DCON) */
 static struct crt_mode_table DCON1200x900[] = {
-	/* r_rate,          vclk,               hsp,               vsp   */
-	{REFRESH_60, CLK_57_275M, M1200X900_R60_HSP, M1200X900_R60_VSP,
+	/* r_rate,               hsp,               vsp   */
+	{REFRESH_60, M1200X900_R60_HSP, M1200X900_R60_VSP,
 	/* The correct htotal is 1240, but this doesn't raster on VX855. */
 	/* Via suggested changing to a multiple of 16, hence 1264.       */
 	/*  HT,   HA,  HBS, HBE,  HSS, HSE,  VT,  VA, VBS, VBE, VSS, VSE */
@@ -707,121 +700,117 @@ static struct crt_mode_table DCON1200x900[] = {
 
 /* 1280x600 (GTF) */
 static struct crt_mode_table CRTM1280x600[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE,  HSS, HSE, VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, CLK_61_500M, M1280x600_R60_HSP, M1280x600_R60_VSP,
+	{REFRESH_60, M1280x600_R60_HSP, M1280x600_R60_VSP,
 	 {1648, 1280, 1280, 368, 1336, 128, 622, 600, 600, 22, 601, 3} }
 };
 
 /* 1360x768 (CVT) */
 static struct crt_mode_table CRTM1360x768[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_84_750M, M1360X768_R60_HSP, M1360X768_R60_VSP,
+	{REFRESH_60, M1360X768_R60_HSP, M1360X768_R60_VSP,
 	 {1776, 1360, 1360, 416, 1432, 136, 798, 768, 768, 30, 771, 5} }
 };
 
 /* 1360x768 (CVT Reduce Blanking) */
 static struct crt_mode_table CRTM1360x768_RB[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_72_000M, M1360X768_RB_R60_HSP,
-	 M1360X768_RB_R60_VSP,
+	{REFRESH_60, M1360X768_RB_R60_HSP, M1360X768_RB_R60_VSP,
 	 {1520, 1360, 1360, 160, 1408, 32, 790, 768, 768, 22, 771, 5} }
 };
 
 /* 1366x768 (GTF) */
 static struct crt_mode_table CRTM1366x768[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,          hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_85_860M, M1368X768_R60_HSP, M1368X768_R60_VSP,
+	{REFRESH_60, M1368X768_R60_HSP, M1368X768_R60_VSP,
 	 {1800, 1368, 1368, 432, 1440, 144, 795, 768, 768, 27, 769, 3} },
-	{REFRESH_50, CLK_69_924M, M1368X768_R50_HSP, M1368X768_R50_VSP,
+	{REFRESH_50, M1368X768_R50_HSP, M1368X768_R50_VSP,
 	 {1768, 1368, 1368, 400, 1424, 144, 791, 768, 768, 23, 769, 3} }
 };
 
 /* 1440x900 (CVT) */
 static struct crt_mode_table CRTM1440x900[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_106_500M, M1440X900_R60_HSP, M1440X900_R60_VSP,
+	{REFRESH_60, M1440X900_R60_HSP, M1440X900_R60_VSP,
 	 {1904, 1440, 1440, 464, 1520, 152, 934, 900, 900, 34, 903, 6} },
-	{REFRESH_75, CLK_136_700M, M1440X900_R75_HSP, M1440X900_R75_VSP,
+	{REFRESH_75, M1440X900_R75_HSP, M1440X900_R75_VSP,
 	 {1936, 1440, 1440, 496, 1536, 152, 942, 900, 900, 42, 903, 6} }
 };
 
 /* 1440x900 (CVT Reduce Blanking) */
 static struct crt_mode_table CRTM1440x900_RB[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_88_750M, M1440X900_RB_R60_HSP,
-	 M1440X900_RB_R60_VSP,
+	{REFRESH_60, M1440X900_RB_R60_HSP, M1440X900_RB_R60_VSP,
 	 {1600, 1440, 1440, 160, 1488, 32, 926, 900, 900, 26, 903, 6} }
 };
 
 /* 1600x900 (CVT) */
 static struct crt_mode_table CRTM1600x900[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,          hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_118_840M, M1600X900_R60_HSP, M1600X900_R60_VSP,
+	{REFRESH_60, M1600X900_R60_HSP, M1600X900_R60_VSP,
 	 {2112, 1600, 1600, 512, 1688, 168, 934, 900, 900, 34, 903, 5} }
 };
 
 /* 1600x900 (CVT Reduce Blanking) */
 static struct crt_mode_table CRTM1600x900_RB[] = {
-	/* r_rate,        vclk,           hsp,        vsp   */
+	/* r_rate,           hsp,        vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_97_750M, M1600X900_RB_R60_HSP,
-	 M1600X900_RB_R60_VSP,
+	{REFRESH_60, M1600X900_RB_R60_HSP, M1600X900_RB_R60_VSP,
 	 {1760, 1600, 1600, 160, 1648, 32, 926, 900, 900, 26, 903, 5} }
 };
 
 /* 1600x1024 (GTF) */
 static struct crt_mode_table CRTM1600x1024[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,          hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, CLK_136_700M, M1600X1024_R60_HSP, M1600X1024_R60_VSP,
+	{REFRESH_60, M1600X1024_R60_HSP, M1600X1024_R60_VSP,
 	 {2144, 1600, 1600, 544, 1704, 168, 1060, 1024, 1024, 36, 1025, 3} }
 };
 
 /* 1792x1344 (DMT) */
 static struct crt_mode_table CRTM1792x1344[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, CLK_204_000M, M1792x1344_R60_HSP, M1792x1344_R60_VSP,
+	{REFRESH_60, M1792x1344_R60_HSP, M1792x1344_R60_VSP,
 	 {2448, 1792, 1792, 656, 1920, 200, 1394, 1344, 1344, 50, 1345, 3} }
 };
 
 /* 1856x1392 (DMT) */
 static struct crt_mode_table CRTM1856x1392[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, CLK_218_500M, M1856x1392_R60_HSP, M1856x1392_R60_VSP,
+	{REFRESH_60, M1856x1392_R60_HSP, M1856x1392_R60_VSP,
 	 {2528, 1856, 1856, 672, 1952, 224, 1439, 1392, 1392, 47, 1393, 3} }
 };
 
 /* 1920x1200 (CVT) */
 static struct crt_mode_table CRTM1920x1200[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_193_295M, M1920X1200_R60_HSP, M1920X1200_R60_VSP,
+	{REFRESH_60, M1920X1200_R60_HSP, M1920X1200_R60_VSP,
 	 {2592, 1920, 1920, 672, 2056, 200, 1245, 1200, 1200, 45, 1203, 6} }
 };
 
 /* 1920x1200 (CVT with Reduce Blanking) */
 static struct crt_mode_table CRTM1920x1200_RB[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, CLK_153_920M, M1920X1200_RB_R60_HSP,
-	 M1920X1200_RB_R60_VSP,
+	{REFRESH_60, M1920X1200_RB_R60_HSP, M1920X1200_RB_R60_VSP,
 	 {2080, 1920, 1920, 160, 1968, 32, 1235, 1200, 1200, 35, 1203, 6} }
 };
 
 /* 2048x1536 (CVT) */
 static struct crt_mode_table CRTM2048x1536[] = {
-	/* r_rate,          vclk,              hsp,             vsp   */
+	/* r_rate,              hsp,             vsp   */
 	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, CLK_267_250M, M2048x1536_R60_HSP, M2048x1536_R60_VSP,
+	{REFRESH_60, M2048x1536_R60_HSP, M2048x1536_R60_VSP,
 	 {2800, 2048, 2048, 752, 2200, 224, 1592, 1536, 1536, 56, 1539, 4} }
 };
 
@@ -974,14 +963,12 @@ static struct VideoModeTable viafb_rb_modes[] = {
 };
 
 struct crt_mode_table CEAM1280x720[] = {
-	{REFRESH_60, CLK_74_270M, M1280X720_CEA_R60_HSP,
-	 M1280X720_CEA_R60_VSP,
+	{REFRESH_60, M1280X720_CEA_R60_HSP, M1280X720_CEA_R60_VSP,
 	 /* HT,    HA,   HBS,  HBE,  HSS, HSE,  VT,   VA,  VBS, VBE, VSS, VSE */
 	 {1650, 1280, 1280, 370, 1390, 40, 750, 720, 720, 30, 725, 5} }
 };
 struct crt_mode_table CEAM1920x1080[] = {
-	{REFRESH_60, CLK_148_500M, M1920X1080_CEA_R60_HSP,
-	 M1920X1080_CEA_R60_VSP,
+	{REFRESH_60, M1920X1080_CEA_R60_HSP, M1920X1080_CEA_R60_VSP,
 	 /* HT,    HA,   HBS,  HBE,  HSS, HSE,  VT,  VA, VBS, VBE,  VSS, VSE */
 	 {2200, 1920, 1920, 300, 2008, 44, 1125, 1080, 1080, 45, 1084, 5} }
 };
-- 
1.6.3.2

