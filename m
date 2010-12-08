Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab0LHB15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:27:57 -0500
Received: from kroah.org ([198.145.64.141]:33441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab0LHBCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:22 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:38 2010
Message-Id: <20101208005738.858162825@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [174/289] drm/radeon/kms/atom: set sane defaults in atombios_get_encoder_mode()
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit c7a71fc761551dc8be8543f14a90d08cda4e77f9 upstream.

If there was no connector mapped to the encoder, atombios_get_encoder_mode()
returned 0 which is the id for DP.  Return something sane instead based on
the encoder id.  This avoids hitting the DP paths on non-DP encoders.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -595,6 +595,7 @@ atombios_digital_setup(struct drm_encode
 int
 atombios_get_encoder_mode(struct drm_encoder *encoder)
 {
+	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct drm_device *dev = encoder->dev;
 	struct radeon_device *rdev = dev->dev_private;
 	struct drm_connector *connector;
@@ -602,9 +603,20 @@ atombios_get_encoder_mode(struct drm_enc
 	struct radeon_connector_atom_dig *dig_connector;
 
 	connector = radeon_get_connector_for_encoder(encoder);
-	if (!connector)
-		return 0;
-
+	if (!connector) {
+		switch (radeon_encoder->encoder_id) {
+		case ENCODER_OBJECT_ID_INTERNAL_UNIPHY:
+		case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
+		case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
+		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_LVTMA:
+		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_DVO1:
+			return ATOM_ENCODER_MODE_DVI;
+		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_DAC1:
+		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_DAC2:
+		default:
+			return ATOM_ENCODER_MODE_CRT;
+		}
+	}
 	radeon_connector = to_radeon_connector(connector);
 
 	switch (connector->connector_type) {


