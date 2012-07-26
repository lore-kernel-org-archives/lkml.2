Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2GZMiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:38:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36522 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2GZMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:38:20 -0400
Date: Thu, 26 Jul 2012 14:38:28 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: maciej.rutecki@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION] [KMS] [INTEL] Wrong resolution in console and
 XWindow
Message-ID: <20120726123828.GE5326@phenom.ffwll.local>
Mail-Followup-To: maciej.rutecki@gmail.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <201207251020.47637.maciej.rutecki@gmail.com>
 <201207251054.25498.maciej.rutecki@gmail.com>
 <20120725092928.GD5396@phenom.ffwll.local>
 <201207251257.50064.maciej.rutecki@gmail.com>
 <CAKMK7uEZ+TYziN9tNDUc-UVeAzvVuivA869uwQYiWGoAKEq1jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uEZ+TYziN9tNDUc-UVeAzvVuivA869uwQYiWGoAKEq1jg@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:55:59PM +0200, Daniel Vetter wrote:
> On Wed, Jul 25, 2012 at 12:57 PM, Maciej Rutecki
> <maciej.rutecki@gmail.com> wrote:
> > On środa, 25 lipca 2012 o 11:29:28 Daniel Vetter wrote:
> >> On Wed, Jul 25, 2012 at 10:54:25AM +0200, Maciej Rutecki wrote:
> >> > On środa, 25 lipca 2012 o 10:29:26 Daniel Vetter wrote:
> >> > > On Wed, Jul 25, 2012 at 10:20:47AM +0200, Maciej Rutecki wrote:
> >> > > > Last known good: 3.4.4
> >> > > > First bad: 3.5.0
> >> > > >
> >> > > > When booting 3.5.0 resolution (in console, and after in KDE) is set
> >> > > > to 1024x768 (60Hz). In 3.4.4 was correct: 1440x900 (60Hz).
> >> > >
> >> > > Can you please attach the output of xrandr --verbose for both kernels?
> >> > > Also, please boot with drm.debug=0xe added to your kernel cmdline and
> >> > > grab the dmesg (again for both kernels).
> >> >
> >> > Thanks for the ansfer.
> >> >
> >> > Here xrandr and dmesg outputs for 3.4.4 and 3.5.0
> >> >
> >> > http://mrutecki.pl/download/kernel/3.5/swinka/debug/
> >>
> >> Can you please test this quick hack:
> >>
> >>
> >> diff --git a/drivers/gpu/drm/i915/intel_i2c.c
> >> b/drivers/gpu/drm/i915/intel_i2c.c index 1991a44..abe1611 100644
> >> --- a/drivers/gpu/drm/i915/intel_i2c.c
> >> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> >> @@ -405,7 +405,7 @@ clear_err:
> >>        * timing out seems to happen when there _is_ a ddc chip present, but
> >>        * it's slow responding and only answers on the 2nd retry.
> >>        */
> >> -     ret = -ENXIO;
> >> +     ret = 0;
> >>       if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
> >>                    10)) {
> >>               DRM_DEBUG_KMS("GMBUS [%s] timed out after NAK\n",
> >>
> >>
> >> Thanks, Daniel
> >
> > Still the same.
> 
> Hm, can you attach the dmesg again (with drm.debug=0xe)? If I haven't
> botched up something, we should now retry at least the ddc transfer
> ...

Also, another little snippet for you to test. Fyi I'll be on vacation next
week, so final patch (this one here should really work) might take a notch
longer.

Yours, Daniel
--
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index bc5e2c9..85eca1c 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -338,6 +338,7 @@ static bool intel_crt_detect_ddc(struct drm_connector *connector)
 	BUG_ON(crt->base.type != INTEL_OUTPUT_ANALOG);
 
 	i2c = intel_gmbus_get_adapter(dev_priv, dev_priv->crt_ddc_pin);
+	intel_gmbus_force_bit(i2c, true);
 	edid = drm_get_edid(connector, i2c);
 
 	if (edid) {
@@ -546,12 +547,14 @@ static int intel_crt_get_modes(struct drm_connector *connector)
 	struct i2c_adapter *i2c;
 
 	i2c = intel_gmbus_get_adapter(dev_priv, dev_priv->crt_ddc_pin);
+	intel_gmbus_force_bit(i2c, true);
 	ret = intel_ddc_get_modes(connector, i2c);
 	if (ret || !IS_G4X(dev))
 		return ret;
 
 	/* Try to probe digital port for output in DVI-I -> VGA mode. */
 	i2c = intel_gmbus_get_adapter(dev_priv, GMBUS_PORT_DPB);
+	intel_gmbus_force_bit(i2c, true);
 	return intel_ddc_get_modes(connector, i2c);
 }
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
