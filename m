Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1BRJw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:52:29 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57105 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab1BRJwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:52:23 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn> <201102171759.45365.arnd@arndb.de>
In-Reply-To: <201102171759.45365.arnd@arndb.de>
Subject: RE: [PATCH 09/12] unicore32 machine related files: hardware registers
Date: Fri, 18 Feb 2011 17:52:12 +0800
Message-ID: <00e901cbcf51$8507c290$8f1747b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQI7nX5Jqof63rCNDjlwJwGIbqva+gG3KFhgkxl5zWA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 18, 2011 1:00 AM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCH 09/12] unicore32 machine related files: hardware registers
> 
> On Wednesday 16 February 2011, Guan Xuetao wrote:
> > +#define io_p2v(x)      ((x) - PKUNITY_IOSPACE_BASE)
> > +#define io_v2p(x)      ((x) + PKUNITY_IOSPACE_BASE)
> > +
> > +#ifndef __ASSEMBLY__
> > +
> > +# define __REG(x)      (*((volatile unsigned long *)io_p2v(x)))
> > +# define __PREG(x)     (io_v2p((unsigned long)&(x)))
> > +
> > +#else
> > +
> > +# define __REG(x)      io_p2v(x)
> > +# define __PREG(x)     io_v2p(x)
> 
> > #define PKUNITY_IOSPACE_BASE            0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
> 
> The typecasts look wrong here:
> 
> - "volatile unsigned long*" is not the right pointer type to do I/O on. It
>   should instead be "void __iomem *". Please use the "sparse" tool with "make C=1"
>   to get warnings about incorrect pointer type accesses.
__REG() macro could be used in both left and right sides of assignment sentence.
This idea is borrowed from arm/sa1100.
When used in left side, __REG is a register port, and when used in right side, 
__REG is just the value of the register.
It is a trick, but very useful. I'd like to remain the macros.

> 
> - PKUNITY_IOSPACE_BASE seems to be both a virtual and a physical address, which
>   is a bad idea, because it prevents a lot of the checks from working correctly.
PKUNITY_IOSPACE_BASE is only used  for physical-virtual address transformation.
(void *) prefix will introduce type cast error.
In addition,  in unicore32, io space and memory space are all in the same 4G address space,
but only different in address range.

> 
> - The __REG/__PREG macros seem to have the same purpose as io_p2v/io_v2p, you
>   should not require both.
> 
> - The term IOSPACE is confusing, because it normally refers to the PCI PIO
>   space, while you mean the SoC's MMIO region
Ok, renamed to PKUNITY_MMIO_BASE.
> 
> I would recommend defining these as
> 
> #ifndef __ASSEMBLY__
> #define PKUNITY_MMIO_VIRT ((void __iomem *)0x80000000)
> #else
> #define PKUNITY_MMIO_VIRT 0x80000000
> #endif
> 
> #define io_p2v(x)	((x) - PKUNITY_MMIO_VIRT)
> #define io_v2p(x)	((x) + PKUNITY_MMIO_VIRT)
> 
> /* please remove the two macros below as soon as all users are changed to use io_p2v */
> #define __REG(x) io_p2v(x)
> #define __PREG(x) io_v2p(x)
For the reason above, I can only apply the patch as following:

From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Fri, 18 Feb 2011 18:05:23 +0800
Subject: [PATCH] unicore32: rename PKUNITY_IOSPACE_BASE to PKUNITY_MMIO_BASE
   for the term IOSPACE normally refers to the PCI PIO space,
   and remove unused __REG/__PREG macros when __ASSEMBLY__ defined
   -- by advice with Arnd Bergmann

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/mach/PKUnity.h  |    2 +-
 arch/unicore32/include/mach/hardware.h |    9 ++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/unicore32/include/mach/PKUnity.h b/arch/unicore32/include/mach/PKUnity.h
index 1e13208..39f27f4 100644
--- a/arch/unicore32/include/mach/PKUnity.h
+++ b/arch/unicore32/include/mach/PKUnity.h
@@ -21,7 +21,7 @@
  * Memory Definitions
  */
 #define PKUNITY_SDRAM_BASE		0x00000000 /* 0x00000000 - 0x7FFFFFFF 2GB */
-#define PKUNITY_IOSPACE_BASE            0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
+#define PKUNITY_MMIO_BASE		0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
 #define PKUNITY_PCI_BASE		0x80000000 /* 0x80000000 - 0xBFFFFFFF 1GB */
 #include "regs-pci.h"
 #define PKUNITY_BOOT_ROM2_BASE		0xF4000000 /* 0xF4000000 - 0xF7FFFFFF 64MB */
diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
index 3fb7236..ebce7de 100644
--- a/arch/unicore32/include/mach/hardware.h
+++ b/arch/unicore32/include/mach/hardware.h
@@ -17,19 +17,14 @@
 
 #include "PKUnity.h"
 
-#define io_p2v(x)	((x) - PKUNITY_IOSPACE_BASE)
-#define io_v2p(x)	((x) + PKUNITY_IOSPACE_BASE)
+#define io_p2v(x)	((x) - PKUNITY_MMIO_BASE)
+#define io_v2p(x)	((x) + PKUNITY_MMIO_BASE)
 
 #ifndef __ASSEMBLY__
 
 # define __REG(x)	(*((volatile unsigned long *)io_p2v(x)))
 # define __PREG(x)	(io_v2p((unsigned long)&(x)))
 
-#else
-
-# define __REG(x)	io_p2v(x)
-# define __PREG(x)	io_v2p(x)
-
 #endif
 
 #define PCIBIOS_MIN_IO			0x4000 /* should lower than 64KB */
-- 
1.6.2.2

> 
> 	Arnd

Thanks & Regards.

Guan Xuetao

