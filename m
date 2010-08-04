Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab0HDOwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:52:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55124 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927Ab0HDOwm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 10:52:42 -0400
Date: Wed, 4 Aug 2010 10:51:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: sa212+lkml@cyconix.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: Driver: PCIe: 'pci_map_sg' returning invalid bus address?
Message-ID: <20100804145154.GC23544@phenom.dumpdata.com>
References: <4C593245.5070303@cyconix.com>
 <20100804190808D.fujita.tomonori@lab.ntt.co.jp>
 <4C594D78.6090407@cyconix.com>
 <20100804210206A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804210206A.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C597EB3.0036:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 09:03:53PM +0900, FUJITA Tomonori wrote:
> On Wed, 04 Aug 2010 12:22:32 +0100
> Evan Lavelle <sa212+lkml@cyconix.com> wrote:
> 
> > FUJITA Tomonori wrote:
> > >> Made some progress here. The problem is that this is 32-bit PAE kernel, 
> > >> so 'dma_addr_t' is 64-bit. However, I have a 32-bit PCIe card, so I need 
> > >> a 32-bit dma_addr_t. How do I do this? In other words, how do I handle 
> > >> 32-bit PCI cards on PAE or 64-bit systems? My code sets the DMA mask to 
> > >> 32 bits but this is *not* sufficient:
> > >>
> > >> pci_set_dma_mask(my_dev, DMA_32BIT_MASK)
> > > 
> > > It doesn't work on x86_32 kernel if your driver doesn't work with the
> > > block layer or the network subsystem.
> > 
> > Sorry, not sure that I understand this. Are you saying that I can't set 
> > a DMA mask on x86_32 unless I have a block or network driver?
> 
> Yeah, the mask is ignored. As I wrote in the previous mail, x86_32
> doesn't have a bounce mechanism so dma_map_{single|sg} can't do
> anything for a buffer above 32bit even if the mask is 32bit.
> 
> 
> > > If your driver can't handle 64bit DMA, you need bounce buffer. 
> > 
> > The problem is not that I can't handle 64-bit DMA in the driver, but 
> > that the PCI card can't do 64-bit DMA. I tell the kernel this by calling 
> > 'pci_set_dma_mask' with a 32-bit mask, but it appears to be ignoring my 
> > request and then giving me a 64-bit dma_addr_t for the 32-bit PCI card.
> 
> If your card can't do 64-bit DMA, you need a bounce buffer mechanism.
> 
> Options are:
> 
> - your driver implements its own bounce buffer mechanism (as some
>   driver do).
> 
> - add swiotlb support to x86_32 (I don't think that it's difficult but
>   I might miss something).

I think the highmem support might be a bit tricky. The PowerPC folks
did some work in there, so it _ought_ to work.

Evan, you could edit arch/x86/Kconfig and change:
 config SWIOTLB
         def_bool y if X86_64

to say
	def_bool y if X86

and see how it works? FYI, it might wreak havoc on your machine thought,
so be sure you have a fail-safe kernel and backup your root/home
directory.

(FYI, I made Xen-SWIOTLB be capable of running under X86_32 and so far
no trouble.. but that is not baremetal obviously).
