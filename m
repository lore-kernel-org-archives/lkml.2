Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1FOVaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:30:06 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:38139
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353Ab1FOVaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:30:03 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p5FLTsL0024655
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [2.6.39] drm/i915: blank screen on Lenovo Ideapad U160
In-Reply-To: <20110615115903.685acba0@jbarnes-desktop> (Jesse Barnes's message
	of "Wed, 15 Jun 2011 11:59:03 -0700")
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	<gitycau362.fsf@mx10.gouders.net> <giei3eoeic.fsf@mx10.gouders.net>
	<gi1uyx8m2f.fsf_-_@mx10.gouders.net>
	<20110615115903.685acba0@jbarnes-desktop>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Wed, 15 Jun 2011 23:29:53 +0200
Message-ID: <giips6lr5a.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Wed, 15 Jun 2011 23:29:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> On Mon, 13 Jun 2011 23:21:12 +0200
> Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>
>> Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:
>> 
>> > Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:
>> >
>> >> "Robert P. J. Day" <rpjday@crashcourse.ca> writes:
>> >>
>> >>> On Tue, 31 May 2011, Dirk Gouders wrote:
>> >>>
>> >>>> Hello,
>> >>>>
>> >>>> I tested 3.0.0-rc1 on my notebook which has never been the best friend
>> >>>> of the i915 driver.  With linux-2.6.38-gentoo-r4 it has the problem
>> >>>> that the screen remains blank after the lid is closed and reopened, but
>> >>>> that problem I can live with.  With 3.0.0-r1 I am back to a former
>> >>>> problem that the screen goes (and remains) blank while booting.
>> >>>>
>> >>>> The next step I will do is to test linux-2.6.39-gentoo, probably I
>> >>>> did not notice information that I have to adjust boot parameters or the
>> >>>> kernel config?
>> >>>
>> >>>   based on my having lived through the i915 "black screen of death",
>> >>> pulling out my handy "git bisect" and with advice from chris wilson,
>> >>> these days, i simply apply this patch to the source:
>> >>>
>> >>> diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
>> >>> index d2c7104..a1a5d03 100644
>> >>> --- a/drivers/gpu/drm/i915/intel_opregion.c
>> >>> +++ b/drivers/gpu/drm/i915/intel_opregion.c
>> >>> @@ -152,6 +152,8 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
>> >>>  	struct opregion_asle *asle = dev_priv->opregion.asle;
>> >>>  	u32 max;
>> >>>
>> >>> +return ASLE_BACKLIGHT_FAILED; // rday
>> >>> +
>> >>>  	if (!(bclp & ASLE_BCLP_VALID))
>> >>>  		return ASLE_BACKLIGHT_FAILED;
>> >>>
>> >>>
>> >>>   i tried taking it out a couple of times and immediately got the same
>> >>> i915-related problem so until i hear differently, the patch stays in.
>> >>
>> >> Thanks for the hint.  I tested the patch with 3.0.0-rc1 and
>> >> unfortunately the symptoms remain the same.
>> >>
>> >> Meanwhile, I tested 2.6.39-gentoo as well and it also causes that
>> >> problem.  So, this is not really a (new) 3.0.0-rc1 issue.
>> >>
>> >> Best regards,
>> >>
>> >> Dirk
>> >
>> > Your patch reminded me of another patch of Chris that caused problems
>> > for several other people, but manually applied to the changed context in
>> > 3.0.0-rc1 again works for me:
>> >
>> > --- linux-3.0-rc1/drivers/gpu/drm/i915/intel_bios.c     2011-05-30 02:43:36.000000000 +0200
>> > +++ /usr/src/linux-3.0-rc1/drivers/gpu/drm/i915/intel_bios.c    2011-05-31 20:53:35.000000000 +0200
>> > @@ -267,7 +267,7 @@
>> >         case 4:
>> >                 return alternate ? 100 : 96;
>> >         default:
>> > -               return alternate ? 100 : 120;
>> > +               return alternate ? 120 : 100;
>> >         }
>> >  }
>> >
>> > The strange thing is that I am pretty sure that I did not have to modify
>> > 2.6.28-gentoo{,-r4} what I at that time also reported here:
>> > https://bugs.freedesktop.org/show_bug.cgi?id=31596
>> 
>> For completeness I want to report that I did a bisect and found out that
>> the following commit seems to be the one that reintroduced the problem
>> that I have to manually patch the kernel to avoid a blank screen
>> (with backlight turned on) during boot:
>> 
>> 47a05eca72991039e788b25232061f9c9df9ec23 is the first bad commit
>> commit 47a05eca72991039e788b25232061f9c9df9ec23
>> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Date:   Mon Feb 7 13:46:40 2011 -0800
>> 
>>     drm/i915: disable PCH ports if needed when disabling a CRTC
>>     
>>     Disable any PCH ports associated with a pipe when disabling it.  This
>>     should prevent transcoder disable failures due to ports still being on.
>>     
>>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>>     [ickle: introduce *_PIPE_ENABLED() macro]
>>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> 
>> :040000 040000 2c7c54cceb89821941943614cede86c4a2c2a8bc 9382527ee169beb54a10eb0afe8a69d418025c2e M      drivers
>
> Just to confirm, does this patch also keep your screen enabled?
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_d
> index 81a9059..ef41487 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1366,7 +1366,7 @@ static void intel_disable_pch_ports(struct drm_i915_privat
>         val = I915_READ(reg);
>         if (ADPA_PIPE_ENABLED(val, pipe))
>                 I915_WRITE(reg, val & ~ADPA_DAC_ENABLE);
> -
> +#if 0
>         reg = PCH_LVDS;
>         val = I915_READ(reg);
>         if (LVDS_PIPE_ENABLED(val, pipe)) {
> @@ -1374,7 +1374,7 @@ static void intel_disable_pch_ports(struct drm_i915_privat
>                 POSTING_READ(reg);
>                 udelay(100);
>         }
> -
> +#endif
>         disable_pch_hdmi(dev_priv, pipe, HDMIB);
>         disable_pch_hdmi(dev_priv, pipe, HDMIC);
>         disable_pch_hdmi(dev_priv, pipe, HDMID);

No, that patch does not help.

Yesterday, I reverted the following part of the above commit which
completely leaves out the call to intel_disable_pch_ports() and that
helped, but I'm afraid that is not very useful information:

@@ -2864,14 +2900,12 @@ static void ironlake_crtc_disable(struct drm_crtc *crtc)
 
        ironlake_fdi_disable(crtc);
 
-       if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
-               temp = I915_READ(PCH_LVDS);
-               if (temp & LVDS_PORT_EN) {
-                       I915_WRITE(PCH_LVDS, temp & ~LVDS_PORT_EN);
-                       POSTING_READ(PCH_LVDS);
-                       udelay(100);
-               }
-       }
+       /* This is a horrible layering violation; we should be doing this in
+        * the connector/encoder ->prepare instead, but we don't always have
+        * enough information there about the config to know whether it will
+        * actually be necessary or just cause undesired flicker.
+        */
+       intel_disable_pch_ports(dev_priv, pipe);
 
        intel_disable_transcoder(dev_priv, pipe);
