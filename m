Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0LMAHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:07:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36316 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab0LLXrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:12 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [129/223] drm/radeon/kms/atom: set sane defaults in atombios_get_encoder_mode()
Message-Id: <20101212234711.274A2B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit c7a71fc761551dc8be8543f14a90d08cda4e77f9 upstream.

If there was no connector mapped to the encoder, atombios_get_encoder_mode()
returned 0 which is the id for DP.  Return something sane instead based on
the encoder id.  This avoids hitting the DP paths on non-DP encoders.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

Index: linux/drivers/gpu/drm/radeon/radeon_encoders.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/radeon_encoders.c
+++ linux/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -626,11 +626,23 @@ atombios_get_encoder_mode(struct drm_enc
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector;
 	struct radeon_connector_atom_dig *dig_connector;
+	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 
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
