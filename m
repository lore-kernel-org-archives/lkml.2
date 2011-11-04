Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1KDMLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:11:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33331 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab1KDMJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:55 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-13-4eb3d611fd97
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 07/10] drm/exynos: restored kernel_fb_list when reiniting
 fb_helper
Date: Fri, 04 Nov 2011 21:09:56 +0900
Message-id: <1320408599-7475-8-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0200 (UTC)
 FILETIME=[9FDD3180:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonyoung Shim <jy0922.shim@samsung.com>

during recreating exynos_drm_fbdev as a new display device probes,
fb_helper is reinitialized but kernel fb is not changed
so kernel_fb_list should be restored after fb_helper is reinitialized.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
index 1f4b3d1..74092a8 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
@@ -405,6 +405,18 @@ int exynos_drm_fbdev_reinit(struct drm_device *dev)
 	fb_helper = private->fb_helper;
 
 	if (fb_helper) {
+		struct list_head temp_list;
+
+		INIT_LIST_HEAD(&temp_list);
+
+		/*
+		 * fb_helper is reintialized but kernel fb is reused
+		 * so kernel_fb_list need to be backuped and restored
+		 */
+		if (!list_empty(&fb_helper->kernel_fb_list))
+			list_replace_init(&fb_helper->kernel_fb_list,
+					&temp_list);
+
 		drm_fb_helper_fini(fb_helper);
 
 		ret = drm_fb_helper_init(dev, fb_helper,
@@ -414,6 +426,9 @@ int exynos_drm_fbdev_reinit(struct drm_device *dev)
 			return ret;
 		}
 
+		if (!list_empty(&temp_list))
+			list_replace(&temp_list, &fb_helper->kernel_fb_list);
+
 		ret = drm_fb_helper_single_add_all_connectors(fb_helper);
 		if (ret < 0) {
 			DRM_ERROR("failed to add fb helper to connectors\n");
-- 
1.7.4.1

