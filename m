Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1B0EqN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:46:13 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:59056 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1B0EqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:46:11 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <02ed01cbcb48$3e3781a0$baa684e0$@mprc.pku.edu.cn> <201102171828.15482.arnd@arndb.de> <018a01cbd29b$1ff4c590$5fde50b0$@mprc.pku.edu.cn> <201102221618.56779.arnd@arndb.de>
In-Reply-To: <201102221618.56779.arnd@arndb.de>
Subject: RE: [PATCHv2 06/11] unicore32 core architecture: mm related: generic codes
Date: Sun, 27 Feb 2011 12:46:01 +0800
Message-ID: <018101cbd639$3c639430$b52abc90$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFzBjIBRnYbotNL7Xe3f7gpXcNfFQFYVyKIAr4MZq4DMT6SupSMKDNQ
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, February 22, 2011 11:19 PM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCHv2 06/11] unicore32 core architecture: mm related: generic codes
> 
> On Tuesday 22 February 2011, Guan Xuetao wrote:
> > > > +#ifdef __io
> > > > +void __iomem *ioport_map(unsigned long port, unsigned int nr)
> > > > +{
> > > > +       /* we map PC lagcy 64K IO port to PCI IO space 0x80030000 */
> > > > +       return (void __iomem *) (unsigned long)
> > > > +                       io_p2v((port & 0xffff) + PKUNITY_PCILIO_BASE);
> > > > +}
> > >
> > > Interestingly, this function looks completely correct, but I don't see
> > > the definition for __io, so I suspect that the function is not actually
> > > getting used.
> > When I want to use pci device driver,  I will define __io and use ioport_map for drivers.
> > It is obviously a trick.
> 
> Ok, I see.
> 
> > And with your patch for asm-generic/io.h, these codes could be removed.
> 
> You'd still need to define ioport_map, but the definition could simply
> become
> 
> static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
> {
> 	return PCIO_BASE + port;
> }
> 
> 	Arnd
I have a look to lib/iomap.c, and it is suitable for unicore32.
So please see following patch:

From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sun, 27 Feb 2011 12:46:06 +0800
Subject: [PATCH] unicore32: replace unicore32-specific iomap functions with generic lib implementation

1. define and enable CONFIG_GENERIC_IOMAP
2. define unicore32-specific PCI_IOBASE for asm-generic/io.h
3. define HAVE_ARCH_PIO_SIZE and unicore32-specific PIO_* macros
4. remove all unicore32-specific iomap functions

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig          |    3 ++
 arch/unicore32/include/asm/io.h |    9 ++++--
 arch/unicore32/mm/Makefile      |    2 +-
 arch/unicore32/mm/iomap.c       |   56 ---------------------------------------
 4 files changed, 10 insertions(+), 60 deletions(-)
 delete mode 100644 arch/unicore32/mm/iomap.c

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 7f65018..4a36db4 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -30,6 +30,9 @@ config GENERIC_CLOCKEVENTS
 config GENERIC_CSUM
 	def_bool y
 
+config GENERIC_IOMAP
+	def_bool y
+
 config NO_IOPORT
 	bool
 
diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
index d73457c..2483fcb 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -18,6 +18,7 @@
 #include <asm/memory.h>
 #include <asm/system.h>
 
+#define PCI_IOBASE	io_p2v(PKUNITY_PCILIO_BASE)
 #include <asm-generic/io.h>
 
 /*
@@ -38,9 +39,6 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
 #define ioremap_cached(cookie, size)	__uc32_ioremap_cached(cookie, size)
 #define iounmap(cookie)			__uc32_iounmap(cookie)
 
-extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
-extern void ioport_unmap(void __iomem *addr);
-
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
@@ -48,5 +46,10 @@ extern void ioport_unmap(void __iomem *addr);
 #undef xlate_dev_mem_ptr
 #define xlate_dev_mem_ptr(p)	__va(p)
 
+#define HAVE_ARCH_PIO_SIZE
+#define PIO_OFFSET		(unsigned int)(PCI_IOBASE)
+#define PIO_MASK		(unsigned int)(IO_SPACE_LIMIT)
+#define PIO_RESERVED		(PIO_OFFSET + PIO_MASK + 1)
+
 #endif	/* __KERNEL__ */
 #endif	/* __UNICORE_IO_H__ */
diff --git a/arch/unicore32/mm/Makefile b/arch/unicore32/mm/Makefile
index f3ff410..46c1666 100644
--- a/arch/unicore32/mm/Makefile
+++ b/arch/unicore32/mm/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y				:= extable.o fault.o init.o pgd.o mmu.o
-obj-y				+= iomap.o flush.o ioremap.o
+obj-y				+= flush.o ioremap.o
 
 obj-$(CONFIG_SWIOTLB)		+= dma-swiotlb.o
 
diff --git a/arch/unicore32/mm/iomap.c b/arch/unicore32/mm/iomap.c
deleted file mode 100644
index a7e1a3d..0000000
--- a/arch/unicore32/mm/iomap.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * linux/arch/unicore32/mm/iomap.c
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- * Copyright (C) 2001-2010 GUAN Xue-tao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Map IO port and PCI memory spaces so that {read,write}[bwl] can
- * be used to access this memory.
- */
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/ioport.h>
-#include <linux/io.h>
-
-#ifdef __io
-void __iomem *ioport_map(unsigned long port, unsigned int nr)
-{
-	/* we map PC lagcy 64K IO port to PCI IO space 0x80030000 */
-	return (void __iomem *) (unsigned long)
-			io_p2v((port & 0xffff) + PKUNITY_PCILIO_BASE);
-}
-EXPORT_SYMBOL(ioport_map);
-
-void ioport_unmap(void __iomem *addr)
-{
-}
-EXPORT_SYMBOL(ioport_unmap);
-#endif
-
-#ifdef CONFIG_PCI
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len   = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
-
-	if (!len || !start)
-		return NULL;
-	if (maxlen && len > maxlen)
-		len = maxlen;
-	if (flags & IORESOURCE_IO)
-		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM) {
-		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
-		return ioremap_nocache(start, len);
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(pci_iomap);
-#endif
-- 
1.6.2.2


