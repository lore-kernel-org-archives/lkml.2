Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1FSV1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 17:27:12 -0400
Received: from relais.videotron.ca ([24.201.245.36]:63827 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1FSV1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 17:27:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 19 Jun 2011 17:27:08 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <Pine.LNX.4.44L0.1106191453200.14586-100000@netrider.rowland.org>
Message-id: <alpine.LFD.2.00.1106191718000.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106191453200.14586-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011, Alan Stern wrote:

> On Sun, 19 Jun 2011, Nicolas Pitre wrote:
> 
> > On Thu, 16 Jun 2011, Arnd Bergmann wrote:
> > 
> > > On Thursday 16 June 2011 22:10:53 Alexander Holler wrote:
> > > > Using packed doesn't seem to be necessary (at least not with those 
> > > > versions of gcc I'm using here), I've tried both versions (on arm, 
> > > > without packed and with packed, aligned(4)) and both are working. I've 
> > > > only posted the patch because I found the usage of packed, aligned(4) 
> > > > much clearer than without packed. And It might help avoiding such 
> > > > discussions like this with people like me who aren't that deep involved 
> > > > in gcc-specific implementation details. ;)
> > > > 
> > > > Anyway, feel free to nack that patch. I don't really care and just 
> > > > thought I should post it (e.g. as an alternative to removing that packed).
> > > 
> > > At least I would be happier without the patch. I'm trying to convince
> > > people to not use these attributes unless required because too much
> > > harm is done when they are used without understanding the full
> > > consequences. I also recommend using __packed as localized as possible,
> > > i.e. set it for the members that need it, not the entire struct.
> > > 
> > > I agree that your patch is harmless, it's just the opposite of
> > > a cleanup in my opinion.
> > 
> > The question is: does the structure really has to be packed?
> 
> What do you mean?  The structure really does need to be allocated
> without padding between the fields; is that the same thing?  So do a
> bunch of other structures that currently have no annotations at all.

Yes, that's the same thing.  The packed attribute tells the compiler 
that you don't want it to insert padding in it as it sees fit.

> > If it does, then the follow-up question is: is a packing on word 
> > boundaries sufficient?
> 
> Again, what do you mean?  The structure contains some 32-bit fields and 
> it must always be allocated at a 4-byte boundary.  However there's 
> nothing wrong with stricter allocation -- I don't recall the details 
> but it's entirely possible that some of the fields could be 64 bits on 
> some architectures, in which cases the alignment certainly should be 
> 8-byte.

The alignment attribute tells the compiler that whatever the structure 
is, it will always be aligned to a 4-byte boundary.  And because 
hardware representation very rarely express 4-byte values not aligned to 
a 4-byte address boundary, the combination of both attributes is 
actually the best way to have no padding in a structure but still access 
it with word-sized accesses when possible.  Of course that assumes that 
the non padded structure does have a sequence of members which sizes 
match their alignments or a 4-byte boundary, whichever is the smallest.

> > If the answer is yes in both cases, then having packed,aligned(4) is not 
> > a frivolity but rather a correctness issue.
> 
> Why so?  Current systems work just fine without it.

Doesn't mean that because it used to work that it is strictly correct.  
Wouldn't be the first time that a GCC upgrade broke the kernel because 
the kernel wasn't describing things properly enough.

> >  We can of course provide a 
> > define in include/linux/compiler-gcc.hto hide the ugliness of it 
> > somewhat:
> > 
> > #define __packed_32  __attribute__((packed,aligned(4)))
> > 
> > I suspect that the vast majority of the __packed uses in the kernel 
> > would be better with this __packed_32 instead, the actual need and 
> > intent would be more clearly expressed, and the generated code in the 
> > presence of those GCC changes would then be way more efficient and still 
> > correct.
> 
> What if the intent is that the structure should be 4-byte aligned on 
> 32-bit systems and 8-byte aligned on 64-bit systems?  The compiler 
> already does this sort of thing automatically, why mess with it?

Above you say that the structure must not contain padding, and now you 
say that you want different alignment depending on whether or not the 
architecture is 32 or 64 bits?

/me confused now.


Nicolas
