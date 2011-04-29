Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab1D2S6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:23 -0400
Received: from kroah.org ([198.145.64.141]:50249 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686Ab1D2S6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:54 2011
Message-Id: <20110429185654.317566218@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>
Subject: [18/55] drm/i915: Sanitize the output registers after resume
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit f6e5b1603b8bb7131b6778d0d4e2e5dda120a379 upstream.

Similar to booting, we need to inspect the state left by the BIOS and
remove any conflicting bits before we take over. The example reported by
Seth Forshee is very similar to the bug we encountered with the state left
by grub2, that the crtc pipe<->planning mapping was reversed from our
expectations and so we failed to turn off the outputs when booting or,
in this case, resuming. This may be in fact the same bug, but triggered
at resume time.

This patch rearranges the code we already have to clear up the
conflicting state upon init and calls it from reset (which is called
after we have lost control of the hardware, i.e. along both the boot and
resume paths) instead.

Reported-and-tested-by: Seth Forshee <seth.forshee@canonical.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=35796
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |   68 ++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 32 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5630,36 +5630,6 @@ cleanup_work:
 	return ret;
 }
 
-static void intel_crtc_reset(struct drm_crtc *crtc)
-{
-	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
-
-	/* Reset flags back to the 'unknown' status so that they
-	 * will be correctly set on the initial modeset.
-	 */
-	intel_crtc->dpms_mode = -1;
-}
-
-static struct drm_crtc_helper_funcs intel_helper_funcs = {
-	.dpms = intel_crtc_dpms,
-	.mode_fixup = intel_crtc_mode_fixup,
-	.mode_set = intel_crtc_mode_set,
-	.mode_set_base = intel_pipe_set_base,
-	.mode_set_base_atomic = intel_pipe_set_base_atomic,
-	.load_lut = intel_crtc_load_lut,
-	.disable = intel_crtc_disable,
-};
-
-static const struct drm_crtc_funcs intel_crtc_funcs = {
-	.reset = intel_crtc_reset,
-	.cursor_set = intel_crtc_cursor_set,
-	.cursor_move = intel_crtc_cursor_move,
-	.gamma_set = intel_crtc_gamma_set,
-	.set_config = drm_crtc_helper_set_config,
-	.destroy = intel_crtc_destroy,
-	.page_flip = intel_crtc_page_flip,
-};
-
 static void intel_sanitize_modesetting(struct drm_device *dev,
 				       int pipe, int plane)
 {
@@ -5710,6 +5680,42 @@ static void intel_sanitize_modesetting(s
 	}
 }
 
+static void intel_crtc_reset(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
+
+	/* Reset flags back to the 'unknown' status so that they
+	 * will be correctly set on the initial modeset.
+	 */
+	intel_crtc->dpms_mode = -1;
+
+	/* We need to fix up any BIOS configuration that conflicts with
+	 * our expectations.
+	 */
+	intel_sanitize_modesetting(dev, intel_crtc->pipe, intel_crtc->plane);
+}
+
+static struct drm_crtc_helper_funcs intel_helper_funcs = {
+	.dpms = intel_crtc_dpms,
+	.mode_fixup = intel_crtc_mode_fixup,
+	.mode_set = intel_crtc_mode_set,
+	.mode_set_base = intel_pipe_set_base,
+	.mode_set_base_atomic = intel_pipe_set_base_atomic,
+	.load_lut = intel_crtc_load_lut,
+	.disable = intel_crtc_disable,
+};
+
+static const struct drm_crtc_funcs intel_crtc_funcs = {
+	.reset = intel_crtc_reset,
+	.cursor_set = intel_crtc_cursor_set,
+	.cursor_move = intel_crtc_cursor_move,
+	.gamma_set = intel_crtc_gamma_set,
+	.set_config = drm_crtc_helper_set_config,
+	.destroy = intel_crtc_destroy,
+	.page_flip = intel_crtc_page_flip,
+};
+
 static void intel_crtc_init(struct drm_device *dev, int pipe)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
@@ -5759,8 +5765,6 @@ static void intel_crtc_init(struct drm_d
 
 	setup_timer(&intel_crtc->idle_timer, intel_crtc_idle_timer,
 		    (unsigned long)intel_crtc);
-
-	intel_sanitize_modesetting(dev, intel_crtc->pipe, intel_crtc->plane);
 }
 
 int intel_get_pipe_from_crtc_id(struct drm_device *dev, void *data,


