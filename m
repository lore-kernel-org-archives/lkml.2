Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1JKRGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:06:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1JKRGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:06:39 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:10 2011
Message-Id: <20111011165710.757744574@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:26 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [16/38] drm/radeon/kms: Fix logic error in DP HPD handler
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5ba7ddf81634bfdf32d09261d2959e3f5b7c4263 upstream.

Only disable the pipe if the monitor is physically
disconnected.  The previous logic also disabled the
pipe if the link was trained.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=41248

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -68,11 +68,11 @@ void radeon_connector_hotplug(struct drm
 	if (connector->connector_type == DRM_MODE_CONNECTOR_DisplayPort) {
 		int saved_dpms = connector->dpms;
 
-		if (radeon_hpd_sense(rdev, radeon_connector->hpd.hpd) &&
-		    radeon_dp_needs_link_train(radeon_connector))
-			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
-		else
+		/* Only turn off the display it it's physically disconnected */
+		if (!radeon_hpd_sense(rdev, radeon_connector->hpd.hpd))
 			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
+		else if (radeon_dp_needs_link_train(radeon_connector))
+			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
 		connector->dpms = saved_dpms;
 	}
 }


