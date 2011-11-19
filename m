Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1KSJdV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 04:33:21 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53203 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1KSJdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 04:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <861ut5mdvn.fsf@sumi.keithp.com>
References: <s5hlirgm1kg.wl%tiwai@suse.de>
	<yunsjlnl1f6.fsf@aiko.keithp.com>
	<s5hlirelndd.wl%tiwai@suse.de>
	<861ut5mdvn.fsf@sumi.keithp.com>
Date: Sat, 19 Nov 2011 10:33:16 +0100
Message-ID: <CACTFLAMuPQ6ycmrByT-XxN5RgY6MLbUMhwEMup8o0qBJdwY4iQ@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Fix invalid backpanel values for GEN3 or older chips
From: Daniel Mack <zonque@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, harald@redhat.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 8:25 PM, Keith Packard <keithp@keithp.com> wrote:
> On Thu, 17 Nov 2011 17:33:50 +0100, Takashi Iwai <tiwai@suse.de> wrote:
>
>> If it's only with 915GM, we'll just need to change IS_PINEVEW() to
>> IS_PINEVIEW() || IS_I915GM().  This might be a safer option at this
>> moment unless we check all cases or specs...
>
> I read through the hardware docs yesterday and figured out what was
> going on. On all pre-gen4 hardware, the maximum backlight value has the
> lowest bit (of 16) hard-wired to zero. This means that the possible
> backlight duty cycle values are limited to 0 .. 0xfffe.
>
> On older hardware, this was managed by reporting this true range. This
> meant that the set_backlight path didn't need any special code; simply
> setting the values as provided should have worked just fine.
>
> On Pineview, this was changed (for reasons unknown) to use only 15 bits
> for backlight levels. The range of possible values is then
> 0 .. 0x7fff. In this case, values have to be shifted by one to convert
> between the advertised range of 0 .. 0x7fff and the hardware range of
> 0 .. 0xfffe.
>
> Exposing the range of 0 .. 0xfffe introduces a potential problem --
> write a value of 0xffff and the hardware gets mightily confused,
> and probably ends up turning the backlight off. Using the range of
> 0 .. 0x7fff avoids this issue completely.
>
> Using the narrower range does limit the precision of the backlight level
> setting, but it seems like 32767 possible values is more than sufficient...
>
> Here's a patch which just uses the pineview version everywhere (and
> cleans that up at the same time).
>
> From e06789f688dc7ab1331f5f15ad3d60326b5139b4 Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Fri, 18 Nov 2011 11:09:24 -0800
> Subject: [PATCH] drm/i915: Treat pre-gen4 backlight duty cycle value
>  consistently
>
> For i945 and earlier chips, the backlight frequency value had the low
> bit (of 16) fixed to zero. The Pineview code path handled this by just
> exposing the backlight range as 15 bits while other chips had the
> backlight range limited to 0 .. 0xfffe.
>
> This patch makes everyone take the pineview code path, providing 15
> bits of backlight duty cycle range which seems more than sufficient to me.
>
> Signed-off-by: Keith Packard <keithp@keithp.com>

Yep, that works as well. Thanks.

Reported-and-tested-by: Daniel Mack <zonque@gmail.com>
Cc: stable@kernel.org


> ---
>  drivers/gpu/drm/i915/intel_panel.c |   16 +++++-----------
>  1 files changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index 21f60b7..04d79fd 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -178,13 +178,10 @@ u32 intel_panel_get_max_backlight(struct drm_device *dev)
>        if (HAS_PCH_SPLIT(dev)) {
>                max >>= 16;
>        } else {
> -               if (IS_PINEVIEW(dev)) {
> +               if (INTEL_INFO(dev)->gen < 4)
>                        max >>= 17;
> -               } else {
> +               else
>                        max >>= 16;
> -                       if (INTEL_INFO(dev)->gen < 4)
> -                               max &= ~1;
> -               }
>
>                if (is_backlight_combination_mode(dev))
>                        max *= 0xff;
> @@ -203,13 +200,12 @@ u32 intel_panel_get_backlight(struct drm_device *dev)
>                val = I915_READ(BLC_PWM_CPU_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
>        } else {
>                val = I915_READ(BLC_PWM_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
> -               if (IS_PINEVIEW(dev))
> +               if (INTEL_INFO(dev)->gen < 4)
>                        val >>= 1;
>
>                if (is_backlight_combination_mode(dev)) {
>                        u8 lbpc;
>
> -                       val &= ~1;
>                        pci_read_config_byte(dev->pdev, PCI_LBPC, &lbpc);
>                        val *= lbpc;
>                }
> @@ -246,11 +242,9 @@ static void intel_panel_actually_set_backlight(struct drm_device *dev, u32 level
>        }
>
>        tmp = I915_READ(BLC_PWM_CTL);
> -       if (IS_PINEVIEW(dev)) {
> -               tmp &= ~(BACKLIGHT_DUTY_CYCLE_MASK - 1);
> +       if (INTEL_INFO(dev)->gen < 4)
>                level <<= 1;
> -       } else
> -               tmp &= ~BACKLIGHT_DUTY_CYCLE_MASK;
> +       tmp &= ~BACKLIGHT_DUTY_CYCLE_MASK;
>        I915_WRITE(BLC_PWM_CTL, tmp | level);
>  }
>
> --
> 1.7.7.3
>
>
>
> --
> keith.packard@intel.com
>
