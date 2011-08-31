Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1HaOrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:47:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab1HaOrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:47:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 24/35] Hexagon: Provide basic implementation and/or stubs for I/O routines.
Date: Wed, 31 Aug 2011 16:28:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
References: <20110830190729.923334292@codeaurora.org> <20110830190801.995980546@codeaurora.org>
In-Reply-To: <20110830190801.995980546@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311628.53309.arnd@arndb.de>
X-Provags-ID: V02:K0:4pa4oi9jjHYjJrQq0HfzS/buKZB/CSNhrmDzofhOjxQ
 DfssNiKkJUq9em5c/knhxkv/FP+gjn5duWcck7+VPHlkVtInLZ
 NFMaTBBYvnjG6LSVQMRUNIG+L8J9a4kVC1LWQEFGBHI82ha2iy
 NFyqHMlpOdp13XQWwdp5gFrIZZT5svgi0TG5pxEf7diOKFJp0w
 +TlhIbbI1G809jnvCBQVa+GopOh9d+ONoxOf/KQ2pfdmp47aE5
 HiZFowRIpudh/rZPNF/iSEkxWVAl3x2L13S+qtfggy1AqjfRzG
 Q/G+1R9OvBMNhVhe4PEm6z/ME/ox08Xzwdumlr8ufZ0pgtEATF
 oZdzdZFwjU/LJFg1/F14=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> Changed read/write to use inline assembly.
> 
> Rearranged the file and put all the ioport stuff at the bottom.  For now
> I'd like to just leave the stubs in there in case they need to be
> filled out later; plus things don't compile.
> 
> We still seem to need IO_SPACE_LIMIT to be defined, particularly to something
> large, as we have drivers that request resources with IORESOURCE_IO that
> are memory mapped IO.  The ioread/iowrites work as they select the correct
> routine to use.

Which drivers? If the drivers are buggy, better fix them than working around
in the architecture.

I have experimental patches in the tmp/randconfig3 branch of the arm-soc.git
tree to remove the need for PIO functions in ARM. Please have a look there
if you are interested.

> +/*
> + * We don't have PCI yet.
> + */
> +#define IO_SPACE_LIMIT 0xffffffff
> +#define _IO_BASE 0x0

If you absolutely insist on defining these, at least make them meaningful,
e.g. defining _IO_BASE to an unused location in the virtual address space,
and IO_SPACE_LIMIT small enough to be harmless, at most 0xffff.

If you ever gain PCI support, you can then map the PCI I/O space into that
area.

> +static inline void memcpy_fromio(void *dst, const volatile void __iomem *src,
> +	int count)
> +{
> +	memcpy(dst, (void *) src, count);
> +}
> +
> +static inline void memcpy_toio(volatile void __iomem *dst, const void *src,
> +	int count)
> +{
> +	memcpy((void *) dst, src, count);
> +}

This will need __force in order to build with sparse.

> +#define PCI_IO_ADDR	volatile void __iomem *

Better make _IO_BASE have the right type to start with, like

#define _IO_BASE ((void __iomem *)0xefff0000)
static inline u8 inb(unsigned long port)
{
	return readb(_IO_BASE + (port & IO_SPACE_LIMIT));
}

static inline void outb(u8 data, unsigned long port)
{
	writeb(data, _IO_BASE + (port & IO_SPACE_LIMIT));
}

> +/*  _p means "pause until the I/O completes"  */
> +#define outb_p outb
> +#define outw_p outw
> +#define outl_p outl
> +
> +#define inb_p inb
> +#define inw_p inw
> +#define inl_p inl

It doesn't actually mean that. It means 'pause for a bit longer'. The inb/outb
family of functions is already required to wait for the I/O to complete,
unlike readb/writeb, which only needs to wait for inbound data, while
outbound writes are posted to the bus without waiting for the data to arrive.

> +static inline void insb(unsigned long addr, void *buffer, int count)
> +{
> +	printk(KERN_INFO "insb not implemented\n");
> +}
> +
> +static inline void insw(unsigned long addr, void *buffer, int count)
> +{
> +	printk(KERN_INFO "insw not implemented\n");
> +}
> +
> +static inline void insl(unsigned long addr, void *buffer, int count)
> +{
> +	printk(KERN_INFO "insl not implemented\n");
> +}
> +
> +static inline void outsb(unsigned long addr, const void *buffer, int count)
> +{
> +	printk(KERN_INFO "outsb not implemented\n");
> +}
> +
> +static inline void outsw(unsigned long addr, const void *buffer, int count)
> +{
> +	printk(KERN_INFO "outsw not implemented\n");
> +}
> +
> +static inline void outsl(unsigned long addr, const void *buffer, int count)
> +{
> +	printk(KERN_INFO "outsl not implemented\n");
> +}

Either just add the obvious implementations adding _IO_BASE as above
or stub these out to create a link time error in drivers using them.
If a driver relies on these functions, it won't work anyway, so it's
better to not even build it.

> +/*  generic versions defined in lib/iomap.c  */
> +extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
> +extern void ioport_unmap(void __iomem *addr);


You can also just set CONFIG_NO_IOPORT (CONFIG_NO_IOPORT_MAP once my
patches went in) to remove support for ioport_map.

	Arnd
