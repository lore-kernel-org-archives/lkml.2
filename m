Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2HGX05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:26:57 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57779 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030251Ab2HGWbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:31:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 083/122] drm/radeon: fix dpms on/off on trinity/aruba v2
Date: Tue,  7 Aug 2012 15:26:11 -0700
Message-Id: <20120807221956.499201202@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit fcedac670c3da0d17aaa5db1708694971e8024a9 upstream.

The external encoder need to be setup again before enabling the
transmiter. This seems to be only needed on some trinity/aruba
to fix dpms on.

v2: Add comment, only setup again on dce6 ie aruba or newer.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1392,10 +1392,18 @@ radeon_atom_encoder_dpms_dig(struct drm_
 	case DRM_MODE_DPMS_ON:
 		/* some early dce3.2 boards have a bug in their transmitter control table */
 		if ((rdev->family == CHIP_RV710) || (rdev->family == CHIP_RV730) ||
-		    ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev))
+		    ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
+			if (ASIC_IS_DCE6(rdev)) {
+				/* It seems we need to call ATOM_ENCODER_CMD_SETUP again
+				 * before reenabling encoder on DPMS ON, otherwise we never
+				 * get picture
+				 */
+				atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
+			}
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
-		else
+		} else {
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
+		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
 			if (connector->connector_type == DRM_MODE_CONNECTOR_eDP) {
 				atombios_set_edp_panel_power(connector,


