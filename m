Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1FSTkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 15:40:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1FSTkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 15:40:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 16/19] OpenRISC: Headers
Date: Sun, 19 Jun 2011 21:39:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-17-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-17-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192139.45218.arnd@arndb.de>
X-Provags-ID: V02:K0:1/bWH/kJhu1agsPSxT5Fgwg2MVm+Abt7wcZ6OJXGtp5
 inwZkmfdrPDoK7S0dxi3wGNR1OwdNL+uVDdLYcyfcXQn9WFNaP
 zZParJrRh3J8kOS+dwo7CH3aaHTxDhc7Fznbv7eiVzrWy0+6EV
 LUnhukDiCsHWphLG2eRSx9OCfUA9g9TMISWDY+JfSiMdsB+15z
 uy2cXN6M5ZFsN8ETeiCxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:42 Jonas Bonn wrote:

> --- /dev/null
> +++ b/arch/openrisc/include/asm/cacheflush.h
> @@ -0,0 +1,25 @@

> +/*
> + * The cache doesn't need to be flushed when TLB entries change when
> + * the cache is mapped to physical memory, not virtual memory...
> + * that's what the generic implementation gets us.
> + */
> +
> +#include <asm-generic/cacheflush.h>

You can add this to the list of generated files.

> +
> +extern inline void __delay(int loops)
> +{
> +	__asm__ __volatile__ (
> +			      "l.srli %0,%0,1;"
> +			      "1: l.sfeqi %0,0;"
> +			      "l.bnf 1b;"
> +			      "l.addi %0,%0,-1;"
> +			      : "=r" (loops): "0" (loops));
> +}
> +

If you have an accurate high-resolution time source, better make this compare
the current time in a loop than do a handcoded delay.

> +/* Deprecated */
> +#define virt_to_bus virt_to_phys
> +#define bus_to_virt phys_to_virt

I would rather not define them at all. If you have any drivers using them,
fix the drivers instead.

> +#define __raw_readb(addr) (*(volatile unsigned char *) (addr))
> +#define __raw_readw(addr) (*(volatile unsigned short *) (addr))
> +#define __raw_readl(addr) (*(volatile unsigned int *) (addr))
> +
> +#define __raw_writeb(b,addr) ((*(volatile unsigned char *) (addr)) = (b))
> +#define __raw_writew(b,addr) ((*(volatile unsigned short *) (addr)) = (b))
> +#define __raw_writel(b,addr) ((*(volatile unsigned int *) (addr)) = (b))

You should make sure that the pointer has an __iomem modifier, either
by turning this into an inline function, or by doing magic pointer arithmetic
like

#define __raw_writeb(b,addr) ((*((volatile unsigned char *)(0)	\
				+ ((addr) 			\
				- (unsigned char __iomem *)0))) = (b))

Also, please use 'sparse' to check that all pointer annotations in your
code are correct, using 'make C=1'.

> +/* Wishbone Interface
> + *
> + * The Wishbone bus can be both big or little-endian, but is generally
> + * of the same endianess as the CPU ("native endian").  As peripherals
> + * are generally synthesized together with the CPU, they will also be
> + * of the same endianess.  In order to simplify things, we assume for
> + * now that there are no memory-mapped IO devices on any other bus than
> + * then the local Wishbone bus and that these devices are all native
> + * endian.
> + */
> +
> +#define wb_ioread8(p)  __raw_readb(p)
> +#define wb_ioread16(p) __raw_readw(p)
> +#define wb_ioread32(p) __raw_readl(p)
> +
> +#define wb_iowrite8(v,p)  __raw_writeb(v,p)
> +#define wb_iowrite16(v,p) __raw_writew(v,p)
> +#define wb_iowrite32(v,p) __raw_writel(v,p)

A few things to consider here:

* If your toolchain tries to avoid unaligned accesses, this will be
  incorrect for drivers that have packed structures: you need to
  define the functions as inline assembly in order to ensure an
  atomic access.

* If any device on this bus can trigger a DMA by an MMIO operation,
  there should be an appropriate memory barrier in that operation,
  at least a compiler barrier(), but possibly one that flushes the
  memory bus, depending what the drivers rely on. At least document
  the guarantees that you do or do not make regarding ordering.

