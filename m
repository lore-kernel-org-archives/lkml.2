Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048Ab2JSCta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:52428 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964974Ab2JSCtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Egbert Eich <eich@suse.de>, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 57/76] drm/radeon: Dont destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy().
Date: Thu, 18 Oct 2012 19:47:21 -0700
Message-Id: <20121019024359.292554513@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -974,11 +974,7 @@ static void radeon_legacy_tmds_ext_mode_
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


