Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2J1XgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:36:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42144 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500Ab2J1X2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:11 -0400
Message-Id: <20121028231551.559258973@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:23 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Egbert Eich <eich@suse.de>, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 047/105] drm/radeon: Dont destroy I2C Bus Rec in
 radeon_ext_tmds_enc_destroy().
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index fb15b62..a13ad9d 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -991,11 +991,7 @@ static void radeon_legacy_tmds_ext_mode_set(struct drm_encoder *encoder,
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


