Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1BQRAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:00:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1BQRA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:00:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 09/12] unicore32 machine related files: hardware registers
Date: Thu, 17 Feb 2011 17:59:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn>
In-Reply-To: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171759.45365.arnd@arndb.de>
X-Provags-ID: V02:K0:e0xQt9uz0Nb5z+CCwbH35UZe44YAber2um+A2cKBOPH
 RV6AKeTH6tXuFOjTP4IdU20vQr9wuO1ISrWndj5cdasovrmvU6
 xYDX3Gypr8gXyepyyye4xQcSw8Lykxm7EzB7OmT0C8B29V6Cmk
 T70pj+w134xMGDR2C3pAVEVMh3p2kpcHLG9c5/HxTJzX0upBNM
 dv3O2WnYllofD4cXrviEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 February 2011, Guan Xuetao wrote:
> +#define io_p2v(x)      ((x) - PKUNITY_IOSPACE_BASE)
> +#define io_v2p(x)      ((x) + PKUNITY_IOSPACE_BASE)
> +
> +#ifndef __ASSEMBLY__
> +
> +# define __REG(x)      (*((volatile unsigned long *)io_p2v(x)))
> +# define __PREG(x)     (io_v2p((unsigned long)&(x)))
> +
> +#else
> +
> +# define __REG(x)      io_p2v(x)
> +# define __PREG(x)     io_v2p(x)

> #define PKUNITY_IOSPACE_BASE            0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */

The typecasts look wrong here: 

- "volatile unsigned long*" is not the right pointer type to do I/O on. It
  should instead be "void __iomem *". Please use the "sparse" tool with "make C=1"
  to get warnings about incorrect pointer type accesses.

- PKUNITY_IOSPACE_BASE seems to be both a virtual and a physical address, which
  is a bad idea, because it prevents a lot of the checks from working correctly.

- The __REG/__PREG macros seem to have the same purpose as io_p2v/io_v2p, you
  should not require both.

- The term IOSPACE is confusing, because it normally refers to the PCI PIO
  space, while you mean the SoC's MMIO region

I would recommend defining these as

#ifndef __ASSEMBLY__
#define PKUNITY_MMIO_VIRT ((void __iomem *)0x80000000)
#else
#define PKUNITY_MMIO_VIRT 0x80000000
#endif

#define io_p2v(x)	((x) - PKUNITY_MMIO_VIRT)
#define io_v2p(x)	((x) + PKUNITY_MMIO_VIRT)

/* please remove the two macros below as soon as all users are changed to use io_p2v */
#define __REG(x) io_p2v(x)
#define __PREG(x) io_v2p(x)

	Arnd

