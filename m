Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0K0Cyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 21:54:45 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:33062 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab0K0Cyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 21:54:41 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Greg KH'" <greg@kroah.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
References: <00a701cb8883$649d39f0$2dd7add0$@mprc.pku.edu.cn> <201011241758.14157.arnd@arndb.de>
In-Reply-To: <201011241758.14157.arnd@arndb.de>
Subject: RE: [PATCH] a new UniCore32 arch-dependent patch for linux-2.6.37-rc1
Date: Sat, 27 Nov 2010 10:54:18 +0800
Message-ID: <000c01cb8dde$646f4120$2d4dc360$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AQGzHwPsQ4MuY7Ev2RR1f0Fo5aRFLgI+dobBk6KtF9A=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH] a new UniCore32 arch-dependent patch for linux-
> 2.6.37-rc1
> > > > +CONFIG_CMDLINE_FROM_U_BOOT=y
> > > > +CONFIG_CMDLINE="mem=512M ignore_loglevel
> > > video=unifb:1024x600-16@75 root=/dev/nfs rw
> > > nfsroot=/home/nfs/uc3,rsize=1024,wsize=1024
> > > ip=192.168.10.83:192.168.10.82:192.168.10.1:255.255.255.0::eth0:off"
> > >
> > > You should never need to pass the memory size in the command line.
> > > Please ensure that the boot loader always passes the memory size
> > > using your boot protocol (ideally in a device tree).
> > >
> > [Guan] CMDLINE will only be used when no bootloader params.
> >   And u-boot params have another cmdline to replace this one.
> 
> Well, my point was more specifically that having to provide options on the
> command line that are hardware specific is wrong, independent of whether
> they come from the hardcoded command line or from u-boot.
> 
> The command line can of course be used for boot device configuration like
> the NFS root stuff (which I still would not put in the defconfig), but
memory
> size and screen resolution are something that should always be detectable
> these days.
Ok, I will consider to remove memory size and screen resolution lator.

> > > The files look mostly identical. If there is no fundamental
> > > difference between them, I would recommend providing only a single
> > > defconfig file that works on all the machines.
> > [Guan] nb0916 is for netbook and desktop, and CONFIG_MODULES must
> be
> > enabled.
> >   Smw0919 is for safety embedded devices, only necessary
> > devices/drivers are integrated.
> 
> The defconfig is not typically used without modifications on real systems,
but
> serves as a starting point. If it's reasonable to build a configuration
with all the
> smw0919 device drivers built-in and the additional nb0916 drivers as
loadable
> modules, I guess that would make a reasonable defconfig.
> On smw0919 hardware, you can then just choose not to install the modules
> into the root file system.
Ok.

