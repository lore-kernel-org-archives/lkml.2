Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab1JNVvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:51:37 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:52905 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1JNVvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:51:36 -0400
Date: Fri, 14 Oct 2011 23:43:34 +0200
From: Peter Feuerer <peter@piie.net>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feuerer <peter@piie.net>
Subject: [PATCH 2/2] acerhdf: Add support for new hardware
Message-Id: <20111014234334.a87a2388.peter@piie.net>
In-Reply-To: <20111014234055.2265c524.peter@piie.net>
References: <20111014234055.2265c524.peter@piie.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: NjUwNDc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Feuerer <peter@piie.net>

Add support for new hardware:
Acer Aspire LT-10Q/531/751/1810/1825,
Acer Travelmate 7730,
Packard Bell ENBFT/DOTVR46

To prevent from hardware defects, the default temperature values have been
decreased.

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/platform/x86/acerhdf.c |   66 ++++++++++++++++++++++++++-------------
 1 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 698e45c..833c0ec 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -50,7 +50,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.24"
+#define DRV_VER "0.5.26"
 
 /*
  * According to the Atom N270 datasheet,
@@ -83,8 +83,8 @@ static int kernelmode;
 #endif
 
 static unsigned int interval = 10;
-static unsigned int fanon = 63000;
-static unsigned int fanoff = 58000;
+static unsigned int fanon = 60000;
+static unsigned int fanoff = 53000;
 static unsigned int verbose;
 static unsigned int fanstate = ACERHDF_FAN_AUTO;
 static char force_bios[16];
@@ -150,6 +150,8 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
+	/* LT1005u */
+	{"Acer", "LT-10Q", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
 	/* Acer 1410 */
 	{"Acer", "Aspire 1410", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
@@ -184,29 +186,44 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "Aspire 1810TZ", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 531 */
+	{"Acer", "AO531h", "v0.3104", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AO531h", "v0.3201", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AO531h", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
+	/* Acer 751 */
+	{"Acer", "AO751h", "V0.3212", 0x55, 0x58, {0x21, 0x00} },
+	/* Acer 1825 */
+	{"Acer", "Aspire 1825PTZ", "V1.3118", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1825PTZ", "V1.3127", 0x55, 0x58, {0x9e, 0x00} },
+	/* Acer TravelMate 7730 */
+	{"Acer", "TravelMate 7730G", "v0.3509", 0x55, 0x58, {0xaf, 0x00} },
 	/* Gateway */
-	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
-	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
-	{"Gateway", "LT31",   "v1.3103", 0x55, 0x58, {0x9e, 0x00} },
-	{"Gateway", "LT31",   "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
-	{"Gateway", "LT31",   "v1.3302", 0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "AOA110", "v0.3103",  0x55, 0x58, {0x21, 0x00} },
+	{"Gateway", "AOA150", "v0.3103",  0x55, 0x58, {0x20, 0x00} },
+	{"Gateway", "LT31",   "v1.3103",  0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3201",  0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3302",  0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00} },
 	/* Packard Bell */
-	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
-	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
-	{"Packard Bell", "DOTMU",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMA",  "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMA",  "v1.3302", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOA150",  "v0.3104",  0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "DOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "AOA110",  "v0.3105",  0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "AOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "ENBFT",   "V1.3118",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "ENBFT",   "V1.3127",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v1.3303",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3120",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3108",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3113",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3115",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3117",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3119",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v1.3204",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",   "v1.3201",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",   "v1.3302",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTVR46", "v1.3308",  0x55, 0x58, {0x9e, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0} }
 };
@@ -705,15 +722,20 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
 MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAO751h*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1410*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1810*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1825PTZ:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
+MODULE_ALIAS("dmi:*:*Acer*:TravelMate*7730G:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOA*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMU*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnENBFT*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMA*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTVR46*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
-- 
1.7.7

