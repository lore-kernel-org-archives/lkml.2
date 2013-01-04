Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3ADMJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 07:09:16 -0500
Received: from server109-228-6-235.live-servers.net ([109.228.6.235]:55803
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751269Ab3ADMJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 07:09:13 -0500
X-Greylist: delayed 1703 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2013 07:09:13 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Treat crtc->mode.clock == 0 as disabled
Date: Fri,  4 Jan 2013 11:39:55 +0000
Message-Id: <1357299595-16037-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAB9v_DE0qMdQ2poxv++FGd2zo+Tw5_m6kgTOoBZSCUOGZf+fNA@mail.gmail.com>
References: <CAB9v_DE0qMdQ2poxv++FGd2zo+Tw5_m6kgTOoBZSCUOGZf+fNA@mail.gmail.com>
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent a divide-by-zero by consistently treating an 'active' CRTC
without a mode set as actually disabled.
---
 drivers/gpu/drm/i915/intel_pm.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index e6f54ff..c929a4e 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -44,6 +44,11 @@
  * i915.i915_enable_fbc parameter
  */
 
+static bool intel_crtc_active(struct drm_crtc *crtc)
+{
+	return to_intel_crtc(crtc)->active && crtc->fb && crtc->mode.clock;
+}
+
 static void i8xx_disable_fbc(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -405,9 +410,8 @@ void intel_update_fbc(struct drm_device *dev)
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
@@ -992,7 +996,7 @@ static struct drm_crtc *single_enabled_crtc(struct drm_device *dev)
 	struct drm_crtc *crtc, *enabled = NULL;
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		if (to_intel_crtc(crtc)->active && crtc->fb) {
+		if (intel_crtc_active(crtc)) {
 			if (enabled)
 				return NULL;
 			enabled = crtc;
@@ -1086,7 +1090,7 @@ static bool g4x_compute_wm0(struct drm_device *dev,
 	int entries, tlb_miss;
 
 	crtc = intel_get_crtc_for_plane(dev, plane);
-	if (crtc->fb == NULL || !to_intel_crtc(crtc)->active) {
+	if (!intel_crtc_active(crtc)) {
 		*cursor_wm = cursor->guard_size;
 		*plane_wm = display->guard_size;
 		return false;
@@ -1215,7 +1219,7 @@ static bool vlv_compute_drain_latency(struct drm_device *dev,
 	int entries;
 
 	crtc = intel_get_crtc_for_plane(dev, plane);
-	if (crtc->fb == NULL || !to_intel_crtc(crtc)->active)
+	if (!intel_crtc_active(crtc))
 		return false;
 
 	clock = crtc->mode.clock;	/* VESA DOT Clock */
@@ -1476,7 +1480,7 @@ static void i9xx_update_wm(struct drm_device *dev)
 
 	fifo_size = dev_priv->display.get_fifo_size(dev, 0);
 	crtc = intel_get_crtc_for_plane(dev, 0);
-	if (to_intel_crtc(crtc)->active && crtc->fb) {
+	if (intel_crtc_active(crtc)) {
 		int cpp = crtc->fb->bits_per_pixel / 8;
 		if (IS_GEN2(dev))
 			cpp = 4;
@@ -1490,7 +1494,7 @@ static void i9xx_update_wm(struct drm_device *dev)
 
 	fifo_size = dev_priv->display.get_fifo_size(dev, 1);
 	crtc = intel_get_crtc_for_plane(dev, 1);
-	if (to_intel_crtc(crtc)->active && crtc->fb) {
+	if (intel_crtc_active(crtc)) {
 		int cpp = crtc->fb->bits_per_pixel / 8;
 		if (IS_GEN2(dev))
 			cpp = 4;
@@ -2044,7 +2048,7 @@ sandybridge_compute_sprite_wm(struct drm_device *dev, int plane,
 	int entries, tlb_miss;
 
 	crtc = intel_get_crtc_for_plane(dev, plane);
-	if (crtc->fb == NULL || !to_intel_crtc(crtc)->active) {
+	if (!intel_crtc_active(crtc)) {
 		*sprite_wm = display->guard_size;
 		return false;
 	}
-- 
1.7.10.4

