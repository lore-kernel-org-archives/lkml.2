Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab2KZRKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:10:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933488Ab2KZRKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:14 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Egbert Eich <eich@suse.de>, Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 165/270] drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy().
Date: Mon, 26 Nov 2012 14:57:35 -0200
Message-Id: <1353949160-26803-166-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.de>

commit 082918471139b07964967cfe5f70230909c82ae1 upstream.

radeon_i2c_fini() walks thru the list of I2C bus recs rdev->i2c_bus[]
to destroy each of them.
radeon_ext_tmds_enc_destroy() however also has code to destroy it's
associated I2C bus rec which has been obtained by radeon_i2c_lookup()
and is therefore also in the i2c_bus[] list.
This causes a double free resulting in a kernel panic when unloading
the radeon driver.
Removing destroy code from radeon_ext_tmds_enc_destroy() fixes this
problem.

agd5f: fix compiler warning

Signed-off-by: Egbert Eich <eich@suse.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index a0c8222..9e62325 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -974,11 +974,7 @@ static void radeon_legacy_tmds_ext_mode_set(struct drm_encoder *encoder,
 static void radeon_ext_tmds_enc_destroy(struct drm_encoder *encoder)
 {
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
-	struct radeon_encoder_ext_tmds *tmds = radeon_encoder->enc_priv;
-	if (tmds) {
-		if (tmds->i2c_bus)
-			radeon_i2c_destroy(tmds->i2c_bus);
-	}
+	/* don't destroy the i2c bus record here, this will be done in radeon_i2c_fini */
 	kfree(radeon_encoder->enc_priv);
 	drm_encoder_cleanup(encoder);
 	kfree(radeon_encoder);
-- 
1.7.9.5

