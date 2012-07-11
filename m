Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab2GKNuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:50:23 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:40949 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932560Ab2GKNuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAQEFeRAgMTwbBxKIEb1XkS4DlTqJJoZggmE
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808134"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 5/9] staging: sm7xxfb: minor maintenance on sm7xx_vga_setup
Date: Wed, 11 Jul 2012 15:49:37 +0200
Message-Id: <1342014581-2979-6-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
References: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch keeps code related to sm7xx_vga_setup closed. It is useful to
understand/maintain the logic behind sm7xx_vga_setup with a simple look.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |  106 ++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 7a597fd..ac49c98 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -34,8 +34,6 @@
 
 #include "sm7xx.h"
 
-struct screen_info smtc_scr_info;
-
 /*
 * Private structure
 */
@@ -56,30 +54,6 @@ struct smtcfb_info {
 	u_int hz;
 };
 
-struct vesa_mode {
-	char index[6];
-	u16  lfb_width;
-	u16  lfb_height;
-	u16  lfb_depth;
-};
-
-static struct vesa_mode vesa_mode_table[] = {
-	{"0x301", 640,  480,  8},
-	{"0x303", 800,  600,  8},
-	{"0x305", 1024, 768,  8},
-	{"0x307", 1280, 1024, 8},
-
-	{"0x311", 640,  480,  16},
-	{"0x314", 800,  600,  16},
-	{"0x317", 1024, 768,  16},
-	{"0x31A", 1280, 1024, 16},
-
-	{"0x312", 640,  480,  24},
-	{"0x315", 800,  600,  24},
-	{"0x318", 1024, 768,  24},
-	{"0x31B", 1280, 1024, 24},
-};
-
 char __iomem *smtc_RegBaseAddress;	/* Memory Map IO starting address */
 char __iomem *smtc_VRAMBaseAddress;	/* video memory starting address */
 
@@ -108,6 +82,59 @@ static struct fb_fix_screeninfo smtcfb_fix = {
 	.accel          = FB_ACCEL_SMI_LYNX,
 };
 
+struct vesa_mode {
+	char index[6];
+	u16  lfb_width;
+	u16  lfb_height;
+	u16  lfb_depth;
+};
+
+static struct vesa_mode vesa_mode_table[] = {
+	{"0x301", 640,  480,  8},
+	{"0x303", 800,  600,  8},
+	{"0x305", 1024, 768,  8},
+	{"0x307", 1280, 1024, 8},
+
+	{"0x311", 640,  480,  16},
+	{"0x314", 800,  600,  16},
+	{"0x317", 1024, 768,  16},
+	{"0x31A", 1280, 1024, 16},
+
+	{"0x312", 640,  480,  24},
+	{"0x315", 800,  600,  24},
+	{"0x318", 1024, 768,  24},
+	{"0x31B", 1280, 1024, 24},
+};
+
+struct screen_info smtc_scr_info;
+
+/* process command line options, get vga parameter */
+static int __init sm7xx_vga_setup(char *options)
+{
+	int i;
+
+	if (!options || !*options)
+		return -EINVAL;
+
+	smtc_scr_info.lfb_width = 0;
+	smtc_scr_info.lfb_height = 0;
+	smtc_scr_info.lfb_depth = 0;
+
+	pr_debug("sm7xx_vga_setup = %s\n", options);
+
+	for (i = 0; i < ARRAY_SIZE(vesa_mode_table); i++) {
+		if (strstr(options, vesa_mode_table[i].index)) {
+			smtc_scr_info.lfb_width  = vesa_mode_table[i].lfb_width;
+			smtc_scr_info.lfb_height = vesa_mode_table[i].lfb_height;
+			smtc_scr_info.lfb_depth  = vesa_mode_table[i].lfb_depth;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+__setup("vga=", sm7xx_vga_setup);
+
 static void sm712_set_timing(struct smtcfb_info *sfb)
 {
 	int i = 0, j = 0;
@@ -756,33 +783,6 @@ static inline void sm7xx_init_hw(void)
 	outb_p(0x11, 0x3c5);
 }
 
-/* process command line options, get vga parameter */
-static int __init sm7xx_vga_setup(char *options)
-{
-	int i;
-
-	if (!options || !*options)
-		return -EINVAL;
-
-	smtc_scr_info.lfb_width = 0;
-	smtc_scr_info.lfb_height = 0;
-	smtc_scr_info.lfb_depth = 0;
-
-	pr_debug("sm7xx_vga_setup = %s\n", options);
-
-	for (i = 0; i < ARRAY_SIZE(vesa_mode_table); i++) {
-		if (strstr(options, vesa_mode_table[i].index)) {
-			smtc_scr_info.lfb_width  = vesa_mode_table[i].lfb_width;
-			smtc_scr_info.lfb_height = vesa_mode_table[i].lfb_height;
-			smtc_scr_info.lfb_depth  = vesa_mode_table[i].lfb_depth;
-			return 0;
-		}
-	}
-
-	return -1;
-}
-__setup("vga=", sm7xx_vga_setup);
-
 static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
-- 
1.7.10

