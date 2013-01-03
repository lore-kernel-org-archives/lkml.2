Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3ACX4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:56:38 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:48512 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3ACX4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:56:36 -0500
MIME-Version: 1.0
In-Reply-To: <6c3329$7ukf5e@orsmga002.jf.intel.com>
References: <CA+55aFxQ9vH70UrqC0ypm-diNbGcZbWbdhYa3FLH+0Vbrk4hUQ@mail.gmail.com>
	<CAB9v_DHJYAEcZDuPd3XBEib_nGca=_sKbZngV3z1N6H8KcJJGQ@mail.gmail.com>
	<CA+55aFzQtxET9JWdaLGi52OL=A9yRbj+vaa7RfniuBvfB5K04Q@mail.gmail.com>
	<6c3329$7ukf5e@orsmga002.jf.intel.com>
Date: Thu, 3 Jan 2013 16:56:34 -0700
Message-ID: <CAKocOOOSGDp644fCEdeJ22GCOW00PVB3fedA_3O81q-1rp247Q@mail.gmail.com>
Subject: Re: Linux 3.8-rc2
From: Shuah Khan <shuahkhan@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 3:45 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, 3 Jan 2013 13:32:04 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> On Thu, Jan 3, 2013 at 1:09 PM, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>> >
>> > i915 got broken on my machine (Lenovo ThinkPad SL500) by this -rc. The screen
>> > goes blank after loading the module. I've bisected the problem to
>> > b0a2658acb5bf9ca86b4aab011b7106de3af0add "drm/i915: don't disable
>> > disconnected outputs".
>>
>> Hmm. Daniel - should I just revert it, or do you have a patch to
>> possibly fix the divide-by-zero error in g4x_compute_wm0() (which may
>> involve not getting that deep in the call chain to begin with or
>> whatever)? Maybe that fixes the blank screen too without a revert..
>
> The issue appears to be a disagreement between intel_crtc->active, an
> attached framebuffer and there not being a valid mode set on the crtc.
>
> It looks like we end up in that situation with further confusion over
> intel_crtc->base.enabled vs intel_crtc->active. I suspect the answer is
> something like:
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index a9fb046..5e4b818 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7940,10 +7940,8 @@ bool intel_set_mode(struct drm_crtc *crtc,
>                 }
>         }
>
> -       for_each_intel_crtc_masked(dev, prepare_pipes, intel_crtc) {
> -               if (intel_crtc->base.enabled)
> -                       dev_priv->display.crtc_disable(&intel_crtc->base);
> -       }
> +       for_each_intel_crtc_masked(dev, prepare_pipes, intel_crtc)
> +               dev_priv->display.crtc_disable(&intel_crtc->base);
>
>         /* crtc->mode is already used by the ->mode_set callbacks, hence we need
>          * to set it here already despite that we pass it down the callchain.
>
> However, until that confusion is unravelled, reverting b0a2658ac, seems
> the most sensible approach.
> -Chris

There is a "radeon 0000:02:00.0: GPU lockup CP stall for more than
10000msec" issue that was in 3.8.-rc1 which is related to drm changes.

Reference:  https://lkml.org/lkml/2013/1/2/289

Good to get that fix into 3.8-rc2.

-- Shuah
