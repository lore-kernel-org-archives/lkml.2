Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1HEVrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:47:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53864 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752177Ab1HEVrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:47:21 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+cCv4BMiOcFj6/ew8Qn0V+mdA2lNCshnBH+HMY7c
	4HTCYjh9wKT5qo
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 6/6] viafb: remove 640x480-60 CRT special case
Date: Fri,  5 Aug 2011 22:05:58 +0000
Message-Id: <1312581958-4273-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timing for 640x480-60 was handled different than all others.
This patch changes this by changing the blanking start and end.
The reason for this is that I can't find any reason for the old
behaviour and it was not consistent anyway as the special case for
LCD did not always trigger as the LCD code does not use this
function and it did trigger regardless of whether the display set is
CRT or LCD but only based whether any DVI/LCD device exists.
There are no negative effects observed for CRT or DVI devices.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c      |   14 --------------
 drivers/video/via/viamode.c |    2 +-
 2 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 2050fb8..c5e7833 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1488,20 +1488,6 @@ void viafb_fill_crtc_timing(struct VideoModeTable *video_mode, int bpp_byte,
 	}
 
 	crt_reg = crt_table[index].crtc;
-
-	/* Mode 640x480 has border, but LCD/DFP didn't have border. */
-	/* So we would delete border. */
-	if ((viafb_LCD_ON | viafb_DVI_ON)
-	    && video_mode->crtc[0].crtc.hor_addr == 640
-	    && video_mode->crtc[0].crtc.ver_addr == 480
-	    && refresh == 60) {
-		/* The border is 8 pixels. */
-		crt_reg.hor_blank_start = crt_reg.hor_blank_start - 8;
-
-		/* Blanking time should add left and right borders. */
-		crt_reg.hor_blank_end = crt_reg.hor_blank_end + 16;
-	}
-
 	crt_reg.hor_blank_end += crt_reg.hor_blank_start;
 	crt_reg.hor_sync_end += crt_reg.hor_sync_start;
 	crt_reg.ver_blank_end += crt_reg.ver_blank_start;
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 58df74e..8a9f4fc 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -281,7 +281,7 @@ static struct crt_mode_table CRTM640x480[] = {
 	/*r_rate,hsp,vsp */
 	/*HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
 	{REFRESH_60, M640X480_R60_HSP, M640X480_R60_VSP,
-	 {800, 640, 648, 144, 656, 96, 525, 480, 480, 45, 490, 2} },
+	 {800, 640, 640, 160, 656, 96, 525, 480, 480, 45, 490, 2} },
 	{REFRESH_75, M640X480_R75_HSP, M640X480_R75_VSP,
 	 {840, 640, 640, 200, 656, 64, 500, 480, 480, 20, 481, 3} },
 	{REFRESH_85, M640X480_R85_HSP, M640X480_R85_VSP,
-- 
1.6.3.2

