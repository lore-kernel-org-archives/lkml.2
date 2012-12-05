Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2LETAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:00:11 -0500
Received: from mail.tpi.com ([70.99.223.143]:4629 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab2LETAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:00:10 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 3.7-rc8] drm: Fix possible EDID memory allocation oops
Date: Wed,  5 Dec 2012 12:00:03 -0700
Message-Id: <1354734003-92714-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The result of drm_property_create_blob() is not checked for success
which could lead to a NULL pointer dereference.

I was led to this by a smatch warning:

drivers/gpu/drm/drm_crtc.c:3186 drm_mode_connector_update_edid_property() error: potential null dereference 'connector->edid_blob_ptr'.  (drm_property_create_blob returns null)

drm_property_create_blob() calls kzalloc() which can return NULL.

Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

This bug actually exists in the original commit f453ba0460742ad027ae0c4c7d61e62817b3e7ef
(2.6.29), but I only checked as far back as 3.0 for stable.

 drivers/gpu/drm/drm_crtc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index ef1b221..31872ba 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -3180,6 +3180,10 @@ int drm_mode_connector_update_edid_property(struct drm_connector *connector,
 	size = EDID_LENGTH * (1 + edid->extensions);
 	connector->edid_blob_ptr = drm_property_create_blob(connector->dev,
 							    size, edid);
+	if (!connector->edid_blob_ptr) {
+		pr_err("drm: Could not allocate %d edid blob bytes.\n", size);
+		return -ENOMEM;
+	}
 
 	ret = drm_connector_property_set_value(connector,
 					       dev->mode_config.edid_property,
-- 
1.7.9.5

