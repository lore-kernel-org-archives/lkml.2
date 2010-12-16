Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab0LPUhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:37:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:52475 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab0LPUhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:37:07 -0500
Message-Id: <5b55a1$ivkrie@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,356,1288594800"; 
   d="scan'208";a="637169230"
Date: Thu, 16 Dec 2010 20:37:03 +0000
To: Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org
Subject: Re: Linux 2.6.37-rc6
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        alexdeucher@gmail.com, airlied@linux.ie
In-Reply-To: <20101216173011.GA2689@vixen>
References: <AANLkTikWYd1UOJgMHiBb-cZwEHVOFWPBupcf8unfEKxo@mail.gmail.com> <20101216173011.GA2689@vixen>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 18:30:11 +0100, Domenico Andreoli <cavokz@gmail.com> wrote:
> Hi,
> 
> On Wed, Dec 15, 2010 at 07:10:28PM -0800, ext Linus Torvalds wrote:
> > 
> > Go forth and test. And please do remember to ping bugzilla (or
> > developers) about any regressions you find, whether new or old.
> 
> I have some problem with i945, display remains blank. I also tried
> adding i915.modeset=0 but nothing changed. Machine is well alive and
> responds to basic commands like Ctrl+Alt+F1 and Ctrl+Alt+Del but I have
> not other machine to enter via network.

If i915.modeset=0 doesn't restore the display then something is extremely
fishy. Do you see any console output before the i915.ko is loaded?

> [    1.284262] [drm] Initialized drm 1.1.0 20060810
> [    1.284334] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.485212] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    1.485642] [drm] initialized overlay support
> [    2.526011] No connectors reported connected with modes
> [    2.526053] [drm] Cannot find any crtc or sizes - going 1024x768

The issue appears to be that no outputs are being detected. I presume that
you have instead a VGA connected to the box and that the regression is in
fact e7dbb2f2. If I'm guessing rightly:

diff --git a/drivers/gpu/drm/i915/intel_crt.c
b/drivers/gpu/drm/i915/intel_crt.c
index 8df5743..14c276e 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -148,7 +148,9 @@ static void intel_crt_mode_set(struct drm_encoder *encoder,
                           dpll_md & ~DPLL_MD_UDI_MULTIPLIER_MASK);
        }
 
-       adpa = ADPA_HOTPLUG_BITS;
+       adpa = 0;
+       if (INTEL_INFO(dev)->gen >= 4)
+               adpa |= ADPA_HOTPLUG_BITS;
        if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
                adpa |= ADPA_HSYNC_ACTIVE_HIGH;
        if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)

-- 
Chris Wilson, Intel Open Source Technology Centre
