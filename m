Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2L0BB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 20:01:56 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32854 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2L0BBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 20:01:53 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH] drm: make frame duration time calculation more precise
Date: Thu, 27 Dec 2012 09:01:46 +0800
Message-Id: <1356570106-2263-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a bit more precise to compute the total number of pixels first and
then divide, rather than multiplying the line pixel count by the
already-rounded line duration.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/drm_irq.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 19c01ca..05c91e0 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -505,6 +505,7 @@ void drm_calc_timestamping_constants(struct drm_crtc *crtc)
 
 	/* Valid dotclock? */
 	if (dotclock > 0) {
+		int frame_size;
 		/* Convert scanline length in pixels and video dot clock to
 		 * line duration, frame duration and pixel duration in
 		 * nanoseconds:
@@ -512,7 +513,10 @@ void drm_calc_timestamping_constants(struct drm_crtc *crtc)
 		pixeldur_ns = (s64) div64_u64(1000000000, dotclock);
 		linedur_ns  = (s64) div64_u64(((u64) crtc->hwmode.crtc_htotal *
 					      1000000000), dotclock);
-		framedur_ns = (s64) crtc->hwmode.crtc_vtotal * linedur_ns;
+		frame_size = crtc->hwmode.crtc_htotal *
+				crtc->hwmode.crtc_vtotal;
+		framedur_ns = (s64) div64_u64((u64) frame_size * 1000000000,
+					      dotclock);
 	} else
 		DRM_ERROR("crtc %d: Can't calculate constants, dotclock = 0!\n",
 			  crtc->base.id);
-- 
1.7.7.3

