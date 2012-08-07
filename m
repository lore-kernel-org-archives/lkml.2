Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab2HGWbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:31:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab2HGWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:31:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 081/122] drm/radeon: fix hotplug of DP to DVI|HDMI passive adapters (v2)
Date: Tue,  7 Aug 2012 15:26:09 -0700
Message-Id: <20120807221956.266051409@linuxfoundation.org>
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

commit 266dcba541a1ef7e5d82d9e67c67fde2910636e8 upstream.

No need to retrain the link for passive adapters.

v2: agd5f
- no passive DP to VGA adapters, update comments
- assign radeon_connector_atom_dig after we are sure
  we have a digital connector as analog connectors
  have different private data.
- get new sink type before checking for retrain.  No
  need to check if it's no longer a DP connection.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -64,14 +64,27 @@ void radeon_connector_hotplug(struct drm
 
 	/* just deal with DP (not eDP) here. */
 	if (connector->connector_type == DRM_MODE_CONNECTOR_DisplayPort) {
-		int saved_dpms = connector->dpms;
+		struct radeon_connector_atom_dig *dig_connector =
+			radeon_connector->con_priv;
 
-		/* Only turn off the display it it's physically disconnected */
-		if (!radeon_hpd_sense(rdev, radeon_connector->hpd.hpd))
-			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
-		else if (radeon_dp_needs_link_train(radeon_connector))
-			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
-		connector->dpms = saved_dpms;
+		/* if existing sink type was not DP no need to retrain */
+		if (dig_connector->dp_sink_type != CONNECTOR_OBJECT_ID_DISPLAYPORT)
+			return;
+
+		/* first get sink type as it may be reset after (un)plug */
+		dig_connector->dp_sink_type = radeon_dp_getsinktype(radeon_connector);
+		/* don't do anything if sink is not display port, i.e.,
+		 * passive dp->(dvi|hdmi) adaptor
+		 */
+		if (dig_connector->dp_sink_type == CONNECTOR_OBJECT_ID_DISPLAYPORT) {
+			int saved_dpms = connector->dpms;
+			/* Only turn off the display if it's physically disconnected */
+			if (!radeon_hpd_sense(rdev, radeon_connector->hpd.hpd))
+				drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
+			else if (radeon_dp_needs_link_train(radeon_connector))
+				drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
+			connector->dpms = saved_dpms;
+		}
 	}
 }
 


