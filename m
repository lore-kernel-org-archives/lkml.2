Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab3AILAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:00:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:20484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab3AILAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:00:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="274721043"
Date: Wed, 9 Jan 2013 13:03:39 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: add ACPI support
Message-ID: <20130109110339.GU13897@intel.com>
References: <1357650332-30031-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAN+gG=HzJaOwPfymx5JST1+r9QxfqU5D-gN8i95aVDkqQ=ot8Q@mail.gmail.com>
 <20130108180958.GL13897@intel.com>
 <CAN+gG=FGv=VJ=6Db_s7p_7XJQi3=FJXDfqeE1AVPtFznHnWQ0Q@mail.gmail.com>
 <20130109092817.GP13897@intel.com>
 <CAN+gG=H+JPz4C_vBEBi2qePqO=t9zS69sHZXvvtsctZGtL1mQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=H+JPz4C_vBEBi2qePqO=t9zS69sHZXvvtsctZGtL1mQQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 11:38:24AM +0100, Benjamin Tissoires wrote:
> >
> > If they have reset GPIO or something like that, how else we should we
> > handle this if not in the driver? The i2c-hid core doesn't know for what
> > purpose a given GPIO line is.
> 
> But the hid protocol aims at reducing the number of drivers. The idea
> is to built one driver to rule them all... :)
> Some stats:
> - hid-multitouch (the driver that drives multitouch screens) has a
> list of ~80 registered products, most of them are USB (few are
> Bluetooth). Bonus point, this list is not exhaustive because there is
> an auto-detection mechanism in place which forwards unknown
> mt-touchscreen to hid-multitouch. Now with i2c-hid, hid-multitouch can
> also handle any Win8 certified i2c touchscreen, so I guess it will add
> a lot of new devices to this list.
> - hid-core registered ~240 exception -> it means that on all existing
> input devices that follow the hid protocol, only 240 need special
> handling.

OK, got it :)

> So my point is that some of the hid drivers may know the attached
> GPIOs, but the generic hid drivers (hid-multitouch, hid-generic and
> hid-core then) won't.

OK.

> Anyway, there may be adjustments at the beginning, but I still think
> we could add a common place for i2c quirks in i2c-hid, at least at the
> beginning.

Sure.

I noticed that the current i2c-hid code doesn't handle the GPIOs at all
right now (even if not enumerated form ACPI) so we need to invent something
once real hardware starts to be available. I have few devices here but they
are unusable (except the enumeration parts) as they need some FW which I
don't have yet.

> The best solution would be to be able to deduce the behavior of those
> GPIOs thanks to the ACPI description. Problem for me: I can't have
> access to the document referred in HID over i2c specification (Windows
> ACPI Design Guide for SOC Platform) while working at Red Hat...
> 
> >
> > i2c-hid core can handle the GPIO interrupt if client->irq is not set (by
> > converting the GPIO into interrupt number and passing it to the hid
> > driver). I didn't implement that because we have the client->irq already
> > set so I can't test this.
> 
> But this part of the code is already in ACPI i2c enumeration, right?
> So why you want to rewrite it in i2c-hid?

No, the ACPI I2C enumeration only handles Interrupt and IRQ resources. It
doesn't handle the GpioInt resources and this needs to be done in i2c-hid.

> >
> >> The closest thing which is already in the kernel tree is the handling
> >> of device specific quirks in usbhid. We may be forced to do such a
> >> thing if the DSDT is not explicit enough to guess the right behavior
> >> (how to trigger the reset line, etc..)
> >>
> >> Also, I missed one point in my previous review:
> >>
> >> >
> >> >> Please note that I can only compare this to my patch, based on the
> >> >> DSDT example Microsoft gave in its spec. So sorry if I'm asking
> >> >> useless things, but I like to understand... :)
> >> >> Here are a few comments:
> >> >>
> >> >> >
> >> >> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> >> > ---
> >> >> >  drivers/hid/i2c-hid/i2c-hid.c |   73 +++++++++++++++++++++++++++++++++++++++--
> >> >> >  1 file changed, 71 insertions(+), 2 deletions(-)
> >> >> >
> >> >> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> >> >> > index 9ef22244..b2eebb6 100644
> >>  (...snipped...)
> >>
> >> >> > +
> >> >> > +       pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> >>
> >> Here, I don't think mixing devm_* and regular allocations is a good thing.
> >> I know it's a pain, but at the time I wrote the driver, the input
> >> layer was not devm-ized, so I was not able to use devm allocs. Now it
> >> should be feasible, but I didn't found the time to do it.
> >> So I'm afraid, this allocation must use a regular kwalloc and it
> >> should be freed somewhere later, until we devm-ize the whole module.
> >
> > Good point.
> >
> > I was thinking to embed the platform data in the i2c_hid structure so that
> > it gets allocated at the same time as ihid and then we can handle setting
> > the platform data like:
> >
> >         if (!platform_data) {
> >                 ret = i2c_hid_acpi_pdata(client, &ihid->pdata);
> >                 /* handle error */
> >         } else {
> >                 ihid->pdata = *platform_data;
> >         }
> >
> > Does that sound feasible to you?
> 
> yep, go for it!

Thanks. I'll prepare next version and send it out for review soon.
