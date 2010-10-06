Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab0JFHTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:19:20 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48654 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0JFHTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:19:19 -0400
Subject: Re: RFC: btusb firmware load help
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
In-Reply-To: <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux>
	 <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux>
	 <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 09:19:12 +0200
Message-ID: <1286349552.6145.11.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> > most likely via a separate firmware loading driver.
> 
> Like the fwload patch ? Or something different?

something clean of course and not this hacking around, but in general
along that.

> > Your ath3k driver is such a driver. Same as the bcm203x driver.
> 
> Right -- so ath3k depends on some atheros USB device IDs, and its a
> stupid driver that just loads firmware. The problem with this new
> device is that it requires two phases. One to load some sort of
> firmware onto it to get it to read as an ath3k device, and then ath3k
> will load the right firmware to it. So the hardware device is already
> claiming a btusb vendor:device ID, we can't change that I believe. Of
> course for future devices we can, and we've addressed this and its
> been fixed.

So your current loading procedure is this:

	1) btusb with hacked firmware loading
	2) ath3k
	3) btusb with HCI

Who thought that this is a good idea in the first place? And more
important that I would accept this upstream? This is even worse than I
thought it is.

Please get this craziness fixed.

> > They don't do anything than claiming that USB device, loading the firmware, and then let it reset.
> 
> Right but if the SFLASH configurations hardware is already shipping
> and without firmware is claiming to be a BT USB device which matches
> the USB vendor:device ID of the btusb driver. Unfortunately it does
> not accept HCI commands which as you indicates breaks some
> specification. We can and have fixed this in future chipsets but this
> one cannot be addressed. So what do we do?
> 
> > And after the reset the btusb can claim the one where the firmware has
> > been loaded and which behaves like a proper USB dongle.
> 
> Right, that's what the fwload patch from our BT team does, no?

Yes, but not inside the btusb driver. Stop hacking a generic driver with
crazy firmware loading only because the USB Bluetooth class descriptors
got screwed up in the first place.

> > The part that I don't understand is that you have the ath3k driver doing
> > it exactly how it should be done, why now started to make nasty hacks in
> > the btusb driver.
> 
> Yeah that seems to have been a shortcoming, its something you should
> expect from us moving forward. I've been told AR3012 and future
> Atheros chipsets will not have behave this way, and this issue is only
> present for the AR3011 devices with SFLASH configuration.

Most likely including the flashing into ath3k firmware loading driver
and that being called bound twice might be a good idea. However we are
not doing the firmware loading in btusb. Then a patch to blacklist this
broken device. And then ensure that the firmware changes the USB PIDs
after success.

And if I understand you correct, then it does this anyway right now
already. Otherwise the ath3k driver would not bind to it.

Now I am failing to understand why this was done wrong in the first
place. Especially if the loading procedure happens as you say it
happens.

This is the example for the Broadcom 203x devices:

static struct usb_device_id blacklist_table[] = {
        /* Broadcom BCM2033 without firmware */
        { USB_DEVICE(0x0a5c, 0x2033), .driver_info = BTUSB_IGNORE },

The btusb driver clearly blacklists them. And then bcm203x can take over
loading the firmware:

static const struct usb_device_id bcm203x_table[] = {
        /* Broadcom Blutonium (BCM2033) */
        { USB_DEVICE(0x0a5c, 0x2033) },

So there is a working example of this already in the kernel tree since
forever.

Regards

Marcel


