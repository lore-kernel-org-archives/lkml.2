Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab2JDR45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:56:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:53468 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2JDR44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:56:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,537,1344236400"; 
   d="scan'208";a="201651240"
Message-ID: <506DCDED.4060207@intel.com>
Date: Thu, 04 Oct 2012 10:57:01 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org
Subject: Re: [RFC PATCH 0/7] Improve swiotlb performance by using physical
 addresses
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <20121004133319.GD9158@phenom.dumpdata.com>
In-Reply-To: <20121004133319.GD9158@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 06:33 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 03, 2012 at 05:38:41PM -0700, Alexander Duyck wrote:
>> While working on 10Gb/s routing performance I found a significant amount of
>> time was being spent in the swiotlb DMA handler.  Further digging found that a
>> significant amount of this was due to the fact that virtual to physical
>> address translation and calling the function that did it.  It accounted for
>> nearly 60% of the total overhead.
>>
>> This patch set works to resolve that by changing the io_tlb_start address and
>> io_tlb_overflow_buffer address from virtual addresses to physical addresses.
> The assertion in your patches is that the DMA addresses (bus address)
> are linear is not applicable (unfortunatly). Meaning virt_to_phys() !=
> virt_to_dma().

That isn't my assertion.  My assertion is that virt_to_phys(x + y) ==
(virt_to_phys(x) + y).

> Now, on x86 and ia64 it is true - but one of the users of swiotlb
> library is the Xen swiotlb - which cannot guarantee that the physical
> address are 1-1 with the bus addresses. Hence the bulk of dealing with
> figuring out the right physical to bus address is done in Xen-SWIOTLB
> and the basics of finding an entry in the bounce buffer (if needed),
> mapping it, unmapping ,etc is carried out by the generic library.
>
> This is sad - b/c your patches are a good move forward.

I think if you take a second look you will find you might be taking
things one logical step too far.  From what I can tell my assertion is
correct.  I believe the bits you are talking about don't apply until you
use the xen_virt _to_bus/xen_phys_to_bus call, and the only difference
between those two calls is a virt_to_phys which is what I am eliminating.

> Perhaps another way to do this is by having your patches split the
> lookups in "chunks". Wherein we validate in swiotlb_init_*tbl that the
> 'tbl' (so the bounce buffer) is linear - if not, we split it up in
> chunks. Perhaps the various backends can be responsible for this since
> they would know which of their memory regions are linear or not. But
> that sounds complicated and we don't want to complicate this library.
>
> Or another way would be to provide 'phys_to_virt' and 'virt_to_phys'
> functions for the swiotlb_tbl_{map|unmap}_single and the main library
> (lib/swiotlb.c) can decide to use them. If they are NULL, then it
> would do what your patches suggested. If they are defined, then
> carry out those lookups on the 'empty-to-be-used' bounce buffer
> address. Hm, that sounds like a better way of doing it.
>

I don't see any special phys_to_virt or virt_to_phys calls available for
Xen.  The only calls I do see are phys_to_machine and machine_to_phys
which seem to be translating between physical addresses and those used
for DMA.  If that is the case I should be fine because I am not going as
far as translating the io_tlb_start into a DMA address I am only taking
it to a physical one.

I am not asserting that the DMA memory is contiguous.  I am asserting
that from the CPU perspective the physical memory is contiguous which I 
believe you already agreed with.  From what I can tell this should be
fine since almost all of the virt_to_phys calls out there are just doing
offset manipulation and not breaking the memory up into discreet
chunks.  The sectioning up of the segments in Xen should happen after we
have taken care of the virt_to_phys work so the bounce buffer case
should work out correctly.

Thanks,

Alex
