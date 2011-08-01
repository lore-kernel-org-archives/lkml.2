Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1HAXfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:35:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1HAX0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:54 2011
Message-Id: <20110801232054.838357890@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [42/70] drm/radeon: fix oops in ttm reserve when pageflipping (v2)
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 498c555f56a02ec1059bc150cde84411ba0ac010 upstream.

We need to take a reference to this object, pinning doesn't take a reference
so if userspace deletes the object it can disappear even if pinned.

v2: fix error paths to unreference properly also.

should fix:
https://bugzilla.kernel.org/show_bug.cgi?id=32402
and
https://bugzilla.redhat.com/show_bug.cgi?id=680651

Acked-By: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_display.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -264,6 +264,8 @@ static void radeon_unpin_work_func(struc
 		radeon_bo_unreserve(work->old_rbo);
 	} else
 		DRM_ERROR("failed to reserve buffer after flip\n");
+
+	drm_gem_object_unreference_unlocked(&work->old_rbo->gem_base);
 	kfree(work);
 }
 
@@ -371,6 +373,8 @@ static int radeon_crtc_page_flip(struct
 	new_radeon_fb = to_radeon_framebuffer(fb);
 	/* schedule unpin of the old buffer */
 	obj = old_radeon_fb->obj;
+	/* take a reference to the old object */
+	drm_gem_object_reference(obj);
 	rbo = gem_to_radeon_bo(obj);
 	work->old_rbo = rbo;
 	INIT_WORK(&work->work, radeon_unpin_work_func);
@@ -378,12 +382,9 @@ static int radeon_crtc_page_flip(struct
 	/* We borrow the event spin lock for protecting unpin_work */
 	spin_lock_irqsave(&dev->event_lock, flags);
 	if (radeon_crtc->unpin_work) {
-		spin_unlock_irqrestore(&dev->event_lock, flags);
-		kfree(work);
-		radeon_fence_unref(&fence);
-
 		DRM_DEBUG_DRIVER("flip queue: crtc already busy\n");
-		return -EBUSY;
+		r = -EBUSY;
+		goto unlock_free;
 	}
 	radeon_crtc->unpin_work = work;
 	radeon_crtc->deferred_flip_completion = 0;
@@ -497,6 +498,8 @@ pflip_cleanup1:
 pflip_cleanup:
 	spin_lock_irqsave(&dev->event_lock, flags);
 	radeon_crtc->unpin_work = NULL;
+unlock_free:
+	drm_gem_object_unreference_unlocked(old_radeon_fb->obj);
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 	radeon_fence_unref(&fence);
 	kfree(work);


