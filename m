Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1FTPD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:03:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56372 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751745Ab1FTPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:03:52 -0400
Date: Mon, 20 Jun 2011 11:03:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Pitre <nico@fluxnic.net>
cc: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>, <linux-usb@vger.kernel.org>,
        <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
In-Reply-To: <alpine.LFD.2.00.1106191718000.2142@xanadu.home>
Message-ID: <Pine.LNX.4.44L0.1106201049420.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011, Nicolas Pitre wrote:

> > > The question is: does the structure really has to be packed?
> > 
> > What do you mean?  The structure really does need to be allocated
> > without padding between the fields; is that the same thing?  So do a
> > bunch of other structures that currently have no annotations at all.
> 
> Yes, that's the same thing.  The packed attribute tells the compiler 
> that you don't want it to insert padding in it as it sees fit.

I thought the packed attribute does more than that.  For example, on
some architectures doesn't it also force the compiler to use
byte-oriented instructions for accessing the structure's fields?

> > > If the answer is yes in both cases, then having packed,aligned(4) is not 
> > > a frivolity but rather a correctness issue.
> > 
> > Why so?  Current systems work just fine without it.
> 
> Doesn't mean that because it used to work that it is strictly correct.  
> Wouldn't be the first time that a GCC upgrade broke the kernel because 
> the kernel wasn't describing things properly enough.

It seems most unlikely that a gcc upgrade would cause unnecessary 
padding to be added between a bunch of fields, all of the same size and 
alignment.

> > What if the intent is that the structure should be 4-byte aligned on 
> > 32-bit systems and 8-byte aligned on 64-bit systems?  The compiler 
> > already does this sort of thing automatically, why mess with it?
> 
> Above you say that the structure must not contain padding, and now you 
> say that you want different alignment depending on whether or not the 
> architecture is 32 or 64 bits?
> 
> /me confused now.

I looked at the structures in question; they contain nothing but u32
values and arrays of u32's, except for an array of u8's at the end of
one of the structures.  So this question doesn't arise for them.

On the other hand, one of the other structures you haven't been 
considering looks like this (with a bunch of uninteresting #define 
lines omitted):

struct ehci_qtd {
	/* first part defined by EHCI spec */
	__hc32			hw_next;	/* see EHCI 3.5.1 */
	__hc32			hw_alt_next;    /* see EHCI 3.5.2 */
	__hc32			hw_token;       /* see EHCI 3.5.3 */
	__hc32			hw_buf [5];        /* see EHCI 3.5.4 */
	__hc32			hw_buf_hi [5];        /* Appendix B */

	/* the rest is HCD-private */
	dma_addr_t		qtd_dma;		/* qtd address */
	struct list_head	qtd_list;		/* sw qtd list */
	struct urb		*urb;			/* qtd's urb */
	size_t			length;			/* length of buffer */
} __attribute__ ((aligned (32)));

(__hc32 is an unsigned 32-bit type which can be either big-endian or 
little-endian, depending on the device hardware.)

Only the first 5 fields need to be allocated without padding; the last 
4 can be laid out arbitrarily because they do not correspond to 
anything in the hardware.  Once again, I do not think the ((packed)) 
attribute is needed here -- in fact, we probably want to avoid it 
because dma_addr_t can be 64 bits even on 32-bit architectures.

Alan Stern

