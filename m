Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0LQMWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:22:47 -0500
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:14255 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0LQMWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:22:46 -0500
Date: Fri, 17 Dec 2010 13:24:40 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, alexdeucher@gmail.com,
        airlied@linux.ie
Subject: Re: Linux 2.6.37-rc6
Message-ID: <20101217122440.GA2712@vixen>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, alexdeucher@gmail.com,
	airlied@linux.ie
References: <AANLkTikWYd1UOJgMHiBb-cZwEHVOFWPBupcf8unfEKxo@mail.gmail.com>
 <20101216173011.GA2689@vixen>
 <5b55a1$ivkrie@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b55a1$ivkrie@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 08:37:03PM +0000, ext Chris Wilson wrote:
> On Thu, 16 Dec 2010 18:30:11 +0100, Domenico Andreoli <cavokz@gmail.com> wrote:
> > Hi,
> > 
> > On Wed, Dec 15, 2010 at 07:10:28PM -0800, ext Linus Torvalds wrote:
> > > 
> > > Go forth and test. And please do remember to ping bugzilla (or
> > > developers) about any regressions you find, whether new or old.
> > 
> > I have some problem with i945, display remains blank. I also tried
> > adding i915.modeset=0 but nothing changed. Machine is well alive and
> > responds to basic commands like Ctrl+Alt+F1 and Ctrl+Alt+Del but I have
> > not other machine to enter via network.
> 
> If i915.modeset=0 doesn't restore the display then something is extremely
> fishy. Do you see any console output before the i915.ko is loaded?

no, I can only see what is in /var/log/messages

> > [    1.284262] [drm] Initialized drm 1.1.0 20060810
> > [    1.284334] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > [    1.485212] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> > [    1.485642] [drm] initialized overlay support
> > [    2.526011] No connectors reported connected with modes
> > [    2.526053] [drm] Cannot find any crtc or sizes - going 1024x768

[    1.277898] [drm] Initialized drm 1.1.0 20060810
[    1.277966] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.476151] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.476552] [drm] initialized overlay support
[    2.516008] No connectors reported connected with modes
[    2.516049] [drm] Cannot find any crtc or sizes - going 1024x768
[    2.526296] Console: switching to colour frame buffer device 128x48
[    2.528880] fb0: inteldrmfb frame buffer device
[    2.528907] drm: registered panic notifier
[    2.528937] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

this is the log with reverted e7dbb2f2.

> The issue appears to be that no outputs are being detected. I presume that
> you have instead a VGA connected to the box and that the regression is in
> fact e7dbb2f2. If I'm guessing rightly:

yes, display is attached to the VGA port.

I reverted this commit on -rc6, the only improvement is that with
i915.modeset=0 I get the display back to normal VGA mode but when KMS
is enabled I still get the blank screen.

> diff --git a/drivers/gpu/drm/i915/intel_crt.c
> b/drivers/gpu/drm/i915/intel_crt.c
> index 8df5743..14c276e 100644
> --- a/drivers/gpu/drm/i915/intel_crt.c
> +++ b/drivers/gpu/drm/i915/intel_crt.c
> @@ -148,7 +148,9 @@ static void intel_crt_mode_set(struct drm_encoder *encoder,
>                            dpll_md & ~DPLL_MD_UDI_MULTIPLIER_MASK);
>         }
>  
> -       adpa = ADPA_HOTPLUG_BITS;
> +       adpa = 0;
> +       if (INTEL_INFO(dev)->gen >= 4)
> +               adpa |= ADPA_HOTPLUG_BITS;
>         if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
>                 adpa |= ADPA_HSYNC_ACTIVE_HIGH;
>         if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)

I tried this patch on -rc6 but does not help at all.

cheers,
Domenico
