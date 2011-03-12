Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1CLBQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:16:12 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:56028 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1CLBQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:16:08 -0500
Message-ID: <0c95516185af4197b4045dc88b7e343d.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110311092751.3812b03c@jbarnes-vaio.home>
References: <5e60ae646a15c73f5be0c309f51d1c63.squirrel@webmail.greenhost.nl>
    <20110311092751.3812b03c@jbarnes-vaio.home>
Date: Sat, 12 Mar 2011 02:15:54 +0100 (CET)
Subject: Re: drm/i915: Fix DPMS and suspend interaction for intel_panel.c
From: "Indan Zupancic" <indan@nul.nu>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Cc: "Keith Packard" <keithp@keithp.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: a2a1964a1561ab7a63907465a561ffe8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, March 11, 2011 18:27, Jesse Barnes wrote:
> On Fri, 11 Mar 2011 02:35:45 +0100 (CET)
> "Indan Zupancic" <indan@nul.nu> wrote:
>
>> drm/i915: Fix DPMS and suspend interaction for intel_panel.c
>>
>> When suspending intel_panel_disable_backlight() is never called,
>> but intel_panel_enable_backlight() is called at resume. With the
>> effect that if the brightness was ever changed after screen
>> blanking, the wrong brightness gets restored at resume time.
>>
>> Nothing guarantees that those calls will be balanced, so having
>> backlight_enabled makes no sense, as the real state can change
>> without the panel code noticing. So keep things as stateless as
>> possible.
>>
>> Signed-off-by: Indan Zupancic <indan@nul.nu>
>
> Chris is right that we don't always control the backlight brightness
> directly, so we'll want a more complete solution at any rate.

Well, not having control basically means not caching any register
values, or as little as possible. For gen >=4 there's the top bit
of BLC_PWM_CTL2, so the brightness handling can be cleanly separated
from the panel disabling/enabling. For older gens we need to save
the brightness and then set it to zero, as happens now.

For brightness control we only need to set the new brightness on
systems with ASLE.

> I don't think this one is urgent enough to send upstream now, and it
> would be good to make a couple of other fixes as well, while you're
> fixing things up. :)  Comments below.

It's not urgent, it's just a bugfix. I did my best to resist the
urge to do other cleanups as well, so close to the release cycle.

>From my point of view it's sad that 2.6.37 was released with buggy
backlight handling, and it would be sad if it wasn't fixed in 2.6.38.
But I think this is only because I have a gen 2 and the check for
combination mode for gen 2 was added in 2.6.37, everyone else already
had the buggy backlight behaviour for ages. Without the check gen 2
works correctly because the PWM value never changes, only LBPC, and
the driver didn't touch LBPC.

>> -/* i915_suspend.c */
>> -extern int i915_save_state(struct drm_device *dev);
>> -extern int i915_restore_state(struct drm_device *dev);
>> -
>
> Looks like a spurious cleanup hunk, should be a separate hunk (possibly
> along with other save/restore state cleanups, like removing all the
> ILK+ code that probably won't work well :).

Wild guess: ILK+ means Ironlake+?

But indeed, though as the duplicate declaration is in the diff context
it seemed safe enough at the time. ;-)

>> -void intel_panel_setup_backlight(struct drm_device *dev)
>> -{
>> -	struct drm_i915_private *dev_priv = dev->dev_private;
>> -
>> -	dev_priv->backlight_level = intel_panel_get_backlight(dev);
>> -	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
>>  }
>
> This is getting pretty messy.

That functions was added in the 2.6.38 cycle I think, in an attempt
to fix the backlight problems.

>  Your patch is a step in the right
> direction, but I think we may as well go further:
>   - suspend/resume of backlight state belongs in the backlight class
>     driver

There is no backlight suspend/resume handling, the panel just gets
enabled at resume. The registers save/restore is done i915_suspend.c,
where it belongs. The current bugginess is not only for suspend, but
for any two DPMS on calls without a disable in between. Try

xset dpms force off
xset dpms force on
..change brightness..
xset dpms force on

I think you'll get the old brightness.

>   - that driver should call into the registered i915 backlight handler
>     if i915 is controlling it natively (PWM native, combo, legacy)

Brightness setting is only needed for ASLE, otherwise it's never set
by the driver. So in the end most complexity is only there because of
one combination: ASLE + legacy combination mode.

>   - we need a backlight driver struct with function pointers for the
>     various calls, so we can split out the PCH functions from the rest;
>     might be good to separate native, combo, and legacy that way as
>     well; even if results in some code duplication it might make each
>     easier to read and less likely to break others when we make changes

Problem is, are we sure that systems don't change from legacy combination
mode to BLC_PWM_CTL only? Otherwise you have to check every time.

I must admit I'm not sure what the backlight hierarchy is, but I don't
think the intel_panel.c code has much to do with it: It has nothing to
do with backlight key events and doesn't handle them. All it does is
enabling or disabling the panel for DPMS. The only thing that needs to
set the backlight is intel_opregion.c when ASLE is used, and that bit
should indeed go somewhere else.

So if I'd clean up the code, I think this is what I would try first:

Rip out all brightness control out of intel_panel.c and replace it
with a generic, minimal register saving for disabling the panel, with
all system specific info (which registers to use, masks, etc.) stored
in struct intel_device_info.

All the extra complexity comes from ASLE. As you wrote the Intel ASLE
documentation, I hope you can give some more information about it:

1) First, are there any gen 2 or gen 3 systems with ASLE? If not, there
is no need to handle legacy combination mode for those gens. I think
ASLE came with gen 4, but can you confirm that? Either the gen 2 check
for legacy mode is not needed, or a gen 3 check needs to be added.

2) What happens if the driver doesn't support ASLE? If the BIOS changes
the brightness directly, then we can rip out the whole ASLE thing, as
it's useless. This is probably not possible, so we have to keep the
ASLE madness.

If ASLE needs to set the brightness then we need a way to do that.
But I'd change the interface to a percentage or 0-255 scale, that
fits better with the ASLE thing and the max brightness is hidden.

(I dislike ASLE because it's clear the BIOS knows how to do what it
wants, but bothers the driver with it, which has to do it the same
way as the BIOS, or things stop working.)

And instead of all those almost duplicate functions I'd have one
generic one that works for all, with system specific stuff put in
struct intel_device_info.

i915_read_blc_pwm_ctl() can be greatly simplified by calling
i915_save_state() early and often enough. I don't think you want crash
recovery scattered around the code like that, but done centrally so it's
easier to recover from a hardware crash. I guess saving state just after
driver initialisation and after every modeset is close to enough, but I
have no idea about 3D. My hope is that after a GPU hang, the system can
be restored by resetting the GPU and restore the state. I haven't looked
into this yet, are there any reasons why this won't work?

The intel_panel_get_max_backlight() code can be simplified by always
ignoring the first bit, so that the Pineview and gen < 4 handling can
be generic.

I think abstracting more specific system behaviour into struct
intel_device_info instead of the gen checks everywhere would often
simplify and reduce the code.

> Any thoughts about that?  I think Chris and Matthew have been
> talking about it as well, so I'd be curious what our backlight
> final solution ought to be.

Didn't Matthew factor out the intel opregion code? That should get the
brightness setting hooked up into the right spot too.

After the above cleanups it's only a matter where to put the set_backlight()
code.

But it seems all improvements can be done incrementally, and as they change
a lot of code, it's good to start from a working base. So that would be a
reason to apply my patch this cycle instead of later. Either that, or apply
it in rc1 and do everything else in rc2 or later, but that seems worse. But
it's up to you guys.

Greetings,

Indan


