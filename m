Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0LPKKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:10:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:11374 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab0LPKKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:10:41 -0500
Message-Id: <b9dded$hd6gpd@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,354,1288594800"; 
   d="scan'208";a="584270637"
Date: Thu, 16 Dec 2010 10:10:36 +0000
To: Hui Zhu <teawater@gmail.com>
Subject: Re: [BUG] i915 boot got black screen with 2.6.37-rc5+
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com, ak@linux.intel.com,
        gregkh@suse.de, stable@kernel.org, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <AANLkTi=6HOsAg1mvoZ4GBy-vw2cH-bGUsQVGtCseWvy4@mail.gmail.com>
References: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com> <b9dded$hcr3k7@orsmga002.jf.intel.com> <AANLkTim=k601vg+sJJH3bvdfAmrCbCEouL78XoVxuDwy@mail.gmail.com> <5b55a1$iv0t6h@fmsmga002.fm.intel.com> <AANLkTi=6HOsAg1mvoZ4GBy-vw2cH-bGUsQVGtCseWvy4@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 10:20:57 +0800, Hui Zhu <teawater@gmail.com> wrote:
> On Wed, Dec 15, 2010 at 18:20, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Wed, 15 Dec 2010 17:28:45 +0800, Hui Zhu <teawater@gmail.com> wrote:
> >> lspci | grep Display
> >> 00:02.1 Display controller: Intel Corporation 82Q35 Express Integrated
> >> Graphics Controller (rev 02)
> >
> > Q35. I wasn't expecting that. Can you please add drm.debug=0xe to your
> > boot line and attach the dmesg from rc3 and rc5? Thanks.
> > -Chris
> >
> > --
> > Chris Wilson, Intel Open Source Technology Centre
> >
> 
> Thanks Chris.
> 
> I post the logs of rc3+, rc4+ and rc5+ in attchement.  Wish they can
> be more helpful.

The hotplug probe was failing. The only change along that path I could see
was to setting some hotplug flags in the analag adapter register. Can you
try this patch to see if it fixes things for you? Meanwhile I'll check the
docs for the validity of those flags for the various gen.

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
