Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0LLXpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44569 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0LLXpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:02 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [6/223] drm/radeon/kms: don't disable shared encoders on pre-DCE3 display blocks
Message-Id: <20101212234501.0D351B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit a0ae5864d42b41c411368bd689462bf063c029c8 upstream.

The A/B links aren't independantly useable on these blocks so when
we disable the encoders, make sure to only disable the encoder when
there is no connector using it.

Should fix:
https://bugs.freedesktop.org/show_bug.cgi?id=18564

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux/drivers/gpu/drm/radeon/radeon_encoders.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/radeon_encoders.c
+++ linux/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -1545,6 +1545,23 @@ static void radeon_atom_encoder_disable(
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct radeon_encoder_atom_dig *dig;
+
+	/* check for pre-DCE3 cards with shared encoders;
+	 * can't really use the links individually, so don't disable
+	 * the encoder if it's in use by another connector
+	 */
+	if (!ASIC_IS_DCE3(rdev)) {
+		struct drm_encoder *other_encoder;
+		struct radeon_encoder *other_radeon_encoder;
+
+		list_for_each_entry(other_encoder, &dev->mode_config.encoder_list, head) {
+			other_radeon_encoder = to_radeon_encoder(other_encoder);
+			if ((radeon_encoder->encoder_id == other_radeon_encoder->encoder_id) &&
+			    drm_helper_encoder_in_use(other_encoder))
+				goto disable_done;
+		}
+	}
+
 	radeon_atom_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
 
 	switch (radeon_encoder->encoder_id) {
@@ -1584,6 +1601,7 @@ static void radeon_atom_encoder_disable(
 		break;
 	}
 
+disable_done:
 	if (radeon_encoder_is_digital(encoder)) {
 		if (atombios_get_encoder_mode(encoder) == ATOM_ENCODER_MODE_HDMI)
 			r600_hdmi_disable(encoder);