> +#define memset_io(a,b,c)	memset((void *)(a),(b),(c))
> +#define memcpy_fromio(a,b,c)	memcpy((a),(void *)(b),(c))
> +#define memcpy_toio(a,b,c)	memcpy((void *)(a),(b),(c))

Threse also need a pointer conversion and barriers.

> +/*
> + * Again, OpenRISC does not require mem IO specific function.
> + */
> +
> +#define eth_io_copy_and_sum(a,b,c,d)	eth_copy_and_sum((a),(void *)(b),(c),(d))
> +
> +#define IO_BASE			0x0
> +#define IO_SPACE_LIMIT 		0xffffffff

(IO_BASE == 0) doesn't work with PCI or anything else. It should also be a
void __iomem pointer, e.g.
#define IO_BASE	((void __iomem *) 0xfffa0000)
When you load your PCI host driver, use that address to map the I/O space window,
and return IO_BASE+port in your ioport_map().

IO_SPACE_LIMIT should be the total size of the I/O space window, typically 64KB
unless you have multiple PCI domains.

> +#define inb(port)		(*(volatile unsigned char *) (port+IO_BASE))
> +#define outb(value,port)	((*(volatile unsigned char *) (port+IO_BASE)) = (value))

Just define them in terms of readb/writeb, so you also get the appropriate
barriers and type checking.

> +/* __iomem accessors
> + *
> + * These accessors work on __iomem cookies and the recommended means of
> + * doing MMIO access for OpenRISC.  The current assumption for OpenRISC
> + * is that the Wishbone bus is the only bus with memory mapped peripherals
> + * and that the bus endianess (and device endianess) is the same as that
> + * of the CPU.
> + */
> +
> +#define ioread8(addr)           wb_ioread8(addr)
> +#define ioread16(addr)          wb_ioread16(addr)
> +#define ioread32(addr)          wb_ioread32(addr)
> +
> +#define iowrite8(v, addr)       wb_iowrite8((v),(addr))
> +#define iowrite16(v, addr)      wb_iowrite16((v),(addr))
> +#define iowrite32(v, addr)      wb_iowrite32((v),(addr))
> +
> +#endif

The assumption is wrong. ioread/write are defined as little-endian, just like
PCI.

> diff --git a/arch/openrisc/include/asm/pci.h b/arch/openrisc/include/asm/pci.h
> new file mode 100644
> index 0000000..47c3e45
> --- /dev/null
> +++ b/arch/openrisc/include/asm/pci.h
> @@ -0,0 +1,28 @@
> +
> +#ifndef __ASM_OPENRISC_PCI_H
> +#define __ASM_OPENRISC_PCI_H
> +
> +#include <asm-generic/pci.h>
> +
> +/*
> + * no PCI support yet implemented for OpenRISC
> + */
> +
> +#endif /* __ASM_OPENRISC_PCI_H */

Just autogenerate this file then.

> diff --git a/arch/openrisc/include/asm/smp.h b/arch/openrisc/include/asm/smp.h
> new file mode 100644
> index 0000000..fadff1e
> --- /dev/null
> +++ b/arch/openrisc/include/asm/smp.h

This file should not be included anywhere if you don't have SMP support.

> diff --git a/arch/openrisc/include/asm/spinlock.h b/arch/openrisc/include/asm/spinlock.h
> new file mode 100644
> index 0000000..fd00a3a
> --- /dev/null
> +++ b/arch/openrisc/include/asm/spinlock.h
> +
> +#ifndef __ASM_OPENRISC_SPINLOCK_H
> +#define __ASM_OPENRISC_SPINLOCK_H
> +
> +#error "or32 doesn't do SMP yet"
> +
> +#endif

same here.


> diff --git a/arch/openrisc/include/asm/string.h b/arch/openrisc/include/asm/string.h
> new file mode 100644
> index 0000000..6b41da1
> --- /dev/null
> +++ b/arch/openrisc/include/asm/string.h

generic

	Arnd
