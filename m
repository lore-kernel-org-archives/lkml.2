Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0LHCDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:03:47 -0500
Received: from kroah.org ([198.145.64.141]:48306 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab0LHA7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:02 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:22 2010
Message-Id: <20101208005722.013652358@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [006/289] drm/radeon/kms: dont disable shared encoders on pre-DCE3 display blocks
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/gpu/drm/radeon/radeon_encoders.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -1547,6 +1547,23 @@ static void radeon_atom_encoder_disable(
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
@@ -1586,6 +1603,7 @@ static void radeon_atom_encoder_disable(
 		break;
 	}
 
+disable_done:
 	if (radeon_encoder_is_digital(encoder)) {
 		if (atombios_get_encoder_mode(encoder) == ATOM_ENCODER_MODE_HDMI)
 			r600_hdmi_disable(encoder);


