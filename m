Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462Ab0GWP3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:29:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:59752 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760728Ab0GWP3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:44 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18mC784/VAmS2W7iN8XZfGXgjgTyUcfBXFEORroRp
	txKNU+8yY4yYIm
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 07/11] viafb: PLL value cleanup
Date: Fri, 23 Jul 2010 15:39:22 +0000
Message-Id: <1279899566-4359-8-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: PLL value cleanup

This is a big change of how PLL values are handled on the road to
dynamic PLL value generation. The table was converted automatically in
the relevant parameters for frequency generation. Sadly there were some
bits set whose meaning is unknown. Those differences are documented
but ignored as the unichrome code implies that they are not important
(a big thanks to Luc for his amazing work).
The PLL values for 31490000 and 133308000 are deleted as they were more
than 5% off and not used anyway. The values for CX700@60466000 and
VX855@153920000 are corrected as they were wrong and easily correctable
as enough correct values was available because CX700 and VX855 support
the same values only with a little difference in hardware format.
All remaining values are not more than 2% off.
Additionally the surrounding code is changed as needed especially the
byte order of the values written to hardware to allow nicer conversion
functions.
This is mostly a change preparing for dynamic PLL generation and the two
corrected values aside no runtime change is expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/hw.c    |  578 +++++++++++++++++++++++++++++++--------------
 drivers/video/via/hw.h    |   14 +-
 drivers/video/via/share.h |  309 ------------------------
 3 files changed, 412 insertions(+), 489 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 05be8c1..7dcb4d5 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -23,143 +23,341 @@
 #include "global.h"
 
 static struct pll_map pll_value[] = {
-	{CLK_25_175M, CLE266_PLL_25_175M, K800_PLL_25_175M,
-	 CX700_25_175M, VX855_25_175M},
-	{CLK_29_581M, CLE266_PLL_29_581M, K800_PLL_29_581M,
-	 CX700_29_581M, VX855_29_581M},
-	{CLK_26_880M, CLE266_PLL_26_880M, K800_PLL_26_880M,
-	 CX700_26_880M, VX855_26_880M},
-	{CLK_31_490M, CLE266_PLL_31_490M, K800_PLL_31_490M,
-	 CX700_31_490M, VX855_31_490M},
-	{CLK_31_500M, CLE266_PLL_31_500M, K800_PLL_31_500M,
-	 CX700_31_500M, VX855_31_500M},
-	{CLK_31_728M, CLE266_PLL_31_728M, K800_PLL_31_728M,
-	 CX700_31_728M, VX855_31_728M},
-	{CLK_32_668M, CLE266_PLL_32_668M, K800_PLL_32_668M,
-	 CX700_32_668M, VX855_32_668M},
-	{CLK_36_000M, CLE266_PLL_36_000M, K800_PLL_36_000M,
-	 CX700_36_000M, VX855_36_000M},
-	{CLK_40_000M, CLE266_PLL_40_000M, K800_PLL_40_000M,
-	 CX700_40_000M, VX855_40_000M},
-	{CLK_41_291M, CLE266_PLL_41_291M, K800_PLL_41_291M,
-	 CX700_41_291M, VX855_41_291M},
-	{CLK_43_163M, CLE266_PLL_43_163M, K800_PLL_43_163M,
-	 CX700_43_163M, VX855_43_163M},
-	{CLK_45_250M, CLE266_PLL_45_250M, K800_PLL_45_250M,
-	 CX700_45_250M, VX855_45_250M},
-	{CLK_46_000M, CLE266_PLL_46_000M, K800_PLL_46_000M,
-	 CX700_46_000M, VX855_46_000M},
-	{CLK_46_996M, CLE266_PLL_46_996M, K800_PLL_46_996M,
-	 CX700_46_996M, VX855_46_996M},
-	{CLK_48_000M, CLE266_PLL_48_000M, K800_PLL_48_000M,
-	 CX700_48_000M, VX855_48_000M},
-	{CLK_48_875M, CLE266_PLL_48_875M, K800_PLL_48_875M,
-	 CX700_48_875M, VX855_48_875M},
-	{CLK_49_500M, CLE266_PLL_49_500M, K800_PLL_49_500M,
-	 CX700_49_500M, VX855_49_500M},
-	{CLK_52_406M, CLE266_PLL_52_406M, K800_PLL_52_406M,
-	 CX700_52_406M, VX855_52_406M},
-	{CLK_52_977M, CLE266_PLL_52_977M, K800_PLL_52_977M,
-	 CX700_52_977M,	VX855_52_977M},
-	{CLK_56_250M, CLE266_PLL_56_250M, K800_PLL_56_250M,
-	 CX700_56_250M, VX855_56_250M},
-	{CLK_57_275M, 0, 0, 0, VX855_57_275M},
-	{CLK_60_466M, CLE266_PLL_60_466M, K800_PLL_60_466M,
-	 CX700_60_466M, VX855_60_466M},
-	{CLK_61_500M, CLE266_PLL_61_500M, K800_PLL_61_500M,
-	 CX700_61_500M, VX855_61_500M},
-	{CLK_65_000M, CLE266_PLL_65_000M, K800_PLL_65_000M,
-	 CX700_65_000M, VX855_65_000M},
-	{CLK_65_178M, CLE266_PLL_65_178M, K800_PLL_65_178M,
-	 CX700_65_178M, VX855_65_178M},
-	{CLK_66_750M, CLE266_PLL_66_750M, K800_PLL_66_750M,
-	 CX700_66_750M, VX855_66_750M},
-	{CLK_68_179M, CLE266_PLL_68_179M, K800_PLL_68_179M,
-	 CX700_68_179M, VX855_68_179M},
-	{CLK_69_924M, CLE266_PLL_69_924M, K800_PLL_69_924M,
-	 CX700_69_924M, VX855_69_924M},
-	{CLK_70_159M, CLE266_PLL_70_159M, K800_PLL_70_159M,
-	 CX700_70_159M, VX855_70_159M},
-	{CLK_72_000M, CLE266_PLL_72_000M, K800_PLL_72_000M,
-	 CX700_72_000M, VX855_72_000M},
-	{CLK_78_750M, CLE266_PLL_78_750M, K800_PLL_78_750M,
-	 CX700_78_750M, VX855_78_750M},
-	{CLK_80_136M, CLE266_PLL_80_136M, K800_PLL_80_136M,
-	 CX700_80_136M, VX855_80_136M},
-	{CLK_83_375M, CLE266_PLL_83_375M, K800_PLL_83_375M,
-	 CX700_83_375M, VX855_83_375M},
-	{CLK_83_950M, CLE266_PLL_83_950M, K800_PLL_83_950M,
-	 CX700_83_950M, VX855_83_950M},
-	{CLK_84_750M, CLE266_PLL_84_750M, K800_PLL_84_750M,
-	 CX700_84_750M, VX855_84_750M},
-	{CLK_85_860M, CLE266_PLL_85_860M, K800_PLL_85_860M,
-	 CX700_85_860M, VX855_85_860M},
-	{CLK_88_750M, CLE266_PLL_88_750M, K800_PLL_88_750M,
-	 CX700_88_750M, VX855_88_750M},
-	{CLK_94_500M, CLE266_PLL_94_500M, K800_PLL_94_500M,
-	 CX700_94_500M, VX855_94_500M},
-	{CLK_97_750M, CLE266_PLL_97_750M, K800_PLL_97_750M,
-	 CX700_97_750M, VX855_97_750M},
-	{CLK_101_000M, CLE266_PLL_101_000M, K800_PLL_101_000M,
-	 CX700_101_000M, VX855_101_000M},
-	{CLK_106_500M, CLE266_PLL_106_500M, K800_PLL_106_500M,
-	 CX700_106_500M, VX855_106_500M},
-	{CLK_108_000M, CLE266_PLL_108_000M, K800_PLL_108_000M,
-	 CX700_108_000M, VX855_108_000M},
-	{CLK_113_309M, CLE266_PLL_113_309M, K800_PLL_113_309M,
-	 CX700_113_309M, VX855_113_309M},
-	{CLK_118_840M, CLE266_PLL_118_840M, K800_PLL_118_840M,
-	 CX700_118_840M, VX855_118_840M},
-	{CLK_119_000M, CLE266_PLL_119_000M, K800_PLL_119_000M,
-	 CX700_119_000M, VX855_119_000M},
-	{CLK_121_750M, CLE266_PLL_121_750M, K800_PLL_121_750M,
-	 CX700_121_750M, 0},
-	{CLK_125_104M, CLE266_PLL_125_104M, K800_PLL_125_104M,
-	 CX700_125_104M, 0},
-	{CLK_133_308M, CLE266_PLL_133_308M, K800_PLL_133_308M,
-	 CX700_133_308M, 0},
-	{CLK_135_000M, CLE266_PLL_135_000M, K800_PLL_135_000M,
-	 CX700_135_000M, VX855_135_000M},
-	{CLK_136_700M, CLE266_PLL_136_700M, K800_PLL_136_700M,
-	 CX700_136_700M, VX855_136_700M},
-	{CLK_138_400M, CLE266_PLL_138_400M, K800_PLL_138_400M,
-	 CX700_138_400M, VX855_138_400M},
-	{CLK_146_760M, CLE266_PLL_146_760M, K800_PLL_146_760M,
-	 CX700_146_760M, VX855_146_760M},
-	{CLK_153_920M, CLE266_PLL_153_920M, K800_PLL_153_920M,
-	 CX700_153_920M, VX855_153_920M},
-	{CLK_156_000M, CLE266_PLL_156_000M, K800_PLL_156_000M,
-	 CX700_156_000M, VX855_156_000M},
-	{CLK_157_500M, CLE266_PLL_157_500M, K800_PLL_157_500M,
-	 CX700_157_500M, VX855_157_500M},
-	{CLK_162_000M, CLE266_PLL_162_000M, K800_PLL_162_000M,
-	 CX700_162_000M, VX855_162_000M},
-	{CLK_187_000M, CLE266_PLL_187_000M, K800_PLL_187_000M,
-	 CX700_187_000M, VX855_187_000M},
-	{CLK_193_295M, CLE266_PLL_193_295M, K800_PLL_193_295M,
-	 CX700_193_295M, VX855_193_295M},
-	{CLK_202_500M, CLE266_PLL_202_500M, K800_PLL_202_500M,
-	 CX700_202_500M, VX855_202_500M},
-	{CLK_204_000M, CLE266_PLL_204_000M, K800_PLL_204_000M,
-	 CX700_204_000M, VX855_204_000M},
-	{CLK_218_500M, CLE266_PLL_218_500M, K800_PLL_218_500M,
-	 CX700_218_500M, VX855_218_500M},
-	{CLK_234_000M, CLE266_PLL_234_000M, K800_PLL_234_000M,
-	 CX700_234_000M, VX855_234_000M},
-	{CLK_267_250M, CLE266_PLL_267_250M, K800_PLL_267_250M,
-	 CX700_267_250M, VX855_267_250M},
-	{CLK_297_500M, CLE266_PLL_297_500M, K800_PLL_297_500M,
-	 CX700_297_500M, VX855_297_500M},
-	{CLK_74_481M, CLE266_PLL_74_481M, K800_PLL_74_481M,
-	 CX700_74_481M, VX855_74_481M},
-	{CLK_172_798M, CLE266_PLL_172_798M, K800_PLL_172_798M,
-	 CX700_172_798M, VX855_172_798M},
-	{CLK_122_614M, CLE266_PLL_122_614M, K800_PLL_122_614M,
-	 CX700_122_614M, VX855_122_614M},
-	{CLK_74_270M, CLE266_PLL_74_270M, K800_PLL_74_270M,
-	 CX700_74_270M, 0},
-	{CLK_148_500M, CLE266_PLL_148_500M, K800_PLL_148_500M,
-	 CX700_148_500M, VX855_148_500M}
+	{25175000,
+		{99, 7, 3},
+		{85, 3, 4},	/* ignoring bit difference: 0x00008000 */
+		{141, 5, 4},
+		{141, 5, 4} },
+	{29581000,
+		{33, 4, 2},
+		{66, 2, 4},	/* ignoring bit difference: 0x00808000 */
+		{166, 5, 4},	/* ignoring bit difference: 0x00008000 */
+		{165, 5, 4} },
+	{26880000,
+		{15, 4, 1},
+		{30, 2, 3},	/* ignoring bit difference: 0x00808000 */
+		{150, 5, 4},
+		{150, 5, 4} },
+	{31500000,
+		{53, 3, 3},	/* ignoring bit difference: 0x00008000 */
+		{141, 4, 4},	/* ignoring bit difference: 0x00008000 */
+		{176, 5, 4},
+		{176, 5, 4} },
+	{31728000,
+		{31, 7, 1},
+		{177, 5, 4},	/* ignoring bit difference: 0x00008000 */
+		{177, 5, 4},
+		{142, 4, 4} },
+	{32688000,
+		{73, 4, 3},
+		{146, 4, 4},	/* ignoring bit difference: 0x00008000 */
+		{183, 5, 4},
+		{146, 4, 4} },
+	{36000000,
+		{101, 5, 3},	/* ignoring bit difference: 0x00008000 */
+		{161, 4, 4},	/* ignoring bit difference: 0x00008000 */
+		{202, 5, 4},
+		{161, 4, 4} },
+	{40000000,
+		{89, 4, 3},
+		{89, 4, 3},	/* ignoring bit difference: 0x00008000 */
+		{112, 5, 3},
+		{112, 5, 3} },
+	{41291000,
+		{23, 4, 1},
+		{69, 3, 3},	/* ignoring bit difference: 0x00008000 */
+		{115, 5, 3},
+		{115, 5, 3} },
+	{43163000,
+		{121, 5, 3},
+		{121, 5, 3},	/* ignoring bit difference: 0x00008000 */
+		{121, 5, 3},
+		{121, 5, 3} },
+	{45250000,
+		{127, 5, 3},
+		{127, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{127, 5, 3},
+		{127, 5, 3} },
+	{46000000,
+		{90, 7, 2},
+		{103, 4, 3},	/* ignoring bit difference: 0x00008000 */
+		{129, 5, 3},
+		{103, 4, 3} },
+	{46996000,
+		{105, 4, 3},	/* ignoring bit difference: 0x00008000 */
+		{131, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{131, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{105, 4, 3} },
+	{48000000,
+		{67, 20, 0},
+		{134, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{134, 5, 3},
+		{134, 5, 3} },
+	{48875000,
+		{99, 29, 0},
+		{82, 3, 3},	/* ignoring bit difference: 0x00808000 */
+		{82, 3, 3},	/* ignoring bit difference: 0x00808000 */
+		{137, 5, 3} },
+	{49500000,
+		{83, 6, 2},
+		{83, 3, 3},	/* ignoring bit difference: 0x00008000 */
+		{138, 5, 3},
+		{83, 3, 3} },
+	{52406000,
+		{117, 4, 3},
+		{117, 4, 3},	/* ignoring bit difference: 0x00008000 */
+		{117, 4, 3},
+		{88, 3, 3} },
+	{52977000,
+		{37, 5, 1},
+		{148, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{148, 5, 3},
+		{148, 5, 3} },
+	{56250000,
+		{55, 7, 1},	/* ignoring bit difference: 0x00008000 */
+		{126, 4, 3},	/* ignoring bit difference: 0x00008000 */
+		{157, 5, 3},
+		{157, 5, 3} },
+	{57275000,
+		{0, 0, 0},
+		{2, 2, 0},
+		{2, 2, 0},
+		{157, 5, 3} },	/* ignoring bit difference: 0x00808000 */
+	{60466000,
+		{76, 9, 1},
+		{169, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{169, 5, 3},	/* FIXED: old = {72, 2, 3} */
+		{169, 5, 3} },
+	{61500000,
+		{86, 20, 0},
+		{172, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{172, 5, 3},
+		{172, 5, 3} },
+	{65000000,
+		{109, 6, 2},	/* ignoring bit difference: 0x00008000 */
+		{109, 3, 3},	/* ignoring bit difference: 0x00008000 */
+		{109, 3, 3},
+		{109, 3, 3} },
+	{65178000,
+		{91, 5, 2},
+		{182, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{109, 3, 3},
+		{182, 5, 3} },
+	{66750000,
+		{75, 4, 2},
+		{150, 4, 3},	/* ignoring bit difference: 0x00808000 */
+		{150, 4, 3},
+		{112, 3, 3} },
+	{68179000,
+		{19, 4, 0},
+		{114, 3, 3},	/* ignoring bit difference: 0x00008000 */
+		{190, 5, 3},
+		{191, 5, 3} },
+	{69924000,
+		{83, 17, 0},
+		{195, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{195, 5, 3},
+		{195, 5, 3} },
+	{70159000,
+		{98, 20, 0},
+		{196, 5, 3},	/* ignoring bit difference: 0x00808000 */
+		{196, 5, 3},
+		{195, 5, 3} },
+	{72000000,
+		{121, 24, 0},
+		{161, 4, 3},	/* ignoring bit difference: 0x00808000 */
+		{161, 4, 3},
+		{161, 4, 3} },
+	{78750000,
+		{33, 3, 1},
+		{66, 3, 2},	/* ignoring bit difference: 0x00008000 */
+		{110, 5, 2},
+		{110, 5, 2} },
+	{80136000,
+		{28, 5, 0},
+		{68, 3, 2},	/* ignoring bit difference: 0x00008000 */
+		{112, 5, 2},
+		{112, 5, 2} },
+	{83375000,
+		{93, 2, 3},
+		{93, 4, 2},	/* ignoring bit difference: 0x00800000 */
+		{93, 4, 2},	/* ignoring bit difference: 0x00800000 */
+		{117, 5, 2} },
+	{83950000,
+		{41, 7, 0},
+		{117, 5, 2},	/* ignoring bit difference: 0x00008000 */
+		{117, 5, 2},
+		{117, 5, 2} },
+	{84750000,
+		{118, 5, 2},
+		{118, 5, 2},	/* ignoring bit difference: 0x00808000 */
+		{118, 5, 2},
+		{118, 5, 2} },
+	{85860000,
+		{84, 7, 1},
+		{120, 5, 2},	/* ignoring bit difference: 0x00808000 */
+		{120, 5, 2},
+		{118, 5, 2} },
+	{88750000,
+		{31, 5, 0},
+		{124, 5, 2},	/* ignoring bit difference: 0x00808000 */
+		{174, 7, 2},	/* ignoring bit difference: 0x00808000 */
+		{124, 5, 2} },
+	{94500000,
+		{33, 5, 0},
+		{132, 5, 2},	/* ignoring bit difference: 0x00008000 */
+		{132, 5, 2},
+		{132, 5, 2} },
+	{97750000,
+		{82, 6, 1},
+		{137, 5, 2},	/* ignoring bit difference: 0x00808000 */
+		{137, 5, 2},
+		{137, 5, 2} },
+	{101000000,
+		{127, 9, 1},
+		{141, 5, 2},	/* ignoring bit difference: 0x00808000 */
+		{141, 5, 2},
+		{141, 5, 2} },
+	{106500000,
+		{119, 4, 2},
+		{119, 4, 2},	/* ignoring bit difference: 0x00808000 */
+		{119, 4, 2},
+		{149, 5, 2} },
+	{108000000,
+		{121, 4, 2},
+		{121, 4, 2},	/* ignoring bit difference: 0x00808000 */
+		{151, 5, 2},
+		{151, 5, 2} },
+	{113309000,
+		{95, 12, 0},
+		{95, 3, 2},	/* ignoring bit difference: 0x00808000 */
+		{95, 3, 2},
+		{159, 5, 2} },
+	{118840000,
+		{83, 5, 1},
+		{166, 5, 2},	/* ignoring bit difference: 0x00808000 */
+		{166, 5, 2},
+		{166, 5, 2} },
+	{119000000,
+		{108, 13, 0},
+		{133, 4, 2},	/* ignoring bit difference: 0x00808000 */
+		{133, 4, 2},
+		{167, 5, 2} },
+	{121750000,
+		{85, 5, 1},
+		{170, 5, 2},	/* ignoring bit difference: 0x00808000 */
+		{68, 2, 2},
+		{0, 0, 0} },
+	{125104000,
+		{53, 6, 0},	/* ignoring bit difference: 0x00008000 */
+		{106, 3, 2},	/* ignoring bit difference: 0x00008000 */
+		{175, 5, 2},
+		{0, 0, 0} },
+	{135000000,
+		{94, 5, 1},
+		{28, 3, 0},	/* ignoring bit difference: 0x00804000 */
+		{151, 4, 2},
+		{189, 5, 2} },
+	{136700000,
+		{115, 12, 0},
+		{191, 5, 2},	/* ignoring bit difference: 0x00808000 */
+		{191, 5, 2},
+		{191, 5, 2} },
+	{138400000,
+		{87, 9, 0},
+		{116, 3, 2},	/* ignoring bit difference: 0x00808000 */
+		{116, 3, 2},
+		{194, 5, 2} },
+	{146760000,
+		{103, 5, 1},
+		{206, 5, 2},	/* ignoring bit difference: 0x00808000 */
+		{206, 5, 2},
+		{206, 5, 2} },
+	{153920000,
+		{86, 8, 0},
+		{86, 4, 1},	/* ignoring bit difference: 0x00808000 */
+		{86, 4, 1},
+		{86, 4, 1} },	/* FIXED: old = {84, 2, 1} */
+	{156000000,
+		{109, 5, 1},
+		{109, 5, 1},	/* ignoring bit difference: 0x00808000 */
+		{109, 5, 1},
+		{108, 5, 1} },
+	{157500000,
+		{55, 5, 0},	/* ignoring bit difference: 0x00008000 */
+		{22, 2, 0},	/* ignoring bit difference: 0x00802000 */
+		{110, 5, 1},
+		{110, 5, 1} },
+	{162000000,
+		{113, 5, 1},
+		{113, 5, 1},	/* ignoring bit difference: 0x00808000 */
+		{113, 5, 1},
+		{113, 5, 1} },
+	{187000000,
+		{118, 9, 0},
+		{131, 5, 1},	/* ignoring bit difference: 0x00808000 */
+		{131, 5, 1},
+		{131, 5, 1} },
+	{193295000,
+		{108, 8, 0},
+		{81, 3, 1},	/* ignoring bit difference: 0x00808000 */
+		{135, 5, 1},
+		{135, 5, 1} },
+	{202500000,
+		{99, 7, 0},
+		{85, 3, 1},	/* ignoring bit difference: 0x00808000 */
+		{142, 5, 1},
+		{142, 5, 1} },
+	{204000000,
+		{100, 7, 0},
+		{143, 5, 1},	/* ignoring bit difference: 0x00808000 */
+		{143, 5, 1},
+		{143, 5, 1} },
+	{218500000,
+		{92, 6, 0},
+		{153, 5, 1},	/* ignoring bit difference: 0x00808000 */
+		{153, 5, 1},
+		{153, 5, 1} },
+	{234000000,
+		{98, 6, 0},
+		{98, 3, 1},	/* ignoring bit difference: 0x00008000 */
+		{98, 3, 1},
+		{164, 5, 1} },
+	{267250000,
+		{112, 6, 0},
+		{112, 3, 1},	/* ignoring bit difference: 0x00808000 */
+		{187, 5, 1},
+		{187, 5, 1} },
+	{297500000,
+		{102, 5, 0},	/* ignoring bit difference: 0x00008000 */
+		{166, 4, 1},	/* ignoring bit difference: 0x00008000 */
+		{208, 5, 1},
+		{208, 5, 1} },
+	{74481000,
+		{26, 5, 0},
+		{125, 3, 3},	/* ignoring bit difference: 0x00808000 */
+		{208, 5, 3},
+		{209, 5, 3} },
+	{172798000,
+		{121, 5, 1},
+		{121, 5, 1},	/* ignoring bit difference: 0x00808000 */
+		{121, 5, 1},
+		{121, 5, 1} },
+	{122614000,
+		{60, 7, 0},
+		{137, 4, 2},	/* ignoring bit difference: 0x00808000 */
+		{137, 4, 2},
+		{172, 5, 2} },
+	{74270000,
+		{83, 8, 1},
+		{208, 5, 3},
+		{208, 5, 3},
+		{0, 0, 0} },
+	{148500000,
+		{83, 8, 0},
+		{208, 5, 2},
+		{166, 4, 2},
+		{208, 5, 2} }
 };
 
 static struct fifo_depth_select display_fifo_depth_reg = {
@@ -1360,40 +1558,70 @@ void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active)
 
 }
 
+static u32 cle266_encode_pll(struct pll_config pll)
+{
+	return (pll.multiplier << 8)
+		| (pll.rshift << 6)
+		| pll.divisor;
+}
+
+static u32 k800_encode_pll(struct pll_config pll)
+{
+	return ((pll.divisor - 2) << 16)
+		| (pll.rshift << 10)
+		| (pll.multiplier - 2);
+}
+
+static u32 vx855_encode_pll(struct pll_config pll)
+{
+	return (pll.divisor << 16)
+		| (pll.rshift << 10)
+		| pll.multiplier;
+}
+
 u32 viafb_get_clk_value(int clk)
 {
-	int i;
+	u32 value = 0;
+	int i = 0;
 
-	for (i = 0; i < NUM_TOTAL_PLL_TABLE; i++) {
-		if (clk == pll_value[i].clk) {
-			switch (viaparinfo->chip_info->gfx_chip_name) {
-			case UNICHROME_CLE266:
-			case UNICHROME_K400:
-				return pll_value[i].cle266_pll;
-
-			case UNICHROME_K800:
-			case UNICHROME_PM800:
-			case UNICHROME_CN700:
-				return pll_value[i].k800_pll;
-
-			case UNICHROME_CX700:
-			case UNICHROME_K8M890:
-			case UNICHROME_P4M890:
-			case UNICHROME_P4M900:
-			case UNICHROME_VX800:
-				return pll_value[i].cx700_pll;
-			case UNICHROME_VX855:
-				return pll_value[i].vx855_pll;
-			}
+	while (i < NUM_TOTAL_PLL_TABLE && clk != pll_value[i].clk)
+		i++;
+
+	if (i == NUM_TOTAL_PLL_TABLE) {
+		printk(KERN_WARNING "viafb_get_clk_value: PLL lookup failed!");
+	} else {
+		switch (viaparinfo->chip_info->gfx_chip_name) {
+		case UNICHROME_CLE266:
+		case UNICHROME_K400:
+			value = cle266_encode_pll(pll_value[i].cle266_pll);
+			break;
+
+		case UNICHROME_K800:
+		case UNICHROME_PM800:
+		case UNICHROME_CN700:
+			value = k800_encode_pll(pll_value[i].k800_pll);
+			break;
+
+		case UNICHROME_CX700:
+		case UNICHROME_CN750:
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M890:
+		case UNICHROME_P4M900:
+		case UNICHROME_VX800:
+			value = k800_encode_pll(pll_value[i].cx700_pll);
+			break;
+
+		case UNICHROME_VX855:
+			value = vx855_encode_pll(pll_value[i].vx855_pll);
+			break;
 		}
 	}
 
-	DEBUG_MSG(KERN_INFO "Can't find match PLL value\n\n");
-	return 0;
+	return value;
 }
 
 /* Set VCLK*/
-void viafb_set_vclock(u32 CLK, int set_iga)
+void viafb_set_vclock(u32 clk, int set_iga)
 {
 	/* H.W. Reset : ON */
 	viafb_write_reg_mask(CR17, VIACR, 0x00, BIT7);
@@ -1403,26 +1631,23 @@ void viafb_set_vclock(u32 CLK, int set_iga)
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_CLE266:
 		case UNICHROME_K400:
-			viafb_write_reg(SR46, VIASR, CLK / 0x100);
-			viafb_write_reg(SR47, VIASR, CLK % 0x100);
+			via_write_reg(VIASR, SR46, (clk & 0x00FF));
+			via_write_reg(VIASR, SR47, (clk & 0xFF00) >> 8);
 			break;
 
 		case UNICHROME_K800:
 		case UNICHROME_PM800:
 		case UNICHROME_CN700:
 		case UNICHROME_CX700:
+		case UNICHROME_CN750:
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M890:
 		case UNICHROME_P4M900:
 		case UNICHROME_VX800:
 		case UNICHROME_VX855:
-			viafb_write_reg(SR44, VIASR, CLK / 0x10000);
-			DEBUG_MSG(KERN_INFO "\nSR44=%x", CLK / 0x10000);
-			viafb_write_reg(SR45, VIASR, (CLK & 0xFFFF) / 0x100);
-			DEBUG_MSG(KERN_INFO "\nSR45=%x",
-				  (CLK & 0xFFFF) / 0x100);
-			viafb_write_reg(SR46, VIASR, CLK % 0x100);
-			DEBUG_MSG(KERN_INFO "\nSR46=%x", CLK % 0x100);
+			via_write_reg(VIASR, SR44, (clk & 0x0000FF));
+			via_write_reg(VIASR, SR45, (clk & 0x00FF00) >> 8);
+			via_write_reg(VIASR, SR46, (clk & 0xFF0000) >> 16);
 			break;
 		}
 	}
@@ -1432,22 +1657,23 @@ void viafb_set_vclock(u32 CLK, int set_iga)
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_CLE266:
 		case UNICHROME_K400:
-			viafb_write_reg(SR44, VIASR, CLK / 0x100);
-			viafb_write_reg(SR45, VIASR, CLK % 0x100);
+			via_write_reg(VIASR, SR44, (clk & 0x00FF));
+			via_write_reg(VIASR, SR45, (clk & 0xFF00) >> 8);
 			break;
 
 		case UNICHROME_K800:
 		case UNICHROME_PM800:
 		case UNICHROME_CN700:
 		case UNICHROME_CX700:
+		case UNICHROME_CN750:
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M890:
 		case UNICHROME_P4M900:
 		case UNICHROME_VX800:
 		case UNICHROME_VX855:
-			viafb_write_reg(SR4A, VIASR, CLK / 0x10000);
-			viafb_write_reg(SR4B, VIASR, (CLK & 0xFFFF) / 0x100);
-			viafb_write_reg(SR4C, VIASR, CLK % 0x100);
+			via_write_reg(VIASR, SR4A, (clk & 0x0000FF));
+			via_write_reg(VIASR, SR4B, (clk & 0x00FF00) >> 8);
+			via_write_reg(VIASR, SR4C, (clk & 0xFF0000) >> 16);
 			break;
 		}
 	}
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index a109de3..c443998 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -700,12 +700,18 @@ struct _lcd_scaling_factor {
 	struct _lcd_ver_scaling_factor lcd_ver_scaling_factor;
 };
 
+struct pll_config {
+	u16 multiplier;
+	u8 divisor;
+	u8 rshift;
+};
+
 struct pll_map {
 	u32 clk;
-	u32 cle266_pll;
-	u32 k800_pll;
-	u32 cx700_pll;
-	u32 vx855_pll;
+	struct pll_config cle266_pll;
+	struct pll_config k800_pll;
+	struct pll_config cx700_pll;
+	struct pll_config vx855_pll;
 };
 
 struct rgbLUT {
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index 7f0de7f..2cbe103 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -631,7 +631,6 @@
 #define CLK_25_175M     25175000
 #define CLK_26_880M     26880000
 #define CLK_29_581M     29581000
-#define CLK_31_490M     31490000
 #define CLK_31_500M     31500000
 #define CLK_31_728M     31728000
 #define CLK_32_668M     32688000
@@ -676,7 +675,6 @@
 #define CLK_119_000M    119000000
 #define CLK_121_750M    121750000	/* 121.704MHz */
 #define CLK_125_104M    125104000
-#define CLK_133_308M    133308000
 #define CLK_135_000M    135000000
 #define CLK_136_700M    136700000
 #define CLK_138_400M    138400000
@@ -699,313 +697,6 @@
 #define CLK_172_798M    172798000
 #define CLK_122_614M    122614000
 
-/* CLE266 PLL value
-*/
-#define CLE266_PLL_25_175M     0x0000C763
-#define CLE266_PLL_26_880M     0x0000440F
-#define CLE266_PLL_29_581M     0x00008421
-#define CLE266_PLL_31_490M     0x00004721
-#define CLE266_PLL_31_500M     0x0000C3B5
-#define CLE266_PLL_31_728M     0x0000471F
-#define CLE266_PLL_32_668M     0x0000C449
-#define CLE266_PLL_36_000M     0x0000C5E5
-#define CLE266_PLL_40_000M     0x0000C459
-#define CLE266_PLL_41_291M     0x00004417
-#define CLE266_PLL_43_163M     0x0000C579
-#define CLE266_PLL_45_250M     0x0000C57F	/* 45.46MHz */
-#define CLE266_PLL_46_000M     0x0000875A
-#define CLE266_PLL_46_996M     0x0000C4E9
-#define CLE266_PLL_48_000M     0x00001443
-#define CLE266_PLL_48_875M     0x00001D63
-#define CLE266_PLL_49_500M     0x00008653
-#define CLE266_PLL_52_406M     0x0000C475
-#define CLE266_PLL_52_977M     0x00004525
-#define CLE266_PLL_56_250M     0x000047B7
-#define CLE266_PLL_60_466M     0x0000494C
-#define CLE266_PLL_61_500M     0x00001456
-#define CLE266_PLL_65_000M     0x000086ED
-#define CLE266_PLL_65_178M     0x0000855B
-#define CLE266_PLL_66_750M     0x0000844B	/* 67.116MHz */
-#define CLE266_PLL_68_179M     0x00000413
-#define CLE266_PLL_69_924M     0x00001153
-#define CLE266_PLL_70_159M     0x00001462
-#define CLE266_PLL_72_000M     0x00001879
-#define CLE266_PLL_74_270M     0x00004853
-#define CLE266_PLL_78_750M     0x00004321
-#define CLE266_PLL_80_136M     0x0000051C
-#define CLE266_PLL_83_375M     0x0000C25D
-#define CLE266_PLL_83_950M     0x00000729
-#define CLE266_PLL_84_750M     0x00008576	/* 84.537MHz */
-#define CLE266_PLL_85_860M     0x00004754
-#define CLE266_PLL_88_750M     0x0000051F
-#define CLE266_PLL_94_500M     0x00000521
-#define CLE266_PLL_97_750M     0x00004652
-#define CLE266_PLL_101_000M    0x0000497F
-#define CLE266_PLL_106_500M    0x00008477	/* 106.491463 MHz */
-#define CLE266_PLL_108_000M    0x00008479
-#define CLE266_PLL_113_309M    0x00000C5F
-#define CLE266_PLL_118_840M    0x00004553
-#define CLE266_PLL_119_000M    0x00000D6C
-#define CLE266_PLL_121_750M    0x00004555	/* 121.704MHz */
-#define CLE266_PLL_125_104M    0x000006B5
-#define CLE266_PLL_133_308M    0x0000465F
-#define CLE266_PLL_135_000M    0x0000455E
-#define CLE266_PLL_136_700M    0x00000C73
-#define CLE266_PLL_138_400M    0x00000957
-#define CLE266_PLL_146_760M    0x00004567
-#define CLE266_PLL_148_500M    0x00000853
-#define CLE266_PLL_153_920M    0x00000856
-#define CLE266_PLL_156_000M    0x0000456D
-#define CLE266_PLL_157_500M    0x000005B7
-#define CLE266_PLL_162_000M    0x00004571
-#define CLE266_PLL_187_000M    0x00000976
-#define CLE266_PLL_193_295M    0x0000086C
-#define CLE266_PLL_202_500M    0x00000763
-#define CLE266_PLL_204_000M    0x00000764
-#define CLE266_PLL_218_500M    0x0000065C
-#define CLE266_PLL_234_000M    0x00000662
-#define CLE266_PLL_267_250M    0x00000670
-#define CLE266_PLL_297_500M    0x000005E6
-#define CLE266_PLL_74_481M     0x0000051A
-#define CLE266_PLL_172_798M    0x00004579
-#define CLE266_PLL_122_614M    0x0000073C
-
-/* K800 PLL value
-*/
-#define K800_PLL_25_175M     0x00539001
-#define K800_PLL_26_880M     0x001C8C80
-#define K800_PLL_29_581M     0x00409080
-#define K800_PLL_31_490M     0x006F9001
-#define K800_PLL_31_500M     0x008B9002
-#define K800_PLL_31_728M     0x00AF9003
-#define K800_PLL_32_668M     0x00909002
-#define K800_PLL_36_000M     0x009F9002
-#define K800_PLL_40_000M     0x00578C02
-#define K800_PLL_41_291M     0x00438C01
-#define K800_PLL_43_163M     0x00778C03
-#define K800_PLL_45_250M     0x007D8C83	/* 45.46MHz */
-#define K800_PLL_46_000M     0x00658C02
-#define K800_PLL_46_996M     0x00818C83
-#define K800_PLL_48_000M     0x00848C83
-#define K800_PLL_48_875M     0x00508C81
-#define K800_PLL_49_500M     0x00518C01
-#define K800_PLL_52_406M     0x00738C02
-#define K800_PLL_52_977M     0x00928C83
-#define K800_PLL_56_250M     0x007C8C02
-#define K800_PLL_60_466M     0x00A78C83
-#define K800_PLL_61_500M     0x00AA8C83
-#define K800_PLL_65_000M     0x006B8C01
-#define K800_PLL_65_178M     0x00B48C83
-#define K800_PLL_66_750M     0x00948C82	/* 67.116MHz */
-#define K800_PLL_68_179M     0x00708C01
-#define K800_PLL_69_924M     0x00C18C83
-#define K800_PLL_70_159M     0x00C28C83
-#define K800_PLL_72_000M     0x009F8C82
-#define K800_PLL_74_270M     0x00ce0c03
-#define K800_PLL_78_750M     0x00408801
-#define K800_PLL_80_136M     0x00428801
-#define K800_PLL_83_375M     0x005B0882
-#define K800_PLL_83_950M     0x00738803
-#define K800_PLL_84_750M     0x00748883	/* 84.477MHz */
-#define K800_PLL_85_860M     0x00768883
-#define K800_PLL_88_750M     0x007A8883
-#define K800_PLL_94_500M     0x00828803
-#define K800_PLL_97_750M     0x00878883
-#define K800_PLL_101_000M    0x008B8883
-#define K800_PLL_106_500M    0x00758882	/* 106.491463 MHz */
-#define K800_PLL_108_000M    0x00778882
-#define K800_PLL_113_309M    0x005D8881
-#define K800_PLL_118_840M    0x00A48883
-#define K800_PLL_119_000M    0x00838882
-#define K800_PLL_121_750M    0x00A88883	/* 121.704MHz */
-#define K800_PLL_125_104M    0x00688801
-#define K800_PLL_133_308M    0x005D8801
-#define K800_PLL_135_000M    0x001A4081
-#define K800_PLL_136_700M    0x00BD8883
-#define K800_PLL_138_400M    0x00728881
-#define K800_PLL_146_760M    0x00CC8883
-#define K800_PLL_148_500M    0x00ce0803
-#define K800_PLL_153_920M    0x00548482
-#define K800_PLL_156_000M    0x006B8483
-#define K800_PLL_157_500M    0x00142080
-#define K800_PLL_162_000M    0x006F8483
-#define K800_PLL_187_000M    0x00818483
-#define K800_PLL_193_295M    0x004F8481
-#define K800_PLL_202_500M    0x00538481
-#define K800_PLL_204_000M    0x008D8483
-#define K800_PLL_218_500M    0x00978483
-#define K800_PLL_234_000M    0x00608401
-#define K800_PLL_267_250M    0x006E8481
-#define K800_PLL_297_500M    0x00A48402
-#define K800_PLL_74_481M     0x007B8C81
-#define K800_PLL_172_798M    0x00778483
-#define K800_PLL_122_614M    0x00878882
-
-/* PLL for VT3324 */
-#define CX700_25_175M     0x008B1003
-#define CX700_26_719M     0x00931003
-#define CX700_26_880M     0x00941003
-#define CX700_29_581M     0x00A49003
-#define CX700_31_490M     0x00AE1003
-#define CX700_31_500M     0x00AE1003
-#define CX700_31_728M     0x00AF1003
-#define CX700_32_668M     0x00B51003
-#define CX700_36_000M     0x00C81003
-#define CX700_40_000M     0x006E0C03
-#define CX700_41_291M     0x00710C03
-#define CX700_43_163M     0x00770C03
-#define CX700_45_250M     0x007D0C03	/* 45.46MHz */
-#define CX700_46_000M     0x007F0C03
-#define CX700_46_996M     0x00818C83
-#define CX700_48_000M     0x00840C03
-#define CX700_48_875M     0x00508C81
-#define CX700_49_500M     0x00880C03
-#define CX700_52_406M     0x00730C02
-#define CX700_52_977M     0x00920C03
-#define CX700_56_250M     0x009B0C03
-#define CX700_60_466M     0x00460C00
-#define CX700_61_500M     0x00AA0C03
-#define CX700_65_000M     0x006B0C01
-#define CX700_65_178M     0x006B0C01
-#define CX700_66_750M     0x00940C02	/*67.116MHz */
-#define CX700_68_179M     0x00BC0C03
-#define CX700_69_924M     0x00C10C03
-#define CX700_70_159M     0x00C20C03
-#define CX700_72_000M     0x009F0C02
-#define CX700_74_270M     0x00CE0C03
-#define CX700_74_481M     0x00CE0C03
-#define CX700_78_750M     0x006C0803
-#define CX700_80_136M     0x006E0803
-#define CX700_83_375M     0x005B0882
-#define CX700_83_950M     0x00730803
-#define CX700_84_750M     0x00740803	/* 84.537Mhz */
-#define CX700_85_860M     0x00760803
-#define CX700_88_750M     0x00AC8885
-#define CX700_94_500M     0x00820803
-#define CX700_97_750M     0x00870803
-#define CX700_101_000M    0x008B0803
-#define CX700_106_500M    0x00750802
-#define CX700_108_000M    0x00950803
-#define CX700_113_309M    0x005D0801
-#define CX700_118_840M    0x00A40803
-#define CX700_119_000M    0x00830802
-#define CX700_121_750M    0x00420800	/* 121.704MHz */
-#define CX700_125_104M    0x00AD0803
-#define CX700_133_308M    0x00930802
-#define CX700_135_000M    0x00950802
-#define CX700_136_700M    0x00BD0803
-#define CX700_138_400M    0x00720801
-#define CX700_146_760M    0x00CC0803
-#define CX700_148_500M    0x00a40802
-#define CX700_153_920M    0x00540402
-#define CX700_156_000M    0x006B0403
-#define CX700_157_500M    0x006C0403
-#define CX700_162_000M    0x006F0403
-#define CX700_172_798M    0x00770403
-#define CX700_187_000M    0x00810403
-#define CX700_193_295M    0x00850403
-#define CX700_202_500M    0x008C0403
-#define CX700_204_000M    0x008D0403
-#define CX700_218_500M    0x00970403
-#define CX700_234_000M    0x00600401
-#define CX700_267_250M    0x00B90403
-#define CX700_297_500M    0x00CE0403
-#define CX700_122_614M    0x00870802
-
-/* PLL for VX855 */
-#define VX855_22_000M     0x007B1005
-#define VX855_25_175M     0x008D1005
-#define VX855_26_719M     0x00961005
-#define VX855_26_880M     0x00961005
-#define VX855_27_000M     0x00971005
-#define VX855_29_581M     0x00A51005
-#define VX855_29_829M     0x00641003
-#define VX855_31_490M     0x00B01005
-#define VX855_31_500M     0x00B01005
-#define VX855_31_728M     0x008E1004
-#define VX855_32_668M     0x00921004
-#define VX855_36_000M     0x00A11004
-#define VX855_40_000M     0x00700C05
-#define VX855_41_291M     0x00730C05
-#define VX855_43_163M     0x00790C05
-#define VX855_45_250M     0x007F0C05      /* 45.46MHz */
-#define VX855_46_000M     0x00670C04
-#define VX855_46_996M     0x00690C04
-#define VX855_48_000M     0x00860C05
-#define VX855_48_875M     0x00890C05
-#define VX855_49_500M     0x00530C03
-#define VX855_52_406M     0x00580C03
-#define VX855_52_977M     0x00940C05
-#define VX855_56_250M     0x009D0C05
-#define VX855_57_275M     0x009D8C85    /* Used by XO panel */
-#define VX855_60_466M     0x00A90C05
-#define VX855_61_500M     0x00AC0C05
-#define VX855_65_000M     0x006D0C03
-#define VX855_65_178M     0x00B60C05
-#define VX855_66_750M     0x00700C03    /*67.116MHz */
-#define VX855_67_295M     0x00BC0C05
-#define VX855_68_179M     0x00BF0C05
-#define VX855_68_369M     0x00BF0C05
-#define VX855_69_924M     0x00C30C05
-#define VX855_70_159M     0x00C30C05
-#define VX855_72_000M     0x00A10C04
-#define VX855_73_023M     0x00CC0C05
-#define VX855_74_481M     0x00D10C05
-#define VX855_78_750M     0x006E0805
-#define VX855_79_466M     0x006F0805
-#define VX855_80_136M     0x00700805
-#define VX855_81_627M     0x00720805
-#define VX855_83_375M     0x00750805
-#define VX855_83_527M     0x00750805
-#define VX855_83_950M     0x00750805
-#define VX855_84_537M     0x00760805
-#define VX855_84_750M     0x00760805     /* 84.537Mhz */
-#define VX855_85_500M     0x00760805        /* 85.909080 MHz*/
-#define VX855_85_860M     0x00760805
-#define VX855_85_909M     0x00760805
-#define VX855_88_750M     0x007C0805
-#define VX855_89_489M     0x007D0805
-#define VX855_94_500M     0x00840805
-#define VX855_96_648M     0x00870805
-#define VX855_97_750M     0x00890805
-#define VX855_101_000M    0x008D0805
-#define VX855_106_500M    0x00950805
-#define VX855_108_000M    0x00970805
-#define VX855_110_125M    0x00990805
-#define VX855_112_000M    0x009D0805
-#define VX855_113_309M    0x009F0805
-#define VX855_115_000M    0x00A10805
-#define VX855_118_840M    0x00A60805
-#define VX855_119_000M    0x00A70805
-#define VX855_121_750M    0x00AA0805       /* 121.704MHz */
-#define VX855_122_614M    0x00AC0805
-#define VX855_126_266M    0x00B10805
-#define VX855_130_250M    0x00B60805      /* 130.250 */
-#define VX855_135_000M    0x00BD0805
-#define VX855_136_700M    0x00BF0805
-#define VX855_137_750M    0x00C10805
-#define VX855_138_400M    0x00C20805
-#define VX855_144_300M    0x00CA0805
-#define VX855_146_760M    0x00CE0805
-#define VX855_148_500M	  0x00D00805
-#define VX855_153_920M    0x00540402
-#define VX855_156_000M    0x006C0405
-#define VX855_156_867M    0x006E0405
-#define VX855_157_500M    0x006E0405
-#define VX855_162_000M    0x00710405
-#define VX855_172_798M    0x00790405
-#define VX855_187_000M    0x00830405
-#define VX855_193_295M    0x00870405
-#define VX855_202_500M    0x008E0405
-#define VX855_204_000M    0x008F0405
-#define VX855_218_500M    0x00990405
-#define VX855_229_500M    0x00A10405
-#define VX855_234_000M    0x00A40405
-#define VX855_267_250M    0x00BB0405
-#define VX855_297_500M    0x00D00405
-#define VX855_339_500M    0x00770005
-#define VX855_340_772M    0x00770005
-
 
 /* Definition CRTC Timing Index */
 #define H_TOTAL_INDEX               0
-- 
1.6.3.2

