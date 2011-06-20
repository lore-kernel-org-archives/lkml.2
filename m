Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1FTUmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:42:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56503 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752453Ab1FTUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:42:33 -0400
Date: Mon, 20 Jun 2011 16:42:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Pitre <nico@fluxnic.net>
cc: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>, <linux-usb@vger.kernel.org>,
        <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
In-Reply-To: <alpine.LFD.2.00.1106201449320.2142@xanadu.home>
Message-ID: <Pine.LNX.4.44L0.1106201640290.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Nicolas Pitre wrote:

> Any usage of __packed is potentially making the code less optimal than 
> it could, depending on the actual layout of the structure where this is 
> applied, because outside of the IO accessor context, the compiler would 
> use less than optimal instructions when accessing the structure members.
> 
> If what you have is:
> 
> struct foo {
> 	u8  c;
> 	u32 d;
> 	u8  e;
> };
> 
> If you need that structure to be packed then so be it and nothing else 
> can be done about it.
> 
> However if you have:
> 
> struct foo {
> 	u32 c;
> 	u64 d;
> 	u32 e;
> };
> 
> Here the d member is not naturally aligned.  On most architectures, 
> including ARM with the ABI currently in use, the compiler would insert a 
> 32-bit padding between c and d.  If you must prevent that from happening 
> then you'll mark this struct with __packed.  However that will also mark 
> it as having an alignment of 1, meaning that all accesses to this 
> structure will be done byte by byte and the resulting values 
> reconstructed with shifts and ORs.

Agreed.

> Whar ARnd is talking about is _only_ about the IO accessor on ARM which 
> behavior changed with newer GCC versions.  Changing the IO accessor 
> implementation will fix the byte sized access issue to the hardware, but 
> the rest of the code will still suck even if it will work correctly.
> 
> By adding the aligned(4) attribute here, you're telling the compiler 
> that despite the packing attribute, it may assume that the structure is 
> still aligned on a 32-bit boundary (which is normally true except if you 
> cast a random pointer to this struct of course) and therefore it can 
> still use 32-bit sized accesses, and the u64 member will be correctly 
> accessed using a pair of 32-bit accesses instead of 8 byte sized 
> accesses.
> 
> So this is a matter of being intelligent with those attributes and not 
> stamping them freely just because a structure might be mapped to some 
> hardware representation.  In most cases, the packed attribute is just 
> unneeded.

Again, agreed.  The current code does not have the packed attribute.

> > As far as I can tell, the other structures in ehci.h have 
> > ((aligned(32)) simply in order to save space, since there can be large 
> > numbers of these structures allocated.
> 
> How can increasing the alignment to 32 bytes save space?

No, no -- the alignment is _decreased_ to 32 bits.  Without the 
attribute the alignment would have been 64 bits.

> Usually a greater alignment is used to ensure proper mapping to CPU 
> cache line boundaries, not to save space.

Irrelevant to the point I was making.

Alan Stern

