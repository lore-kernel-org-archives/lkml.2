Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab0G3R6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:58:24 -0400
Received: from kroah.org ([198.145.64.141]:58971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760082Ab0G3R5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:01 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:47 2010
Message-Id: <20100730175147.059552706@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [144/205] drm/i915: dont queue flips during a flip pending event
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 83f7fd055eb3f1e843803cd906179d309553967b upstream.

Hardware will set the flip pending ISR bit as soon as it receives the
flip instruction, and (supposedly) clear it once the flip completes
(e.g. at the next vblank).  If we try to send down a flip instruction
while the ISR bit is set, the hardware can become very confused, and we
may never receive the corresponding flip pending interrupt, effectively
hanging the chip.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4232,6 +4232,7 @@ static int intel_crtc_page_flip(struct d
 	unsigned long flags;
 	int pipesrc_reg = (intel_crtc->pipe == 0) ? PIPEASRC : PIPEBSRC;
 	int ret, pipesrc;
+	u32 flip_mask;
 	RING_LOCALS;
 
 	work = kzalloc(sizeof *work, GFP_KERNEL);
@@ -4282,6 +4283,16 @@ static int intel_crtc_page_flip(struct d
 	atomic_inc(&obj_priv->pending_flip);
 	work->pending_flip_obj = obj;
 
+	if (intel_crtc->plane)
+		flip_mask = I915_DISPLAY_PLANE_B_FLIP_PENDING_INTERRUPT;
+	else
+		flip_mask = I915_DISPLAY_PLANE_A_FLIP_PENDING_INTERRUPT;
+
+	/* Wait for any previous flip to finish */
+	if (IS_GEN3(dev))
+		while (I915_READ(ISR) & flip_mask)
+			;
+
 	BEGIN_LP_RING(4);
 	if (IS_I965G(dev)) {
 		OUT_RING(MI_DISPLAY_FLIP |


