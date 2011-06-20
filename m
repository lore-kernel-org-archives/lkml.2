Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1FTQ1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:27:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1FTQ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:27:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Mon, 20 Jun 2011 18:26:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
References: <Pine.LNX.4.44L0.1106201049420.2113-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106201049420.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201826.13478.arnd@arndb.de>
X-Provags-ID: V02:K0:w+Alov9enbUz3EqLqCoWT8C9AllVweOpE+Y2+3Kb7qo
 j0NF0FJ4rwI+L9QXNnS+80HeVQVXpe2gOYPUKHZRkYai1SO8o5
 qCCjMOX5Ov9X+0mpH9EzSlMGrKN1skoE6Iq4ptmGnae6VgI66k
 1ZGDteanYf7bMW1iXFBE7rsRiWhmwcr225Huzk5IG20pZ1Nzqe
 z1BgCzITRg8y5L7kwnxWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 June 2011, Alan Stern wrote:
> On Sun, 19 Jun 2011, Nicolas Pitre wrote:
> 
> > > > The question is: does the structure really has to be packed?
> > > 
> > > What do you mean?  The structure really does need to be allocated
> > > without padding between the fields; is that the same thing?  So do a
> > > bunch of other structures that currently have no annotations at all.
> > 
> > Yes, that's the same thing.  The packed attribute tells the compiler 
> > that you don't want it to insert padding in it as it sees fit.
> 
> I thought the packed attribute does more than that.  For example, on
> some architectures doesn't it also force the compiler to use
> byte-oriented instructions for accessing the structure's fields?

Correct, and ARM is one of those. Giving  both packed and aligned(4)
will make gcc use 32-bit accesses again-

> > > > If the answer is yes in both cases, then having packed,aligned(4) is not 
> > > > a frivolity but rather a correctness issue.
> > > 
> > > Why so?  Current systems work just fine without it.
> > 
> > Doesn't mean that because it used to work that it is strictly correct.  
> > Wouldn't be the first time that a GCC upgrade broke the kernel because 
> > the kernel wasn't describing things properly enough.
> 
> It seems most unlikely that a gcc upgrade would cause unnecessary 
> padding to be added between a bunch of fields, all of the same size and 
> alignment.

I agree. The issue is mostly between EABI and oABI compilers behaving
differently on ARM, as well as differences between architectures.

> On the other hand, one of the other structures you haven't been 
> considering looks like this (with a bunch of uninteresting #define 
> lines omitted):
> 
> struct ehci_qtd {
> 	/* first part defined by EHCI spec */
> 	__hc32			hw_next;	/* see EHCI 3.5.1 */
> 	__hc32			hw_alt_next;    /* see EHCI 3.5.2 */
> 	__hc32			hw_token;       /* see EHCI 3.5.3 */
> 	__hc32			hw_buf [5];        /* see EHCI 3.5.4 */
> 	__hc32			hw_buf_hi [5];        /* Appendix B */
> 
> 	/* the rest is HCD-private */
> 	dma_addr_t		qtd_dma;		/* qtd address */
> 	struct list_head	qtd_list;		/* sw qtd list */
> 	struct urb		*urb;			/* qtd's urb */
> 	size_t			length;			/* length of buffer */
> } __attribute__ ((aligned (32)));
> 
> (__hc32 is an unsigned 32-bit type which can be either big-endian or 
> little-endian, depending on the device hardware.)
> 
> Only the first 5 fields need to be allocated without padding; the last 
> 4 can be laid out arbitrarily because they do not correspond to 
> anything in the hardware.  Once again, I do not think the ((packed)) 
> attribute is needed here -- in fact, we probably want to avoid it 
> because dma_addr_t can be 64 bits even on 32-bit architectures.

Agreed as well. The packing only ever matters for data structures
interpreted outside of the kernel -- user space, hardware or
network. The first five members in this structure seem to be
accessed by hardware, but they are all aligned correctly. The
other members are only used inside of the kernel and that has to
be built using only one ABI. goto no_problem;

	Arnd
