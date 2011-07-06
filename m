Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1GFJgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:36:05 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:10149 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab1GFJgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:36:02 -0400
X-RZG-AUTH: :O2kGeEG7b/pS1EO8W3C+nMaWotNRcyCeCTTmQgOI2iYXpKw2M5aRJ08f0lRSYr+JtxI=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding
 problem
From: Thomas Reim <thomas.reim@nepomuc.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        reimth@googlemail.com
In-Reply-To: <BANLkTinz5OM+NDsZy8UqbAZRFCqVV93ZNg@mail.gmail.com>
References: <1308705639-4215-1-git-send-email-reimth@gmail.com>
	 <1308866743-8066-1-git-send-email-reimth@gmail.com>
	 <BANLkTi=P6rB=avMSxVkEx7JQ9d95Siw2ng@mail.gmail.com>
	 <1308888133.3185.36.camel@Mark-Aurel.gas.de>
	 <BANLkTinz5OM+NDsZy8UqbAZRFCqVV93ZNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 11:35:32 +0200
Message-ID: <1309944933.3059.57.camel@Mark-Aurel.gas.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alex,

sorry for the long delay. I have updated the patch according to the
comments in your last e-mail (see below).

I've added function radeon_connector_needs_extended_probe() and flag
radeon_connector->requires_extended_probe that provide the means to
force on a board,connector basis to check for a valid EDID header during
DDC probe.

I've adapted function radeon_ddc_probe() to perform an additional EDID
header check if required by the connector.

Finally, I've adapted function radeon_device_init() to also log
subsystem vendor and device information, if available. This allows to
add further quirks based on the dmesg output of drm/radeon.

> > I've added RS740 because linux uses the same firmware and this chip was
> > also part of the other patch you mentioned in your first e-mail. RV630
> > was added because I checked freedesktop bug 31943. The problem described
> > there is different from the one here, but I saw logs, when no monitor
> > was connected, and for this situation the patch would help.
> 
> I'd rather add quirks on a case by case bases rather than speculating
> on mailing list reports.

Done. See function radeon_connector_needs_extended_probe()

> 
> >
> > With regard to moving away from connector type and chip family to pci
> > devices I'm not really sure. I remember complaints from people a year
> > ago, that used the RS690 on a laptop and had the same problem. I just
> > can't find the related messages. Don't you believe that this could be to
> > focused? Especially, if we compare patch
> > http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=4a9a8b71e12d41abb71c4e741bff524f016cfef4?
> >
> 
> We should probably revert or rework that patch when we apply yours
> otherwise we may end up removing i2c buses unnecessarily in some
> cases.  I think this is a better approach.

Understood.

> 
> > I felt rather safe with the above approach, as nothing will go wrong, if
> > we check the HDMIA type connectors also RS690 of another manufacturers.
> > We just check for a valid first six bytes set of the EDID header now.
> 
> As I said above, lets just apply this to the specific board and
> connector that is problematic.  I seems to only affect the hdmi port
> on the add-in cards, so there's no need to penalize all hdmi ports.
> If we get enough quirks down the road, we can make it a general rule.
> 

You're right. The patch currently fixes only the ASUS M2A-VM device:
+       if ((dev->pdev->device == 0x791e) &&
+           (dev->pdev->subsystem_vendor == 0x1043) &&
+           (dev->pdev->subsystem_device == 0x826d)) {
+               if ((connector_type == DRM_MODE_CONNECTOR_HDMIA) &&
+                   (supported_device == ATOM_DEVICE_DFP2_SUPPORT))
This will solve bug
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/722806.


> >
> > Just one info entry per connector will be added during connector setup.
> > The EDID dump was already there and comes from the DDC probing during
> > connector setup. After that, there are no more entries in the log with
> > regard to the buggy HDMI connector. From a user point of view I would
> > prefer to have the two log entries:
> > radeon 0000:01:05.0: HDMI-A-1: EDID block 0 invalid.
> > [drm] Radeon display connector HDMI-A-1: No display connected or invalid
> > EDID.
> > One from the probing, which is a little bit cryptic, and the explaining
> > one which prelude the silence for this connector.
> 
> ok, that makes sense.
> 
> >
> >> > diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
> >> > index 781196d..7e93cf9 100644
> >> > --- a/drivers/gpu/drm/radeon/radeon_i2c.c
> >> > +++ b/drivers/gpu/drm/radeon/radeon_i2c.c
> >> > @@ -34,7 +34,7 @@
> >> >  */
> >> >  bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
> >> >  {
> >> > -       u8 out_buf[] = { 0x0, 0x0};
> >> > +       u8 out = 0x0;
> >> >        u8 buf[2];
> >> >        int ret;
> >> >        struct i2c_msg msgs[] = {
> >> > @@ -42,7 +42,7 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
> >> >                        .addr = 0x50,
> >> >                        .flags = 0,
> >> >                        .len = 1,
> >> > -                       .buf = out_buf,
> >> > +                       .buf = &out,
> >> >                },
> >> >                {
> >> >                        .addr = 0x50,
> >>
> >>
> >> The change above doesn't seem to be related.
> >
> > This was a comment from Jean who complained about the ineffective usage
> > of the i2c bus. But I can also restore the old code. What's your
> > preference?
> 
> Ah, I missed that.  Let's make that a separate patch, or fix it when
> you add support for the extended edid check.
> 
Done.

The patch is for the latest git version of the linux kernel. Do you
think it would be possible to provide this patch already starting from
the most recent 2.35 kernel update? Ubuntu uses this kernel version for
the long-term stable Maverick release.

I will send the patch in my next e-mail. Hope this helps you. 

Best regards

Thomas


