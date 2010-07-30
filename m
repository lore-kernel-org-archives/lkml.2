Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab0G3Sti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:49:38 -0400
Received: from kroah.org ([198.145.64.141]:35726 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab0G3Rej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:39 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:07 2010
Message-Id: <20100730173107.230441672@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [050/140] drm/i915: enable low power render writes on GEN3 hardware.
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 944001201ca0196bcdb088129e5866a9f379d08c upstream.

A lot of 945GMs have had stability issues for a long time, this manifested as X hangs, blitter engine hangs, and lots of crashes.

one such report is at:
https://bugs.freedesktop.org/show_bug.cgi?id=20560

along with numerous distro bugzillas.

This only took a week of digging and hair ripping to figure out.

Tracked down and tested on a 945GM Lenovo T60,
previously running
x11perf -copypixwin500
or
x11perf -copywinpix500
repeatedly would cause the GPU to wedge within 4 or 5 tries, with random busy bits set.

After this patch no hangs were observed.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4999,6 +4999,16 @@ i915_gem_load(struct drm_device *dev)
 	list_add(&dev_priv->mm.shrink_list, &shrink_list);
 	spin_unlock(&shrink_list_lock);
 
+	/* On GEN3 we really need to make sure the ARB C3 LP bit is set */
+	if (IS_GEN3(dev)) {
+		u32 tmp = I915_READ(MI_ARB_STATE);
+		if (!(tmp & MI_ARB_C3_LP_WRITE_ENABLE)) {
+			/* arb state is a masked write, so set bit + bit in mask */
+			tmp = MI_ARB_C3_LP_WRITE_ENABLE | (MI_ARB_C3_LP_WRITE_ENABLE << MI_ARB_MASK_SHIFT);
+			I915_WRITE(MI_ARB_STATE, tmp);
+		}
+	}
+
 	/* Old X drivers will take 0-2 for front, back, depth buffers */
 	dev_priv->fence_reg_start = 3;
 


