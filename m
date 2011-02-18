Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab1BRKms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:42:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50541 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1BRKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:42:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 09/12] unicore32 machine related files: hardware registers
Date: Fri, 18 Feb 2011 11:42:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn> <201102171759.45365.arnd@arndb.de> <00e901cbcf51$8507c290$8f1747b0$@mprc.pku.edu.cn>
In-Reply-To: <00e901cbcf51$8507c290$8f1747b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181142.42614.arnd@arndb.de>
X-Provags-ID: V02:K0:b4jKJ/daw4c3yISYbw0oAttfI4gxQC1oGuhOipLYeyd
 V6c7b+rhbbLLQi9C9bbyuqSg/oE9675Vha/H5+O7WAMY/AE31a
 b8GlMNu/EGh7+k7niW+EYsJ9WzKsdchbkRpiAm0mkj3jcSJKT4
 vZDGNYa/XT/8xNbmOK1PdDPLIT1ATf7L90xAQJeZD1+UfjpXVZ
 mlW8tn1KL6CoIsDyveTNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 February 2011 10:52:12 Guan Xuetao wrote:

> > On Wednesday 16 February 2011, Guan Xuetao wrote:
> > > +#define io_p2v(x)      ((x) - PKUNITY_IOSPACE_BASE)
> > > +#define io_v2p(x)      ((x) + PKUNITY_IOSPACE_BASE)
> > > +
> > > +#ifndef __ASSEMBLY__
> > > +
> > > +# define __REG(x)      (*((volatile unsigned long *)io_p2v(x)))
> > > +# define __PREG(x)     (io_v2p((unsigned long)&(x)))
> > > +
> > > +#else
> > > +
> > > +# define __REG(x)      io_p2v(x)
> > > +# define __PREG(x)     io_v2p(x)
> > 
> > > #define PKUNITY_IOSPACE_BASE            0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
> > 
> > The typecasts look wrong here:
> > 
> > - "volatile unsigned long*" is not the right pointer type to do I/O on. It
> >   should instead be "void __iomem *". Please use the "sparse" tool with "make C=1"
> >   to get warnings about incorrect pointer type accesses.
> __REG() macro could be used in both left and right sides of assignment sentence.
> This idea is borrowed from arm/sa1100.
>
> When used in left side, __REG is a register port, and when used in right side, 
> __REG is just the value of the register.
> It is a trick, but very useful. I'd like to remain the macros.
 
Ok, I didn't realize this. However, this is a really bad idea
and I would strongly advise removing this throughout the code.

The only way we do MMIO accesses in Linux is through the
readl()/writel() functions. On many architectures, these
contain more than just a pointer dereference, and if you
need that, you can change it in just one place.

Things that can go wrong with volatile pointer dereferences include:

* compiler turns 32 bit access into four 8-bit accesses
* I/O bus reorders access and it moves outside of a spinlock
* non-volatile accesses to system RAM get reordered around
  MMIO access, which may break if the MMIO triggers a DMA.

> diff --git a/arch/unicore32/include/mach/PKUnity.h b/arch/unicore32/include/mach/PKUnity.h
> index 1e13208..39f27f4 100644
> --- a/arch/unicore32/include/mach/PKUnity.h
> +++ b/arch/unicore32/include/mach/PKUnity.h
> @@ -21,7 +21,7 @@
>   * Memory Definitions
>   */
>  #define PKUNITY_SDRAM_BASE		0x00000000 /* 0x00000000 - 0x7FFFFFFF 2GB */
> -#define PKUNITY_IOSPACE_BASE            0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
> +#define PKUNITY_MMIO_BASE		0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
>  #define PKUNITY_PCI_BASE		0x80000000 /* 0x80000000 - 0xBFFFFFFF 1GB */
>  #include "regs-pci.h"
>  #define PKUNITY_BOOT_ROM2_BASE		0xF4000000 /* 0xF4000000 - 0xF7FFFFFF 64MB */

This change is ok.

> diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
> index 3fb7236..ebce7de 100644
> --- a/arch/unicore32/include/mach/hardware.h
> +++ b/arch/unicore32/include/mach/hardware.h
> @@ -17,19 +17,14 @@
>  
>  #include "PKUnity.h"
>  
> -#define io_p2v(x)	((x) - PKUNITY_IOSPACE_BASE)
> -#define io_v2p(x)	((x) + PKUNITY_IOSPACE_BASE)
> +#define io_p2v(x)	((x) - PKUNITY_MMIO_BASE)
> +#define io_v2p(x)	((x) + PKUNITY_MMIO_BASE)
>
>  #ifndef __ASSEMBLY__

The result of io_p2v really needs to be a (void __iomem *) pointer, not
an integer, so the accesses can work.

>  # define __REG(x)	(*((volatile unsigned long *)io_p2v(x)))
>  # define __PREG(x)	(io_v2p((unsigned long)&(x)))

And as explained, these should be removed and all users converted to
use readl()/writel().

	Arnd
