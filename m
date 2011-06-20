Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab1FTWXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:23:46 -0400
Received: from relais.videotron.ca ([24.201.245.36]:64341 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab1FTWXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:23:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Jun 2011 18:23:44 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <201106202323.49513.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1106201814490.2142@xanadu.home>
References: <alpine.LFD.2.00.1106201306210.2142@xanadu.home>
 <201106202226.37381.arnd@arndb.de>
 <20110620205559.GM26089@n2100.arm.linux.org.uk>
 <201106202323.49513.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Arnd Bergmann wrote:

> On Monday 20 June 2011 22:55:59 Russell King - ARM Linux wrote:
> > On Mon, Jun 20, 2011 at 10:26:37PM +0200, Arnd Bergmann wrote:
> > > * We already need a compiler barrier in the non-_relaxed() versions of
> > >   the I/O accessors, which will force a reload of the base address
> > >   in a lot of cases, so the code is already suboptimal. Yes, we don't
> > >   have the barrier today without CONFIG_ARM_DMA_MEM_BUFFERABLE, but that
> > >   is a bug, because it lets the compiler move accesses to DMA buffers
> > >   around readl/writel.
> > 
> > You're now being obtuse there.  You don't need compiler barriers to
> > guarantee order - that's what volatile does there.
> > 
> 
> A simple counterexample:
> 
> 
> int f(volatile unsigned long *v)
> {
>         unsigned long a[2], ret;
>         a[0] = 1;              /* initialize our DMA buffer */
>         a[1] = 2;
>         *v = (unsigned long)a; /* pass the address to the device, start DMA */
>         ret = *v;              /* flush DMA by reading from mmio */
>         return ret + a[1];     /* return accumulated status from readl and from modified
> 				  DMA buffer */
> }
> 
> arm-linux-gnueabi-gcc -Wall -O2 test.c -S
> 
> Without a barrier, the stores into the DMA buffer before the start are
> lost, as is the load from the modified DMA buffer:
> 
>         sub     sp, sp, #8
>         add     r3, sp, #0
>         str     r3, [r0, #0]
>         ldr     r0, [r0, #0]
>         adds    r0, r0, #2
>         add     sp, sp, #8
>         bx      lr
> 
> Adding a memory clobber to the volatile dereference turns this into the
> expected output:
> 
>         sub     sp, sp, #8
>         movs    r3, #2
>         movs    r2, #1
>         stmia   sp, {r2, r3}
>         add     r3, sp, #0
>         str     r3, [r0, #0]
>         ldr     r0, [r0, #0]
>         ldr     r3, [sp, #4]
>         adds    r0, r0, r3
>         add     sp, sp, #8
>         bx      lr
> 
> Now, the dma buffer is written before the volatile access, and read out
> again afterwards.

This example is flawed. The DMA API documentation already forbids DMA to 
the stack because of cache line sharing issues.  If you declare your 
buffer outside of the function body, the compiler can't optimize away 
the buffer store anymore, and this example works as expected without any 
memory clobber.


Nicolas
