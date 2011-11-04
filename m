Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab1KDMLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:11:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1KDMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:54 -0400
X-AuditID: cbfee61b-b7b7fae000005864-02-4eb3d6102624
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 04/10] drm/exynos: fixed converting between display mode and
 timing
Date: Fri, 04 Nov 2011 21:09:53 +0900
Message-id: <1320408599-7475-5-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0169 (UTC)
 FILETIME=[9FD87690:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

missing members are added into converting function between timing and display
mode and refresh rate of display mode is calculated by drm mode function.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_connector.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_connector.c b/drivers/gpu/drm/exynos/exynos_drm_connector.c
index d1a459f..7ca1274 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_connector.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_connector.c
@@ -47,6 +47,7 @@ convert_to_display_mode(struct drm_display_mode *mode,
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
 	mode->clock = timing->pixclock / 1000;
+	mode->vrefresh = timing->refresh;
 
 	mode->hdisplay = timing->xres;
 	mode->hsync_start = mode->hdisplay + timing->left_margin;
@@ -57,6 +58,12 @@ convert_to_display_mode(struct drm_display_mode *mode,
 	mode->vsync_start = mode->vdisplay + timing->upper_margin;
 	mode->vsync_end = mode->vsync_start + timing->vsync_len;
 	mode->vtotal = mode->vsync_end + timing->lower_margin;
+
+	if (timing->vmode & FB_VMODE_INTERLACED)
+		mode->flags |= DRM_MODE_FLAG_INTERLACE;
+
+	if (timing->vmode & FB_VMODE_DOUBLE)
+		mode->flags |= DRM_MODE_FLAG_DBLSCAN;
 }
 
 /* convert drm_display_mode to exynos_video_timings */
@@ -69,7 +76,7 @@ convert_to_video_timing(struct fb_videomode *timing,
 	memset(timing, 0, sizeof(*timing));
 
 	timing->pixclock = mode->clock * 1000;
-	timing->refresh = mode->vrefresh;
+	timing->refresh = drm_mode_vrefresh(mode);
 
 	timing->xres = mode->hdisplay;
 	timing->left_margin = mode->hsync_start - mode->hdisplay;
-- 
1.7.4.1

