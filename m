Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1GWKpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 06:45:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:49714 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1GWKpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 06:45:09 -0400
Date: Sat, 23 Jul 2011 12:45:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: drm: Remove utterly bogus preempt_disable() sections
Message-ID: <alpine.LFD.2.02.1107231242170.2702@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 27641c3f (drm/vblank: Add support for precise vblank
timestamping) adds preempt_disable()/enable() around a spin locked
section with the comments:

 * Disable preemption, so vblank_time_lock is held as short as
 * possible, even under a kernel with PREEMPT_RT patches.

/* Disable preemption while holding vblank_time_lock. Do
 * it explicitely to guard against PREEMPT_RT kernel.

Just that this has never been tested on a RT kernel which would have
granted that nonsense with a might_sleep() warning because
dev->vblank_time_lock is converted to a "sleeping" spinlock on RT.

So this is activly wrong on RT and superflous on mainline. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/gpu/drm/drm_irq.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-2.6/drivers/gpu/drm/drm_irq.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/drm_irq.c
+++ linux-2.6/drivers/gpu/drm/drm_irq.c
@@ -109,10 +109,7 @@ static void vblank_disable_and_save(stru
 	/* Prevent vblank irq processing while disabling vblank irqs,
 	 * so no updates of timestamps or count can happen after we've
 	 * disabled. Needed to prevent races in case of delayed irq's.
-	 * Disable preemption, so vblank_time_lock is held as short as
-	 * possible, even under a kernel with PREEMPT_RT patches.
 	 */
-	preempt_disable();
 	spin_lock_irqsave(&dev->vblank_time_lock, irqflags);
 
 	dev->driver->disable_vblank(dev, crtc);
@@ -163,7 +160,6 @@ static void vblank_disable_and_save(stru
 	clear_vblank_timestamps(dev, crtc);
 
 	spin_unlock_irqrestore(&dev->vblank_time_lock, irqflags);
-	preempt_enable();
 }
 
 static void vblank_disable_fn(unsigned long arg)
@@ -875,10 +871,6 @@ int drm_vblank_get(struct drm_device *de
 	spin_lock_irqsave(&dev->vbl_lock, irqflags);
 	/* Going from 0->1 means we have to enable interrupts again */
 	if (atomic_add_return(1, &dev->vblank_refcount[crtc]) == 1) {
-		/* Disable preemption while holding vblank_time_lock. Do
-		 * it explicitely to guard against PREEMPT_RT kernel.
-		 */
-		preempt_disable();
 		spin_lock_irqsave(&dev->vblank_time_lock, irqflags2);
 		if (!dev->vblank_enabled[crtc]) {
 			/* Enable vblank irqs under vblank_time_lock protection.
@@ -898,7 +890,6 @@ int drm_vblank_get(struct drm_device *de
 			}
 		}
 		spin_unlock_irqrestore(&dev->vblank_time_lock, irqflags2);
-		preempt_enable();
 	} else {
 		if (!dev->vblank_enabled[crtc]) {
 			atomic_dec(&dev->vblank_refcount[crtc]);
