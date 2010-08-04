Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab0HDKJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:09:03 -0400
Received: from sh.osrg.net ([192.16.179.4]:52627 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab0HDKJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:09:00 -0400
Date: Wed, 4 Aug 2010 19:08:51 +0900
To: sa212+lkml@cyconix.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Driver: PCIe: 'pci_map_sg' returning invalid bus address?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C593245.5070303@cyconix.com>
References: <4C5002AD.6070206@cyconix.com>
	<4C593245.5070303@cyconix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100804190808D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 04 Aug 2010 19:08:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Aug 2010 10:26:29 +0100
Evan Lavelle <sa212+lkml@cyconix.com> wrote:

> Made some progress here. The problem is that this is 32-bit PAE kernel, 
> so 'dma_addr_t' is 64-bit. However, I have a 32-bit PCIe card, so I need 
> a 32-bit dma_addr_t. How do I do this? In other words, how do I handle 
> 32-bit PCI cards on PAE or 64-bit systems? My code sets the DMA mask to 
> 32 bits but this is *not* sufficient:
> 
> pci_set_dma_mask(my_dev, DMA_32BIT_MASK)

It doesn't work on x86_32 kernel if your driver doesn't work with the
block layer or the network subsystem.

If your driver can't handle 64bit DMA, you need bounce buffer. I don't
know what your driver do, but a subsystem passes a buffer to your
driver. If a buffer is not below 32bit address, for example, if you
read data from hardware, you need to allocate a temporary buffer
(below 32bit), do DMA with the buffer, copy the data to the original
buffer, then free the temporary buffer.

The block layer and the network subsystem have the own bounce
mechanism. x86_64 kernel has swiotlb, which is the generic bounce
buffer mechanism. So if a driver sets the dma mask, they do bounce
buffer for the driver.
