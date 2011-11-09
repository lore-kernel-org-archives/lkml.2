Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab1KJDgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:36:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935894Ab1KJDgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:36:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:44 2011
Message-Id: <20111109213144.626155215@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [025/264] drm/radeon/kms: handle !force case in connector detect more gracefully
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d0d0a225e6ad43314c9aa7ea081f76adc5098ad4 upstream.

When force == false, we don't do load detection in the connector
detect functions.  Unforunately, we also return the previous
connector state so we never get disconnect events for DVI-I, DVI-A,
or VGA.  Save whether we detected the monitor via load detection
previously and use that to determine whether we return the previous
state or not.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=41561

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |   23 ++++++++++++++++++++---
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 +
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -724,6 +724,7 @@ radeon_vga_detect(struct drm_connector *
 		dret = radeon_ddc_probe(radeon_connector,
 					radeon_connector->requires_extended_probe);
 	if (dret) {
+		radeon_connector->detected_by_load = false;
 		if (radeon_connector->edid) {
 			kfree(radeon_connector->edid);
 			radeon_connector->edid = NULL;
@@ -750,12 +751,21 @@ radeon_vga_detect(struct drm_connector *
 	} else {
 
 		/* if we aren't forcing don't do destructive polling */
-		if (!force)
-			return connector->status;
+		if (!force) {
+			/* only return the previous status if we last
+			 * detected a monitor via load.
+			 */
+			if (radeon_connector->detected_by_load)
+				return connector->status;
+			else
+				return ret;
+		}
 
 		if (radeon_connector->dac_load_detect && encoder) {
 			encoder_funcs = encoder->helper_private;
 			ret = encoder_funcs->detect(encoder, connector);
+			if (ret == connector_status_connected)
+				radeon_connector->detected_by_load = true;
 		}
 	}
 
@@ -897,6 +907,7 @@ radeon_dvi_detect(struct drm_connector *
 		dret = radeon_ddc_probe(radeon_connector,
 					radeon_connector->requires_extended_probe);
 	if (dret) {
+		radeon_connector->detected_by_load = false;
 		if (radeon_connector->edid) {
 			kfree(radeon_connector->edid);
 			radeon_connector->edid = NULL;
@@ -964,8 +975,13 @@ radeon_dvi_detect(struct drm_connector *
 	    (connector->connector_type == DRM_MODE_CONNECTOR_HDMIA))
 		goto out;
 
+	/* if we aren't forcing don't do destructive polling */
 	if (!force) {
-		ret = connector->status;
+		/* only return the previous status if we last
+		 * detected a monitor via load.
+		 */
+		if (radeon_connector->detected_by_load)
+			ret = connector->status;
 		goto out;
 	}
 
@@ -989,6 +1005,7 @@ radeon_dvi_detect(struct drm_connector *
 					ret = encoder_funcs->detect(encoder, connector);
 					if (ret == connector_status_connected) {
 						radeon_connector->use_digital = false;
+						radeon_connector->detected_by_load = true;
 					}
 				}
 				break;
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -447,6 +447,7 @@ struct radeon_connector {
 	struct edid *edid;
 	void *con_priv;
 	bool dac_load_detect;
+	bool detected_by_load; /* if the connection status was determined by load */
 	uint16_t connector_object_id;
 	struct radeon_hpd hpd;
 	struct radeon_router router;


