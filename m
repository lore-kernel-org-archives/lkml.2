Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1FTTO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:14:28 -0400
Received: from relais.videotron.ca ([24.201.245.36]:32260 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1FTTO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:14:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Jun 2011 15:14:26 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <Pine.LNX.4.44L0.1106201329390.2113-100000@iolanthe.rowland.org>
Message-id: <alpine.LFD.2.00.1106201449320.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106201329390.2113-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Alan Stern wrote:

> On Mon, 20 Jun 2011, Nicolas Pitre wrote:
> 
> > Are we talking past each other?
> > 
> > Remember that I was the one asking if the align attribute was needed in 
> > the first place.  If it is not then by all means please get rid of it!
> > 
> > But if it _is_ needed, then the generated code can be much better if the 
> > packed attribute is _also_ followed by the align attribute to 
> > increase it from 1.
> 
> According to Arnd, any remaining possible issues will be addressed by
> changing the implementation of readl/writel on ARM.  It doesn't look as
> though the ehci files need anything else done.

Any usage of __packed is potentially making the code less optimal than 
it could, depending on the actual layout of the structure where this is 
applied, because outside of the IO accessor context, the compiler would 
use less than optimal instructions when accessing the structure members.

If what you have is:

struct foo {
	u8  c;
	u32 d;
	u8  e;
};

If you need that structure to be packed then so be it and nothing else 
can be done about it.

However if you have:

struct foo {
	u32 c;
	u64 d;
	u32 e;
};

Here the d member is not naturally aligned.  On most architectures, 
including ARM with the ABI currently in use, the compiler would insert a 
32-bit padding between c and d.  If you must prevent that from happening 
then you'll mark this struct with __packed.  However that will also mark 
it as having an alignment of 1, meaning that all accesses to this 
structure will be done byte by byte and the resulting values 
reconstructed with shifts and ORs.

Whar ARnd is talking about is _only_ about the IO accessor on ARM which 
behavior changed with newer GCC versions.  Changing the IO accessor 
implementation will fix the byte sized access issue to the hardware, but 
the rest of the code will still suck even if it will work correctly.

By adding the aligned(4) attribute here, you're telling the compiler 
that despite the packing attribute, it may assume that the structure is 
still aligned on a 32-bit boundary (which is normally true except if you 
cast a random pointer to this struct of course) and therefore it can 
still use 32-bit sized accesses, and the u64 member will be correctly 
accessed using a pair of 32-bit accesses instead of 8 byte sized 
accesses.

So this is a matter of being intelligent with those attributes and not 
stamping them freely just because a structure might be mapped to some 
hardware representation.  In most cases, the packed attribute is just 
unneeded.

> As far as I can tell, the other structures in ehci.h have 
> ((aligned(32)) simply in order to save space, since there can be large 
> numbers of these structures allocated.

How can increasing the alignment to 32 bytes save space?

Usually a greater alignment is used to ensure proper mapping to CPU 
cache line boundaries, not to save space.


Nicolas
