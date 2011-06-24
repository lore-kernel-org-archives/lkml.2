Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab1FXECq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 00:02:46 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:51866 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1FXECm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 00:02:42 -0400
X-RZG-AUTH: :O2kGeEG7b/pS1EO8W3C+nMaWotNRcyCeCTTmQgOI2iYXpKw3NpaUJWKUSoVmTynJ
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding
 problem
From: Thomas Reim <thomas.reim@nepomuc.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: reimth@googlemail.com, Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
In-Reply-To: <BANLkTi=P6rB=avMSxVkEx7JQ9d95Siw2ng@mail.gmail.com>
References: <1308705639-4215-1-git-send-email-reimth@gmail.com>
	 <1308866743-8066-1-git-send-email-reimth@gmail.com>
	 <BANLkTi=P6rB=avMSxVkEx7JQ9d95Siw2ng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 06:02:13 +0200
Message-ID: <1308888133.3185.36.camel@Mark-Aurel.gas.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

thank you for your feedback.

> Thinking about it more, it might be cleaner to just make the extended
> mode a flag, e.g.,
> dret = radeon_ddc_probe_extended(radeon_connector,
> radeon_connector->requires_extended_probe);
> and handle the extended fetch in the same probe function.
> 

OK. That makes also sense. I will adapt again the patch. 

> > +       /* RS690 HDMI DDC quirk:
> > +        * Some integrated ATI Radeon chipset implementations (e. g.
> > +        * Asus M2A-VM HDMI) indicate the availability of a DDC even
> > +        * when there's no monitor connected to HDMI. For HDMI
> > +        * connectors we check for the availability of EDID with
> > +        * at least a correct EDID header and EDID version/revision
> > +        * information. Only then, DDC is assumed to be available.
> > +        * This prevents drm_get_edid() and drm_edid_block_valid() of
> > +        * periodically dumping data and kernel errors into the logs
> > +        * and onto the terminal, which would lead to an unacceptable
> > +        * system behaviour */
> > +       if (connector_type == DRM_MODE_CONNECTOR_HDMIA &&
> > +               (rdev->family == CHIP_RS690 ||
> > +                rdev->family == CHIP_RS740 ||
> > +                rdev->family == CHIP_RV630))
> This seems like an arbitrary selection of chips.  I haven't heard of
> any problems related to ddc on rv630.  Also I think we should limit it
> to the specific connector that is problematic rather than all hdmi
> ports.  In the case of your board, it seems the hdmi port on the
> add-in card is the only problematic one.  Lots of rs690 motherboards
> have hdmi ports on the motherboard itself that work fine.  I'd prefer
> to match based on the pci device and subsytem ids and the
> supported_device and connector type.  See radeon_atom_apply_quirks()
> in radeon_atombios.c for an example.  Something like:
> 
> radeon_connector->requires_extended_probe =
>         radeon_connector_needs_extended_probe(rdev, supported_dev,
> connector_type);

I've added RS740 because linux uses the same firmware and this chip was
also part of the other patch you mentioned in your first e-mail. RV630
was added because I checked freedesktop bug 31943. The problem described
there is different from the one here, but I saw logs, when no monitor
was connected, and for this situation the patch would help. 

With regard to moving away from connector type and chip family to pci
devices I'm not really sure. I remember complaints from people a year
ago, that used the RS690 on a laptop and had the same problem. I just
can't find the related messages. Don't you believe that this could be to
focused? Especially, if we compare patch
http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=4a9a8b71e12d41abb71c4e741bff524f016cfef4?

I felt rather safe with the above approach, as nothing will go wrong, if
we check the HDMIA type connectors also RS690 of another manufacturers.
We just check for a valid first six bytes set of the EDID header now.

