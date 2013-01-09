Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3AIJZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:25:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:3265 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab3AIJY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:24:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="269774060"
Date: Wed, 9 Jan 2013 11:28:17 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: add ACPI support
Message-ID: <20130109092817.GP13897@intel.com>
References: <1357650332-30031-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAN+gG=HzJaOwPfymx5JST1+r9QxfqU5D-gN8i95aVDkqQ=ot8Q@mail.gmail.com>
 <20130108180958.GL13897@intel.com>
 <CAN+gG=FGv=VJ=6Db_s7p_7XJQi3=FJXDfqeE1AVPtFznHnWQ0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=FGv=VJ=6Db_s7p_7XJQi3=FJXDfqeE1AVPtFznHnWQ0Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 10:55:59PM +0100, Benjamin Tissoires wrote:
> On Tue, Jan 8, 2013 at 7:09 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Tue, Jan 08, 2013 at 02:51:53PM +0100, Benjamin Tissoires wrote:
> >> Hi Mika,
> >>
> >> On Tue, Jan 8, 2013 at 2:05 PM, Mika Westerberg
> >> <mika.westerberg@linux.intel.com> wrote:
> >> > The HID over I2C protocol specification states that when the device is
> >> > enumerated from ACPI the HID descriptor address can be obtained by
> >> > executing "_DSM" for the device with function 1. Enable this.
> >>
> >> Hehe, funny thing, I worked on the very same patch last Friday. I was
> >> not able to send it upstream as I still don't have an ACPI 5 enabled
> >> device...
> >> So thanks for submitting (and testing) this!
> >>
> >> Before the review, I just have a quick question. All the HID/i2c
> >> devices I saw so far present a reset line (through a GPIO). Does the
> >> shipped device you have present this line, and if yes, how this meld
> >> with the code (i.e. should we take this into account).
> >
> > Yes, there is either one or two GPIO lines. But there are also devices that
> > don't have any GPIO lines.
> 
> Ouch. But if they don't have any GPIO, how can they manage to send
> information? If they are using polling, then this will require some
> more work in i2c-hid :(

Well they don't have GPIO resources because their interrupt is directly
routed to the ioapic and exposed as an Interrupt resource.

> >
> > We probably should take this into account. I'm not too familiar with HID
> > drivers but what if we set the hid->dev.acpi_node and let the actual HID
> > driver to deal with the GPIO?
> 
> Well, HID is a communication layer between the device and the kernel
> in order to make it agnostic of the transport layer (usb, bt or i2c).
> Even if some drivers do some transport tuning, I don't think it's a
> good idea to ask HID drivers to do transport handling such as setting
> up GPIOs.

If they have reset GPIO or something like that, how else we should we
handle this if not in the driver? The i2c-hid core doesn't know for what
purpose a given GPIO line is.

i2c-hid core can handle the GPIO interrupt if client->irq is not set (by
converting the GPIO into interrupt number and passing it to the hid
driver). I didn't implement that because we have the client->irq already
set so I can't test this.

> The closest thing which is already in the kernel tree is the handling
> of device specific quirks in usbhid. We may be forced to do such a
> thing if the DSDT is not explicit enough to guess the right behavior
> (how to trigger the reset line, etc..)
> 
> Also, I missed one point in my previous review:
> 
> >
> >> Please note that I can only compare this to my patch, based on the
> >> DSDT example Microsoft gave in its spec. So sorry if I'm asking
> >> useless things, but I like to understand... :)
> >> Here are a few comments:
> >>
> >> >
> >> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> > ---
> >> >  drivers/hid/i2c-hid/i2c-hid.c |   73 +++++++++++++++++++++++++++++++++++++++--
> >> >  1 file changed, 71 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> >> > index 9ef22244..b2eebb6 100644
>  (...snipped...)
> 
> >> > +
> >> > +       pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> 
> Here, I don't think mixing devm_* and regular allocations is a good thing.
> I know it's a pain, but at the time I wrote the driver, the input
> layer was not devm-ized, so I was not able to use devm allocs. Now it
> should be feasible, but I didn't found the time to do it.
> So I'm afraid, this allocation must use a regular kwalloc and it
> should be freed somewhere later, until we devm-ize the whole module.

Good point.

I was thinking to embed the platform data in the i2c_hid structure so that
it gets allocated at the same time as ihid and then we can handle setting
the platform data like:

	if (!platform_data) {
		ret = i2c_hid_acpi_pdata(client, &ihid->pdata);
		/* handle error */
	} else {
		ihid->pdata = *platform_data;	
	}

Does that sound feasible to you?

> >> > +       if (!pdata)
> >> > +               goto fail;
> >>
> 
> (...snipped...)
> >> >         if (!platform_data) {
> >> > -               dev_err(&client->dev, "HID register address not provided\n");
> >> > -               return -EINVAL;
> >> > +               platform_data = i2c_hid_acpi_pdata(client);
> >> > +               if (!platform_data) {
> >> > +                       dev_err(&client->dev, "HID register address not provided\n");
> >>
> >> You may have a line with more than 80 characters here (it's difficult
> >> to guess thanks to my gmail client converting tabs into spaces...
> >> grrr)
> >
> > Shouldn't be as checkpatch.pl didn't complain but I'll re-check.
> 
> It's strange if it didn't complained: I count 61 chars for the
> dev_err() message + 3 tabs * 8 chars => 85 chars in total...

You are right, it is over 85 chars.

I've learned that checkpatch.pl doesn't complain if the line is longer than
80 chars, if it contains quoted string.

I'll fix it up.
