Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1FHJYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:24:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1FHJYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:24:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>
Subject: Dynamic patching in discarded sections
Date: Wed, 8 Jun 2011 11:23:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106081123.59414.arnd@arndb.de>
X-Provags-ID: V02:K0:csbe/VEf48BNOjQ6a1nU2Z1CjLFqzhbpRxXQqXs9DNr
 FJzlE6k2KiXJ0QqB8f4VpCNT1X5ldULnLHGVaPNuUBry24jmV8
 Y6CCjd0ASixG5CW/pccyEl8aZh7xw+3HBhwHNcwG89jLVnxX7A
 qFuUYHzrgf3h1uqzBBMTAw8W2CvlFm72GYogw6CvDuNQJ33j6t
 o/Dkqyyf718D6Zc8OMBMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been playing with randconfig builds and found an interesting problem
with the combination of:

CONFIG_ARM_PATCH_PHYS_VIRT=y
CONFIG_HOTPLUG=n
CONFIG_DMABOUNCE=n
CONFIG_MMC_SPI=y

The problem is shown with this code:

static int __devexit mmc_spi_remove(struct spi_device *spi)
{
	...   
                        dma_unmap_single(host->dma_dev, host->ones_dma,
                                MMC_SPI_BLOCKSIZE, DMA_TO_DEVICE);
                        dma_unmap_single(host->dma_dev, host->data_dma,
                                sizeof(*host->data), DMA_BIDIRECTIONAL);
	...
}

and the error message (in case someone looks for this using google) is

`.devexit.text' referenced in section `.pv_table' of drivers/built-in.o: defined in discarded section `.devexit.text' of drivers/built-in.o
`.devexit.text' referenced in section `.pv_table' of drivers/built-in.o: defined in discarded section `.devexit.text' of drivers/built-in.o

What happens is that dma_unmap_single() calls
 __dma_single_dev_to_cpu(dma_to_virt(dev, handle), size, dir), which requires
patching in the caller. However, due to CONFIG_HOTPLUG being disabled, the
__devexit section gets discarded, and the linker cannot create an entry in the
.pvtable section for the mmc_spi_remove function.

I don't know if the same problem exists in other places in the code, but it's
entirely possible. I also couldn't think of a good solution for this, short of
moving the definition of dma_unmap_single() to out of line code.

	Arnd
