Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab2I1UaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:30:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032799Ab2I1UaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 161/218] drm/radeon: fix dig encoder selection on DCE61
Date: Fri, 28 Sep 2012 13:16:18 -0700
Message-Id: <20120928201520.036437414@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 41fa54377057ab38bc3e08ebb46168a7daf2e63b upstream.

Was using the DCE41 code which was wrong. Fixes
blank displays on a number of Trinity systems.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |   31 ++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1769,13 +1769,34 @@ static int radeon_atom_pick_dig_encoder(
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(encoder->crtc);
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct drm_encoder *test_encoder;
-	struct radeon_encoder_atom_dig *dig;
+	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 	uint32_t dig_enc_in_use = 0;
 
-	/* DCE4/5 */
-	if (ASIC_IS_DCE4(rdev)) {
-		dig = radeon_encoder->enc_priv;
-		if (ASIC_IS_DCE41(rdev)) {
+	if (ASIC_IS_DCE6(rdev)) {
+		/* DCE6 */
+		switch (radeon_encoder->encoder_id) {
+		case ENCODER_OBJECT_ID_INTERNAL_UNIPHY:
+			if (dig->linkb)
+				return 1;
+			else
+				return 0;
+			break;
+		case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
+			if (dig->linkb)
+				return 3;
+			else
+				return 2;
+			break;
+		case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
+			if (dig->linkb)
+				return 5;
+			else
+				return 4;
+			break;
+		}
+	} else if (ASIC_IS_DCE4(rdev)) {
+		/* DCE4/5 */
+		if (ASIC_IS_DCE41(rdev) && !ASIC_IS_DCE61(rdev)) {
 			/* ontario follows DCE4 */
 			if (rdev->family == CHIP_PALM) {
 				if (dig->linkb)


