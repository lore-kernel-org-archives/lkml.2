Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1BVOJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:09:21 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:49992 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1BVOJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:09:18 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn> <201102171759.45365.arnd@arndb.de> <00e901cbcf51$8507c290$8f1747b0$@mprc.pku.edu.cn> <201102181142.42614.arnd@arndb.de>
In-Reply-To: <201102181142.42614.arnd@arndb.de>
Subject: RE: [PATCH 09/12] unicore32 machine related files: hardware registers
Date: Tue, 22 Feb 2011 22:09:05 +0800
Message-ID: <018601cbd29a$118b27c0$34a17740$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQI7nX5Jqof63rCNDjlwJwGIbqva+gG3KFhgArBYRcsBbmW5qpL/R/tg
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 18, 2011 6:43 PM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCH 09/12] unicore32 machine related files: hardware registers
> 
> On Friday 18 February 2011 10:52:12 Guan Xuetao wrote:
> 
> > > On Wednesday 16 February 2011, Guan Xuetao wrote:
> > > > +#define io_p2v(x)      ((x) - PKUNITY_IOSPACE_BASE)
> > > > +#define io_v2p(x)      ((x) + PKUNITY_IOSPACE_BASE)
> > > > +
> > > > +#ifndef __ASSEMBLY__
> > > > +
> > > > +# define __REG(x)      (*((volatile unsigned long *)io_p2v(x)))
> > > > +# define __PREG(x)     (io_v2p((unsigned long)&(x)))
> > > > +
> > > > +#else
> > > > +
> > > > +# define __REG(x)      io_p2v(x)
> > > > +# define __PREG(x)     io_v2p(x)
> > >
> > > > #define PKUNITY_IOSPACE_BASE            0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
> > >
> > > The typecasts look wrong here:
> > >
> > > - "volatile unsigned long*" is not the right pointer type to do I/O on. It
> > >   should instead be "void __iomem *". Please use the "sparse" tool with "make C=1"
> > >   to get warnings about incorrect pointer type accesses.
> > __REG() macro could be used in both left and right sides of assignment sentence.
> > This idea is borrowed from arm/sa1100.
> >
> > When used in left side, __REG is a register port, and when used in right side,
> > __REG is just the value of the register.
> > It is a trick, but very useful. I'd like to remain the macros.
> 
> Ok, I didn't realize this. However, this is a really bad idea
> and I would strongly advise removing this throughout the code.
> 
> The only way we do MMIO accesses in Linux is through the
> readl()/writel() functions. On many architectures, these
> contain more than just a pointer dereference, and if you
> need that, you can change it in just one place.
> 
> Things that can go wrong with volatile pointer dereferences include:
> 
> * compiler turns 32 bit access into four 8-bit accesses
> * I/O bus reorders access and it moves outside of a spinlock
> * non-volatile accesses to system RAM get reordered around
>   MMIO access, which may break if the MMIO triggers a DMA.
> 
> > diff --git a/arch/unicore32/include/mach/PKUnity.h b/arch/unicore32/include/mach/PKUnity.h
> > index 1e13208..39f27f4 100644
> > --- a/arch/unicore32/include/mach/PKUnity.h
> > +++ b/arch/unicore32/include/mach/PKUnity.h
> > @@ -21,7 +21,7 @@
> >   * Memory Definitions
> >   */
> >  #define PKUNITY_SDRAM_BASE		0x00000000 /* 0x00000000 - 0x7FFFFFFF 2GB */
> > -#define PKUNITY_IOSPACE_BASE            0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
> > +#define PKUNITY_MMIO_BASE		0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
> >  #define PKUNITY_PCI_BASE		0x80000000 /* 0x80000000 - 0xBFFFFFFF 1GB */
> >  #include "regs-pci.h"
> >  #define PKUNITY_BOOT_ROM2_BASE		0xF4000000 /* 0xF4000000 - 0xF7FFFFFF 64MB */
> 
> This change is ok.
> 
> > diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
> > index 3fb7236..ebce7de 100644
> > --- a/arch/unicore32/include/mach/hardware.h
> > +++ b/arch/unicore32/include/mach/hardware.h
> > @@ -17,19 +17,14 @@
> >
> >  #include "PKUnity.h"
> >
> > -#define io_p2v(x)	((x) - PKUNITY_IOSPACE_BASE)
> > -#define io_v2p(x)	((x) + PKUNITY_IOSPACE_BASE)
> > +#define io_p2v(x)	((x) - PKUNITY_MMIO_BASE)
> > +#define io_v2p(x)	((x) + PKUNITY_MMIO_BASE)
> >
> >  #ifndef __ASSEMBLY__
> 
> The result of io_p2v really needs to be a (void __iomem *) pointer, not
> an integer, so the accesses can work.
> 
> >  # define __REG(x)	(*((volatile unsigned long *)io_p2v(x)))
> >  # define __PREG(x)	(io_v2p((unsigned long)&(x)))
> 
> And as explained, these should be removed and all users converted to
> use readl()/writel().
I see.
I apply the patch as following:
arch/unicore32/include/mach/hardware.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
index ebce7de..b71405a 100644
--- a/arch/unicore32/include/mach/hardware.h
+++ b/arch/unicore32/include/mach/hardware.h
@@ -22,8 +22,7 @@
 
 #ifndef __ASSEMBLY__
 
-# define __REG(x)	(*((volatile unsigned long *)io_p2v(x)))
-# define __PREG(x)	(io_v2p((unsigned long)&(x)))
+# define __REG(x)	(void __iomem *)io_p2v(x)
 
 #endif

---
__REG reserved only for all registers prefix.
And all using for __REG converted to readl/writel.

> 
> 	Arnd

Thanks Arnd

Guan Xuetao

