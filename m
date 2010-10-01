Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0JAIni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 04:43:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0JAInh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 04:43:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: ioremap definition in generic io.h
Date: Fri, 1 Oct 2010 10:43:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1285747145.12259.3.camel@needafix> <201009301404.36551.arnd@arndb.de> <1285922150.2639.37.camel@needafix>
In-Reply-To: <1285922150.2639.37.camel@needafix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010011043.32489.arnd@arndb.de>
X-Provags-ID: V02:K0:Qb/T48v1laMQxE/Y1Of0c1L6ELXLfNFb6FqZMLIJvDV
 OOvyD408BkCpDW1ChsEQ/7AvfDQhWyHLVHgOsizGbGxrDrZBdS
 kXn2Ba3XCAmwKcuc7KRlhBOLpB1zbaiCCYC/rtjB+hLby6ruqq
 0E0tmp6fgBAxPjJA/cBTfjRPdIdZ+TSUgxFXqypIJc17Kae95I
 0bCRc7HR+ijuLw3Jb3Xtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 October 2010 10:35:50 Jonas Bonn wrote:
> > We have the __raw_readl()/__raw_writel() functions which are defined as
> > host-endian, but I would not recommend using them in general because they
> > also mean slightly different things depending on the architecture.
> 
> OK, I'm curious what you mean here... I would have thought that wrapping
> our own functions around these would have been the right way to do
> things.  What subtleties exist here that I would need to look out for?

The most common problem is synchronization. On architectures with out of order
I/O, you want the accessor functions to provide serialization against each
other and against spinlocks. The __raw_* versions are typically completely
unordered.

I would expect that most architectures with a simple I/O model like
microblaze don't have this problem though because the access is always
serialized with  the instructions around it.

> > 
> > #ifdef CONFIG_PLB_BIG_ENDIAN
> > #define plb_ioread32(p) ioread32be(p)
> > #define plb_iowrite32(p) iowrite32be(p)
> > #else
> > #define plb_ioread32(p) ioread32(p)
> > #define plb_iowrite32(p) iowrite32(p)
> > #endif
> 
> This seems like a reasonable approach.  What got me looking at all of
> this was that I wanted to use asm-generic/io.h for our architecture, and
> it's mostly OK except for the definition of ioremap which implies NOMMU.
> Wouldn't it make sense to drop the ioremap definitions from this file,
> thus allowing it to be used by archictectures with MMU?  Or do you know
> of something more in this file which prohibits it from being used more
> "generically"?

The file is certainly meant to be as generic as possible, I just didn't
consider MMU based architectures with strictly ordered I/O yet.
I would suggest the patch below to let you override the defaults.

	Arnd

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 118601f..aaa5fac 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -247,12 +247,16 @@ static inline void *phys_to_virt(unsigned long address)
 /*
  * Change "struct page" to physical address.
  */
+#ifndef ioremap
 static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 {
 	return (void __iomem*) (unsigned long)offset;
 }
+#endif
 
+#ifndef __ioremap
 #define __ioremap(offset, size, flags)	ioremap(offset, size)
+#endif
 
 #ifndef ioremap_nocache
 #define ioremap_nocache ioremap
@@ -262,9 +266,11 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 #define ioremap_wc ioremap_nocache
 #endif
 
+#ifndef iounmap
 static inline void iounmap(void *addr)
 {
 }
+#endif
 
 #ifndef CONFIG_GENERIC_IOMAP
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
