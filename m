Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab2DKXWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:22:55 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51056 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965064Ab2DKXWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:22:50 -0400
Message-Id: <20120411231040.338535038@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 29/59] drm/i915: Add lock on drm_helper_resume_force_mode
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Paul <seanpaul@chromium.org>

commit 927a2f119e8235238a2fc64871051b16c9bdae75 upstream.

i915_drm_thaw was not locking the mode_config lock when calling
drm_helper_resume_force_mode. When there were multiple wake sources,
this caused FDI training failure on SNB which in turn corrupted the
display.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -508,7 +508,9 @@ static int i915_drm_thaw(struct drm_devi
 		drm_irq_install(dev);
 
 		/* Resume the modeset for every activated CRTC */
+		mutex_lock(&dev->mode_config.mutex);
 		drm_helper_resume_force_mode(dev);
+		mutex_unlock(&dev->mode_config.mutex);
 
 		if (IS_IRONLAKE_M(dev))
 			ironlake_enable_rc6(dev);


