Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1HPCvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:51:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1HPCvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:51:46 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:55 2011
Message-Id: <20110816024455.856250121@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:43:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [25/26] drm/radeon/kms: dont try to be smart in the hpd handler
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d5811e8731213f80c80d89e980505052f16aca1c upstream.

Attempting to try and turn off disconnected display hw in the
hotput handler lead to more problems than it helped.  For
now just register an event and only attempt the do something
interesting with DP.  Other connectors are just too problematic:
- Some systems have an HPD pin assigned to LVDS, but it's rarely
if ever connected properly and we don't really care about hpd
events on LVDS anyway since it's always connected.
- The HPD pin is wired up correctly for eDP, but we don't really
have to do anything since the events since it's always connected.
- Some HPD pins fire more than once when you connect/disconnect
- etc.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=39882

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_dp.c       |   12 ++++++++++++
 drivers/gpu/drm/radeon/radeon_connectors.c |   14 ++++++--------
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 +
 3 files changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -613,6 +613,18 @@ static bool radeon_dp_get_link_status(st
 	return true;
 }
 
+bool radeon_dp_needs_link_train(struct radeon_connector *radeon_connector)
+{
+	u8 link_status[DP_LINK_STATUS_SIZE];
+	struct radeon_connector_atom_dig *dig = radeon_connector->con_priv;
+
+	if (!radeon_dp_get_link_status(radeon_connector, link_status))
+		return false;
+	if (dp_channel_eq_ok(link_status, dig->dp_lane_count))
+		return false;
+	return true;
+}
+
 struct radeon_dp_link_train_info {
 	struct radeon_device *rdev;
 	struct drm_encoder *encoder;
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -64,18 +64,16 @@ void radeon_connector_hotplug(struct drm
 	if (connector->dpms != DRM_MODE_DPMS_ON)
 		return;
 
-	/* powering up/down the eDP panel generates hpd events which
-	 * can interfere with modesetting.
-	 */
-	if (connector->connector_type == DRM_MODE_CONNECTOR_eDP)
-		return;
+	/* just deal with DP (not eDP) here. */
+	if (connector->connector_type == DRM_MODE_CONNECTOR_DisplayPort) {
+		int saved_dpms = connector->dpms;
 
-	/* pre-r600 did not always have the hpd pins mapped accurately to connectors */
-	if (rdev->family >= CHIP_R600) {
-		if (radeon_hpd_sense(rdev, radeon_connector->hpd.hpd))
+		if (radeon_hpd_sense(rdev, radeon_connector->hpd.hpd) &&
+		    radeon_dp_needs_link_train(radeon_connector))
 			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
 		else
 			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
+		connector->dpms = saved_dpms;
 	}
 }
 
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -479,6 +479,7 @@ extern void radeon_dp_set_link_config(st
 				      struct drm_display_mode *mode);
 extern void radeon_dp_link_train(struct drm_encoder *encoder,
 				 struct drm_connector *connector);
+extern bool radeon_dp_needs_link_train(struct radeon_connector *radeon_connector);
 extern u8 radeon_dp_getsinktype(struct radeon_connector *radeon_connector);
 extern bool radeon_dp_getdpcd(struct radeon_connector *radeon_connector);
 extern void atombios_dig_encoder_setup(struct drm_encoder *encoder, int action, int panel_mode);


