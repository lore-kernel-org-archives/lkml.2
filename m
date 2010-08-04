Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0HDMEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:04:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:45858 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478Ab0HDMEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:04:04 -0400
Date: Wed, 4 Aug 2010 21:03:53 +0900
To: sa212+lkml@cyconix.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        x86@kernel.org
Subject: Re: Driver: PCIe: 'pci_map_sg' returning invalid bus address?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C594D78.6090407@cyconix.com>
References: <4C593245.5070303@cyconix.com>
	<20100804190808D.fujita.tomonori@lab.ntt.co.jp>
	<4C594D78.6090407@cyconix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100804210206A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 04 Aug 2010 21:03:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Aug 2010 12:22:32 +0100
Evan Lavelle <sa212+lkml@cyconix.com> wrote:

> FUJITA Tomonori wrote:
> >> Made some progress here. The problem is that this is 32-bit PAE kernel, 
> >> so 'dma_addr_t' is 64-bit. However, I have a 32-bit PCIe card, so I need 
> >> a 32-bit dma_addr_t. How do I do this? In other words, how do I handle 
> >> 32-bit PCI cards on PAE or 64-bit systems? My code sets the DMA mask to 
> >> 32 bits but this is *not* sufficient:
> >>
> >> pci_set_dma_mask(my_dev, DMA_32BIT_MASK)
> > 
> > It doesn't work on x86_32 kernel if your driver doesn't work with the
> > block layer or the network subsystem.
> 
> Sorry, not sure that I understand this. Are you saying that I can't set 
> a DMA mask on x86_32 unless I have a block or network driver?

Yeah, the mask is ignored. As I wrote in the previous mail, x86_32
doesn't have a bounce mechanism so dma_map_{single|sg} can't do
anything for a buffer above 32bit even if the mask is 32bit.


> > If your driver can't handle 64bit DMA, you need bounce buffer. 
> 
> The problem is not that I can't handle 64-bit DMA in the driver, but 
> that the PCI card can't do 64-bit DMA. I tell the kernel this by calling 
> 'pci_set_dma_mask' with a 32-bit mask, but it appears to be ignoring my 
> request and then giving me a 64-bit dma_addr_t for the 32-bit PCI card.

If your card can't do 64-bit DMA, you need a bounce buffer mechanism.

Options are:

- your driver implements its own bounce buffer mechanism (as some
  driver do).

- add swiotlb support to x86_32 (I don't think that it's difficult but
  I might miss something).
