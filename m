Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1HNQGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab1HNQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:53 2011
Message-Id: <20110812210553.765965532@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Reim <reimth@gmail.com>,
        Stephen Michaels <Stephen.Micheals@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [19/90] drm: Separate EDID Header Check from EDID Block Check
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Reim <reimth@gmail.com>

commit 051963d4832ed61e5ae74f5330b0a94489e101b9 upstream.

    Provides function drm_edid_header_is_valid() for EDID header check
    and replaces EDID header check part of function drm_edid_block_valid()
    by a call of drm_edid_header_is_valid().
    This is a prerequisite to extend DDC probing, e. g. in function
    radeon_ddc_probe() for Radeon devices, by a central EDID header check.

    Tested for kernel 2.6.35, 2.6.38 and 3.0

Signed-off-by: Thomas Reim <reimth@gmail.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Acked-by: Stephen Michaels <Stephen.Micheals@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_edid.c |   24 ++++++++++++++++++------
 include/drm/drm_crtc.h     |    1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

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
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -802,6 +802,7 @@ extern struct drm_display_mode *drm_gtf_
 extern int drm_add_modes_noedid(struct drm_connector *connector,
 				int hdisplay, int vdisplay);
 
+extern int drm_edid_header_is_valid(const u8 *raw_edid);
 extern bool drm_edid_is_valid(struct edid *edid);
 struct drm_display_mode *drm_mode_find_dmt(struct drm_device *dev,
 					   int hsize, int vsize, int fresh);


