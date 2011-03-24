Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1CXNwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:52:44 -0400
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:63142
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752353Ab1CXNwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:52:43 -0400
X-Greylist: delayed 1305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 09:52:43 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915/lvds: Always return connected in the absence of better information
Date: Thu, 24 Mar 2011 13:30:44 +0000
Message-Id: <1300973444-6084-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <AANLkTikY23FxMVtqTNra05O3CxXZQ5=bvmppTiySHNq=@mail.gmail.com>
References: <AANLkTikY23FxMVtqTNra05O3CxXZQ5=bvmppTiySHNq=@mail.gmail.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LVDS connector should default to connected. We tried our best to
verify the claims of the BIOS that the hardware exists during init(),
and then during detect() we then try to verify that the panel is open.
In the event of an unsucessful query, we should then always report
that the LVDS panel is connected. This was only the case for gen3/4,
later generations leaked the return value from the panel probe instead.

Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 1a311ad..86cd30b 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -473,19 +473,13 @@ static enum drm_connector_status
 intel_lvds_detect(struct drm_connector *connector, bool force)
 {
 	struct drm_device *dev = connector->dev;
-	enum drm_connector_status status = connector_status_connected;
+	enum drm_connector_status status;
 
 	status = intel_panel_detect(dev);
 	if (status != connector_status_unknown)
 		return status;
 
-	/* ACPI lid methods were generally unreliable in this generation, so
-	 * don't even bother.
-	 */
-	if (IS_GEN2(dev) || IS_GEN3(dev))
-		return connector_status_connected;
-
-	return status;
+	return connector_status_connected;
 }
 
 /**
-- 
1.7.4.1

