Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab1KWAtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:49:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358Ab1KWAlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:05 2011
Message-Id: <20111123002405.172015127@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Adam Jackson <ajax@redhat.com>,
        Keith Packard <keithp@keithp.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [06/53] drm/i915/pch: Save/restore PCH_PORT_HOTPLUG across suspend
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit cda2bb78c24de7674eafa3210314dc75bed344a6 upstream.

At least on a Lenovo X220 the HPD bits of this are enabled at boot but
cleared after resume, which means plug interrupts stop working.

This also happens to fix DP displays re-lighting on resume.  I'm quite
certain that's an accident: the first DP link train inevitably fails on
that machine, and it's only serendipity that we're getting multiple plug
interrupts and the second train works.  But I shall take my victories
where I get them.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Tested-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.h     |    1 +
 drivers/gpu/drm/i915/i915_suspend.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -541,6 +541,7 @@ typedef struct drm_i915_private {
 	u32 savePIPEB_LINK_M1;
 	u32 savePIPEB_LINK_N1;
 	u32 saveMCHBAR_RENDER_STANDBY;
+	u32 savePCH_PORT_HOTPLUG;
 
 	struct {
 		/** Bridge to intel-gtt-ko */
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -814,6 +814,7 @@ int i915_save_state(struct drm_device *d
 		dev_priv->saveFDI_RXB_IMR = I915_READ(_FDI_RXB_IMR);
 		dev_priv->saveMCHBAR_RENDER_STANDBY =
 			I915_READ(RSTDBYCTL);
+		dev_priv->savePCH_PORT_HOTPLUG = I915_READ(PCH_PORT_HOTPLUG);
 	} else {
 		dev_priv->saveIER = I915_READ(IER);
 		dev_priv->saveIMR = I915_READ(IMR);
@@ -865,6 +866,7 @@ int i915_restore_state(struct drm_device
 		I915_WRITE(GTIMR, dev_priv->saveGTIMR);
 		I915_WRITE(_FDI_RXA_IMR, dev_priv->saveFDI_RXA_IMR);
 		I915_WRITE(_FDI_RXB_IMR, dev_priv->saveFDI_RXB_IMR);
+		I915_WRITE(PCH_PORT_HOTPLUG, dev_priv->savePCH_PORT_HOTPLUG);
 	} else {
 		I915_WRITE(IER, dev_priv->saveIER);
 		I915_WRITE(IMR, dev_priv->saveIMR);


