Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab0HMVyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:54:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55542 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab0HMVyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:54:32 -0400
Date: Fri, 13 Aug 2010 22:54:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: khc@pm.waw.pl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
Message-ID: <20100813215413.GA21607@n2100.arm.linux.org.uk>
References: <m3sk2m433u.fsf@intrepid.localdomain> <20100811110448S.fujita.tomonori@lab.ntt.co.jp> <20100811072532.GA21511@n2100.arm.linux.org.uk> <20100813152224H.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813152224H.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 03:23:53PM +0900, FUJITA Tomonori wrote:
> On Wed, 11 Aug 2010 08:25:32 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > It doesn't break dmabounce.
> > 
> > What it breaks is the fact that a PCI device which can do 32-bit DMA is
> > connected to a PCI bus which can only access the first 64MB of memory
> > through the host bridge, but the system has more than 64MB available.
> > 
> > Allowing a 32-bit DMA mask means that dmabounce can't detect that memory
> > above 64MB needs to be bounced to memory below the 64MB boundary.
> 
> But dmabounce doesn't look at dev->coherent_dma_mask.
> 
> The change breaks __dma_alloc_buffer()? If we set dev->coherent_dma_mask
> to DMA_BIT_MASK(32) for ixp4xx's pci devices, __dma_alloc_buffer()
> doesn't use GFP_DMA.

With an incorrect coherent_dma_mask, dma_alloc_coherent() will return
memory outside of the 64MB window.  This means that when dmabounce comes
to allocate the replacement buffer, it gets a buffer which won't be
accessible to the DMA controller - which is a condition it doesn't check
for.

Ergo, it breaks dmabounce.
