Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253Ab2DKXoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:44:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965194Ab2DKXWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:22:48 -0400
Message-Id: <20120411231040.187618888@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 28/59] drm/i915: Sanitize BIOS debugging bits from PIPECONF
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit f47166d2b0001fcb752b40c5a2d4db986dfbea68 upstream.

Quoting the BSpec from time immemorial:

  PIPEACONF, bits 28:27: Frame Start Delay (Debug)

  Used to delay the frame start signal that is sent to the display planes.
  Care must be taken to insure that there are enough lines during VBLANK
  to support this setting.

An instance of the BIOS leaving these bits set was found in the wild,
where it caused our modesetting to go all squiffy and skewiff.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=47271
Reported-and-tested-by: Eva Wang <evawang@linpus.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43012
Reported-and-tested-by: Carl Richell <carl@system76.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2312,6 +2312,7 @@
 #define   PIPECONF_DISABLE	0
 #define   PIPECONF_DOUBLE_WIDE	(1<<30)
 #define   I965_PIPECONF_ACTIVE	(1<<30)
+#define   PIPECONF_FRAME_START_DELAY_MASK (3<<27)
 #define   PIPECONF_SINGLE_WIDE	0
 #define   PIPECONF_PIPE_UNLOCKED 0
 #define   PIPECONF_PIPE_LOCKED	(1<<25)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7278,6 +7278,12 @@ static void intel_sanitize_modesetting(s
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 reg, val;
 
+	/* Clear any frame start delays used for debugging left by the BIOS */
+	for_each_pipe(pipe) {
+		reg = PIPECONF(pipe);
+		I915_WRITE(reg, I915_READ(reg) & ~PIPECONF_FRAME_START_DELAY_MASK);
+	}
+
 	if (HAS_PCH_SPLIT(dev))
 		return;
 


