Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab1DOVw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:52:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42471 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757160Ab1DOVw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:52:56 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19gqxppDUxgW7jJAyjVDR3Y0tWFFIxPIrsG2D0CS1
	MNS+ay6LFVQGiM
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Drake <dsd@laptop.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH] viafb: fix OLPC DCON refresh rate
Date: Fri, 15 Apr 2011 22:08:31 +0000
Message-Id: <1302905311-3821-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <4DA62C4D.8070407@gmx.de>
References: <4DA62C4D.8070407@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a regression introduced by
	fd3cc69848b7e1873e5f12bbcdd572b20277ecf3a
	"viafb: remove duplicated clock storage"
caused by an incosistent mode which pretended to have a higher
refresh rate than it actually had. The wrong refresh rate resulted
in a calculated higher pixclock which the OLPC DCON could not handle.
By reducing the refresh rate to 50Hz we get close to the old
pixclock which makes the OLPC display usable again.
Minor other adjustments are needed as 60Hz is assumed to be a safe
value which is not true for OLPC DCON. This is no problem as we only
support 1200x900 on the OLPC.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Reported-by: Daniel Drake <dsd@laptop.org>
---
 drivers/video/via/hw.c      |    8 ++++++--
 drivers/video/via/viamode.c |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index dc4c778..980e263 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2598,8 +2598,12 @@ int viafb_get_refresh(int hres, int vres, u32 long_refresh)
 			best = &vmode->crtc[i];
 	}
 
-	if (abs(best->refresh_rate - long_refresh) > 3)
-		return 60;
+	if (abs(best->refresh_rate - long_refresh) > 3) {
+		if (hres == 1200 && vres == 900)
+			return 50; /* OLPC DCON only supports 50 Hz */
+		else
+			return 60;
+	}
 
 	return best->refresh_rate;
 }
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 8c5bc41..260d339 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -606,7 +606,7 @@ static struct crt_mode_table CRTM1200x720[] = {
 /* 1200x900 (DCON) */
 static struct crt_mode_table DCON1200x900[] = {
 	/* r_rate,               hsp,               vsp   */
-	{REFRESH_60, M1200X900_R60_HSP, M1200X900_R60_VSP,
+	{REFRESH_50, M1200X900_R60_HSP, M1200X900_R60_VSP,
 	/* The correct htotal is 1240, but this doesn't raster on VX855. */
 	/* Via suggested changing to a multiple of 16, hence 1264.       */
 	/*  HT,   HA,  HBS, HBE,  HSS, HSE,  VT,  VA, VBS, VBE, VSS, VSE */
-- 
1.6.3.2

