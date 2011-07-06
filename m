Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1GFXar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:30:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36843 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab1GFXao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:30:44 -0400
From: reimth@googlemail.com
To: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Thomas Reim <rdratlos@yahoo.co.uk>
Subject: [PATCH 1/3] drm: Separate EDID Header Check from EDID Block Check
Date: Thu,  7 Jul 2011 01:30:12 +0200
Message-Id: <1309995012-5873-4-git-send-email-reimth@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1309995012-5873-1-git-send-email-reimth@gmail.com>
References: <1309995012-5873-1-git-send-email-reimth@gmail.com>
In-Reply-To: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
References: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Reim <rdratlos@yahoo.co.uk>

    Provides function drm_edid_header_is_valid() for EDID header check
    and replaces EDID header check part of function drm_edid_block_valid()
    by a call of drm_edid_header_is_valid().
    This is a prerequisite to extend DDC probing, e. g. in function
    radeon_ddc_probe() for Radeon devices, by a central EDID header check.

    Tested for kernel 2.35, 2.38 and 3.0

Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>
---
 drivers/gpu/drm/drm_edid.c |   24 ++++++++++++++++++------
 include/drm/drm_crtc.h     |    1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 0929219..1bbb85b 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -127,6 +127,23 @@ static const u8 edid_header[] = {
 	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00
 };
 
+ /*
+ * Sanity check the header of the base EDID block.  Return 8 if the header
+ * is perfect, down to 0 if it's totally wrong.
+ */
+int drm_edid_header_is_valid(const u8 *raw_edid)
+{
+	int i, score = 0;
+
+	for (i = 0; i < sizeof(edid_header); i++)
+		if (raw_edid[i] == edid_header[i])
+			score++;
+
+	return score;
+}
+EXPORT_SYMBOL(drm_edid_header_is_valid);
+
+
 /*
  * Sanity check the EDID block (base or extension).  Return 0 if the block
  * doesn't check out, or 1 if it's valid.
@@ -139,12 +156,7 @@ drm_edid_block_valid(u8 *raw_edid)
 	struct edid *edid = (struct edid *)raw_edid;
 
 	if (raw_edid[0] == 0x00) {
-		int score = 0;
-
-		for (i = 0; i < sizeof(edid_header); i++)
-			if (raw_edid[i] == edid_header[i])
-				score++;
-
+		int score = drm_edid_header_is_valid(raw_edid);
 		if (score == 8) ;
 		else if (score >= 6) {
 			DRM_DEBUG("Fixing EDID header, your hardware may be failing\n");
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 33d12f8..0ec3687 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -802,6 +802,7 @@ extern struct drm_display_mode *drm_gtf_mode_complex(struct drm_device *dev,
 extern int drm_add_modes_noedid(struct drm_connector *connector,
 				int hdisplay, int vdisplay);
 
+extern int drm_edid_header_is_valid(const u8 *raw_edid);
 extern bool drm_edid_is_valid(struct edid *edid);
 struct drm_display_mode *drm_mode_find_dmt(struct drm_device *dev,
 					   int hsize, int vsize, int fresh);
-- 
1.7.1

