Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2J1X0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:26:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41743 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915Ab2J1X0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:52 -0400
Message-Id: <20121028231539.849427155@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:45 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [ 009/105] drm/i915: dont pwrite tiled objects through the gtt
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit c07496fa61f4c5cb2addd1c57f6b22fcaeea2eeb upstream.

... we will botch up the bit17 swizzling. Furthermore tiled pwrite is
a (now) unused slowpath, so no one really cares.

This fixes the last swizzling issues I have with i-g-t on my bit17
swizzling i915G. No regression, it's been broken since the dawn of
gem, but it's nice for regression tracking when really _all_ i-g-t
tests work.

Actually this is not true, Chris Wilson noticed while reviewing this
patch that the commit

commit d9e86c0ee60f323e890484628f351bf50fa9a15d
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Nov 10 16:40:20 2010 +0000

    drm/i915: Pipelined fencing [infrastructure]

contained a functional change that broke things.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[Luís Picciochi Oliveira: I picked the commit Daniel suggested and
edited it to affect the code that matched the same logical location on
the same function.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 33e155590a50..dbe4dbe46475 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -999,6 +999,7 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	if (obj->phys_obj)
 		ret = i915_gem_phys_pwrite(dev, obj, args, file);
 	else if (obj->gtt_space &&
+		 obj->tiling_mode == I915_TILING_NONE &&
 		 obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
 		ret = i915_gem_object_pin(obj, 0, true);
 		if (ret)


