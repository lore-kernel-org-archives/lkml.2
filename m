Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0HDJ2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:28:06 -0400
Received: from doppler.zen.co.uk ([212.23.3.27]:55187 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab0HDJ2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:28:00 -0400
Message-ID: <4C593245.5070303@cyconix.com>
Date: Wed, 04 Aug 2010 10:26:29 +0100
From: Evan Lavelle <sa212+lkml@cyconix.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Driver: PCIe: 'pci_map_sg' returning invalid bus address?
References: <4C5002AD.6070206@cyconix.com>
In-Reply-To: <4C5002AD.6070206@cyconix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Made some progress here. The problem is that this is 32-bit PAE kernel, 
so 'dma_addr_t' is 64-bit. However, I have a 32-bit PCIe card, so I need 
a 32-bit dma_addr_t. How do I do this? In other words, how do I handle 
32-bit PCI cards on PAE or 64-bit systems? My code sets the DMA mask to 
32 bits but this is *not* sufficient:

pci_set_dma_mask(my_dev, DMA_32BIT_MASK)

Is this a bug, or do I have to do something else? LDD doesn't seem to 
have anything to say about this. I had previously assumed that an IOMMU 
would translate the (32-bit) dma_addr_t to a 36- or 64-bit value, but I 
don't think there's an IOMMU in this system. Do x86 systems have IOMMUs? 
This is a server motherboard, so I don't think it even has AGP. However, 
even if I had an IOMMU, I would still need a way generate a 32-bit 
dma_addr_t to start with.

Second problem: can I use the scatter-gather code ('pci_map_sg') on PAE 
or 64-bit systems? I've found one post that says this isn't possible, 
and that the DAC routines have to be used instead (second post in 
http://www.alteraforum.com/forum/showthread.php?t=4171). These comments 
seem to be incorrect, but I'd appreciate some confirmation of this.

The specific question in my first post was why the coherent mapping 
worked, and the streaming mapping didn't. The answer was that, for this 
system, the dma_addr_t for a coherent buffer in kernel space is in the 
low 4GB, but the dma_addr_t for the streaming buffer in user space has 
bit 32 set. I hadn't realised that dma_addr_t was 64-bit, and I was just 
writing the low 32 bits to the DMA registers on the PCI card. The DMA op 
to the coherent buffer worked, but the DMA op to the streaming buffer 
didn't, since the PCIe card can't drive bit 32.

Thanks -

Evan
