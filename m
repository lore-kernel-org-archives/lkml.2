Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab0GAVey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:34:54 -0400
Received: from kroah.org ([198.145.64.141]:33077 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759231Ab0GAVOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:53 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:59 2010
Message-Id: <20100701174259.305466396@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [152/200] drm/i915: Kill dangerous pending-flip debugging
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 9908ff736adf261e749b4887486a32ffa209304c upstream.

We can, by virtue of a vblank interrupt firing in the middle of setting
up the unpin work (i.e. after we set the unpin_work field and before we
write to the ringbuffer) enter intel_finish_page_flip() prior to
receiving the pending flip notification. Therefore we can expect to hit
intel_finish_page_flip() under normal circumstances without a pending flip
and even without installing the pending_flip_obj. This is exacerbated by
aperture thrashing whilst binding the framebuffer


  Bug 28079 - "glresize" causes kernel panic in intel_finish_page_flip.
  https://bugs.freedesktop.org/show_bug.cgi?id=28079

Reported-by: Nick Bowler <nbowler@draconx.ca>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4155,12 +4155,6 @@ void intel_finish_page_flip(struct drm_d
 	spin_lock_irqsave(&dev->event_lock, flags);
 	work = intel_crtc->unpin_work;
 	if (work == NULL || !work->pending) {
-		if (work && !work->pending) {
-			obj_priv = to_intel_bo(work->pending_flip_obj);
-			DRM_DEBUG_DRIVER("flip finish: %p (%d) not pending?\n",
-					 obj_priv,
-					 atomic_read(&obj_priv->pending_flip));
-		}
 		spin_unlock_irqrestore(&dev->event_lock, flags);
 		return;
 	}


