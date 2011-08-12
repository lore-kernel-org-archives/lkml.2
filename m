Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1HNQ1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:27:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1HNQGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:54 2011
Message-Id: <20110812210554.143269114@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Adam Jackson <ajax@redhat.com>, Keith Packard <keithp@keithp.com>
Subject: [23/90] drm/i915/pch: Fix integer math bugs in panel fitting
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit 302983e9059e9ef5de3ca7671918eeb237c5971e upstream.

Consider a 1600x900 panel, upscaling a 1360x768 mode, full-aspect.  The
old math would give you:

    scaled_width  = 1600 * 768;         /* 1228800 */
    scaled_height = 1360 * 900;         /* 1224000 */
    if (scaled_width > scaled_height) { /* pillarbox, and true */
        width  = 1224000 / 768;         /* int(1593.75) = 1593 */
        x      = (1600 - 1593 + 1) / 2; /* 4 */
        y      = 0;
        height = 768;
    } /* ... */

This is broken.  The total width of scanout would then be 1593 + 4 + 4,
or 1601, which is wider than the panel itself.  The hardware very
dutifully implements this, and you end up with a black 45° diagonal from
the top-left corner to the bottom edge of the screen.  It's a cool
effect and all, but not what you wanted.  Similar things happen for the
letterbox case.

The problem is that you have an integer number of pixels, which means
it's usually impossible to upscale equally on both axes.  1360/768 is
1.7708, 1600/900 is 1.7777.  Since we're constrained on the one axis,
the other one wants to come out as an even number of pixels (the panel
is almost certainly even on both axes, and the x/y offsets will be
applied on both sides).  In the math above, if 'width' comes out even,
rounding down is correct; if it's odd, you'd rather round up.  So just
increment width/height in those cases.

Tested on a Lenovo T500 (Ironlake).

Signed-off-by: Adam Jackson <ajax@redhat.com>
Tested-By: Daniel Manrique <daniel.manrique@canonical.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=38851
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_panel.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -83,11 +83,15 @@ intel_pch_panel_fitting(struct drm_devic
 			u32 scaled_height = mode->hdisplay * adjusted_mode->vdisplay;
 			if (scaled_width > scaled_height) { /* pillar */
 				width = scaled_height / mode->vdisplay;
+				if (width & 1)
+				    	width++;
 				x = (adjusted_mode->hdisplay - width + 1) / 2;
 				y = 0;
 				height = adjusted_mode->vdisplay;
 			} else if (scaled_width < scaled_height) { /* letter */
 				height = scaled_width / mode->hdisplay;
+				if (height & 1)
+				    height++;
 				y = (adjusted_mode->vdisplay - height + 1) / 2;
 				x = 0;
 				width = adjusted_mode->hdisplay;


