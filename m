Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0IQXLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:11:53 -0400
Received: from claw.goop.org ([74.207.240.146]:35569 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab0IQXLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:11:52 -0400
Message-ID: <4C93F5B6.4050508@goop.org>
Date: Fri, 17 Sep 2010 16:11:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: memblock vs early_res
References: <4C93D3F0.3030307@goop.org> <4C93EFF6.5050806@kernel.org>
In-Reply-To: <4C93EFF6.5050806@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/17/2010 03:47 PM, Yinghai Lu wrote:
> On 09/17/2010 01:47 PM, Jeremy Fitzhardinge wrote:
>>  Hi Yinghai,
>>
>> I have the patch below floating around in my tree to make sure that
>> early-reserved highmem is honoured when freeing unreserved memory.  I
>> was trying to rebase it to current linux-next and noticed that all the
>> early_res stuff has been replaced with memblock.
>>
>> Is this still an issue?  What would the memblock version of this patch
>> look like?
>>
> Not sure why this patch is needed.
>
> For the early reserve ranges, that could be overlapped with high pages, is "KVA RAM",
> but We do remove those range in active ranges array. [ in calculate_numa_remap_pages() ].
> [
> ...
>                 memblock_x86_reserve_range(node_kva_final,
>                               node_kva_final+(((u64)size)<<PAGE_SHIFT),
>                               "KVA RAM");
>
>                 node_remap_start_pfn[nid] = node_kva_final>>PAGE_SHIFT;
>                 remove_active_range(nid, node_remap_start_pfn[nid],
>                                          node_remap_start_pfn[nid] + size);
> ...
> ]
>
> Can you check if Gianluca Guida still can duplicate the problem that will need his patch ?

The specific motivation for this patch is to handle Xen ballooning where
the domain can be built with X pages of memory available to it
initially, but Y pages are presented in the E820 map (Y >= X).  The
extra pages in the E820 are not physically present, but I want the
kernel to allocate page structures for them, so I reserve_early() them
to stop them from being used.  Later on, the balloon driver can
incrementally populate these pfns and return them to the kernel for use
as real memory.

Without this patch, the reservations of the highmem pages are ignored
and the kernel ends up trying to use these non-resident pages.  (At
least that's what used to happen, and I didn't see any changes which
looked like they would address this.)

Does the code you quote above address this case?

Thanks,
    J
