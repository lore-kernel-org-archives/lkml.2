Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2GaFFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:05:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48576 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370Ab2GaEuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:13 -0400
Message-Id: <20120731044322.812127633@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 71/73] drm/radeon: on hotplug force link training to happen (v2)
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 3524f17..895e628 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -79,10 +79,16 @@ void radeon_connector_hotplug(struct drm_connector *connector)
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