> 
> > > > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> > > linux-2.6.37-rc1/arch/unicore32/include/asm/dma.h
> > > linux-2.6.37.y/arch/unicore32/include/asm/dma.h
> > > > --- linux-2.6.37-rc1/arch/unicore32/include/asm/dma.h	1970-01-01
> > > 08:00:00.000000000 +0800
> > > > +++ linux-2.6.37.y/arch/unicore32/include/asm/dma.h	2010-11-11
> > > 09:55:29.517572760 +0800
> > > > @@ -0,0 +1,34 @@
> > > > +/*
> > > > + * linux/arch/unicore32/include/asm/dma.h
> > >
> > > Just use the asm-generic file.
> > [Guan] when I set MAX_DMA_ADDRESS to PAGE_OFFSET, some pci drivers
> > have problem.
> >   I will check it later.
> 
> Interesting. You already allow to override MAX_DMA_ADDRESS to
> (PAGE_OFFSET + SZ_128M) when PCI is enabled. It would be good to find out
> (and document!) the signficance of the extra 128MB here.
> 
PCI controller in PKUnity-3 masks highest 5-bit for upstream channel, so we
must
Limit the DMA allocation with 128M physical memory for supporting PCI
devices.

> If it turns out to be required, please make a patch to the
asm-generic/dma.h
> file to allow overriding MAX_DMA_ADDRESS in the same way you do in your
> version.
I need to check it later. 
I suppose MAX_DMA_ADDRESS is virtual address, so it should be larger than
PAGE_OFFSET.
 
> 
> > > > + * Nothing too fancy for now.
> > > > + *
> > > > + * On UniCore we already have well known fixed virtual addresses
> > > > + imposed by
> > > > + * the architecture such as the vector page which is located at
> > > > + 0xffff0000,
> > >
> > > The comment is copied from ARM, but is it really true on unicore?
> > >
> > [Guan] Yes.
> 
> In what way does the architecture enforce this? What are the contents of
> this page? Can you make it an actual VDSO rather than a magic page that
sits
> in the user address space?
Page table is created for vector page and exceptions entry stub.
However, vector page is not in the user address space.
 
> > > > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> > > linux-2.6.37-rc1/arch/unicore32/include/asm/highmem.h
> > > linux-2.6.37.y/arch/unicore32/include/asm/highmem.h
> > > > --- linux-2.6.37-rc1/arch/unicore32/include/asm/highmem.h
1970-
> 01-01
> > > 08:00:00.000000000 +0800
> > > > +++ linux-2.6.37.y/arch/unicore32/include/asm/highmem.h	2010-
> 11-08
> > > 15:53:09.077836027 +0800
> > > > @@ -0,0 +1,53 @@
> > > > +/*
> > > > + * linux/arch/unicore32/include/asm/highmem.h
> > >
> > > What is the maximum amount of memory you support on the 32 bit
> machines?
> > > We're removing all the optimizations for highmem from the kernel
> > > now, so I would recommend not to support this in new architectures
> > > if you can avoid it.
> > [Guan] we need to support 2GB memory.
> 
> Would it be an option to have a fixed 2GB/2GB split between user and
> physical address space? That would limit the user addressable range to
> something just under 2GB (because of vmalloc/ioremap pages), but would
> significantly simplify and speed up user memory access from kernel space.
Thanks. I consider not to support highmem in 32-bit address space.

> > > > +/*
> > > > + * Use this value to indicate lack of interrupt
> > > > + * capability
> > > > + */
> > > > +#ifndef NO_IRQ
> > > > +#define NO_IRQ	((unsigned int)(-1))
> > > > +#endif
> > >
> > > This should not be required at all any more.
> > >
> > [Guan] amba bus driver need NO_IRQ
> 
> That is a bug, as far as I can tell. I think it should be changed to a
hardcoded (-
> 1) in the amba drivers as we do elsewhere.
> 
> Until now, I was not even aware that we had an amba bus driver, and I'm
not
> conviced that it's a good idea to use it either in its current form.
> 
> Most of the users of the amba bus currently declare static devices in the
> architecture tree, which is something that breaks a number of assumptions
in
> the device model about the life time of device structures.
Yes. Amba bus and NO_IRQ are removed.

> > > > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> > > linux-2.6.37-rc1/arch/unicore32/include/asm/mach/pci.h
> > > linux-2.6.37.y/arch/unicore32/include/asm/mach/pci.h
> > > > --- linux-2.6.37-rc1/arch/unicore32/include/asm/mach/pci.h
1970-
> 01-01
> > > 08:00:00.000000000 +0800
> > > > +++ linux-2.6.37.y/arch/unicore32/include/asm/mach/pci.h
2010-
> 11-08
> > > 17:46:49.475569661 +0800
> > > > @@ -0,0 +1,65 @@
> > > > +/*
> > > > + * linux/arch/unicore32/include/asm/mach/pci.h
> > > > +
> > > > +struct hw_pci {
> > > > +#ifdef CONFIG_PCI_DOMAINS
> > > > +	int		domain;
> > > > +#endif
> > > > +	struct list_head buses;
> > > > +	int		nr_controllers;
> > > > +	int		(*setup)(int nr, struct pci_sys_data *);
> > > > +	struct pci_bus *(*scan)(int nr, struct pci_sys_data *);
> > > > +	void		(*preinit)(void);
> > > > +	void		(*postinit)(void);
> > > > +	u8		(*swizzle)(struct pci_dev *dev, u8 *pin);
> > > > +	int		(*map_irq)(struct pci_dev *dev, u8 slot, u8
pin);
> > > > +};
> > > > +
> > > > +/*
> > > > + * Per-controller structure
> > > > + */
> > > > +struct pci_sys_data {
> > > > +#ifdef CONFIG_PCI_DOMAINS
> > > > +	int		domain;
> > > > +#endif
> > > > +	struct list_head node;
> > > > +	int		busnr;		/* primary bus number
*/
> > > > +	u64		mem_offset;	/* bus->cpu memory mapping
offset
> */
> > > > +	unsigned long	io_offset;	/* bus->cpu IO mapping
offset	  */
> > > > +	struct pci_bus	*bus;		/* PCI bus
*/
> > > > +	struct resource *resource[3];	/* Primary PCI bus resources
*/
> > > > +					/* Bridge swizzling
*/
> > > > +	u8		(*swizzle)(struct pci_dev *, u8 *);
> > > > +					/* IRQ mapping
> 	  */
> > > > +	int		(*map_irq)(struct pci_dev *, u8, u8);
> > > > +	struct hw_pci	*hw;
> > > > +	void		*private_data;	/* platform controller
private data
> > */
> > > > +};
> > >
> > > These are two separate abstractions for multiple PCI controllers,
> > > but your code does not even contain one implementation.
> > >
> > > I can only assume that you actually have a PCI implementation, but
> > > if you do not have more than one, you are better off implementing
> > > just the one you have instead of extra wrappers.
> > [Guan] we do have pci bus and pci driver. I have to implement these
> > interface for pci compatibility.
> 
> Ok. I would put the actual PCI implementation into the architecture patch
> series then, but get rid of the indirect function pointers.
> 
> Do you support multiple PCI domains (root bridges)?
No.

> > > > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> > > linux-2.6.37-rc1/arch/unicore32/include/asm/mach/time.h
> > > linux-2.6.37.y/arch/unicore32/include/asm/mach/time.h
> > > > --- linux-2.6.37-rc1/arch/unicore32/include/asm/mach/time.h
1970-
> 01-01
> > > 08:00:00.000000000 +0800
> > > > +++ linux-2.6.37.y/arch/unicore32/include/asm/mach/time.h
2010-
> 11-08
> > > 17:48:06.111456784 +0800
> > > > @@ -0,0 +1,52 @@
> > > > +/*
> > > > + * linux/arch/unicore32/include/asm/mach/time.h
> > >
> > > Can be removed when you get rid of the machine_desc abstraction.
> > [Guan] sys_timer can't be removed, which is used for device register.
> 
> I don't understand. I can only see one sys_timer instance, the puv3_timer,
so
> you can just as well hardcode access to that.
Removed.
 
> > > > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> > > linux-2.6.37-rc1/arch/unicore32/include/asm/memblock.h
> > > linux-2.6.37.y/arch/unicore32/include/asm/memblock.h
> > > > --- linux-2.6.37-rc1/arch/unicore32/include/asm/memblock.h
1970-
> 01-01
> > > 08:00:00.000000000 +0800
> > > > +++ linux-2.6.37.y/arch/unicore32/include/asm/memblock.h
2010-
> 11-10
> > > 18:59:14.326006751 +0800
> > > > @@ -0,0 +1,22 @@
> > > > +/*
> > > > + * linux/arch/unicore32/include/asm/memblock.h
> > >
> > > This too.
> > [Guan] we use memblock as infrastructure, and perhaps it's not good.
> 
> No, there is nothing wrong with memblock.
> 
> My point was that the indirect function calls through machine_desc that
you
> use here are not needed.
> 
> I would also recommend using only memblock and not also bootmem, by
> unconditionally setting CONFIG_NO_BOOTMEM.
I will consider it later.
 
> 
> > > > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> > > linux-2.6.37-rc1/arch/unicore32/include/asm/swab.h
> > > linux-2.6.37.y/arch/unicore32/include/asm/swab.h
> > > > +#ifndef __UNICORE_SWAB_H__
> > > > +#define __UNICORE_SWAB_H__
> > > > +
> > > > +#include <linux/compiler.h>
> > > > +#include <linux/types.h>
> > > > +
> > > > +#if !defined(__STRICT_ANSI__) || defined(__KERNEL__) #  define
> > > > +__SWAB_64_THRU_32__ #endif
> > > > +
> > > > +static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
> > >
> > > Can't you use the __builtin_bswap32/__builtin_bswap64 provided by gcc?
> > [Guan] __bswapsi2 is in libgcc, which is needed by __builtin_bswap32.
> 
> You could link against libgcc, see arch/tile/Makefile for an example how
to do
> that.
Yes, it works. I think it's not a good idea. Kernel should be independent on
libgcc.

> > > > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> > > linux-2.6.37-rc1/arch/unicore32/include/asm/uaccess.h
> > > linux-2.6.37.y/arch/unicore32/include/asm/uaccess.h
> > > > --- linux-2.6.37-rc1/arch/unicore32/include/asm/uaccess.h
1970-
> 01-01
> > > 08:00:00.000000000 +0800
> > > > +++ linux-2.6.37.y/arch/unicore32/include/asm/uaccess.h	2010-
> 11-09
> > > 11:33:30.209566466 +0800
> > > > @@ -0,0 +1,408 @@
> > > > +/*
> > > > + * linux/arch/unicore32/include/asm/uaccess.h
> > >
> > > Please have another look at the asm-generic version of this file.
> > > With the current version it may be useful to base on that.
> > [Guan] __copy_from_user and __copy_to_user is too expensive for 1/2/4
> words.
> 
> The asm-generic version of __copy_from_user/__copy_to_user uses
> __builtin_constant_p() to optimize away all this overhead at build time,
so
> even a copy_to_user(dst, src, 4) gets turned into a very small number of
> instructions.
> 
> This should work for both cases: when called with a constant size and when
> called from get_user/put_user.
> 
> I suppose you can do the same thing in your code.
Ok, I will do this work later.

> 
> > > > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> > > linux-2.6.37-rc1/arch/unicore32/include/asm/unistd.h
> > > linux-2.6.37.y/arch/unicore32/include/asm/unistd.h
> > > > --- linux-2.6.37-rc1/arch/unicore32/include/asm/unistd.h
1970-01-01
> > > 08:00:00.000000000 +0800
> > > > +++ linux-2.6.37.y/arch/unicore32/include/asm/unistd.h	2010-11-11
> > > 10:47:36.743710466 +0800
> > >
> > > Please use the cleaned-up asm-generic version as arch/tile does now.
> > > You add a lot of overhead otherwise.
> > [Guan] we use __NR_* as the immediate number in soft-interrupt
> instruction.
> >      And if the syscall number changed, all software and toolchain
> > need re-compiled.
> 
> Yes, I realize that. I think it would be very hard to integrate your
architecture
> code without breaking compatibility, but breaking it once in order to fix
all
> the problems arising from your backwards-compatibility code will make your
> life much easier in the long run.
> 
> One possible way to do the migration would be to do the upstream
> integration using only the new ABI, but keep a private patch that reverts
to
> the existing ABI. At some point in the future, you can then declare the
old
> ABI obsolete and drop the patch, supporting only the new ABI.
Good. We will just do the new ABI work recently, and it's a great idea.

> 
> > > > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> > > linux-2.6.37-rc1/arch/unicore32/Kconfig
> > linux-2.6.37.y/arch/unicore32/Kconfig
> > > > --- linux-2.6.37-rc1/arch/unicore32/Kconfig	1970-01-01
> > 08:00:00.000000000
> > > +0800
> > > > +++ linux-2.6.37.y/arch/unicore32/Kconfig	2010-11-11
> > 10:40:02.001225028
> > > +0800
> > > > @@ -0,0 +1,337 @@
> > > > +	config ARCH_PUV3
> > > > +	bool "PKUnity v3 (SuperK)"
> > > > +	select CPU_UCV2
> > > > +	select PKUNITY_AMBA
> > > > +	select ZONE_DMA
> > > > +	select EMBEDDED
> > > > +	select GENERIC_CLOCKEVENTS
> > > > +	select HAVE_CLK
> > > > +	select ARCH_USES_GETTIMEOFFSET
> > > > +	select ARCH_REQUIRE_GPIOLIB
> > > > +	select ARCH_HAS_CPUFREQ
> > >
> > > You might not want to select ZONE_DMA and
> ARCH_USES_GETTIMEOFFSET,
> > > since you are generally better off without them.
> > [Guan] We need ZONE_DMA for only 128M low memory could be used for
> DMA.
> 
> Ok. Is this only for some device drivers, or is this a general limitation?
The ZONE_DMA only limits pci devices, not a general limitation.
However, many chips could be connected to different bus, 
so this limit influences global in our architecture.

Guan Xuetao


