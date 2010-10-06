Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab0JFP4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:56:15 -0400
Received: from senator.holtmann.net ([87.106.208.187]:38582 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab0JFP4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:56:14 -0400
Subject: Re: RFC: btusb firmware load help
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
In-Reply-To: <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux>
	 <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux>
	 <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
	 <1286349552.6145.11.camel@aeonflux>
	 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 17:56:06 +0200
Message-ID: <1286380566.6145.42.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> > Now I am failing to understand why this was done wrong in the first
> > place. Especially if the loading procedure happens as you say it
> > happens.
> 
> You got me :) Anyone?
> 
> > This is the example for the Broadcom 203x devices:
> >
> > static struct usb_device_id blacklist_table[] = {
> >        /* Broadcom BCM2033 without firmware */
> >        { USB_DEVICE(0x0a5c, 0x2033), .driver_info = BTUSB_IGNORE },
> >
> > The btusb driver clearly blacklists them. And then bcm203x can take over
> > loading the firmware:
> >
> > static const struct usb_device_id bcm203x_table[] = {
> >        /* Broadcom Blutonium (BCM2033) */
> >        { USB_DEVICE(0x0a5c, 0x2033) },
> >
> > So there is a working example of this already in the kernel tree since
> > forever.
> 
> Nice, thanks for the pointer. Our team will review and try to address
> an alternative patch.
> 
> Now for my own sanity -- I still don't think I get this how this
> BCM2033 blacklist trick works, I take it the device once plugged in
> gets a generic btusb USB device vendor:device ID. The btusb driver
> then picks up the the blacklist table, and searches for a
> usb_match_id() on it for the given interface... What I don't get is
> how there will be a match here if the USB vendor:device ID is just the
> generic btusb one. Can you help me understand how this trick works?

the generic Bluetooth USB class descriptors is what btusb uses. With a
few expectation for devices that use VID:PID combination.

So in general what happens if a device gets matched via the Bluetooth
USB class descriptors the btusb driver will claim. We do however check
against out blacklist first. If the VID:PID is listed in the blacklist
we do return ENODEV. That means that the USB subsystem goes ahead and
tries the next driver. In this case bcm203x driver. This will claim it,
load the firmware, reset it and come back with different VID:PID values.
After that the btusb can successfully claim it since it is no longer in
the blacklist.

If I understand this all correct without having the hardware available
for verifying this, then it should be like this:

Just add this to blacklist_table[] in btusb.c:

        /* Atheros AR3011 without firmware */
        { USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },

And then we can add the firmware loading to ath3k driver to load the
specific 1st stage firmware. And then ath3k can load the 2nd stage as
well. After that it should become a default Bluetooth USB device and the
btusb driver can take care of it.

Regards

Marcel


