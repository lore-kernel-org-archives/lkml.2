Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1HQUjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:39:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61810 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1HQUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch 24/36] Hexagon: Provide basic implementation and/or stubs for I/O routines.
Date: Wed, 17 Aug 2011 21:55:40 +0200
Message-ID: <3634899.QN7OL7NIVd@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163522.101836238@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163522.101836238@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:s0ON4hRFEO0KGyXe4/t88oeB69tGu7dZhzh1AVSx4fS
 v4f7D/DGfKPZhvNSrYkBUM4BJHyyi8TxOOZN+5941u6sC07qw+
 /9gMIDcatrIlQDWdgcajF9MgZDEEjrltIs8pSQ0nQPUQ+jU3OW
 w9YZQ4ZpFhDydOOfsLHZmik9snhBmpY6Eao/PHY2P8kR6VogxD
 X0/ZsEdOu8PPuk1B8m6bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:21 Richard Kuo wrote:

> +/*
> + * Need to figure out where our I/O space is.  Important for PCI.
> + * Which we don't have.
> + */
> +#define IO_SPACE_LIMIT 0xffffffff
> +#define _IO_BASE 0x0

Better set IO_SPACE_LIMIT to zero then, which should prevent drivers
from doing NULL pointer dereferences when they want to access I/O
space.

> +/*
> + * IO port access primitives.  Hexagon doesn't have special IO access
> + * instructions; all I/O is memory mapped.
> + *
> + * in/out are used for "ports", but we don't have "port instructions",
> + * so these are really just memory mapped too.
> + */
> +
> +/*
> + * readb - read byte from memory mapped device
> + * @addr:  pointer to memory
> + *
> + * Operates on "I/O bus memory space"
> + */
> +static inline u8 readb(const volatile void __iomem *addr)
> +{
> +	const volatile u8 *__mem = addr;
> +	u8 val = *__mem;
> +	return val;
> +}
> +
> +static inline u16 readw(const volatile void __iomem *addr)
> +{
> +	const volatile u16 *__mem = addr;
> +	u16 val = *__mem;
> +	return val;
> +}
> +
> +static inline u32 readl(const volatile void __iomem *addr)
> +{
> +	const volatile u32 *__mem = addr;
> +	u32 val = *__mem;
> +	return val;
> +}

These definitions might not be safe, because gcc can turn these
accesses into byte-wise pointer dereferences when it feels like it.
Better use inline assembly.

> +/*
> + * inb - read byte from I/O port or something
> + * @port:  address in I/O space
> + *
> + * Operates on "I/O bus I/O space"
> + */
> +static inline u8 inb(unsigned long port)
> +{
> +	printk(KERN_INFO "inb not implemented\n");
> +	return 0;
> +}
> +
> +static inline u16 inw(unsigned long port)
> +{
> +	printk(KERN_INFO "inw not implemented\n");
> +	return 0;
> +}
> +
> +static inline u32 inl(unsigned long port)
> +{
> +	printk(KERN_INFO "inl not implemented\n");
> +	return 0;
> +}

I'm working on a patch set to make it possible to build the
kernel without having to define these when you have no PCI.
Maybe you can leave them out already and see how far you get
on your platform?

It will definitely break allyesconfig right now, but perhaps
not break any of the drivers that you actually use.

> +/*
> + * outb - write a byte to a memory location
> + * @data: data to write to
> + * @addr:  address in I/O space
> + */
> +static inline void outb(u8 data, unsigned long port)
> +{
> +	writeb(data, (PCI_IO_ADDR)_IO_BASE+port);
> +}
> +
> +static inline void outw(u16 data, unsigned long port)
> +{
> +	writew(data, (PCI_IO_ADDR)_IO_BASE+port);
> +}
> +
> +static inline void outl(u32 data, unsigned long port)
> +{
> +	writel(data, (PCI_IO_ADDR)_IO_BASE+port);
> +}

It seems very inconsistent to provide outb but not inb.

> +
> +/*  generic versions defined in lib/iomap.c  */
> +extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
> +extern void ioport_unmap(void __iomem *addr);

You don't need these when you set CONFIG_NO_IOPORT.

	Arnd
