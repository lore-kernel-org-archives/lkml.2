Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2JNLjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 07:39:24 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:21777 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2JNLjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 07:39:23 -0400
X-Authority-Analysis: v=2.0 cv=OOOlLFmB c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=g7R6esmICIkA:10 a=05ChyHeVI94A:10 a=8nJEP1OIZ-IA:10 a=ayC55rCoAAAA:8 a=HjRi3UqH30YA:10 a=vFjhSUxfD_l3DD1Us0UA:9 a=wPNLvfGTeEIA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507AA469.5070100@cfl.rr.com>
Date: Sun, 14 Oct 2012 07:39:21 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: markh@compro.net,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com> <507A91EA.2030205@cfl.rr.com> <CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com>
In-Reply-To: <CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 07:26 AM, Daniel Vetter wrote:
> On Sun, Oct 14, 2012 at 12:20 PM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>> Hi Daniel,
>>
>> cat /proc/cmdline
>> root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4
>> video=1024x768 noresume splash=silent quiet apm=off nomodeset vga=normal
>> drm.debug=0xe
>>
>> dmesg is attached
>
>>From the dmesg:
>
> [    1.833195] [drm:drm_pci_agp_init] *ERROR* Cannot initialize the
> agpgart module.
>
> Which is the root-cause preventing i915.ko from loading. Now with 3.7
> we /shouldn't/ all that agp crap any longer on snb/ivb, so I'm a bit
> confused why it still tries to initialize it. Can you maybe attach
> your .config?
>

Did you mean 3.6 above? I used 3.6.2? If I'm using the right kernel I will 
apply the patch and try. Let me know.

> Also, we need to employ some dirty runtime tricks to no longer require
> agp on newer chips, since we still need to keep it around for
> backwards-compat with old userspace on old chips. Can you please check
> with the below diff whether this hack works?
>
> Thanks, Daniel
>
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index a7837e5..1152502 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -842,6 +842,7 @@ i915_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *ent)
>          if (intel_info->gen != 3) {
>                  driver.driver_features &=
>                          ~(DRIVER_USE_AGP | DRIVER_REQUIRE_AGP);
> +               printk("dropping agp requirement\n");
>          } else if (!intel_agp_enabled) {
>                  DRM_ERROR("drm/i915 can't work without intel_agp module!\n");
>                  return -ENODEV;
>

Doesn't this patch only add a printk? Is that what you want me to do?

Mark

