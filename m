Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab1DLGUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:20:33 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:38987 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1DLGUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:20:31 -0400
Date: Tue, 12 Apr 2011 08:19:15 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        linux-kernel@vger.kernel.org,
        Aloisio Almeida <aloisio.almeida@openbossa.org>,
        Arnd Bergmann <arnd@arndb.de>, Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC] NFC subsystem prototype
Message-ID: <20110412061915.GT9690@prithivi.gnumonks.org>
References: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
 <20110409130945.GC3248@prithivi.gnumonks.org>
 <20110409184559.41b947af@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110409184559.41b947af@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

On Sat, Apr 09, 2011 at 06:45:59PM +0100, Alan Cox wrote:
> >    If you're worried about SPI-attached RFID/NFC ASICs, then I think the
> >    propper approach is to have a generic support for exporting SPI devices to
> >    userspace (similar to what we have with usb + libusb).
> 
> That bit in my experience doesn't work. Most i²c devices for example end
> up needing an actual kernel driver because you have to manage the
> transaction flow to stop users breaking things horribly.

luckily the NFC controller landscape is extremely monolithic, i.e. there are
not many vendors (+ chips) that need support, so it _may_ still be an option
to have that small 'actual kernel driver'.  But I agree, it is ugly.

> >    I simply do not see the advantage of having this in the kenrel.  There are
> >    no latency/timing constraints, and the amount of data you are moving is so
> >    small, that performance considerations also don't really play any role.
> 
> The big one is security management - once you've got readers that are
> needing to report different stuff to different people you need at least
> the muxing in kernel. 

I doubt that NFC is envisioned as a 'multiple simultaneous users in a device'
application - so I'm not sure how valid that argument really ise.  In any case,
you would also have to have some kind of access control lists or similar in the
kernel to decide which user can talk to which card UID, or mifare application ID,
or similar identifier on the respective higher-level protocol.

> It also separates protocol stacks from apps which is rather important in more
> complex systems.

The separation can also be had in userspace, i.e. have a shared ISO 14443 stack
inside the multiplex daemon, and have applications talk at a much higher level
API.

> > 2) even if you go for an in-kernel subsystem, what is your strategy for the
> >    many existing CL-RC5xx / CL-RC6xx ASIC based RFID/NFC readers?  For them,
> >    you typically need your own software implementation of the anti-collision
> >    procedures of 14443-3 (a+b) and the T=CL (14443-4) code.  All of this has
> >    been implemented in userspace e.g. librfid - but do you want to port or
> >    re-implement it all in kernel-land, and then 'glue' it below your current
> >    NFC subsystem approach?
> 
> The obvious thing would be to plug it into the kernel at a higher level
> than the raw asic interface. We manage that sort of stuff with all sorts
> of network devices just fine, and in fact we'll need chunks of that
> anyway for virtualisation of rfid/nfc.

Actually, I'm not sure if we understand each other correctly.

The case that Lauro seems to be implementing right now, is with a RFID
controller that includes the analog+digital transceiver, as well as runs the
RFID protocol stack (ISO 14443) inside a 8051 based microcontroller.  This is
what is on Linux so far mostly used in combination with libnfc in userspace.

The case I was talking about is the opposite: You have a pure SPI/I2C (or often
through a protocol converter USB) attached RFID transceiver and have to
implement the protocol stack on the main CPU.  This is what you you would so
far drive from something like librfid in userspace.

If there is concensus that this all should live in kernel space, I could
try to find some time to work on an initial librfid-to-kernel port.

What is definitely needed then is some kind of PC/SC integration on the
userspace side, i.e. an ifdhandler that can plug into pcscd, as most of
the (non-NFC) ISO 14443 applications today (electronic passports, VISA, ID
card, ...) simply assume a smart card interface.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
