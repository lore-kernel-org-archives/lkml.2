Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab2DSVIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:08:50 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46047 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab2DSVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:08:46 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 17:08:29 EDT
Message-Id: <20120419210309.239934422@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:04:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oleksij Rempel <bug-track@fisher-privat.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 72/75] drm/i915: Hold mode_config lock whilst changing mode for lastclose()
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit c291be9dba370ba696a0d482249a212cf5c15f45 upstream.

Upon lastclose(), we switch back to the fbcon configuration. This
requires taking the mode_config lock in order to serialise the change
with output probing elsewhere.

Reported-by: Oleksij Rempel <bug-track@fisher-privat.net>
References: https://bugs.freedesktop.org/show_bug.cgi?id=48652
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_fb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -283,6 +283,8 @@ void intel_fb_restore_mode(struct drm_de
 	struct drm_mode_config *config = &dev->mode_config;
 	struct drm_plane *plane;
 
+	mutex_lock(&dev->mode_config.mutex);
+
 	ret = drm_fb_helper_restore_fbdev_mode(&dev_priv->fbdev->helper);
 	if (ret)
 		DRM_DEBUG("failed to restore crtc mode\n");
@@ -290,4 +292,6 @@ void intel_fb_restore_mode(struct drm_de
 	/* Be sure to shut off any planes that may be active */
 	list_for_each_entry(plane, &config->plane_list, head)
 		plane->funcs->disable_plane(plane);
+
+	mutex_unlock(&dev->mode_config.mutex);
 }


