Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3AGKfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:35:07 -0500
Received: from smtp.fireflyinternet.com ([109.228.6.236]:14712 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750933Ab3AGKfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:35:04 -0500
X-Greylist: delayed 1340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2013 05:35:04 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Treat crtc->mode.clock == 0 as disabled
Date: Mon,  7 Jan 2013 10:11:40 +0000
Message-Id: <1357553501-8783-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAKMK7uH2L=tPUszeO7XMHJjXiJ5ZcG+wVi5u5c2UeQa8-xM=YQ@mail.gmail.com>
References: <CAKMK7uH2L=tPUszeO7XMHJjXiJ5ZcG+wVi5u5c2UeQa8-xM=YQ@mail.gmail.com>
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent a divide-by-zero by consistently treating an 'active' CRTC
without a mode set as actually disabled.

This looks to have been first introduced with

commit 24929352481f085c5f85d4d4cbc919ddf106d381
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Jul 2 20:28:59 2012 +0200

    drm/i915: read out the modeset hw state at load and resume time

but then combined with

commit b0a2658acb5bf9ca86b4aab011b7106de3af0add
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Dec 18 09:37:54 2012 +0100

    drm/i915: don't disable disconnected outputs

it finally started oopsing.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-and-tested-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/intel_pm.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index e6f54ff..e83a117 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -44,6 +44,14 @@
  * i915.i915_enable_fbc parameter
  */
 
+static bool intel_crtc_active(struct drm_crtc *crtc)
+{
+	/* Be paranoid as we can arrive here with only partial
+	 * state retrieved from the hardware during setup.
+	 */
+	return to_intel_crtc(crtc)->active && crtc->fb && crtc->mode.clock;
+}
+
 static void i8xx_disable_fbc(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -405,9 +413,8 @@ void intel_update_fbc(struct drm_device *dev)
 	 *   - going to an unsupported config (interlace, pixel multiply, etc.)
 	 */
 	list_for_each_entry(tmp_crtc, &dev->mode_config.crtc_list, head) {
-		if (to_intel_crtc(tmp_crtc)->active &&
-		    !to_intel_crtc(tmp_crtc)->primary_disabled &&
-		    tmp_crtc->fb) {
+		if (intel_crtc_active(tmp_crtc) &&
+		    !to_intel_crtc(tmp_crtc)->primary_disabled) {
 			if (crtc) {
 				DRM_DEBUG_KMS("more than one pipe active, disabling compression\n");
 				dev_priv->no_fbc_reason = FBC_MULTIPLE_PIPES;
@@ -992,7 +999,7 @@ static struct drm_crtc *single_enabled_crtc(struct drm_device *dev)
 	struct drm_crtc *crtc, *enabled = NULL;
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		if (to_intel_crtc(crtc)->active && crtc->fb) {
+		if (intel_crtc_active(crtc)) {
 			if (enabled)
 				return NULL;
 			enabled = crtc;
@@ -1086,7 +1093,7 @@ static bool g4x_compute_wm0(struct drm_device *dev,
 	int entries, tlb_miss;
 
 	crtc = intel_get_crtc_for_plane(dev, plane);
-	if (crtc->fb == NULL || !to_intel_crtc(crtc)->active) {
+	if (!intel_crtc_active(crtc)) {
 		*cursor_wm = cursor->guard_size;
 		*plane_wm = display->guard_size;
 		return false;
@@ -1215,7 +1222,7 @@ static bool vlv_compute_drain_latency(struct drm_device *dev,
 	int entries;
 
 	crtc = intel_get_crtc_for_plane(dev, plane);
-	if (crtc->fb == NULL || !to_intel_crtc(crtc)->active)
+	if (!intel_crtc_active(crtc))
 		return false;
 
 	clock = crtc->mode.clock;	/* VESA DOT Clock */
@@ -1476,7 +1483,7 @@ static void i9xx_update_wm(struct drm_device *dev)
 
 	fifo_size = dev_priv->display.get_fifo_size(dev, 0);
 	crtc = intel_get_crtc_for_plane(dev, 0);
-	if (to_intel_crtc(crtc)->active && crtc->fb) {
+	if (intel_crtc_active(crtc)) {
 		int cpp = crtc->fb->bits_per_pixel / 8;
 		if (IS_GEN2(dev))
 			cpp = 4;
@@ -1490,7 +1497,7 @@ static void i9xx_update_wm(struct drm_device *dev)
 
 	fifo_size = dev_priv->display.get_fifo_size(dev, 1);
 	crtc = intel_get_crtc_for_plane(dev, 1);
-	if (to_intel_crtc(crtc)->active && crtc->fb) {
+	if (intel_crtc_active(crtc)) {
 		int cpp = crtc->fb->bits_per_pixel / 8;
 		if (IS_GEN2(dev))
 			cpp = 4;
@@ -2044,7 +2051,7 @@ sandybridge_compute_sprite_wm(struct drm_device *dev, int plane,
 	int entries, tlb_miss;
 
 	crtc = intel_get_crtc_for_plane(dev, plane);
-	if (crtc->fb == NULL || !to_intel_crtc(crtc)->active) {
+	if (!intel_crtc_active(crtc)) {
 		*sprite_wm = display->guard_size;
 		return false;
 	}
-- 
1.7.10.4

