Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030194Ab2HGWb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:31:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815Ab2HGWbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:31:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 082/122] drm/radeon: on hotplug force link training to happen (v2)
Date: Tue,  7 Aug 2012 15:26:10 -0700
Message-Id: <20120807221956.374625476@linuxfoundation.org>
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

commit ca2ccde5e2f24a792caa4cca919fc5c6f65d1887 upstream.

To have DP behave like VGA/DVI we need to retrain the link
on hotplug. For this to happen we need to force link
training to happen by setting connector dpms to off
before asking it turning it on again.

v2: agd5f
- drop the dp_get_link_status() change in atombios_dp.c
  for now.  We still need the dpms OFF change.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -79,10 +79,16 @@ void radeon_connector_hotplug(struct drm
 		if (dig_connector->dp_sink_type == CONNECTOR_OBJECT_ID_DISPLAYPORT) {
 			int saved_dpms = connector->dpms;
 			/* Only turn off the display if it's physically disconnected */
-			if (!radeon_hpd_sense(rdev, radeon_connector->hpd.hpd))
+			if (!radeon_hpd_sense(rdev, radeon_connector->hpd.hpd)) {
 				drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
-			else if (radeon_dp_needs_link_train(radeon_connector))
+			} else if (radeon_dp_needs_link_train(radeon_connector)) {
+				/* set it to OFF so that drm_helper_connector_dpms()
+				 * won't return immediately since the current state
+				 * is ON at this point.
+				 */
+				connector->dpms = DRM_MODE_DPMS_OFF;
 				drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
+			}
 			connector->dpms = saved_dpms;
 		}
 	}


