Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1FTQsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:48:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43954 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752835Ab1FTQsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:48:32 -0400
Date: Mon, 20 Jun 2011 12:48:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Pitre <nico@fluxnic.net>
cc: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>, <linux-usb@vger.kernel.org>,
        <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
In-Reply-To: <alpine.LFD.2.00.1106201207280.2142@xanadu.home>
Message-ID: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Nicolas Pitre wrote:

> On Mon, 20 Jun 2011, Alan Stern wrote:
> 
> > On Sun, 19 Jun 2011, Nicolas Pitre wrote:
> > 
> > > > > The question is: does the structure really has to be packed?
> > > > 
> > > > What do you mean?  The structure really does need to be allocated
> > > > without padding between the fields; is that the same thing?  So do a
> > > > bunch of other structures that currently have no annotations at all.
> > > 
> > > Yes, that's the same thing.  The packed attribute tells the compiler 
> > > that you don't want it to insert padding in it as it sees fit.
> > 
> > I thought the packed attribute does more than that.  For example, on
> > some architectures doesn't it also force the compiler to use
> > byte-oriented instructions for accessing the structure's fields?
> 
> Yes, but that's a consequence of not being able to access those fields 
> in their naturally aligned position anymore.  Hence the addition of the 
> align attribute to tell the compiler that we know that the structure is 
> still aligned to a certain degree letting the compiler to avoid 
> byte-oriented instructions when possible.

Not exactly.  As far as I can tell, the ((packed)) attribute caused the 
compiler to change the structure's alignment from its natural value to 
1.  That's why the fields weren't in their naturally aligned positions 
and why removing ((packed)) fixed the problem.

> > > > > If the answer is yes in both cases, then having packed,aligned(4) is not 
> > > > > a frivolity but rather a correctness issue.
> > > > 
> > > > Why so?  Current systems work just fine without it.
> > > 
> > > Doesn't mean that because it used to work that it is strictly correct.  
> > > Wouldn't be the first time that a GCC upgrade broke the kernel because 
> > > the kernel wasn't describing things properly enough.
> > 
> > It seems most unlikely that a gcc upgrade would cause unnecessary 
> > padding to be added between a bunch of fields, all of the same size and 
> > alignment.
> 
> It is not the padding, but rather the decision to use or not to use 
> byte-oriented instructions in the abscence of explicit alignment 
> indication which appears to have changed with a recent GCC, which is the 
> source of this thread.

I thought the source of the thread had nothing to do with any recent
changes to gcc.  Maybe I was wrong.  In any case, the issue was not the
lack of an alignment indication but rather the unnecessary presence of
a ((packed)) attribute causing the compiler to forget about the natural
alignment.

To put it another way, the problem was caused by having ((packed))  
where it wasn't needed.  You want to fix the immediate fallout of the
problem by adding an alignment attribute, instead of fixing the problem
itself by removing the underlying cause.


> > On the other hand, one of the other structures you haven't been 
> > considering looks like this (with a bunch of uninteresting #define 
> > lines omitted):
> > 
> > struct ehci_qtd {
> > 	/* first part defined by EHCI spec */
> > 	__hc32			hw_next;	/* see EHCI 3.5.1 */
> > 	__hc32			hw_alt_next;    /* see EHCI 3.5.2 */
> > 	__hc32			hw_token;       /* see EHCI 3.5.3 */
> > 	__hc32			hw_buf [5];        /* see EHCI 3.5.4 */
> > 	__hc32			hw_buf_hi [5];        /* Appendix B */
> > 
> > 	/* the rest is HCD-private */
> > 	dma_addr_t		qtd_dma;		/* qtd address */
> > 	struct list_head	qtd_list;		/* sw qtd list */
> > 	struct urb		*urb;			/* qtd's urb */
> > 	size_t			length;			/* length of buffer */
> > } __attribute__ ((aligned (32)));
> > 
> > (__hc32 is an unsigned 32-bit type which can be either big-endian or 
> > little-endian, depending on the device hardware.)
> > 
> > Only the first 5 fields need to be allocated without padding; the last 
> > 4 can be laid out arbitrarily because they do not correspond to 
> > anything in the hardware.  Once again, I do not think the ((packed)) 
> > attribute is needed here -- in fact, we probably want to avoid it 
> > because dma_addr_t can be 64 bits even on 32-bit architectures.
> 
> Indeed, nothing indicates that any packed attribute is required here.

Likewise, nothing indicates any packed attribute is required for the 
structures in include/linux/usb/ehci_def.h.

Alan Stern

