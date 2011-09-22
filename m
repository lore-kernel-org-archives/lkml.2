Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab1IVPMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:12:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48735 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750855Ab1IVPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:12:53 -0400
Date: Thu, 22 Sep 2011 11:12:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthias Dellweg <2500@gmx.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Michal Sojka <sojkam1@fel.cvut.cz>, Arnd Bergmann <arnd@arndb.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] enable usb control message with class specific request
In-Reply-To: <20110922121031.639006d0@horus>
Message-ID: <Pine.LNX.4.44L0.1109221100270.2137-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011, Matthias Dellweg wrote:

> Hi!
> Usb devio assumes that the wIndex in every control message apart from
> those flagged as USB_TYPE_VENDOR holds the number of the Interface
> being addressed. This is for example not true for the class specific
> request GET_DEVICE_ID in the printer class:
> 
> "The high-byte of the wIndex field is used to specify the zero-based
> interface index. The low-byte of the wIndex field is used to specify
> the zero-based alternate setting." [1]
> 
> In this special case it misinterpretes the alternate setting 1 for the
> interface and tries to claim a nonexisting one. Therefor you won't get
> the printers name.
> 
> The patch below is a minimal approach to fix this. Maybe it should be
> extended to USB_TYPE_RESERVED. Maybe there should be an extended test
> that knows something about specific classes.
> 
> What do you think?
> regards Matthias
> 
> [1] http://www.usb.org/developers/devclass_docs/usbprint11.pdf

In this case, it appears that the printer class specification 
contradicts the USB-2.0 specification.  Section 9.3.1 says (referring 
to the low-order five bits of bmRequestType):

	Requests may be directed to the device, an interface on the 
	device, or a specific endpoint on a device. This field also
	specifies the intended recipient of the request. When an
	interface or endpoint is specified, the wIndex field identifies
	the interface or endpoint.

And Figure 9-3 shows that when wIndex is used to specify an interface, 
the interface number belongs in the low-order byte, not the high-order 
byte.

I don't think it's safe to relax the test the way you have suggested.
There are too many other class-specific requests that must be 
prevented.  Maybe an exception could be added for this one particular 
case.  Besides, you don't want to remove the test entirely -- you want 
to use the high-order byte of wIndex instead of the low-order byte.

The printer spec really is spectacularly bad in this respect.  What 
happens if the printer is a composite device, and the other interface 
uses the same bmRequestType and bRequest values for its own 
class-specific purpose, but uses the low-order byte of wIndex to 
indicate the interface number (as it should).  Then the printer 
wouldn't know which interface was supposed to respond to the message!

Alan Stern

