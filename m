Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2G0Lqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 07:46:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33889 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G0Lqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 07:46:53 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [REGRESSION] [KMS] [INTEL] Wrong resolution in console and XWindow
Date: Fri, 27 Jul 2012 13:46:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc3; KDE/4.8.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
References: <201207251020.47637.maciej.rutecki@gmail.com> <CAKMK7uEZ+TYziN9tNDUc-UVeAzvVuivA869uwQYiWGoAKEq1jg@mail.gmail.com> <20120726123828.GE5326@phenom.ffwll.local>
In-Reply-To: <20120726123828.GE5326@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207271346.49259.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 26 lipca 2012 o 14:38:28 Daniel Vetter wrote:
> On Wed, Jul 25, 2012 at 01:55:59PM +0200, Daniel Vetter wrote:
> > On Wed, Jul 25, 2012 at 12:57 PM, Maciej Rutecki
> > 
> > <maciej.rutecki@gmail.com> wrote:
> > > On środa, 25 lipca 2012 o 11:29:28 Daniel Vetter wrote:
> > >> On Wed, Jul 25, 2012 at 10:54:25AM +0200, Maciej Rutecki wrote:
> > >> > On środa, 25 lipca 2012 o 10:29:26 Daniel Vetter wrote:
> > >> > > On Wed, Jul 25, 2012 at 10:20:47AM +0200, Maciej Rutecki wrote:
> > >> > > > Last known good: 3.4.4
> > >> > > > First bad: 3.5.0
> > >> > > > 
> > >> > > > When booting 3.5.0 resolution (in console, and after in KDE) is
> > >> > > > set to 1024x768 (60Hz). In 3.4.4 was correct: 1440x900 (60Hz).
> > >> > > 
> > >> > > Can you please attach the output of xrandr --verbose for both
> > >> > > kernels? Also, please boot with drm.debug=0xe added to your
> > >> > > kernel cmdline and grab the dmesg (again for both kernels).
> > >> > 
> > >> > Thanks for the ansfer.
> > >> > 
> > >> > Here xrandr and dmesg outputs for 3.4.4 and 3.5.0
> > >> > 
> > >> > http://mrutecki.pl/download/kernel/3.5/swinka/debug/
> > >> 
> > >> Can you please test this quick hack:
> > >> 
> > >> 
> > >> diff --git a/drivers/gpu/drm/i915/intel_i2c.c
> > >> b/drivers/gpu/drm/i915/intel_i2c.c index 1991a44..abe1611 100644
> > >> --- a/drivers/gpu/drm/i915/intel_i2c.c
> > >> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> > >> 
> > >> @@ -405,7 +405,7 @@ clear_err:
> > >>        * timing out seems to happen when there _is_ a ddc chip
> > >>        present, but * it's slow responding and only answers on the
> > >>        2nd retry. */
> > >> 
> > >> -     ret = -ENXIO;
> > >> +     ret = 0;
> > >> 
> > >>       if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) ==
> > >>       0,
> > >>       
> > >>                    10)) {
> > >>               
> > >>               DRM_DEBUG_KMS("GMBUS [%s] timed out after NAK\n",
> > >> 
> > >> Thanks, Daniel
> > > 
> > > Still the same.
> > 
> > Hm, can you attach the dmesg again (with drm.debug=0xe)? If I haven't
> > botched up something, we should now retry at least the ddc transfer
> > ...
> 
> Also, another little snippet for you to test. Fyi I'll be on vacation next
> week, so final patch (this one here should really work) might take a notch
> longer.
> 
> Yours, Daniel
> --
> diff --git a/drivers/gpu/drm/i915/intel_crt.c
> b/drivers/gpu/drm/i915/intel_crt.c index bc5e2c9..85eca1c 100644
> --- a/drivers/gpu/drm/i915/intel_crt.c
> +++ b/drivers/gpu/drm/i915/intel_crt.c
> @@ -338,6 +338,7 @@ static bool intel_crt_detect_ddc(struct drm_connector
> *connector) BUG_ON(crt->base.type != INTEL_OUTPUT_ANALOG);
> 
>  	i2c = intel_gmbus_get_adapter(dev_priv, dev_priv->crt_ddc_pin);
> +	intel_gmbus_force_bit(i2c, true);
>  	edid = drm_get_edid(connector, i2c);
> 
>  	if (edid) {
> @@ -546,12 +547,14 @@ static int intel_crt_get_modes(struct drm_connector
> *connector) struct i2c_adapter *i2c;
> 
>  	i2c = intel_gmbus_get_adapter(dev_priv, dev_priv->crt_ddc_pin);
> +	intel_gmbus_force_bit(i2c, true);
>  	ret = intel_ddc_get_modes(connector, i2c);
>  	if (ret || !IS_G4X(dev))
>  		return ret;
> 
>  	/* Try to probe digital port for output in DVI-I -> VGA mode. */
>  	i2c = intel_gmbus_get_adapter(dev_priv, GMBUS_PORT_DPB);
> +	intel_gmbus_force_bit(i2c, true);
>  	return intel_ddc_get_modes(connector, i2c);
>  }

I have little problem with the patch:
$ patch -p1 < /tmp/latka.patch 
patching file drivers/gpu/drm/i915/intel_crt.c
Hunk #1 FAILED at 338.
patch unexpectedly ends in middle of line
Hunk #2 succeeded at 498 with fuzz 2 (offset -48 lines).
1 out of 2 hunks FAILED -- saving rejects to file 
drivers/gpu/drm/i915/intel_crt.c.rej

But I add "intel_gmbus_force_bit(i2c, true);" manually and now resolution is 
OK. Thanks for help.

PS. I also will be in vacation between 4-19 August, so my test may take 
longer.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
