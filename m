Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945975Ab2JLQFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:05:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:51866 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945918Ab2JLQFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:05:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="204916342"
Message-ID: <50783FB6.3070205@intel.com>
Date: Fri, 12 Oct 2012 09:05:10 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/7] Improve swiotlb performance by using physical
 addresses
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 01:34 PM, Alexander Duyck wrote:
> While working on 10Gb/s routing performance I found a significant amount of
> time was being spent in the swiotlb DMA handler. Further digging found that a
> significant amount of this was due to virtual to physical address translation
> and calling the function that did it. It accounted for nearly 60% of the
> total swiotlb overhead.
>
> This patch set works to resolve that by replacing the io_tlb_start and
> io_tlb_end virtual addresses with a physical addresses. In addition it changes
> the io_tlb_overflow_buffer from a virtual to a physical address. I followed
> through with the cleanup to the point that the only functions that really
> require the virtual address for the DMA buffer are the init, free, and
> bounce functions.
>
> In the case of devices that are using the bounce buffers these patches should
> result in only a slight performance gain if any. This is due to the locking
> overhead required to map and unmap the buffers.
>
> In the case of devices that are not making use of bounce buffers these patches
> can significantly reduce their overhead. In the case of an ixgbe routing test
> for example, these changes result in 7 fewer calls to __phys_addr and
> allow is_swiotlb_buffer to become inlined due to a reduction in the number of
> instructions. When running a routing throughput test using small packets I
> saw roughly a 6% increase in packets rates after applying these patches. This
> appears to match up with the CPU overhead reduction I was tracking via perf.
>
> Before:
> Results 10.0Mpps
>
> After:
> Results 10.6Mpps
>
> Finally, I updated the parameter names for several of the core function calls
> as there was some ambiguity in naming. Specifically virtual address pointers
> were named dma_addr. When I changed these pointers to physical I instead used
> the name tlb_addr as this value represented a physical address in the
> io_tlb_start region and is less likely to be confused with a bus address.
>
> v2:
> I reviewed the changes and realized that the first patch that was dropping
> io_tlb_end and calculating the value didn't actually gain me much once I had
> gone through and translated the rest of the addresses to physical addresses.
> As such I have updated the patch so that it instead is converting io_tlb_end
> from a virtual address to a physical address.  This actually helps to reduce
> the overhead for is_swiotlb_buffer and swiotlb_dma_supported by several
> instructions.

The first three patches were replacing "static char *" with
"phys_addr_t" when I should have been using "static phys_addr_t".  As
such I will submit an updated v3 version on Monday.

Thanks,

Alex
