Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1CLVbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:31:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52977 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755913Ab1CLVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:31:12 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19BXSxxFeNByUfQnZxDAZlIGU8sQBY282kNkXp+EZ
	gmI3cmVw1v7JPh
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: split pll configs up
Date: Sat, 12 Mar 2011 21:46:26 +0000
Message-Id: <1299966386-3439-5-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1299966386-3439-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1299966386-3439-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the pll configs up on pll versions. This allows
easy adding of other known good pll values. Additionally it made it
possible to remove invalid configurations resulting in better
behaviour for such cases. The resulting clocks are no longer stored
resulting in some computing overhead on each mode change.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |  648 ++++++++++++++++++++++--------------------------
 1 files changed, 301 insertions(+), 347 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 071e3a9..b418acf 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -22,342 +22,272 @@
 #include <linux/via-core.h>
 #include "global.h"
 
-static struct pll_map pll_value[] = {
-	{25175000,
-		{99, 7, 3},
-		{85, 3, 4},	/* ignoring bit difference: 0x00008000 */
-		{141, 5, 4},
-		{141, 5, 4} },
-	{29581000,
-		{33, 4, 2},
-		{66, 2, 4},	/* ignoring bit difference: 0x00808000 */
-		{166, 5, 4},	/* ignoring bit difference: 0x00008000 */
-		{165, 5, 4} },
-	{26880000,
-		{15, 4, 1},
-		{30, 2, 3},	/* ignoring bit difference: 0x00808000 */
-		{150, 5, 4},
-		{150, 5, 4} },
-	{31500000,
-		{53, 3, 3},	/* ignoring bit difference: 0x00008000 */
-		{141, 4, 4},	/* ignoring bit difference: 0x00008000 */
-		{176, 5, 4},
-		{176, 5, 4} },
-	{31728000,
-		{31, 7, 1},
-		{177, 5, 4},	/* ignoring bit difference: 0x00008000 */
-		{177, 5, 4},
-		{142, 4, 4} },
-	{32688000,
-		{73, 4, 3},
-		{146, 4, 4},	/* ignoring bit difference: 0x00008000 */
-		{183, 5, 4},
-		{146, 4, 4} },
-	{36000000,
-		{101, 5, 3},	/* ignoring bit difference: 0x00008000 */
-		{161, 4, 4},	/* ignoring bit difference: 0x00008000 */
-		{202, 5, 4},
-		{161, 4, 4} },
-	{40000000,
-		{89, 4, 3},
-		{89, 4, 3},	/* ignoring bit difference: 0x00008000 */
-		{112, 5, 3},
-		{112, 5, 3} },
-	{41291000,
-		{23, 4, 1},
-		{69, 3, 3},	/* ignoring bit difference: 0x00008000 */
-		{115, 5, 3},
-		{115, 5, 3} },
-	{43163000,
-		{121, 5, 3},
-		{121, 5, 3},	/* ignoring bit difference: 0x00008000 */
-		{121, 5, 3},
-		{121, 5, 3} },
-	{45250000,
-		{127, 5, 3},
-		{127, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{127, 5, 3},
-		{127, 5, 3} },
-	{46000000,
-		{90, 7, 2},
-		{103, 4, 3},	/* ignoring bit difference: 0x00008000 */
-		{129, 5, 3},
-		{103, 4, 3} },
-	{46996000,
-		{105, 4, 3},	/* ignoring bit difference: 0x00008000 */
-		{131, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{131, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{105, 4, 3} },
-	{48000000,
-		{67, 20, 0},
-		{134, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{134, 5, 3},
-		{134, 5, 3} },
-	{48875000,
-		{99, 29, 0},
-		{82, 3, 3},	/* ignoring bit difference: 0x00808000 */
-		{82, 3, 3},	/* ignoring bit difference: 0x00808000 */
-		{137, 5, 3} },
-	{49500000,
-		{83, 6, 2},
-		{83, 3, 3},	/* ignoring bit difference: 0x00008000 */
-		{138, 5, 3},
-		{83, 3, 3} },
-	{52406000,
-		{117, 4, 3},
-		{117, 4, 3},	/* ignoring bit difference: 0x00008000 */
-		{117, 4, 3},
-		{88, 3, 3} },
-	{52977000,
-		{37, 5, 1},
-		{148, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{148, 5, 3},
-		{148, 5, 3} },
-	{56250000,
-		{55, 7, 1},	/* ignoring bit difference: 0x00008000 */
-		{126, 4, 3},	/* ignoring bit difference: 0x00008000 */
-		{157, 5, 3},
-		{157, 5, 3} },
-	{57275000,
-		{0, 0, 0},
-		{2, 2, 0},
-		{2, 2, 0},
-		{157, 5, 3} },	/* ignoring bit difference: 0x00808000 */
-	{60466000,
-		{76, 9, 1},
-		{169, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{169, 5, 3},	/* FIXED: old = {72, 2, 3} */
-		{169, 5, 3} },
-	{61500000,
-		{86, 20, 0},
-		{172, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{172, 5, 3},
-		{172, 5, 3} },
-	{65000000,
-		{109, 6, 2},	/* ignoring bit difference: 0x00008000 */
-		{109, 3, 3},	/* ignoring bit difference: 0x00008000 */
-		{109, 3, 3},
-		{109, 3, 3} },
-	{65178000,
-		{91, 5, 2},
-		{182, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{109, 3, 3},
-		{182, 5, 3} },
-	{66750000,
-		{75, 4, 2},
-		{150, 4, 3},	/* ignoring bit difference: 0x00808000 */
-		{150, 4, 3},
-		{112, 3, 3} },
-	{68179000,
-		{19, 4, 0},
-		{114, 3, 3},	/* ignoring bit difference: 0x00008000 */
-		{190, 5, 3},
-		{191, 5, 3} },
-	{69924000,
-		{83, 17, 0},
-		{195, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{195, 5, 3},
-		{195, 5, 3} },
-	{70159000,
-		{98, 20, 0},
-		{196, 5, 3},	/* ignoring bit difference: 0x00808000 */
-		{196, 5, 3},
-		{195, 5, 3} },
-	{72000000,
-		{121, 24, 0},
-		{161, 4, 3},	/* ignoring bit difference: 0x00808000 */
-		{161, 4, 3},
-		{161, 4, 3} },
-	{78750000,
-		{33, 3, 1},
-		{66, 3, 2},	/* ignoring bit difference: 0x00008000 */
-		{110, 5, 2},
-		{110, 5, 2} },
-	{80136000,
-		{28, 5, 0},
-		{68, 3, 2},	/* ignoring bit difference: 0x00008000 */
-		{112, 5, 2},
-		{112, 5, 2} },
-	{83375000,
-		{93, 2, 3},
-		{93, 4, 2},	/* ignoring bit difference: 0x00800000 */
-		{93, 4, 2},	/* ignoring bit difference: 0x00800000 */
-		{117, 5, 2} },
-	{83950000,
-		{41, 7, 0},
-		{117, 5, 2},	/* ignoring bit difference: 0x00008000 */
-		{117, 5, 2},
-		{117, 5, 2} },
-	{84750000,
-		{118, 5, 2},
-		{118, 5, 2},	/* ignoring bit difference: 0x00808000 */
-		{118, 5, 2},
-		{118, 5, 2} },
-	{85860000,
-		{84, 7, 1},
-		{120, 5, 2},	/* ignoring bit difference: 0x00808000 */
-		{120, 5, 2},
-		{118, 5, 2} },
-	{88750000,
-		{31, 5, 0},
-		{124, 5, 2},	/* ignoring bit difference: 0x00808000 */
-		{174, 7, 2},	/* ignoring bit difference: 0x00808000 */
-		{124, 5, 2} },
-	{94500000,
-		{33, 5, 0},
-		{132, 5, 2},	/* ignoring bit difference: 0x00008000 */
-		{132, 5, 2},
-		{132, 5, 2} },
-	{97750000,
-		{82, 6, 1},
-		{137, 5, 2},	/* ignoring bit difference: 0x00808000 */
-		{137, 5, 2},
-		{137, 5, 2} },
-	{101000000,
-		{127, 9, 1},
-		{141, 5, 2},	/* ignoring bit difference: 0x00808000 */
-		{141, 5, 2},
-		{141, 5, 2} },
-	{106500000,
-		{119, 4, 2},
-		{119, 4, 2},	/* ignoring bit difference: 0x00808000 */
-		{119, 4, 2},
-		{149, 5, 2} },
-	{108000000,
-		{121, 4, 2},
-		{121, 4, 2},	/* ignoring bit difference: 0x00808000 */
-		{151, 5, 2},
-		{151, 5, 2} },
-	{113309000,
-		{95, 12, 0},
-		{95, 3, 2},	/* ignoring bit difference: 0x00808000 */
-		{95, 3, 2},
-		{159, 5, 2} },
-	{118840000,
-		{83, 5, 1},
-		{166, 5, 2},	/* ignoring bit difference: 0x00808000 */
-		{166, 5, 2},
-		{166, 5, 2} },
-	{119000000,
-		{108, 13, 0},
-		{133, 4, 2},	/* ignoring bit difference: 0x00808000 */
-		{133, 4, 2},
-		{167, 5, 2} },
-	{121750000,
-		{85, 5, 1},
-		{170, 5, 2},	/* ignoring bit difference: 0x00808000 */
-		{68, 2, 2},
-		{0, 0, 0} },
-	{125104000,
-		{53, 6, 0},	/* ignoring bit difference: 0x00008000 */
-		{106, 3, 2},	/* ignoring bit difference: 0x00008000 */
-		{175, 5, 2},
-		{0, 0, 0} },
-	{135000000,
-		{94, 5, 1},
-		{28, 3, 0},	/* ignoring bit difference: 0x00804000 */
-		{151, 4, 2},
-		{189, 5, 2} },
-	{136700000,
-		{115, 12, 0},
-		{191, 5, 2},	/* ignoring bit difference: 0x00808000 */
-		{191, 5, 2},
-		{191, 5, 2} },
-	{138400000,
-		{87, 9, 0},
-		{116, 3, 2},	/* ignoring bit difference: 0x00808000 */
-		{116, 3, 2},
-		{194, 5, 2} },
-	{146760000,
-		{103, 5, 1},
-		{206, 5, 2},	/* ignoring bit difference: 0x00808000 */
-		{206, 5, 2},
-		{206, 5, 2} },
-	{153920000,
-		{86, 8, 0},
-		{86, 4, 1},	/* ignoring bit difference: 0x00808000 */
-		{86, 4, 1},
-		{86, 4, 1} },	/* FIXED: old = {84, 2, 1} */
-	{156000000,
-		{109, 5, 1},
-		{109, 5, 1},	/* ignoring bit difference: 0x00808000 */
-		{109, 5, 1},
-		{108, 5, 1} },
-	{157500000,
-		{55, 5, 0},	/* ignoring bit difference: 0x00008000 */
-		{22, 2, 0},	/* ignoring bit difference: 0x00802000 */
-		{110, 5, 1},
-		{110, 5, 1} },
-	{162000000,
-		{113, 5, 1},
-		{113, 5, 1},	/* ignoring bit difference: 0x00808000 */
-		{113, 5, 1},
-		{113, 5, 1} },
-	{187000000,
-		{118, 9, 0},
-		{131, 5, 1},	/* ignoring bit difference: 0x00808000 */
-		{131, 5, 1},
-		{131, 5, 1} },
-	{193295000,
-		{108, 8, 0},
-		{81, 3, 1},	/* ignoring bit difference: 0x00808000 */
-		{135, 5, 1},
-		{135, 5, 1} },
-	{202500000,
-		{99, 7, 0},
-		{85, 3, 1},	/* ignoring bit difference: 0x00808000 */
-		{142, 5, 1},
-		{142, 5, 1} },
-	{204000000,
-		{100, 7, 0},
-		{143, 5, 1},	/* ignoring bit difference: 0x00808000 */
-		{143, 5, 1},
-		{143, 5, 1} },
-	{218500000,
-		{92, 6, 0},
-		{153, 5, 1},	/* ignoring bit difference: 0x00808000 */
-		{153, 5, 1},
-		{153, 5, 1} },
-	{234000000,
-		{98, 6, 0},
-		{98, 3, 1},	/* ignoring bit difference: 0x00008000 */
-		{98, 3, 1},
-		{164, 5, 1} },
-	{267250000,
-		{112, 6, 0},
-		{112, 3, 1},	/* ignoring bit difference: 0x00808000 */
-		{187, 5, 1},
-		{187, 5, 1} },
-	{297500000,
-		{102, 5, 0},	/* ignoring bit difference: 0x00008000 */
-		{166, 4, 1},	/* ignoring bit difference: 0x00008000 */
-		{208, 5, 1},
-		{208, 5, 1} },
-	{74481000,
-		{26, 5, 0},
-		{125, 3, 3},	/* ignoring bit difference: 0x00808000 */
-		{208, 5, 3},
-		{209, 5, 3} },
-	{172798000,
-		{121, 5, 1},
-		{121, 5, 1},	/* ignoring bit difference: 0x00808000 */
-		{121, 5, 1},
-		{121, 5, 1} },
-	{122614000,
-		{60, 7, 0},
-		{137, 4, 2},	/* ignoring bit difference: 0x00808000 */
-		{137, 4, 2},
-		{172, 5, 2} },
-	{74270000,
-		{83, 8, 1},
-		{208, 5, 3},
-		{208, 5, 3},
-		{0, 0, 0} },
-	{148500000,
-		{83, 8, 0},
-		{208, 5, 2},
-		{166, 4, 2},
-		{208, 5, 2} }
+static struct pll_config cle266_pll_config[] = {
+	{19, 4, 0},
+	{26, 5, 0},
+	{28, 5, 0},
+	{31, 5, 0},
+	{33, 5, 0},
+	{55, 5, 0},
+	{102, 5, 0},
+	{53, 6, 0},
+	{92, 6, 0},
+	{98, 6, 0},
+	{112, 6, 0},
+	{41, 7, 0},
+	{60, 7, 0},
+	{99, 7, 0},
+	{100, 7, 0},
+	{83, 8, 0},
+	{86, 8, 0},
+	{108, 8, 0},
+	{87, 9, 0},
+	{118, 9, 0},
+	{95, 12, 0},
+	{115, 12, 0},
+	{108, 13, 0},
+	{83, 17, 0},
+	{67, 20, 0},
+	{86, 20, 0},
+	{98, 20, 0},
+	{121, 24, 0},
+	{99, 29, 0},
+	{33, 3, 1},
+	{15, 4, 1},
+	{23, 4, 1},
+	{37, 5, 1},
+	{83, 5, 1},
+	{85, 5, 1},
+	{94, 5, 1},
+	{103, 5, 1},
+	{109, 5, 1},
+	{113, 5, 1},
+	{121, 5, 1},
+	{82, 6, 1},
+	{31, 7, 1},
+	{55, 7, 1},
+	{84, 7, 1},
+	{83, 8, 1},
+	{76, 9, 1},
+	{127, 9, 1},
+	{33, 4, 2},
+	{75, 4, 2},
+	{119, 4, 2},
+	{121, 4, 2},
+	{91, 5, 2},
+	{118, 5, 2},
+	{83, 6, 2},
+	{109, 6, 2},
+	{90, 7, 2},
+	{93, 2, 3},
+	{53, 3, 3},
+	{73, 4, 3},
+	{89, 4, 3},
+	{105, 4, 3},
+	{117, 4, 3},
+	{101, 5, 3},
+	{121, 5, 3},
+	{127, 5, 3},
+	{99, 7, 3}
+};
+
+static struct pll_config k800_pll_config[] = {
+	{22, 2, 0},
+	{28, 3, 0},
+	{81, 3, 1},
+	{85, 3, 1},
+	{98, 3, 1},
+	{112, 3, 1},
+	{86, 4, 1},
+	{166, 4, 1},
+	{109, 5, 1},
+	{113, 5, 1},
+	{121, 5, 1},
+	{131, 5, 1},
+	{143, 5, 1},
+	{153, 5, 1},
+	{66, 3, 2},
+	{68, 3, 2},
+	{95, 3, 2},
+	{106, 3, 2},
+	{116, 3, 2},
+	{93, 4, 2},
+	{119, 4, 2},
+	{121, 4, 2},
+	{133, 4, 2},
+	{137, 4, 2},
+	{117, 5, 2},
+	{118, 5, 2},
+	{120, 5, 2},
+	{124, 5, 2},
+	{132, 5, 2},
+	{137, 5, 2},
+	{141, 5, 2},
+	{166, 5, 2},
+	{170, 5, 2},
+	{191, 5, 2},
+	{206, 5, 2},
+	{208, 5, 2},
+	{30, 2, 3},
+	{69, 3, 3},
+	{82, 3, 3},
+	{83, 3, 3},
+	{109, 3, 3},
+	{114, 3, 3},
+	{125, 3, 3},
+	{89, 4, 3},
+	{103, 4, 3},
+	{117, 4, 3},
+	{126, 4, 3},
+	{150, 4, 3},
+	{161, 4, 3},
+	{121, 5, 3},
+	{127, 5, 3},
+	{131, 5, 3},
+	{134, 5, 3},
+	{148, 5, 3},
+	{169, 5, 3},
+	{172, 5, 3},
+	{182, 5, 3},
+	{195, 5, 3},
+	{196, 5, 3},
+	{208, 5, 3},
+	{66, 2, 4},
+	{85, 3, 4},
+	{141, 4, 4},
+	{146, 4, 4},
+	{161, 4, 4},
+	{177, 5, 4}
+};
+
+static struct pll_config cx700_pll_config[] = {
+	{98, 3, 1},
+	{86, 4, 1},
+	{109, 5, 1},
+	{110, 5, 1},
+	{113, 5, 1},
+	{121, 5, 1},
+	{131, 5, 1},
+	{135, 5, 1},
+	{142, 5, 1},
+	{143, 5, 1},
+	{153, 5, 1},
+	{187, 5, 1},
+	{208, 5, 1},
+	{68, 2, 2},
+	{95, 3, 2},
+	{116, 3, 2},
+	{93, 4, 2},
+	{119, 4, 2},
+	{133, 4, 2},
+	{137, 4, 2},
+	{151, 4, 2},
+	{166, 4, 2},
+	{110, 5, 2},
+	{112, 5, 2},
+	{117, 5, 2},
+	{118, 5, 2},
+	{120, 5, 2},
+	{132, 5, 2},
+	{137, 5, 2},
+	{141, 5, 2},
+	{151, 5, 2},
+	{166, 5, 2},
+	{175, 5, 2},
+	{191, 5, 2},
+	{206, 5, 2},
+	{174, 7, 2},
+	{82, 3, 3},
+	{109, 3, 3},
+	{117, 4, 3},
+	{150, 4, 3},
+	{161, 4, 3},
+	{112, 5, 3},
+	{115, 5, 3},
+	{121, 5, 3},
+	{127, 5, 3},
+	{129, 5, 3},
+	{131, 5, 3},
+	{134, 5, 3},
+	{138, 5, 3},
+	{148, 5, 3},
+	{157, 5, 3},
+	{169, 5, 3},
+	{172, 5, 3},
+	{190, 5, 3},
+	{195, 5, 3},
+	{196, 5, 3},
+	{208, 5, 3},
+	{141, 5, 4},
+	{150, 5, 4},
+	{166, 5, 4},
+	{176, 5, 4},
+	{177, 5, 4},
+	{183, 5, 4},
+	{202, 5, 4}
+};
+
+static struct pll_config vx855_pll_config[] = {
+	{86, 4, 1},
+	{108, 5, 1},
+	{110, 5, 1},
+	{113, 5, 1},
+	{121, 5, 1},
+	{131, 5, 1},
+	{135, 5, 1},
+	{142, 5, 1},
+	{143, 5, 1},
+	{153, 5, 1},
+	{164, 5, 1},
+	{187, 5, 1},
+	{208, 5, 1},
+	{110, 5, 2},
+	{112, 5, 2},
+	{117, 5, 2},
+	{118, 5, 2},
+	{124, 5, 2},
+	{132, 5, 2},
+	{137, 5, 2},
+	{141, 5, 2},
+	{149, 5, 2},
+	{151, 5, 2},
+	{159, 5, 2},
+	{166, 5, 2},
+	{167, 5, 2},
+	{172, 5, 2},
+	{189, 5, 2},
+	{191, 5, 2},
+	{194, 5, 2},
+	{206, 5, 2},
+	{208, 5, 2},
+	{83, 3, 3},
+	{88, 3, 3},
+	{109, 3, 3},
+	{112, 3, 3},
+	{103, 4, 3},
+	{105, 4, 3},
+	{161, 4, 3},
+	{112, 5, 3},
+	{115, 5, 3},
+	{121, 5, 3},
+	{127, 5, 3},
+	{134, 5, 3},
+	{137, 5, 3},
+	{148, 5, 3},
+	{157, 5, 3},
+	{169, 5, 3},
+	{172, 5, 3},
+	{182, 5, 3},
+	{191, 5, 3},
+	{195, 5, 3},
+	{209, 5, 3},
+	{142, 4, 4},
+	{146, 4, 4},
+	{161, 4, 4},
+	{141, 5, 4},
+	{150, 5, 4},
+	{165, 5, 4},
+	{176, 5, 4}
 };
 
 static struct fifo_depth_select display_fifo_depth_reg = {
@@ -1674,26 +1604,48 @@ static u32 vx855_encode_pll(struct pll_config pll)
 		| pll.multiplier;
 }
 
-u32 viafb_get_clk_value(int clk)
+static inline u32 get_pll_internal_frequency(u32 ref_freq,
+	struct pll_config pll)
 {
-	u32 value = 0;
-	int i, best = 0;
+	return ref_freq / pll.divisor * pll.multiplier;
+}
 
-	for (i = 1; i < ARRAY_SIZE(pll_value); i++) {
-		if (abs(pll_value[i].clk - clk)
-			< abs(pll_value[best].clk - clk))
-			best = i;
+static inline u32 get_pll_output_frequency(u32 ref_freq, struct pll_config pll)
+{
+	return get_pll_internal_frequency(ref_freq, pll)>>pll.rshift;
+}
+
+static struct pll_config get_pll_config(struct pll_config *config, int size,
+	int clk)
+{
+	struct pll_config best = config[0];
+	const u32 f0 = 14318180; /* X1 frequency */
+	int i;
+
+	for (i = 1; i < size; i++) {
+		if (abs(get_pll_output_frequency(f0, config[i]) - clk)
+			< abs(get_pll_output_frequency(f0, best) - clk))
+			best = config[i];
 	}
 
+	return best;
+}
+
+u32 viafb_get_clk_value(int clk)
+{
+	u32 value = 0;
+
 	switch (viaparinfo->chip_info->gfx_chip_name) {
 	case UNICHROME_CLE266:
 	case UNICHROME_K400:
-		value = cle266_encode_pll(pll_value[best].cle266_pll);
+		value = cle266_encode_pll(get_pll_config(cle266_pll_config,
+			ARRAY_SIZE(cle266_pll_config), clk));
 		break;
 	case UNICHROME_K800:
 	case UNICHROME_PM800:
 	case UNICHROME_CN700:
-		value = k800_encode_pll(pll_value[best].k800_pll);
+		value = k800_encode_pll(get_pll_config(k800_pll_config,
+			ARRAY_SIZE(k800_pll_config), clk));
 		break;
 	case UNICHROME_CX700:
 	case UNICHROME_CN750:
@@ -1701,11 +1653,13 @@ u32 viafb_get_clk_value(int clk)
 	case UNICHROME_P4M890:
 	case UNICHROME_P4M900:
 	case UNICHROME_VX800:
-		value = k800_encode_pll(pll_value[best].cx700_pll);
+		value = k800_encode_pll(get_pll_config(cx700_pll_config,
+			ARRAY_SIZE(cx700_pll_config), clk));
 		break;
 	case UNICHROME_VX855:
 	case UNICHROME_VX900:
-		value = vx855_encode_pll(pll_value[best].vx855_pll);
+		value = vx855_encode_pll(get_pll_config(vx855_pll_config,
+			ARRAY_SIZE(vx855_pll_config), clk));
 		break;
 	}
 
-- 
1.6.3.2

