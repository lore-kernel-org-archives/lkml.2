Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab1BQROr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:14:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab1BQROl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:14:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 06/12] unicore32 additional architecture files: low-level lib: misc
Date: Thu, 17 Feb 2011 18:14:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <014d01cbcdae$091bc6d0$1b535470$@mprc.pku.edu.cn>
In-Reply-To: <014d01cbcdae$091bc6d0$1b535470$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171814.29081.arnd@arndb.de>
X-Provags-ID: V02:K0:Rbk1+gVAa9ZIH4uxCx9vtla911T6JaTjpAN8+/n3Mu/
 HwIYm8zZyjqwVqMdEk7EWSSCjaHN+AGeSXQvGBbUdi7yDjvD8Q
 yIRMlnYkxuIoOrQ2kLcXAgaMVMVgxvG9zY6GdTC2LCUy47AGq7
 u2ZlY8TLaVTL61XAOgUQgM+3BBcfRwG490jesdmD8vjI3KTsgJ
 KuaC/jDekENALVOLVAYfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 February 2011, Guan Xuetao wrote:
> diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
> new file mode 100644
> index 0000000..d73457c
> --- /dev/null
> +++ b/arch/unicore32/include/asm/io.h
> @@ -0,0 +1,52 @@
> +/*
> + * linux/arch/unicore32/include/asm/io.h
> + *
> + * Code specific to PKUnity SoC and UniCore ISA
> + *
> + * Copyright (C) 2001-2010 GUAN Xue-tao
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __UNICORE_IO_H__
> +#define __UNICORE_IO_H__
> +
> +#ifdef __KERNEL__
> +
> +#include <asm/byteorder.h>
> +#include <asm/memory.h>
> +#include <asm/system.h>
> +
> +#include <asm-generic/io.h>
> +

I just realized that the generic io.h implementation is actually wrong here, because it does
not offset the PIO port numbers with the PCI I/O range. To get this right, you need
the patch below, and also need to define PCI_IOBASE appropriately.

	Arnd
8<-------
asm-generic: fix inX/outX functions for architectures that have PCI

The definitions for the PC-style PIO functions in asm-generic/io.h were
meant as dummies so you could compile code on architectures without
ISA and PCI buses. However, unicore32 actually wants to use them
with a real PCI bus, so they need to be defined to actually address
the register window holding the I/O ports.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 4644c9a..e0ffa3d 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -94,6 +94,10 @@ static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 #define writeq(b,addr) __raw_writeq(__cpu_to_le64(b),addr)
 #endif
 
+#ifndef PCI_IOBASE
+#define PCI_IOBASE ((void __iomem *) 0)
+#endif
+
 /*****************************************************************************/
 /*
  * traditional input/output functions
@@ -101,32 +105,32 @@ static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 
 static inline u8 inb(unsigned long addr)
 {
-	return readb((volatile void __iomem *) addr);
+	return readb(addr + PCI_IOBASE);
 }
 
 static inline u16 inw(unsigned long addr)
 {
-	return readw((volatile void __iomem *) addr);
+	return readw(addr + PCI_IOBASE);
 }
 
 static inline u32 inl(unsigned long addr)
 {
-	return readl((volatile void __iomem *) addr);
+	return readl(addr + PCI_IOBASE);
 }
 
 static inline void outb(u8 b, unsigned long addr)
 {
-	writeb(b, (volatile void __iomem *) addr);
+	writeb(b, addr + PCI_IOBASE);
 }
 
 static inline void outw(u16 b, unsigned long addr)
 {
-	writew(b, (volatile void __iomem *) addr);
+	writew(b, addr + PCI_IOBASE);
 }
 
 static inline void outl(u32 b, unsigned long addr)
 {
-	writel(b, (volatile void __iomem *) addr);
+	writel(b, addr + PCI_IOBASE);
 }
 
 #define inb_p(addr)	inb(addr)
@@ -213,32 +217,32 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 
 static inline void readsl(const void __iomem *addr, void *buf, int len)
 {
-	insl((unsigned long)addr, buf, len);
+	insl(addr - PCI_IOBASE, buf, len);
 }
 
 static inline void readsw(const void __iomem *addr, void *buf, int len)
 {
-	insw((unsigned long)addr, buf, len);
+	insw(addr - PCI_IOBASE, buf, len);
 }
 
 static inline void readsb(const void __iomem *addr, void *buf, int len)
 {
-	insb((unsigned long)addr, buf, len);
+	insb(addr - PCI_IOBASE, buf, len);
 }
 
 static inline void writesl(const void __iomem *addr, const void *buf, int len)
 {
-	outsl((unsigned long)addr, buf, len);
+	outsl(addr - PCI_IOBASE, buf, len);
 }
 
 static inline void writesw(const void __iomem *addr, const void *buf, int len)
 {
-	outsw((unsigned long)addr, buf, len);
+	outsw(addr - PCI_IOBASE, buf, len);
 }
 
 static inline void writesb(const void __iomem *addr, const void *buf, int len)
 {
-	outsb((unsigned long)addr, buf, len);
+	outsb(addr - PCI_IOBASE, buf, len);
 }
 
 #ifndef CONFIG_GENERIC_IOMAP
@@ -269,8 +273,9 @@ static inline void writesb(const void __iomem *addr, const void *buf, int len)
 	outsl((unsigned long) (p), (src), (count))
 #endif /* CONFIG_GENERIC_IOMAP */
 
-
-#define IO_SPACE_LIMIT 0xffffffff
+#ifndef IO_SPACE_LIMIT
+#define IO_SPACE_LIMIT 0xffff
+#endif
 
 #ifdef __KERNEL__
 
