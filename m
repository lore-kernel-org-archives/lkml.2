Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161471Ab1FAJYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:24:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:43347 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161426Ab1FAIJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:09:53 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:05 2011
Message-Id: <20110601080304.663791712@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:37 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christopher James Halse Rogers 
	<christopher.halse.rogers@canonical.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [041/146] drm: Send pending vblank events before disabling vblank.
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christopher James Halse Rogers <christopher.halse.rogers@canonical.com>

commit 498548ec69c6897fe4376b2ca90758762fa0b817 upstream.

This is the least-bad behaviour.  It means that we signal the
vblank event before it actually happens, but since we're disabling
vblanks there's no guarantee that it will *ever* happen otherwise.

This prevents GL applications which use WaitMSC from hanging
indefinitely.

Signed-off-by: Christopher James Halse Rogers <christopher.halse.rogers@canonical.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_irq.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -942,11 +942,34 @@ EXPORT_SYMBOL(drm_vblank_put);
 
 void drm_vblank_off(struct drm_device *dev, int crtc)
 {
+	struct drm_pending_vblank_event *e, *t;
+	struct timeval now;
 	unsigned long irqflags;
+	unsigned int seq;
 
 	spin_lock_irqsave(&dev->vbl_lock, irqflags);
 	vblank_disable_and_save(dev, crtc);
 	DRM_WAKEUP(&dev->vbl_queue[crtc]);
+
+	/* Send any queued vblank events, lest the natives grow disquiet */
+	seq = drm_vblank_count_and_time(dev, crtc, &now);
+	list_for_each_entry_safe(e, t, &dev->vblank_event_list, base.link) {
+		if (e->pipe != crtc)
+			continue;
+		DRM_DEBUG("Sending premature vblank event on disable: \
+			  wanted %d, current %d\n",
+			  e->event.sequence, seq);
+
+		e->event.sequence = seq;
+		e->event.tv_sec = now.tv_sec;
+		e->event.tv_usec = now.tv_usec;
+		drm_vblank_put(dev, e->pipe);
+		list_move_tail(&e->base.link, &e->base.file_priv->event_list);
+		wake_up_interruptible(&e->base.file_priv->event_wait);
+		trace_drm_vblank_event_delivered(e->base.pid, e->pipe,
+						 e->event.sequence);
+	}
+
 	spin_unlock_irqrestore(&dev->vbl_lock, irqflags);
 }
 EXPORT_SYMBOL(drm_vblank_off);


