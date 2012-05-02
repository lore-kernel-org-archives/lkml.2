Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2EBW44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:56:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56661 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2EBW4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:56:55 -0400
Date: Wed, 2 May 2012 23:59:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Preston Fick <pffick@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com
Subject: Re: [PATCH 3/3] usb: cp210x: Add ioctl for GPIO support
Message-ID: <20120502235939.5086eb7d@pyramind.ukuu.org.uk>
In-Reply-To: <20120502222728.GA2871@kroah.com>
References: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
	<1335845210-5147-3-git-send-email-preston.fick@silabs.com>
	<20120502200356.GA25915@kroah.com>
	<20120502214901.6b6e031c@pyramind.ukuu.org.uk>
	<20120502215226.GD27281@kroah.com>
	<20120502231027.1c45105d@pyramind.ukuu.org.uk>
	<20120502222728.GA2871@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ok now in your user application how are you going to find which gpio
> > numbers to use that are associated with this specific port,
> 
> Just look at the gpio device that has ttyUSB0 as its parent.

Taking care of course that you keep the ttyUSB file handle open while you
do so, ugly from user space, hideous from kernel space.

> 
> > and how is udev going to do that to manage permissions ?
> 
> How does udev handle permissions for gpio devices today?

It sticks its fingers in its ears and goes "la la la"

> > So you need an ioctl to give you the range that is mapped to this (or a
> > sysfs node, but the sysfs node makes the security problem pretty
> > much insoluble)
> 
> range for what?  Doesn't the gpio interfac provide the size of the gpio
> registers to userspace?

If you fish them out via sysfs trees yes.

>> > 	open /dev/ttyUSB0 [or sysfs node]
> > 	read gpio numbers
> > 	close 
> > 
> > 	open gpio foo
> > 
> > Oh dear... so random shell scripting user is going to screw up horribly.
> 
> What's the odds that the data going across the tty link corrisponds with
> the gpio control?

I think you missed the problem - which speaks volumes for the interface
issue

	open sysfs node
	read gpio numbers
	close

			unplug 
			new device
				assigned the same gpio numbers
	open gpio
	whoops - that was the milling machine not the smartcard

> And shell scripting the gpio interface is used today, I've seen it on
> the beaglebone machine.

Yes it works very well but that isn't the issue.

> > I think it basically boils down to this
> > 
> > If you have a serial port with some gpio lines that drive arbitary
> > unrelated electronics then the gpio interface is handy because you can
> > use the same code logic as if it was wired to other pins elsewhere
> > 
> > If you are using them as part of the tty interface as extra control lines
> > (eg for smartcard protocols) then you want them driven via the tty
> > interface and doubly so once we add some of the smartcard/sim ldisc
> > support.
> > 
> > Hence we really need to expose them both ways because end users are doing
> > both things with the gpio pins on these ports.
> > 
> > So I'd suggest we expose them via termiox bits and also via the tty
> > providing gpio range info in a standardised way.
> 
> Ok, I'll wait for your proposed standardised way before complaining any
> more :)

I think I'd suggest we support the following


open /dev/ttyUSB0
get gpio info somehow
run via gpio interface
close /dev/ttyUSB0

and

open /dev/ttyUSB0
via termiox( what gpios do you have )
via termiox( set/get gpio values)
close /dev/ttyUSB0

that would support the ldisc use of them. I need to go read the specs on
that and look at some hardware. I think we may need a mapping ioctl too
because the pin allocations may need to be described in terms of "pin 0
is this reader signal", "pin 1 is that"

Alan
