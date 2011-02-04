Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1BDJNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:13:12 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:58806
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753513Ab1BDJNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:13:09 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Bobby Bingham <uhmmmm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] reverse-engineer safe snb wm0 values
Date: Fri,  4 Feb 2011 09:12:57 +0000
Message-Id: <1296810777-16645-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110203221108.281c8512@duality>
References: <20110203221108.281c8512@duality>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
Hi Bobby,

this is a patch that I am testing, but so far no else one has experienced
the same symptoms that this fixes on my machines...

It looks like you have won the privilege of being my first victim^W
tester.

Also in drm-intel-fixes
(git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git)
is a patch to invalidate the TLB on the BLT which also may cause hangs,
but has a different pattern of failure in
/sys/kernel/debug/dri/0/i915_error_state:

commit 71a77e07d0e33b57d4a50c173e5ce4fabceddbec
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 2 12:13:49 2011 +0000

    drm/i915: Invalidate TLB caches on SNB BLT/BSD rings

I hope one of these brings stability back to your machine...
-Chris

---
 drivers/gpu/drm/i915/intel_display.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e187257..19c9395 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4270,7 +4270,9 @@ static void sandybridge_update_wm(struct drm_device *dev)
 				 &sandybridge_cursor_wm_info, latency,
 				 &plane_wm, &cursor_wm)) {
 		I915_WRITE(WM0_PIPEA_ILK,
-			   (plane_wm << WM0_PIPE_PLANE_SHIFT) | cursor_wm);
+			   ((sandybridge_display_wm_info.fifo_size - plane_wm) << WM0_PIPE_PLANE_SHIFT) |
+			   (2 << WM0_PIPE_SPRITE_SHIFT) |
+			   cursor_wm);
 		DRM_DEBUG_KMS("FIFO watermarks For pipe A -"
 			      " plane %d, " "cursor: %d\n",
 			      plane_wm, cursor_wm);
@@ -4282,7 +4284,9 @@ static void sandybridge_update_wm(struct drm_device *dev)
 				 &sandybridge_cursor_wm_info, latency,
 				 &plane_wm, &cursor_wm)) {
 		I915_WRITE(WM0_PIPEB_ILK,
-			   (plane_wm << WM0_PIPE_PLANE_SHIFT) | cursor_wm);
+			   ((sandybridge_display_wm_info.fifo_size - plane_wm) << WM0_PIPE_PLANE_SHIFT) |
+			   (2 << WM0_PIPE_SPRITE_SHIFT) |
+			   cursor_wm);
 		DRM_DEBUG_KMS("FIFO watermarks For pipe B -"
 			      " plane %d, cursor: %d\n",
 			      plane_wm, cursor_wm);
-- 
1.7.2.3

