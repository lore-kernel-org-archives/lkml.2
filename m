Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab1B0DfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 22:35:19 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:48660 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab1B0DfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 22:35:17 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn> <201102221519.03423.arnd@arndb.de> <010f01cbd5b0$09980830$1cc81890$@mprc.pku.edu.cn> <201102261416.10050.arnd@arndb.de>
In-Reply-To: <201102261416.10050.arnd@arndb.de>
Subject: RE: [PATCH 09/12] unicore32 machine related files: hardware registers
Date: Sun, 27 Feb 2011 11:35:05 +0800
Message-ID: <017d01cbd62f$53af8590$fb0e90b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQI7nX5Jqof63rCNDjlwJwGIbqva+gJhTbw9Ag0f/DgB2uCytJMC2LSA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Saturday, February 26, 2011 9:16 PM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCH 09/12] unicore32 machine related files: hardware registers
> 
> On Saturday 26 February 2011, Guan Xuetao wrote:
> > > >  #ifndef __ASSEMBLY__
> > > >
> > > > -# define __REG(x)      (*((volatile unsigned long *)io_p2v(x)))
> > > > -# define __PREG(x)     (io_v2p((unsigned long)&(x)))
> > > > +# define __REG(x)      (void __iomem *)io_p2v(x)
> > >
> > > The patch looks correct, but if you make the the definition for
> > > PKUNITY_MMIO_BASE contain the cast to (void __iomem *), you no
> > > longer need another cast.
> >
> > Because the io_p2v(x) calculate x and PKUNITY_IOSPACE_BASE,
> > all registers should be added with (void __iomem *).
> > So I prefer to remain the previous patch.
> 
> The problem with the definition of io_p2v is that it gives you
> an type that is impossible to use correctly, except in assembly
> code. Linux assumes that MMIO registers in virtual space
> are __iomem pointers, and we like that to be consistent.
> 
> If you have a function that returns a virtual address, it should
> really have the same type as any other function that uses a virtual
> address.
Ok, I see.
Please see following patch, __REG removed and __iomem added to io_p2v:

diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
index b71405a..b197b0b 100644
--- a/arch/unicore32/include/mach/hardware.h
+++ b/arch/unicore32/include/mach/hardware.h
@@ -17,13 +17,10 @@
 
 #include "PKUnity.h"
 
-#define io_p2v(x)	((x) - PKUNITY_MMIO_BASE)
-#define io_v2p(x)	((x) + PKUNITY_MMIO_BASE)
-
 #ifndef __ASSEMBLY__
-
-# define __REG(x)	(void __iomem *)io_p2v(x)
-
+#define io_p2v(x)	(void __iomem *)((x) - PKUNITY_MMIO_BASE)
+#else
+#define io_p2v(x)	((x) - PKUNITY_MMIO_BASE)
 #endif
 
 #define PCIBIOS_MIN_IO			0x4000 /* should lower than 64KB */
> 
> 	Arnd
Thanks & Regards.
Guan Xuetao

