Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab2HIJBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:01:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37095 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab2HIJBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:01:09 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.59+drm33.26
Date: Thu,  9 Aug 2012 11:01:07 +0200
Message-Id: <1344502867-10186-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.59+drm33.26 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm: integer overflow in drm_mode_dirtyfb_ioctl()
* Linux 2.6.32.59+drm33.26

 Makefile                   |    2 +-
 drivers/gpu/drm/drm_crtc.c |    4 ++++
 include/drm/drm_mode.h     |    2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 7667dad..a9c82a4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .59+drm33.25
+EXTRAVERSION = .59+drm33.26
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 81ba0e6..ec9e97e 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1832,6 +1832,10 @@ int drm_mode_dirtyfb_ioctl(struct drm_device *dev,
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
