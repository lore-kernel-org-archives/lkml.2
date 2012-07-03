Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab2GCNUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:20:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab2GCNT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:19:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Date: Tue, 3 Jul 2012 13:19:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
References: <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com> <20120701104401.GA4352@mail.gnudd.com> <20120703130042.GA10007@mail.gnudd.com>
In-Reply-To: <20120703130042.GA10007@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207031319.40884.arnd@arndb.de>
X-Provags-ID: V02:K0:H8jhjzVfpNAAsesByRWHd0Sj15cnWGLxv4cV0aLWWEO
 lXtqPfSJpRnK1H5XTl2ViKgEXqAFUZRN+ITY6y4BnYt+wxB3Az
 Hb2ywQUQMwVHcGYEOLdsrQh6MOhBgXSE9ujiAiAuviU3VFGGWL
 nThYzFYRUHk+Xfwbmranu7JHdFTfwp8WbPTDnnvcZsFdAKgOMd
 c5wx0yUI1xWUdyjg3DfA//O5WU+0gpUK/Noxew8OZKKaq5oqP1
 DOqSc14mmS1Q2LXF3tVsPTtM/EZjOKHSRrZzf0fRX81esjJZT2
 e97fRt+tq7gJ8AP+hL+cHaAxfn1q0Qr2mm8V30AJ4Atbz6Fgbk
 KQgQ4hPou15UxF6/DWjI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2012, Alessandro Rubini wrote:
> Peter Anvin:
> > There is no problem with adding ARM or !X86 dependencies to drivers
> > now and fixing them later or as required.
> 
> Ok. This is my summary of the compilation errors I have when
> enabling ARM_AMBA undex x86 and enabling everything that appears
> in "make oldconfig":
> 
> 
> This is a sum up of the errors in all driver that are
> enabled by telling "CONFIG_ARM_AMBA=y" in the x86 config.
> 
>    drivers/dma/pl330.c: register names conflict with arch symbols
>      proposed fix: use proper prefix names
> 
>    drivers/dma/amba-pl08x.c: needs <asm/hardware/pl080.h>
>      proposed fix: move pl080.h to include/linux

Note that there is already an include/linux/amba/pl08x.h.
I would just move the few parts of pl080.h that are actually
needed with global visibility there, and move the rest
to drivers/dma/.

>    drivers/gpio/gpio-pl061.c: uses chained_irq_enter/exit
>      proposed fix: depend on CONFIG_ARM (the function only exists in arm)
> 
>    drivers/mmc/host/mmci.c: uses <asm/sizes.h>
>    drivers/mmc/host/mmci.c: uses readsl/writesl
>      proposed fix: use linux/sizes.h and provide readsl/writesl like others do

Ack on the linux/sizes.h, that definitely makes sense.

I'm not sure I want to spread readsl/writesl beyond the architectures
that already have it. Maybe instead change the driver to use ioread32_rep,
which is already available on all architectures and is defined the
same way as readsl on ARM.

>    drivers/watchdog/sp805_wdt.c: uses writel_relaxed
>      proposed fix: depend on CONFIG_ARM (this is a spear-only cell by now)

This one on the other hand makes sense to be defined on all architectures
IMHO. I don't mind restricting the driver to ARM for now, but having
a generic writel_relaxed would be nice.

	Arnd
