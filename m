Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab0G3R63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:58:29 -0400
Received: from kroah.org ([198.145.64.141]:58978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319Ab0G3R5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:47 2010
Message-Id: <20100730175147.142053725@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        =?ISO-8859-15?q?Kristian=20H=C3=B8gsberg?= <krh@bitplanet.net>,
        Eric Anholt <eric@anholt.net>
Subject: [145/205] drm/i915: Hold the spinlock whilst resetting unpin_work along error path
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 468f0b44ce4b002ca7d9260f802a341854752c02 upstream.

Delay taking the mutex until we need to and ensure that we hold the
spinlock when resetting unpin_work on the error path. Also defer the
debugging print messages until after we have released the spinlock.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kristian Høgsberg <krh@bitplanet.net>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4239,8 +4239,6 @@ static int intel_crtc_page_flip(struct d
 	if (work == NULL)
 		return -ENOMEM;
 
-	mutex_lock(&dev->struct_mutex);
-
 	work->event = event;
 	work->dev = crtc->dev;
 	intel_fb = to_intel_framebuffer(crtc->fb);
@@ -4250,10 +4248,10 @@ static int intel_crtc_page_flip(struct d
 	/* We borrow the event spin lock for protecting unpin_work */
 	spin_lock_irqsave(&dev->event_lock, flags);
 	if (intel_crtc->unpin_work) {
-		DRM_DEBUG_DRIVER("flip queue: crtc already busy\n");
 		spin_unlock_irqrestore(&dev->event_lock, flags);
 		kfree(work);
-		mutex_unlock(&dev->struct_mutex);
+
+		DRM_DEBUG_DRIVER("flip queue: crtc already busy\n");
 		return -EBUSY;
 	}
 	intel_crtc->unpin_work = work;
@@ -4262,13 +4260,19 @@ static int intel_crtc_page_flip(struct d
 	intel_fb = to_intel_framebuffer(fb);
 	obj = intel_fb->obj;
 
+	mutex_lock(&dev->struct_mutex);
 	ret = intel_pin_and_fence_fb_obj(dev, obj);
 	if (ret != 0) {
-		DRM_DEBUG_DRIVER("flip queue: %p pin & fence failed\n",
-			  to_intel_bo(obj));
-		kfree(work);
-		intel_crtc->unpin_work = NULL;
 		mutex_unlock(&dev->struct_mutex);
+
+		spin_lock_irqsave(&dev->event_lock, flags);
+		intel_crtc->unpin_work = NULL;
+		spin_unlock_irqrestore(&dev->event_lock, flags);
+
+		kfree(work);
+
+		DRM_DEBUG_DRIVER("flip queue: %p pin & fence failed\n",
+				 to_intel_bo(obj));
 		return ret;
 	}
 