> > @@ -777,8 +780,17 @@ static int radeon_ddc_dump(struct drm_connector *connector)
> >        if (!radeon_connector->ddc_bus)
> >                return -1;
> >        edid = drm_get_edid(connector, &radeon_connector->ddc_bus->adapter);
> > +       /* Log EDID retrieval status here. In particular with regard to
> > +        * connectors with requires_extended_probe flag set, that will prevent
> > +        * function radeon_dvi_detect() to fetch EDID on this connector,
> > +        * as long as there is no valid EDID header found */
> >        if (edid) {
> > +               DRM_INFO("Radeon display connector %s: Found valid EDID",
> > +                               drm_get_connector_name(connector));
> >                kfree(edid);
> > +       } else {
> > +               DRM_INFO("Radeon display connector %s: No monitor connected or invalid EDID",
> > +                               drm_get_connector_name(connector));
> 
> These will just spam the log as well.

Here's the log:
kernel: [   14.912386] [drm] Radeon Display Connectors
kernel: [   14.912389] [drm] Connector 0:
kernel: [   14.912391] [drm]   VGA
kernel: [   14.912394] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58
0x7e48 0x7e5c 0x7e4c
kernel: [   14.912397] [drm]   Encoders:
kernel: [   14.912398] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
kernel: [   14.912401] [drm] Connector 1:
kernel: [   14.912402] [drm]   S-video
kernel: [   14.912404] [drm]   Encoders:
kernel: [   14.912405] [drm]     TV1: INTERNAL_KLDSCP_DAC1
kernel: [   14.912407] [drm] Connector 2:
kernel: [   14.912409] [drm]   HDMI-A
kernel: [   14.912410] [drm]   HPD2
kernel: [   14.912413] [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48
0x7e68 0x7e4c 0x7e6c
kernel: [   14.912415] [drm]   Encoders:
kernel: [   14.912417] [drm]     DFP2: INTERNAL_DDI
kernel: [   14.912419] [drm] Connector 3:
kernel: [   14.912421] [drm]   DVI-D
kernel: [   14.912423] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48
0x7e58 0x7e4c 0x7e5c
kernel: [   14.912425] [drm]   Encoders:
kernel: [   14.912427] [drm]     DFP3: INTERNAL_LVTM1
kernel: [   15.071566] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16
(level, low) -> IRQ 16
kernel: [   15.071645] HDA Intel 0000:00:14.2: irq 42 for MSI/MSI-X
kernel: [   15.072678] [drm] Radeon display connector VGA-1: No display
connected or invalid EDID
kernel: [   15.470734] Raw EDID:
kernel: [   15.470745] <3>00 00 00 00 00 00 00 00 00 00 00 07 00 00 00
00  ................
kernel: [   15.470748] <3>00 00 00 00 00 00 00 00 00 00 07 00 00 00 00
00  ................
kernel: [   15.470751] <3>00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00
00  ................
kernel: [   15.470754] <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
kernel: [   15.470757] <3>00 00 00 00 1f 00 00 00 00 00 00 00 00 00 00
00  ................
kernel: [   15.470760] <3>00 00 00 00 00 07 00 00 00 00 00 7f 00 00 00
00  ................
kernel: [   15.470762] <3>00 00 00 00 00 00 07 00 00 00 00 00 00 00 00
00  ................
kernel: [   15.470765] <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
01  ................
kernel: [   15.470767] 
kernel: [   15.779568] Raw EDID:
kernel: [   15.779578] <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
kernel: [   15.779581] <3>00 00 00 00 00 7f 00 00 00 00 03 00 00 00 00
00  ................
kernel: [   15.779584] <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
kernel: [   15.779587] <3>00 00 00 00 ff 00 00 00 00 00 00 00 00 00 00
00  ................
kernel: [   15.779590] <3>00 00 00 00 00 00 00 00 ff 00 00 00 00 00 00
00  ................
kernel: [   15.779593] <3>00 00 00 00 00 00 00 00 00 01 00 00 00 00 00
00  ................
kernel: [   15.779596] <3>00 00 00 7f 00 00 00 00 00 03 07 00 00 00 00
00  ................
kernel: [   15.779598] <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
kernel: [   15.779600] 
kernel: [   16.151817] Raw EDID:
kernel: [   16.151827] <3>00 00 00 00 00 00 1f 00 00 00 00 00 00 00 00
00  ................
kernel: [   16.151830] <3>00 00 00 00 00 00 00 00 00 01 00 00 00 00 00
00  ................
kernel: [   16.151833] <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
kernel: [   16.151836] <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
kernel: [   16.151839] <3>00 00 1f 00 00 00 00 00 00 00 00 00 00 00 0f
00  ................
kernel: [   16.151842] <3>01 00 00 00 00 00 00 00 01 00 00 00 00 07 00
ff  ................
kernel: [   16.151844] <3>00 00 00 00 00 00 ff 00 00 00 00 00 00 00 7f
00  ................
kernel: [   16.151847] <3>00 0f 00 00 00 00 00 00 00 3f 00 00 00 00 00
00  .........?......
kernel: [   16.151849] 
kernel: [   16.444209] Raw EDID:
kernel: [   16.444220] <3>00 07 00 00 00 00 00 00 ff 00 00 00 00 ff 00
00  ................
kernel: [   16.444223] <3>00 00 3f 00 00 00 00 00 00 00 00 00 00 ff 00
00  ..?.............
kernel: [   16.444226] <3>00 00 00 00 00 00 00 00 00 07 00 00 00 01 0f
00  ................
kernel: [   16.444229] <3>00 07 00 00 00 00 00 00 00 00 01 07 00 00 00
00  ................
kernel: [   16.444231] <3>00 00 00 00 00 00 00 00 7f 00 00 00 00 1f 00
00  ................
kernel: [   16.444234] <3>00 00 03 00 00 00 00 3f 00 03 00 00 00 00 00
00  .......?........
kernel: [   16.444237] <3>7f 00 00 1f 00 00 00 00 00 00 00 00 0f 07 00
00  ................
kernel: [   16.444240] <3>00 00 00 00 00 00 00 00 00 00 03 00 00 00 00
00  ................
kernel: [   16.444242] 
kernel: [   16.444248] radeon 0000:01:05.0: HDMI-A-1: EDID block 0
invalid.
kernel: [   16.444252] [drm] Radeon display connector HDMI-A-1: No
display connected or invalid EDID
kernel: [   16.762734] [drm] Radeon display connector DVI-D-1: Found
valid EDID

Just one info entry per connector will be added during connector setup.
The EDID dump was already there and comes from the DDC probing during
connector setup. After that, there are no more entries in the log with
regard to the buggy HDMI connector. From a user point of view I would
prefer to have the two log entries:
radeon 0000:01:05.0: HDMI-A-1: EDID block 0 invalid.
[drm] Radeon display connector HDMI-A-1: No display connected or invalid
EDID.
One from the probing, which is a little bit cryptic, and the explaining
one which prelude the silence for this connector.

> > diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
> > index 781196d..7e93cf9 100644
> > --- a/drivers/gpu/drm/radeon/radeon_i2c.c
> > +++ b/drivers/gpu/drm/radeon/radeon_i2c.c
> > @@ -34,7 +34,7 @@
> >  */
> >  bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
> >  {
> > -       u8 out_buf[] = { 0x0, 0x0};
> > +       u8 out = 0x0;
> >        u8 buf[2];
> >        int ret;
> >        struct i2c_msg msgs[] = {
> > @@ -42,7 +42,7 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
> >                        .addr = 0x50,
> >                        .flags = 0,
> >                        .len = 1,
> > -                       .buf = out_buf,
> > +                       .buf = &out,
> >                },
> >                {
> >                        .addr = 0x50,
> 
> 
> The change above doesn't seem to be related.

This was a comment from Jean who complained about the ineffective usage
of the i2c bus. But I can also restore the old code. What's your
preference?

Best regards

Thomas

