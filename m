Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab2JNL0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 07:26:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39196 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2JNL0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 07:26:46 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <507A91EA.2030205@cfl.rr.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
	<CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com>
	<507A91EA.2030205@cfl.rr.com>
Date: Sun, 14 Oct 2012 13:26:45 +0200
X-Google-Sender-Auth: 5Pz3NYNp0OXzV1BlgLTts5JQFnI
Message-ID: <CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com>
Subject: Re: [Intel-gfx] Intel graphics drm issue?
From: Daniel Vetter <daniel@ffwll.ch>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 12:20 PM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> Hi Daniel,
>
> cat /proc/cmdline
> root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4
> video=1024x768 noresume splash=silent quiet apm=off nomodeset vga=normal
> drm.debug=0xe
>
> dmesg is attached

>From the dmesg:

[    1.833195] [drm:drm_pci_agp_init] *ERROR* Cannot initialize the
agpgart module.

Which is the root-cause preventing i915.ko from loading. Now with 3.7
we /shouldn't/ all that agp crap any longer on snb/ivb, so I'm a bit
confused why it still tries to initialize it. Can you maybe attach
your .config?

Also, we need to employ some dirty runtime tricks to no longer require
agp on newer chips, since we still need to keep it around for
backwards-compat with old userspace on old chips. Can you please check
with the below diff whether this hack works?

Thanks, Daniel

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index a7837e5..1152502 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -842,6 +842,7 @@ i915_pci_probe(struct pci_dev *pdev, const struct
pci_device_id *ent)
        if (intel_info->gen != 3) {
                driver.driver_features &=
                        ~(DRIVER_USE_AGP | DRIVER_REQUIRE_AGP);
+               printk("dropping agp requirement\n");
        } else if (!intel_agp_enabled) {
                DRM_ERROR("drm/i915 can't work without intel_agp module!\n");
                return -ENODEV;

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
