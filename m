Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0HXIfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:35:22 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:35097 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751683Ab0HXIfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:35:19 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX1+E46kdqFiEnxtGnQMEHhUPrECzZEV2xdeqCf5Ovf
	tExjPOdGWi6+j6
Subject: Re: i915: 2.6.36-rc2 wrong resolution on gdm start
From: Ivan Bulatovic <combuster@gmx.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, eric@anholt.net
In-Reply-To: <8u3s8d$jcftu0@orsmga001.jf.intel.com>
References: <1282611655.2177.19.camel@localhost.localdomain>
	 <8u3s8d$jcftu0@orsmga001.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 10:35:12 +0200
Message-ID: <1282638912.2191.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 08:49 +0100, Chris Wilson wrote: 
> On Tue, 24 Aug 2010 03:00:55 +0200, Ivan Bulatovic <combuster@gmx.com> wrote:
> > While in init3, resolution is native, KMS works fine, no problems at
> > all. As soon as gdm starts it seems that TV1 output is recognized as
> > connected even if it isn't so resolution on VGA output is degraded from
> > native 1280x1024 to 1024x768 on startup.
> 
> Interesting. I am chasing a spurious TV connection on SDVO that has been
> present since time immemorial. How certain are you that you've never have a
> false detection in earlier kernels? It may not have affected the choice of
> outputs, except sporadically, but it should be recorded in the debug logs
> with drm.debug=0x6.
> 
> Does this make any difference?
> 
> diff --git a/drivers/gpu/drm/i915/intel_sdvo.c
> b/drivers/gpu/drm/i915/intel_sdvo
> index ea2f4ab..e7ff378 100644
> --- a/drivers/gpu/drm/i915/intel_sdvo.c
> +++ b/drivers/gpu/drm/i915/intel_sdvo.c
> @@ -1454,7 +1454,7 @@ intel_sdvo_detect(struct drm_connector *connector,
>                 return connector_status_unknown;
>         if (intel_sdvo->is_tv) {
>                 /* add 30ms delay when the output type is SDVO-TV */
> -               mdelay(30);
> +               mdelay(100);
>         }
>         if (!intel_sdvo_read_response(intel_sdvo, &response, 2))
>                 return connector_status_unknown;
> 
> Or (more likely):
> 
> diff --git a/drivers/gpu/drm/i915/intel_sdvo.c
> b/drivers/gpu/drm/i915/intel_sdvo
> index ea2f4ab..77c455b 100644
> --- a/drivers/gpu/drm/i915/intel_sdvo.c
> +++ b/drivers/gpu/drm/i915/intel_sdvo.c
> @@ -1216,8 +1216,8 @@ static int intel_sdvo_dpms(struct drm_encoder
> *encoder, in
>                 temp = I915_READ(intel_sdvo->sdvo_reg);
>                 if ((temp & SDVO_ENABLE) == 0)
>                         intel_sdvo_write_sdvox(intel_sdvo, temp |
> SDVO_ENABLE);
> -               for (i = 0; i < 2; i++)
> -                       intel_wait_for_vblank(dev, intel_crtc->pipe);
> +
> +               msleep(100);
>  
>                 status = intel_sdvo_get_trained_inputs(intel_sdvo,
>                                                        &input1, &input2);
> 
> -- 
> Chris Wilson, Intel Open Source Technology Centre

Hi Chris. Well, I think that I had these problems before, around
2.6.28/2.6.29 but all I remember is that it was fixed relatively fast.
Everything worked well untill 2.6.36-rc2 popped up. Not even sporadical
events like these. What was strange about this that I wasn't able to
kill TV connection with xrandr, so I was stuck with 1024x768 and all of
a sudden upon subsequent restarts it somehow remembered that tv is
disconnected and VGA resolution is native.

xrandr -q

TV1 disconnected (normal left inverted right x axis y axis)
  848x480 (0x55)   14.5MHz
        h: width   848 start  849 end  912 total  944 skew    0 clock
15.4KHz
        v: height  480 start  481 end  512 total  513           clock
30.0Hz


cat /var/log/Xorg.0.log | grep TV

[    27.733] (II) intel(0): Output TV1 has no monitor section
[    27.988] (II) intel(0): EDID for output TV1
[    27.991] (II) intel(0): Printing probed modes for output TV1
[    27.991] (II) intel(0): Output TV1 connected
[    27.991] (II) intel(0): Output TV1 using initial mode 1024x768

Above patches didn't help when applied to 2.6.36-rc2. 

I'm going to compare dmesg between 2.6.35.3 and 2.6.36-rc2 with
drm.debug=0x6. Thanks,

Ivan

