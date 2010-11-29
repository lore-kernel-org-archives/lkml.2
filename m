Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0K2MRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:17:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47875 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab0K2MRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:17:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DGI43Af/AoKUxpOIyvw5HyiysIL6L9hRiFhKrlt9EW0B9LxkWEL5dLnT21y3vLBzyS
         17bFlC/4HK+s1DsUu8eluwEHlCLnSrwSSrITyAr0DRr2VCj2+oZVWWT41oOhXjC9KzGD
         4k383hVZAEzzHXhb9Yo4KPrxW01cEIvYCRkAM=
Date: Mon, 29 Nov 2010 13:17:12 +0100 (CET)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
X-X-Sender: elektroman@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
In-Reply-To: <201011282056.17389.arnd@arndb.de>
Message-ID: <alpine.LNX.2.00.1011291316560.11926@localhost.localdomain>
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011282056.17389.arnd@arndb.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Nov 2010, Arnd Bergmann wrote:

> On Saturday 27 November 2010 13:24:35 Hans Ulli Kroll wrote:
> > +#define PCI_IOSIZE_REG         (IO_ADDRESS(GEMINI_PCI_IO_BASE))
> > +#define PCI_PROT_REG           (IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x04)
> > +#define PCI_CTRL_REG           (IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x08)
> > +#define PCI_SOFTRST_REG                (IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x10)
> > +#define PCI_CONFIG_REG         (IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x28)
> > +#define PCI_DATA_REG           (IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x2C)
> 
> If you use the virtual address of the mapping instead of
> GEMINI_PCI_IO_BASE, you don't need to repeat the IO_ADDRESS()
> macro everywhere. I have a patch that gets rid of all the
> conflicting definitions of this macro because it breaks
> a multi-platform build once we get there. 
> 
> > +static DEFINE_SPINLOCK(gemini_pci_lock);
> > +
> > +static struct resource gemini_pci_resource_io = {
> > +       .name   = "PCI I/O Space",
> > +       .start  = IO_ADDRESS(GEMINI_PCI_IO_BASE),
> > +       .end    = IO_ADDRESS(GEMINI_PCI_IO_BASE) + SZ_1M - 1,
> > +       .flags  = IORESOURCE_IO,
> > +};
> > +
> 
> This looks wrong in multiple ways:
> 
> * resources are physical addresses, not virtual addresses
> * GEMINI_PCI_IO_BASE is an address in memory space, so it
>   needs to be IORESOURCE_MEM, not IORESOURCE_IO. You can
>   also register the IORESOURCE_IO resource, but that would
>   be .start=PCIBIOS_MIN_IO, .end=IO_SPACE_LIMIT.
> * IO_SPACE_LIMIT is larger than the I/O window, which can
>   cause overflows. Setting it to 0xffff is generally enough.
> 

So I must remove these lines ??
	}, {
		.virtual	= IO_ADDRESS(GEMINI_PCI_IO_BASE),
		.pfn		= __phys_to_pfn(GEMINI_PCI_IO_BASE),
		.length		= SZ_512K,
		.type		= MT_DEVICE,
	},
These are from arch/arm/mach-gemini/mm.c
	
> > +       spin_lock_irqsave(&gemini_pci_lock, irq_flags);
> > +
> > +       __raw_writel(PCI_CONF_BUS(bus->number) |
> > +                       PCI_CONF_DEVICE(PCI_SLOT(fn)) |
> > +                       PCI_CONF_FUNCTION(PCI_FUNC(fn)) |
> > +                       PCI_CONF_WHERE(config) |
> > +                       PCI_CONF_ENABLE,
> > +                       PCI_CONFIG_REG);
> > +
> > +       switch (size) {
> > +       case 4:
> > +               __raw_writel(value, PCI_DATA_REG);
> > +               break;
> > +       case 2:
> > +               __raw_writew(value, PCI_DATA_REG + (config & 3));
> > +               break;
> > +       case 1:
> > +               __raw_writeb(value, PCI_DATA_REG + (config & 3));
> > +               break;
> > +       default:
> > +               ret = PCIBIOS_BAD_REGISTER_NUMBER;
> > +       }
> > +
> > +       spin_unlock_irqrestore(&gemini_pci_lock, irq_flags);
> 
> The I/O ordering is probably not what you think it is.
> There is no ordering guarantee between __raw_writel and
> spin_lock/spin_unlock, so you really should be using
> readl/writel.
> 
> Note that the pci_ops are called under another spinlock, so
> you also don't need to take gemini_pci_lock here.
> 
> 	Arnd
> 
