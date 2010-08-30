Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0H3Rgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:36:37 -0400
Received: from eazy.amigager.de ([213.239.192.238]:58580 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0H3Rgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:36:35 -0400
Date: Mon, 30 Aug 2010 19:37:02 +0200
From: Tino Keitel <tino.keitel+xorg@tikei.de>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: 2.6.36-rc2 regression: Wrong screen resolution (1024x768
 instead of 1680x1050)
Message-ID: <20100830173702.GA5006@mac.home>
Mail-Followup-To: Maciej Rutecki <maciej.rutecki@gmail.com>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <20100826073039.GA4567@mac.home>
 <201008291519.20734.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <201008291519.20734.maciej.rutecki@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 29, 2010 at 15:19:20 +0200, Maciej Rutecki wrote:
> > TV1 connected 1024x768+0+0 (normal left inverted right x axis y axis)
> > 0mm x 0mm
> >    848x480        30.0 +
> >    640x480        30.0 +
> >    1024x768       30.0*
> >    800x600        30.0
> > 
> > This is a Mac mini Core 2 Duo with Intel i945 graphics.
> > 
> 
> Seems be similar to:
> https://bugzilla.kernel.org/show_bug.cgi?id=17301

Maybe. I don't know if this is connected, but after disabling TV out
using the attached patch, the screen has no signal after suspend to
RAM. However, the patch helped to get back the native LCD resolution
after boot.

Regards,
Tino

--rwEMma7ioTxnRzrJ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="disable_tv_out.diff"

diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index 4f00390..1d306a4 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -25,6 +25,8 @@
  *
  * Derived from Xorg ddx, xf86-video-intel, src/i830_video.c
  */
+
+#include <linux/seq_file.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index d2029ef..f71e488 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1279,6 +1279,8 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
 	 *  1 0 X svideo
 	 *  0 0 0 Component
 	 */
+	type = -1;
+	goto out;
 	if ((tv_dac & TVDAC_SENSE_MASK) == (TVDAC_B_SENSE | TVDAC_C_SENSE)) {
 		DRM_DEBUG_KMS("Detected Composite TV connection\n");
 		type = DRM_MODE_CONNECTOR_Composite;
@@ -1292,7 +1294,7 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
 		DRM_DEBUG_KMS("No TV connection detected\n");
 		type = -1;
 	}
-
+out:
 	/* Restore interrupt config */
 	spin_lock_irqsave(&dev_priv->user_irq_lock, irqflags);
 	i915_enable_pipestat(dev_priv, 0, PIPE_HOTPLUG_INTERRUPT_ENABLE |

--rwEMma7ioTxnRzrJ--
