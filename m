Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1FTUuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:50:37 -0400
Received: from relais.videotron.ca ([24.201.245.36]:45214 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1FTUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:50:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Jun 2011 16:50:34 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, gregkh@suse.de,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Alan Stern <stern@rowland.harvard.edu>,
        Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH] USB: ehci: use packed,
 aligned(4) instead of removing the packed attribute
In-reply-to: <201106202226.37381.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1106201634260.2142@xanadu.home>
References: <alpine.LFD.2.00.1106201306210.2142@xanadu.home>
 <Pine.LNX.4.44L0.1106201329390.2113-100000@iolanthe.rowland.org>
 <20110620184849.GI26089@n2100.arm.linux.org.uk>
 <201106202226.37381.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Arnd Bergmann wrote:

> On Monday 20 June 2011 20:48:49 Russell King - ARM Linux wrote:
> > If it is the case that these structures do not require packing to get
> > their desired layout, then they don't require packing, and the packed
> > attribute should be dropped.
> 
> Yes. But are you going to audit every other use of __packed in the kernel
> to check if it is used on __iomem pointers?

The compiler might tell us about it:

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d66605d..10c47e8 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -49,11 +49,11 @@ extern void __raw_readsl(const void __iomem *addr, void *data, int longlen);
 
 #define __raw_writeb(v,a)	(__chk_io_ptr(a), *(volatile unsigned char __force  *)(a) = (v))
 #define __raw_writew(v,a)	(__chk_io_ptr(a), *(volatile unsigned short __force *)(a) = (v))
-#define __raw_writel(v,a)	(__chk_io_ptr(a), *(volatile unsigned int __force   *)(a) = (v))
+#define __raw_writel(v,a)	(__chk_io_ptr(a), BUILD_BUG_ON_ZERO(__alignof(*(int *)a) != 4), *(volatile unsigned int __force   *)(a) = (v))
 
 #define __raw_readb(a)		(__chk_io_ptr(a), *(volatile unsigned char __force  *)(a))
 #define __raw_readw(a)		(__chk_io_ptr(a), *(volatile unsigned short __force *)(a))
-#define __raw_readl(a)		(__chk_io_ptr(a), *(volatile unsigned int __force   *)(a))
+#define __raw_readl(a)		(__chk_io_ptr(a), BUILD_BUG_ON_ZERO(__alignof(*(int *)a) != 4), *(volatile unsigned int __force   *)(a))
 
 /*
  * Architecture ioremap implementation.

And similar for readh/writeh, given that your GCC version is preserving 
the alignment attribute across the cast of course.

[...]

Scratch that.  The alignment of a void pointer dereference is 1.


Nicolas
