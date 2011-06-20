Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1FTVYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 17:24:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1FTVYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 17:24:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Mon, 20 Jun 2011 23:23:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>, gregkh@suse.de,
        lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>
References: <alpine.LFD.2.00.1106201306210.2142@xanadu.home> <201106202226.37381.arnd@arndb.de> <20110620205559.GM26089@n2100.arm.linux.org.uk>
In-Reply-To: <20110620205559.GM26089@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202323.49513.arnd@arndb.de>
X-Provags-ID: V02:K0:migES4fzcFjb+8aed8TdNLfrfh6EXb+lsu/o7g7YDAv
 i4wck+8+y5doj9JVCut9+kHTKLj8LqLfWrnqZiHYei+JSqJ/u5
 0WUmjC5Pz8sykc393wjnrxwBwYtQ8oTFY/O/Ec4jmqxQ64sWAz
 BmIYguBlxG74KVSkZfguPL+jtRU/d+w4oX952Kd0GzayRpZySd
 0J4bxN3sptfpbrCj3AnaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 June 2011 22:55:59 Russell King - ARM Linux wrote:
> On Mon, Jun 20, 2011 at 10:26:37PM +0200, Arnd Bergmann wrote:
> > * We already need a compiler barrier in the non-_relaxed() versions of
> >   the I/O accessors, which will force a reload of the base address
> >   in a lot of cases, so the code is already suboptimal. Yes, we don't
> >   have the barrier today without CONFIG_ARM_DMA_MEM_BUFFERABLE, but that
> >   is a bug, because it lets the compiler move accesses to DMA buffers
> >   around readl/writel.
> 
> You're now being obtuse there.  You don't need compiler barriers to
> guarantee order - that's what volatile does there.
> 

A simple counterexample:


int f(volatile unsigned long *v)
{
        unsigned long a[2], ret;
        a[0] = 1;              /* initialize our DMA buffer */
        a[1] = 2;
        *v = (unsigned long)a; /* pass the address to the device, start DMA */
        ret = *v;              /* flush DMA by reading from mmio */
        return ret + a[1];     /* return accumulated status from readl and from modified
				  DMA buffer */
}

arm-linux-gnueabi-gcc -Wall -O2 test.c -S

Without a barrier, the stores into the DMA buffer before the start are
lost, as is the load from the modified DMA buffer:

        sub     sp, sp, #8
        add     r3, sp, #0
        str     r3, [r0, #0]
        ldr     r0, [r0, #0]
        adds    r0, r0, #2
        add     sp, sp, #8
        bx      lr

Adding a memory clobber to the volatile dereference turns this into the
expected output:

        sub     sp, sp, #8
        movs    r3, #2
        movs    r2, #1
        stmia   sp, {r2, r3}
        add     r3, sp, #0
        str     r3, [r0, #0]
        ldr     r0, [r0, #0]
        ldr     r3, [sp, #4]
        adds    r0, r0, r3
        add     sp, sp, #8
        bx      lr

Now, the dma buffer is written before the volatile access, and read out
again afterwards.

	Arnd
