Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab1FULZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:25:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab1FULZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:25:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Tue, 21 Jun 2011 13:25:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Alexander Holler <holler@ahsoftware.de>
References: <alpine.LFD.2.00.1106201306210.2142@xanadu.home> <201106202323.49513.arnd@arndb.de> <alpine.LFD.2.00.1106201814490.2142@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1106201814490.2142@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106211325.16777.arnd@arndb.de>
X-Provags-ID: V02:K0:VSwoJR5QfMUYngJHx+X8ZX5f/XZSH1yZfgWqYhv31gi
 zQROxUMSt9vwf9Z065jKGgt1p/+3AQZB7rsWBMlETzkEw8Dx8m
 8QZSNmwsrIphXgNylz9//U/pi2jnFrHReMIx2Kvy8aEfdUoGNP
 3vJt1uxlLIvsvXyU4QXuXpJe1ReFnV87ycLWigddvpMvNULj0X
 fNy2sYcTWNrxJFtj9H/Qg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 June 2011, Nicolas Pitre wrote:
> On Mon, 20 Jun 2011, Arnd Bergmann wrote:

> This example is flawed. The DMA API documentation already forbids DMA to 
> the stack because of cache line sharing issues.  If you declare your 
> buffer outside of the function body, the compiler can't optimize away 
> the buffer store anymore, and this example works as expected without any 
> memory clobber.

Ok, another example, even simpler:

int f(int *dma_buf, volatile int *mmio_reg)
{
        (void) *mmio_reg; /* wait for DMA to complete */
        return *dma_buf;
}


gcc-4.4, 4.5 and 4.6 all turn this into:

        ldr     r0, [r0, #0]
        ldr     r3, [r1, #0]
        bx      lr

which means that the dma_buf variable is dereferenced before the
volatile mmio_reg variable, which opens up a race: An interrupt may have
signalled us that a DMA is in progress, so we read a MMIO register from
the device (this is guaranteed to flush the DMA on PCI and similar buses).
If we read the dma_buf before we read the mmio register, the data we get
back may be stale.

Adding a barrier() between the two turns the assembly into the expected

        ldr     r3, [r1, #0]
        ldr     r0, [r0, #0]
        bx      lr


	Arnd
