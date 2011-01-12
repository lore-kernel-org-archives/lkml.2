Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1ALMH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:07:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:42940 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1ALMH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:07:27 -0500
Message-Id: <b9dded$hknqnh@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,312,1291622400"; 
   d="scan'208";a="592177905"
Date: Wed, 12 Jan 2011 12:07:23 +0000
To: Indan Zupancic <indan@nul.nu>
Subject: Re: Linux 2.6.37
Cc: Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <b34be07ef0c3e8fc82c29d4299f262e4.squirrel@webmail.greenhost.nl>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com> <20110106104816.GA4026@tiehlicka.suse.cz> <20110111171744.GA3854@tiehlicka.suse.cz> <1bdc18$j7rfh5@fmsmga002.fm.intel.com> <b34be07ef0c3e8fc82c29d4299f262e4.squirrel@webmail.greenhost.nl>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 01:35:49 +0100 (CET), "Indan Zupancic" <indan@nul.nu> wrote:
> Yeah, the second patch is a bit of a desperate attempt because Larry reported that
> it didn't fix his problem.
> 
> About your patch, you still do:
> 
> +void intel_panel_setup_backlight(struct drm_device *dev)
> +{
> +	struct drm_i915_private *dev_priv = dev->dev_private;
> +
> +	dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
> +	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
> +}
> 
> While my patch changes that to:
> 
> +	u32 level;
> 
> -	if (dev_priv->backlight_level == 0)
> -		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
> +	if (dev_priv->backlight_level == 0) {
> +		level = intel_panel_get_backlight(dev);
> +		if (level == 0)
> +			level = intel_panel_get_max_backlight(dev);
> +		dev_priv->backlight_level = level;
> +	}
> 
> Your patch uses intel_panel_get_max_backlight() to check if the backlight is
> enabled. Is this always correct, or may it cause bugs in the future?

That was a typo, cut'n'pasting the line from above.

> Anyway, my main concern with unconditionally setting the backlight level to
> the maximum is that any stored brightness level (by the BIOS or whatever) may
> be lost, and that the screen is set to maximum brightness at each boot. This
> is certainly the behaviour I've seen with an unpatched kernel. So I propose to
> do what my patch does and set it to intel_panel_get_backlight(dev) if that
> returns non-zero. Something like this:

Sure, s/intel_panel_get_max_backlight/intel_panel_get_backlight/ and we
get the behaviour we both want - preserving the current backlight unless
none is set.

> While I'm glad this problem is being fixed upstream, it would be nice to get
> some credit for finding the source of the problem.

Sorry. You found the bug but I felt your rationale was off. However, I was
amiss in not giving you the credit you fully deserved.
-Chris

commit 9c1c388a53e5df8819e898106a64e34d0994a5d4
Author: Indan Zupancic <indan@nul.nu>
Date:   Wed Jan 12 11:59:19 2011 +0000

    drm/i915/panel: The backlight is enabled if the current value is non-zero
    
    ... and not if the maximum is non-zero. This fixes the typo introduced
    in 47356eb6728501452 and preserves the backlight value from boot.
    
    [ickle: My thanks also to Indan Zupancic for diagnosing the original
            regression and suggesting the appropriate fix.]
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: stable@kernel.org # after 47356eb6728501452

diff --git a/drivers/gpu/drm/i915/intel_panel.c
b/drivers/gpu/drm/i915/intel_pan
index e00d200..27c79c7 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -278,6 +278,6 @@ void intel_panel_setup_backlight(struct drm_device
*dev)
 {
        struct drm_i915_private *dev_priv = dev->dev_private;
 
-       dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
+       dev_priv->backlight_level = intel_panel_max_backlight(dev);
        dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
 }

-- 
Chris Wilson, Intel Open Source Technology Centre
