Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2FMOgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:36:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57135 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2FMOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:36:05 -0400
Date: Wed, 13 Jun 2012 09:36:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: i915: lvds panel always blank when booted with lid closed
Message-ID: <20120613143600.GD3490@thinkpad-t410>
Mail-Followup-To: Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I boot my Thinkpad T410 in a docking station with the lid closed,
the lvds panel remains blank even when this output is active. This
happens up to and including 3.5-rc2.

I've determined that this happens because lvds isn't being initialized
by the bios when I boot this way, and booting with lvds_channel_mode=2
fixes the issue. I see that there's logic in is_dual_link_lvds()
intended to detect this situation, but it's failing because the T410 has
the LVDS_PIPEB_SELECT bit set. The simple patch below fixes my machine
by masking off this bit when determining whether or not lvds was
initialized by the bios.

I'm not sure though whether or not it's correct to expect that this bit
might be set when lvds hasn't been initialized. The alternative seems to
be quirking this machine as is done for some Macbooks. What is the
correct solution?

Thanks,
Seth


>From 250904ac95cda7630cdd8339724e3c8feceeb586 Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Tue, 12 Jun 2012 16:52:14 -0500
Subject: [PATCH] drm/i915: ignore LVDS_PIPEB_SELECT when checking for LVDS
 register initialization

The Lenovo Thinkpad T410 has this bit set in the LVDS register when
booted with the lid closed, even though the LVDS hasn't really been
initialized. Ignore this bit so that the VBT value will be used instead.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e0aa064..f81f249 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -434,7 +434,7 @@ static bool is_dual_link_lvds(struct drm_i915_private *dev_priv,
 		 * register is uninitialized.
 		 */
 		val = I915_READ(reg);
-		if (!(val & ~LVDS_DETECTED))
+		if (!(val & ~(LVDS_PIPEB_SELECT | LVDS_DETECTED)))
 			val = dev_priv->bios_lvds_val;
 		dev_priv->lvds_val = val;
 	}

