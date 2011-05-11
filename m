Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1EKT6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:58:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37322 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1EKT6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NZUWwCIWlVPjnCw3C19aMI3P9zJNu8+w9hfO//f2JfJyuOOwI+78qrnTCeJG1NjAhY
         9fVIKmVNxdZtjBaMNr/nGPjUEYR4gPXikBUIBUkw3BuJ/BmaaSddJ7OzSKu/UDZNr8pT
         3pb31uVLtESBNzGahppJY5+uA6hfWrpPnTJG0=
Date: Wed, 11 May 2011 21:58:08 +0200
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Skip bogus LVDS VBT mode and check for LVDS
 before adding backlight
Message-ID: <20110511195808.GA5691@patrik-macbook>
References: <20110511172053.GA3557@patrik-macbook>
 <20110511185553.5260805f@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511185553.5260805f@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 06:55:53PM +0100, Alan Cox wrote:
> On Wed, 11 May 2011 19:20:53 +0200
> Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:
> 
> > On the Fit-PC2 the VBT reports an invalid fixed panel mode for LVDS,
> > this gets in the way for SDVO. This patch makes VBT parsing skip the
> > invalid mode. When there is no LVDS output the backlight support
> > crashes so the patch also checks for this before enabling it.
> 
> Looks good for now. The backlight is a bit more complicated I think
> (users can turn on the LVDS at runtime in theory) but we can handle
> that later so long as we tag it with a /* FIXME: Handle turning on LVDS
> at runtime */
> 
> Alan

Backlight is only disabled in case no LVDS modes can be found. And in that
case, no LVDS connector gets added. Am I understanding you correctly if
"in theory" means LVDS can be hotplugged? In that case we have to call
psb_intel_lvds_init when hotplug occurs so the output gets added. If so, we
should put psb_backlight_init() there.

Please try the following patch on a system with LVDS hooked-up to something.

-Patrik

---

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 46ab028..ed7be24 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -663,9 +663,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 		drm_kms_helper_poll_init(dev);
 	}
 
-	ret = psb_backlight_init(dev);
-	if (ret)
-		return ret;
 #if 0
 	/*enable runtime pm at last*/
 	pm_runtime_enable(&dev->pdev->dev);
diff --git a/drivers/staging/gma500/psb_intel_bios.c b/drivers/staging/gma500/psb_intel_bios.c
index 48ac8ba..417965d 100644
--- a/drivers/staging/gma500/psb_intel_bios.c
+++ b/drivers/staging/gma500/psb_intel_bios.c
@@ -154,10 +154,15 @@ static void parse_lfp_panel_data(struct drm_psb_private *dev_priv,
 
 	fill_detail_timing_data(panel_fixed_mode, dvo_timing);
 
-	dev_priv->lfp_lvds_vbt_mode = panel_fixed_mode;
-
-	DRM_DEBUG("Found panel mode in BIOS VBT tables:\n");
-	drm_mode_debug_printmodeline(panel_fixed_mode);
+	if (panel_fixed_mode->htotal > 0 && panel_fixed_mode->vtotal > 0) {
+		dev_priv->lfp_lvds_vbt_mode = panel_fixed_mode;
+		DRM_DEBUG("Found panel mode in BIOS VBT tables:\n");
+		drm_mode_debug_printmodeline(panel_fixed_mode);
+	} else {
+		DRM_DEBUG("Ignoring bogus LVDS VBT mode.\n");
+		dev_priv->lvds_vbt = 0;
+		kfree(panel_fixed_mode);
+	}
 
 	return;
 }
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index b0a225b..081402a 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -843,6 +843,9 @@ void psb_intel_lvds_init(struct drm_device *dev,
 		goto failed_find;
 	}
 
+	if (psb_backlight_init(dev))
+		DRM_DEBUG("Backlight initialization failed\n");
+
 	/*
 	 * Blacklist machines with BIOSes that list an LVDS panel without
 	 * actually having one.
