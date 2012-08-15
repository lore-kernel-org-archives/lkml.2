Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2HOTs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:48:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:36320 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab2HOTsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:48:53 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Xi Wang <xi.wang@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 006/165] drm: integer overflow in drm_mode_dirtyfb_ioctl()
Date: Wed, 15 Aug 2012 15:45:50 -0400
Message-ID: <1345060109-9187-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xi Wang <xi.wang@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a5cd335165e31db9dbab636fd29895d41da55dd2 upstream.

There is a potential integer overflow in drm_mode_dirtyfb_ioctl()
if userspace passes in a large num_clips.  The call to kmalloc would
allocate a small buffer, and the call to fb->funcs->dirty may result
in a memory corruption.

Reported-by: Haogang Chen <haogangchen@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/drm_crtc.c | 4 ++++
 include/drm/drm_mode.h     | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 1a224f8..819d0dc 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1833,6 +1833,10 @@ int drm_mode_dirtyfb_ioctl(struct drm_device *dev,
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
index c5ba163..9cf639c 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -232,6 +232,8 @@ struct drm_mode_fb_cmd {
 #define DRM_MODE_FB_DIRTY_ANNOTATE_FILL 0x02
 #define DRM_MODE_FB_DIRTY_FLAGS         0x03
 
+#define DRM_MODE_FB_DIRTY_MAX_CLIPS     256
+
 /*
  * Mark a region of a framebuffer as dirty.
  *
-- 
1.7.12.rc2

