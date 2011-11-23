Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab1KWGMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:12:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35097 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1KWGMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:12:05 -0500
From: Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [PATCH] drm: integer overflow in drm_mode_dirtyfb_ioctl()
Date: Wed, 23 Nov 2011 01:12:01 -0500
Message-Id: <B02AED60-3DF4-4E8B-AAEC-EF411AAA99F8@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        security@kernel.org
To: David Airlie <airlied@linux.ie>
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential integer overflow in drm_mode_dirtyfb_ioctl()
if userspace passes in a large num_clips.  The call to kmalloc would
allocate a small buffer, and the call to fb->funcs->dirty may result
in a memory corruption.

Reported-by: Haogang Chen <haogangchen@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/gpu/drm/drm_crtc.c |    4 ++++
 include/drm/drm_mode.h     |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 405c63b..8323fc3 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1873,6 +1873,10 @@ int drm_mode_dirtyfb_ioctl(struct drm_device *dev,
 	}
 
 	if (num_clips && clips_ptr) {
+		if (num_clips < 0 || num_clips > DRM_MODE_FB_DIRTY_MAX_CLIPS) {
+			ret = -EINVAL;
+			goto out_err1;
+		}
 		clips = kzalloc(num_clips * sizeof(*clips), GFP_KERNEL);
 		if (!clips) {
 			ret = -ENOMEM;
diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index d30bedf..ddd46db 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -235,6 +235,8 @@ struct drm_mode_fb_cmd {
 #define DRM_MODE_FB_DIRTY_ANNOTATE_FILL 0x02
 #define DRM_MODE_FB_DIRTY_FLAGS         0x03
 
+#define DRM_MODE_FB_DIRTY_MAX_CLIPS     256
+
 /*
  * Mark a region of a framebuffer as dirty.
  *
-- 
1.7.5.4

