Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629Ab1ETGsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:48:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41067 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933375Ab1ETGsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:48:43 -0400
X-Sasl-enc: i+7rjbSr0vpuujEVDrCAuyENrYQ4y65mnZ1wpyIcfxfs 1305874122
Message-ID: <4DD60F57.8030000@ladisch.de>
Date: Fri, 20 May 2011 08:51:03 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-pci@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmap() implementation for pci_alloc_consistent() memory?
References: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>	<20110519145921.GE9854@dumpdata.com>	<4DD53E2B.2090002@ladisch.de> <BANLkTinO1xR4XTN2B325pKCpJ3AjC9YidA@mail.gmail.com>
In-Reply-To: <BANLkTinO1xR4XTN2B325pKCpJ3AjC9YidA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leon Woestenberg wrote:
> On Thu, May 19, 2011 at 5:58 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
>>> On Thu, May 19, 2011 at 12:14:40AM +0200, Leon Woestenberg wrote:
>>> >     vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>>
>> So is this an architecture without coherent caches?
> 
> My aim is to have an architecture independent driver.

Please note that most MMU architectures forbid mapping the same memory
with different attributes, so you must use pgprot_noncached if and only
if dma_alloc_coherent actually uses it.  Something like the code below.

And I'm not sure if you have to do some additional cache flushes when
mapping on some architectures.

>> Or would you want to use pgprot_dmacoherent, if available?
> 
> Hmm, let me check that.

It's available only on ARM and Unicore32.

There's also dma_mmap_coherent(), which does exactly what you want if
your buffer is physically contiguous, but it's ARM only.
Takashi tried to implement it for other architectures; I don't know
what came of it.


Regards,
Clemens


#ifndef pgprot_dmacoherent
/* determine whether coherent mappings need to be uncached */
#if defined(CONFIG_ALPHA) || \
    defined(CONFIG_CRIS) || \
    defined(CONFIG_IA64) || \
    (defined(CONFIG_MIPS) && defined(CONFIG_DMA_COHERENT)) || \
    (defined(CONFIG_PPC) && !defined(CONFIG_NOT_COHERENT_CACHE)) || \
    defined(CONFIG_SPARC64) || \
    defined(CONFIG_X86)
#define ARCH_HAS_DMA_COHERENT_CACHE
#endif
#endif

	...
#ifdef pgprot_dmacoherent
	vma->vm_page_prot = pgprot_dmacoherent(vma->vm_page_prot);
#elif !defined(ARCH_HAS_DMA_COHERENT_CACHE)
#ifdef CONFIG_MIPS
	if (!plat_device_is_coherent(device))
#endif
		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
#endif
