Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1KDMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:09:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1KDMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:54 -0400
X-AuditID: cbfee61b-b7b7fae000005864-ff-4eb3d61000ee
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 02/10] drm/exynos: added kms poll for handling hpd event
Date: Fri, 04 Nov 2011 21:09:51 +0900
Message-id: <1320408599-7475-3-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0138 (UTC)
 FILETIME=[9FD3BBA0:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds kms poll infrastructure to handle hotplug detection event

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c |    5 +++++
 drivers/gpu/drm/exynos/exynos_drm_fb.c  |   12 ++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index 83810cb..53e2216 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -27,6 +27,7 @@
 
 #include "drmP.h"
 #include "drm.h"
+#include "drm_crtc_helper.h"
 
 #include <drm/exynos_drm.h>
 
@@ -61,6 +62,9 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
 
 	drm_mode_config_init(dev);
 
+	/* init kms poll for handling hpd */
+	drm_kms_helper_poll_init(dev);
+
 	exynos_drm_mode_config_init(dev);
 
 	/*
@@ -116,6 +120,7 @@ static int exynos_drm_unload(struct drm_device *dev)
 	exynos_drm_fbdev_fini(dev);
 	exynos_drm_device_unregister(dev);
 	drm_vblank_cleanup(dev);
+	drm_kms_helper_poll_fini(dev);
 	drm_mode_config_cleanup(dev);
 	kfree(dev->dev_private);
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fb.c b/drivers/gpu/drm/exynos/exynos_drm_fb.c
index 48d29cf..7d91a54 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fb.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fb.c
@@ -29,7 +29,9 @@
 #include "drmP.h"
 #include "drm_crtc.h"
 #include "drm_crtc_helper.h"
+#include "drm_fb_helper.h"
 
+#include "exynos_drm_drv.h"
 #include "exynos_drm_fb.h"
 #include "exynos_drm_buf.h"
 #include "exynos_drm_gem.h"
@@ -238,8 +240,18 @@ struct exynos_drm_buf_entry *exynos_drm_fb_get_buf(struct drm_framebuffer *fb)
 	return entry;
 }
 
+static void exynos_drm_output_poll_changed(struct drm_device *dev)
+{
+	struct exynos_drm_private *private = dev->dev_private;
+	struct drm_fb_helper *fb_helper = private->fb_helper;
+
+	if (fb_helper)
+		drm_fb_helper_hotplug_event(fb_helper);
+}
+
 static struct drm_mode_config_funcs exynos_drm_mode_config_funcs = {
 	.fb_create = exynos_drm_fb_create,
+	.output_poll_changed = exynos_drm_output_poll_changed,
 };
 
 void exynos_drm_mode_config_init(struct drm_device *dev)
-- 
1.7.4.1

