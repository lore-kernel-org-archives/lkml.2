Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1FSVjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 17:39:37 -0400
Received: from relais.videotron.ca ([24.201.245.36]:25548 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1FSVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 17:39:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 19 Jun 2011 17:39:33 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
        linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <201106192202.23989.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1106191732440.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106191453200.14586-100000@netrider.rowland.org>
 <201106192202.23989.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011, Arnd Bergmann wrote:

> On Sunday 19 June 2011 21:00:01 Alan Stern wrote:
> > On Sun, 19 Jun 2011, Nicolas Pitre wrote:
> > > On Thu, 16 Jun 2011, Arnd Bergmann wrote:
> > > > On Thursday 16 June 2011 22:10:53 Alexander Holler wrote:
> > > > At least I would be happier without the patch. I'm trying to convince
> > > > people to not use these attributes unless required because too much
> > > > harm is done when they are used without understanding the full
> > > > consequences. I also recommend using __packed as localized as possible,
> > > > i.e. set it for the members that need it, not the entire struct.
> > > > 
> > > > I agree that your patch is harmless, it's just the opposite of
> > > > a cleanup in my opinion.
> > > 
> > > The question is: does the structure really has to be packed?
> > 
> > What do you mean?  The structure really does need to be allocated
> > without padding between the fields; is that the same thing?  So do a
> > bunch of other structures that currently have no annotations at all.
> 
> I guess the issue is that some ABIs actually require a minimum alignment,
> like the old ARM ABI that you can still use to build the kernel.
> 
> If a structure is not a multiple of four bytes in size, that ABI
> will add padding at the end, e.g. in
> 
> struct s {
> 	char c[2];
> };
> 
> struct t {
> 	struct s t1;
> 	unsigned short t2[3];
> };
> 
> On most architectures, struct s will be two bytes in size and one byte
> aligned, while struct t is eight bytes and two byte aligned.
> 
> On ARM oABI, struct s ends up with four byte size and alignment while
> struct t is twelve bytes long. All this is ok for regular structures,
> but not when they are used to describe memory layout of hardware
> registers on on-wire packets.

Agreed.  Is that the case with EHCI though?  In your example, you'd have 
to mark that structure as packed,aligned(2).

> > > If it does, then the follow-up question is: is a packing on word 
> > > boundaries sufficient?
> > 
> > > If the answer is yes in both cases, then having packed,aligned(4) is not 
> > > a frivolity but rather a correctness issue.
> > 
> > Why so?  Current systems work just fine without it.
> 
> I think Nicolas got it backwards here, adding both packed and
> aligned(4) would make a structure like the one above consistently
> incorrect when used to describe a tightly packed hardware structure.

I didn't look at the details, but your example above requires 
aligned(2).  That tells the compiler that it may use instructions to 
access the data (or hardware) that are up to 2-byte wide (on ARM that 
means STRh/LDRH) for the data of that width instead of the byte per byte 
loads.



> 
> In this case, we would have to do
> 
> struct s {
> 	char c[2];
> } __packed;
> 
> struct t {
> 	struct s t1;
> 	unsigned short t2[3] __aligned(2);
> } __packed;
> 
> To tell the compiler that t2 is indeed aligned, while struct t
> is packed to include no padding around t.

... and give the aligned(2) attribute to struct t so those shorts are 
accessed with a 16-bit wide load/store not byte loads/stores.


Nicolas
