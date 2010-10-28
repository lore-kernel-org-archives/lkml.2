Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab0J1BLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 21:11:51 -0400
Received: from c-67-162-90-113.hsd1.in.comcast.net ([67.162.90.113]:47567 "HELO
	kosh.dhis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757889Ab0J1BLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 21:11:49 -0400
Message-ID: <20101028011147.26254.qmail@kosh.dhis.org>
From: pacman@kosh.dhis.org
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
To: segher@kernel.crashing.org (Segher Boessenkool)
Date: Wed, 27 Oct 2010 20:11:47 -0500 (GMT+5)
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <50748.84.105.60.153.1288222432.squirrel@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool writes:
> 
> >> 1) Figure out what exactly is going on;
> >
> > I thought we were past that.
> 
> We are not.
> 
> > The startup sequence leaves the device in a
> > bad
> > state (writing 1000 times per second to memory that the kernel believes is
> > not in use), so it needs to be given a reset command before the kernel
> > tries
> > to use that memory.
> 
> The question now is what causes the firmware to do that, and then
> what is the best way to stop it from doing that.

As far as I can tell, it turns on the host controller during the global
probe, which is not wrong because USB devices could theoretically be used for
booting, or for console display. Then it never turns off the host controller
because someone forgot to put in the code to turn it off.

It's not easy to figure out exactly where that should have been done. Turning
off the host controller too soon would rule out booting from USB, but leaving
it running while the OS is starting up has caused a major problem.

So is it wrong to leave the host controller enabled when the OS is booted? If
not, then the error must be in the communication of which memory addresses
are in use by OF. I've got a node /memory@0 whose "available" property looks
like this:
 00000000 00400000
 00584000 0007c000
 0092a1d8 00004e28
 00a2f000 005d1000
 01800000 0e3fd000
 0fbffab4 0000054c
>From that list, it looks to me like OF is telling the kernel that it should
not attempt to use any address above 0xfbffab4+0x54c == 0xfc00000. The
addresses being written to by the OHCI controller are 0xfc5c080 and
0xfc61080. If the kernel is staying within the "available" list, there won't
be a problem.

Later, when the kernel decides it's done using OF, what's supposed to happen?
It closes stdin, but that doesn't help here since the offending device is a
bus node, not an input node. It looks to me like the kernel makes the
assumption that all devices other than stdin and stdout will have been
deactivated already when the kernel starts, and that this assumption has
been violated. Who is wrong, from the perspective of the OF standard, the
assumer or the violator?

Then there's the "quiesce" call, which I don't understand at all since it's
not mentioned in any of the specification documents I've been able to find.
It's been mentioned as an Apple-only thing. Seems like it would be a good
name for a "make all the devices stop puking on the RAM" function. Since the
OF spec doesn't include this function, they must not have thought it was
necessary.

> > /pci@80000000/usb@5/assigned-addresses
> >  02002810 00000000 80000000 00000000 00001000
> 
> Lovely, incorrect data (it should start with 82002810, i.e.,
> not relocatable -- it is already an assigned address!).

Now you see how I have trouble relating the docs to the reality...

> 
> This means: 32-bit MMIO address space for bus 0 dev 5 fn 0,
> first BAR; assigned to address 80000000; size is 1000.

But "address 80000000" is a physical address (I think), so do I need to do a
map-in on it before using it?

> 
> You could try a boot script like this:
> 
> 
> dev /pci
> 0 ffff04 DO 0 i config-w! -100 +LOOP
> device-end
> 
> 
> which should disable all PCI devices on all busses, on that

Almost all of my devices are under that PCI node. What will I prove by
disabling them?

-- 
Alan Curry
