Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2CHRzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:55:48 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41481 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753962Ab2CHRzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:55:46 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/AeMUadoPACK60LHjEqUWQmXkvJx/g33EEzU8ShZ
	uA9Q/M1QoCi+oc
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/2] viafb: avoid refresh and mode lookup in set_par
Date: Thu,  8 Mar 2012 18:15:29 +0000
Message-Id: <a1c4d39ec862e09acd93247200cd6b9e5cc5701d.1331229163.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1331229163.git.FlorianSchandinat@gmx.de>
References: <cover.1331229163.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As check_var already ensures that the mode is valid there is no need
to do those expensive lookups here again. The only thing that might
change is that the deprecated interface could report slightly
different refresh rates due to rounding errors.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 7529340..0c88375 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -287,26 +287,22 @@ static int viafb_set_par(struct fb_info *info)
 			viafb_second_yres, viafb_bpp1, 1);
 	}
 
-	refresh = viafb_get_refresh(info->var.xres, info->var.yres,
-		get_var_refresh(&info->var));
-	if (viafb_get_best_mode(viafbinfo->var.xres, viafbinfo->var.yres,
-		refresh)) {
-		if (viafb_dual_fb && viapar->iga_path == IGA2) {
-			viafb_bpp1 = info->var.bits_per_pixel;
-			viafb_refresh1 = refresh;
-		} else {
-			viafb_bpp = info->var.bits_per_pixel;
-			viafb_refresh = refresh;
-		}
-
-		if (info->var.accel_flags & FB_ACCELF_TEXT)
-			info->flags &= ~FBINFO_HWACCEL_DISABLED;
-		else
-			info->flags |= FBINFO_HWACCEL_DISABLED;
-		viafb_setmode();
-		viafb_pan_display(&info->var, info);
+	refresh = get_var_refresh(&info->var);
+	if (viafb_dual_fb && viapar->iga_path == IGA2) {
+		viafb_bpp1 = info->var.bits_per_pixel;
+		viafb_refresh1 = refresh;
+	} else {
+		viafb_bpp = info->var.bits_per_pixel;
+		viafb_refresh = refresh;
 	}
 
+	if (info->var.accel_flags & FB_ACCELF_TEXT)
+		info->flags &= ~FBINFO_HWACCEL_DISABLED;
+	else
+		info->flags |= FBINFO_HWACCEL_DISABLED;
+	viafb_setmode();
+	viafb_pan_display(&info->var, info);
+
 	return 0;
 }
 
-- 
1.7.9

