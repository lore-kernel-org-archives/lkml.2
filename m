Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1FHOPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:15:05 -0400
Received: from relais.videotron.ca ([24.201.245.36]:31798 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab1FHOPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:15:03 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 08 Jun 2011 10:15:02 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Dynamic patching in discarded sections
In-reply-to: <201106081123.59414.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1106080946000.2142@xanadu.home>
References: <201106081123.59414.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Arnd Bergmann wrote:

> I've been playing with randconfig builds and found an interesting problem
> with the combination of:
> 
> CONFIG_ARM_PATCH_PHYS_VIRT=y
> CONFIG_HOTPLUG=n
> CONFIG_DMABOUNCE=n
> CONFIG_MMC_SPI=y
> 
> The problem is shown with this code:
> 
> static int __devexit mmc_spi_remove(struct spi_device *spi)
> {
> 	...   
>                         dma_unmap_single(host->dma_dev, host->ones_dma,
>                                 MMC_SPI_BLOCKSIZE, DMA_TO_DEVICE);
>                         dma_unmap_single(host->dma_dev, host->data_dma,
>                                 sizeof(*host->data), DMA_BIDIRECTIONAL);
> 	...
> }
> 
> and the error message (in case someone looks for this using google) is
> 
> `.devexit.text' referenced in section `.pv_table' of drivers/built-in.o: defined in discarded section `.devexit.text' of drivers/built-in.o
> `.devexit.text' referenced in section `.pv_table' of drivers/built-in.o: defined in discarded section `.devexit.text' of drivers/built-in.o
> 
> What happens is that dma_unmap_single() calls
>  __dma_single_dev_to_cpu(dma_to_virt(dev, handle), size, dir), which requires
> patching in the caller. However, due to CONFIG_HOTPLUG being disabled, the
> __devexit section gets discarded, and the linker cannot create an entry in the
> .pvtable section for the mmc_spi_remove function.

We really need to push for better toolchain support here.  This could 
easily be solved with some way to query the currently active section 
from the assembler and use that to construct the argument to the
.pushsection directive.  This way, the .pvtable section could become 
.pvtable.__devexit when the reference is made from a __devexit section, 
and that could be discarded altogether at link time if unneeded.

Dave Martin proposed an extension to gas here (also sent to 
binutils@sourceware.org):

http://article.gmane.org/gmane.linux.linaro.toolchain/701

But as far as I know, nothing further happened. And this is not an ARM 
specific issue either as the X86 alternates have the same problem.

> I don't know if the same problem exists in other places in the code, but it's
> entirely possible. I also couldn't think of a good solution for this, short of
> moving the definition of dma_unmap_single() to out of line code.

Probably the best interim solution would be:

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index dfbb377..f231c92 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -21,7 +21,8 @@
 #define ARM_CPU_KEEP(x)
 #endif
 
-#if defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)
+#if (defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)) || \
+    defined(CONFIG_ARM_PATCH_PHYS_VIRT)
 #define ARM_EXIT_KEEP(x)	x
 #else
 #define ARM_EXIT_KEEP(x)

But clearly the toolchain should be more accommodating instead.


Nicolas
