Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1GJOvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 10:51:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60306 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1GJOvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 10:51:35 -0400
Date: Sun, 10 Jul 2011 15:51:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: nico@fluxnic.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] ARM: move ARCH_HAS_DMA_SET_COHERENT_MASK into
	memory.h
Message-ID: <20110710145123.GH4812@n2100.arm.linux.org.uk>
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com> <1309366019-24379-3-git-send-email-robherring2@gmail.com> <4E1866A2.9040407@gmail.com> <20110709145856.GM4812@n2100.arm.linux.org.uk> <4E19B75D.2080109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E19B75D.2080109@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 09:29:49AM -0500, Rob Herring wrote:
> asm/dma-mapping.h only includes asm/memory.h. We are getting lucky that
> linux/dma-mapping.h is picking up ARCH_HAS_DMA_SET_COHERENT_MASK because
> the include path looks like this for ixp4xx and pxa: linux/dma-mapping.h
> -> linux/scatterlist.h -> asm/io.h -> mach/io.h -> mach/hardware.h.

That's probably because of the way the code has changed over the last
year:

6fee48c dma-mapping: arm: use generic pci_set_dma_mask and pci_set_consistent_dma_mask

Removes HAVE_ARCH_PCI_SET_DMA_MASK from IXP4xx mach/hardware.h, thus
breaking IXP4xx machines.

5f3cd1e dma-mapping: pci: move pci_set_dma_mask and pci_set_consistent_dma_mask to pci-dma-compat.h

Removes HAVE_ARCH_PCI_SET_DMA_MASK support from drivers/pci/pci.c,
which includes linux/pci.h -> asm/pci.h -> mach/hardware.h and thus
the definition.

710224fa arm: fix "arm: fix pci_set_consistent_dma_mask for dmabounce devices"

Creates the current ARCH_HAS_DMA_SET_COHERENT_MASK stuff, placing it
into ixp4xx's and PXA's mach/hardware.h to fix the regression caused
by 6fee48c and 5f3cd1e.

So this really could do with being made more robust first, because
as you point out, the current solution is extremely fragile.
