Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1DZM0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57258 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1DZM0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:30 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 07/21] drm/radeon/kms/atom: set sane defaults in atombios_get_encoder_mode()" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:27 +0200
Message-Id: <1303820787-3584-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 07/21] drm/radeon/kms/atom: set sane defaults in atombios_get_encoder_mode()

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From d90cc9b9d2dc0fa19f37cd019c07a982c96809ba Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 17 Nov 2010 02:49:40 -0500
Subject: [PATCH 07/21] drm/radeon/kms/atom: set sane defaults in atombios_get_encoder_mode()

commit c7a71fc761551dc8be8543f14a90d08cda4e77f9 upstream.

If there was no connector mapped to the encoder, atombios_get_encoder_mode()
returned 0 which is the id for DP.  Return something sane instead based on
the encoder id.  This avoids hitting the DP paths on non-DP encoders.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_encoders.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/radeon/radeon_encoders.c
index 7626bd5..ea55516 100644
--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -587,11 +587,23 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector;
 	struct radeon_connector_atom_dig *radeon_dig_connector;
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
--
1.7.0.4

