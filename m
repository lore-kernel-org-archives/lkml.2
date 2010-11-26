Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0KZSq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:46:27 -0500
Received: from home.keithp.com ([63.227.221.253]:42003 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab0KZSqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:46:13 -0500
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 2/2] drm: record monitor status in output_poll_execute
Date: Fri, 26 Nov 2010 10:45:59 -0800
Message-Id: <1290797159-3977-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290797159-3977-1-git-send-email-keithp@keithp.com>
References: <1290797159-3977-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to correctly report monitor connected status changes, the
previous monitor status must be recorded in the connector->status
value instead of being discarded.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/drm_crtc_helper.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 232ee93..7ca5935 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -848,7 +848,7 @@ static void output_poll_execute(struct work_struct *work)
 	struct delayed_work *delayed_work = to_delayed_work(work);
 	struct drm_device *dev = container_of(delayed_work, struct drm_device, mode_config.output_poll_work);
 	struct drm_connector *connector;
-	enum drm_connector_status old_status, status;
+	enum drm_connector_status old_status;
 	bool repoll = false, changed = false;
 
 	if (!drm_kms_helper_poll)
@@ -873,8 +873,9 @@ static void output_poll_execute(struct work_struct *work)
 		    !(connector->polled & DRM_CONNECTOR_POLL_HPD))
 			continue;
 
-		status = connector->funcs->detect(connector, false);
-		if (old_status != status)
+		connector->status = connector->funcs->detect(connector, false);
+		DRM_DEBUG_KMS("connector status updated to %d\n", connector->status);
+		if (old_status != connector->status)
 			changed = true;
 	}
 
-- 
1.7.2.3

