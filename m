Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917Ab2BJXLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:11:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab2BJWmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:46 -0500
MIME-Version: 1.0
Message-Id: <20120210222948.070979196@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [patch 34/86] drm/radeon/kms: fix TRAVIS panel setup
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 304a48400d9718f74ec35ae46f30868a5f4c4516 upstream.

Different versions of the DP to LVDS bridge chip
need different panel mode settings depending on
the chip version used.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=41569

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_dp.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -564,9 +564,21 @@ int radeon_dp_get_panel_mode(struct drm_
 	    ENCODER_OBJECT_ID_NUTMEG)
 		panel_mode = DP_PANEL_MODE_INTERNAL_DP1_MODE;
 	else if (radeon_connector_encoder_get_dp_bridge_encoder_id(connector) ==
-		 ENCODER_OBJECT_ID_TRAVIS)
-		panel_mode = DP_PANEL_MODE_INTERNAL_DP2_MODE;
-	else if (connector->connector_type == DRM_MODE_CONNECTOR_eDP) {
+		 ENCODER_OBJECT_ID_TRAVIS) {
+		u8 id[6];
+		int i;
+		for (i = 0; i < 6; i++)
+			id[i] = radeon_read_dpcd_reg(radeon_connector, 0x503 + i);
+		if (id[0] == 0x73 &&
+		    id[1] == 0x69 &&
+		    id[2] == 0x76 &&
+		    id[3] == 0x61 &&
+		    id[4] == 0x72 &&
+		    id[5] == 0x54)
+			panel_mode = DP_PANEL_MODE_INTERNAL_DP1_MODE;
+		else
+			panel_mode = DP_PANEL_MODE_INTERNAL_DP2_MODE;
+	} else if (connector->connector_type == DRM_MODE_CONNECTOR_eDP) {
 		u8 tmp = radeon_read_dpcd_reg(radeon_connector, DP_EDP_CONFIGURATION_CAP);
 		if (tmp & 1)
 			panel_mode = DP_PANEL_MODE_INTERNAL_DP2_MODE;


