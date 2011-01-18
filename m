Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1ARViD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:38:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1ARVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:37:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH] asm-generic/io.h: Fix io{read,write}{16,32}be for big endian systems
Date: Tue, 18 Jan 2011 22:37:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8; KDE/4.5.1; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1295374261-19609-1-git-send-email-lars@metafoo.de> <201101182056.35673.arnd@arndb.de> <4D35FE23.1010102@metafoo.de>
In-Reply-To: <4D35FE23.1010102@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101182237.53601.arnd@arndb.de>
X-Provags-ID: V02:K0:b0VLyV+aCk0qILtJV8uT1bbsU5jMT497TGqdb9447B9
 jrlxhU2MwARRdh1CTLIDZLh5XS3QEFny6k7xEtvDXhJzESA2Ck
 uOmiXEEsM0fxPY1K9ny/DwX/9KCt7jOoh+5/rJVQjCf/H6eY8A
 CloNwvE1QUPOcBXy+GyVqCbQfEhqgAqOLjfY2A8UkZC6vOyMrS
 CuZJ607frQGfOIByO/avw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 January 2011 21:54:59 Lars-Peter Clausen wrote:
> >
> > Right, but the header file also serves as a template for new architectures
> > that cannot directly use it. I would prefer not to give a possibly bad example
> > here, especially when it's in a rarely used function.
> 
> Maybe I'm missing something here, but if I have a big-endian architecture isn't
> ioread{16,32}be what I should use to access iomapped memory?

Most I/O devices are little-endian, even for big-endian machines, and
should use readl or ioread. If you have big-endian SoC components,
ioread*be is often the right choice, but that case is rather rare.

Some architectures also define their own I/O accessors for SoC components,
since those often have other requirements from PCI MMIO areas.
E.g. on powerpc, the in_be32/in_le32 accessor only works on directly
mapped MMIO regions and performs no PCI error handling. On ARM, the
readl_relaxed() accessor does not synchronize with external buses.
On x86, readl is different from ioread32 in that it cannot work on
addresses returned from ioport_map.
I believe some SoCs are even configurable to have little- or big-endian
I/O, so the accessor does not do byte swapping.

It might be a good idea to make all this a little more structured, but
it's also fine if you set your own rules for a new architecture when
it has non-PCI devices that work in other ways.

> >>> The right solution is probably to use swab16/swab32 for the
> >>> big-endian functions. This also corrects the iowrite functions
> >>> which really should be using cpu_to_be32 instead of be32_to_cpu
> >>> (although they are always defined to be the same afaict.
> >>
> >> This would first cause a conversion to little-endian, which is a swap() in the
> >> generic case and then you would call swap() again on the result. Which is basically a
> >> noop, but I'm not sure if compilers will detect this.
> >
> > The overhead of the swab() is certainly dwarfed by the long time spent in
> > readl().
> 
> Well at least the code size overhead is fundamental:

Fair enough. You could of course make it out of line, but then you would
no longer be able to use the generic implementation of these functions.

> with #define ioread32be(addr) swap32(ioread32(addr)):
> 
>   4001a694 <get_cycles>:
>         addi sp,sp,-16
>         sw (sp+16),r11
>         sw (sp+12),r12
>         sw (sp+8),r13
>         sw (sp+4),ra
>         mvhi r2,0x4021
>         ori r2,r2,0xa100
>         lw r1,(r2+0)
>         mvi r2,24
>         mvhi r13,0xff
>         lw r12,(r1+0)
>         mv r1,r12
>         calli 400f6f9c <__lshrsi3>
>         mv r11,r1
>         mvi r2,24
>         mv r1,r12
>         calli 400f6f6c <__ashlsi3>
>         or r11,r11,r1
>         mvi r2,8
>         andi r1,r12,0xff00
> ...

That is indeed huge. Byte swapping is a relatively common operation
in the kernel, so independent of the solution to this particular
problem, it will be a good idea to see if you can do a better
implementation than this, using inline assembly or gcc internal
helpers.

> So I as someone who implements arch support has two options either redefine
> ioread32be in the arch io header, or use __raw_readl everywhere to access iomap memory.

__raw_readl is not a good thing to use, because of a number of reasons.
Please choose one of these four:

* change the common ioread*/iowrite* functions to all be based on
  the __raw_* I/O versions, not just the big-endian ones. The
  space overhead you quoted is enough of a justification for that.
* change asm-generic/io.h so you can override the definitions
  with architecture specific implementations.
* use GENERIC_IOMAP.
* define your own bus-specific accessors that are big-endian and
  based on __raw_readl/__raw_writel.

	Arnd
