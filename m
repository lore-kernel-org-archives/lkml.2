Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0EKIGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:06:08 -0400
Received: from daytona.panasas.com ([67.152.220.89]:52682 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756054Ab0EKIGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:06:01 -0400
Message-ID: <4BE90FE5.9050609@panasas.com>
Date: Tue, 11 May 2010 11:05:57 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dan Carpenter <error27@gmail.com>, Benny Halevy <bhalevy@panasas.com>,
       Avishay Traeger <avishay@gmail.com>, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] exofs: confusion between kmap() and kmap_atomic() api
References: <20100507090532.GD27064@bicker>	<4BE68B86.50707@panasas.com> <20100510160322.6e80d9e0.akpm@linux-foundation.org>
In-Reply-To: <20100510160322.6e80d9e0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 May 2010 08:06:00.0224 (UTC) FILETIME=[CAFA9200:01CAF0E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 02:03 AM, Andrew Morton wrote:
> On Sun, 09 May 2010 13:16:38 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On 05/07/2010 12:05 PM, Dan Carpenter wrote:
>>> For kmap_atomic() we call kunmap_atomic() on the returned pointer.
>>> That's different from kmap() and kunmap() and so it's easy to get them
>>> backwards.
>>>
>>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>>>
>>
>> Thank you Dan, I'll push it ASAP. 
> 
>> Looks like a bad bug. So this is actually a leak, right? kunmap_atomic
>> would detect the bad pointer and do nothing?
> 
> void kunmap_atomic(void *kvaddr, enum km_type type)
> {
> 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
> 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
> 
> 	/*
> 	 * Force other mappings to Oops if they'll try to access this pte
> 	 * without first remap it.  Keeping stale mappings around is a bad idea
> 	 * also, in case the page changes cacheability attributes or becomes
> 	 * a protected page in a hypervisor.
> 	 */
> 	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
> 		kpte_clear_flush(kmap_pte-idx, vaddr);
> 	else {
> #ifdef CONFIG_DEBUG_HIGHMEM
> 		BUG_ON(vaddr < PAGE_OFFSET);
> 		BUG_ON(vaddr >= (unsigned long)high_memory);
> #endif
> 	}
> 
> 	pagefault_enable();
> }
> 
> if CONFIG_DEBUG_HIGHMEM=y, kunmap_atomic() will go BUG.
> 
> if CONFIG_DEBUG_HIGHMEM=n, kunmap_atomic() will do nothing, leaving the
> pte pointing at the old page.  Next time someone tries to use that
> kmap_atomic() slot,
> 
> void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
> {
> 	enum fixed_addresses idx;
> 	unsigned long vaddr;
> 
> 	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
> 	pagefault_disable();
> 
> 	if (!PageHighMem(page))
> 		return page_address(page);
> 
> 	debug_kmap_atomic(type);
> 
> 	idx = type + KM_TYPE_NR*smp_processor_id();
> 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
> 	BUG_ON(!pte_none(*(kmap_pte-idx)));
> 	set_pte(kmap_pte-idx, mk_pte(page, prot));
> 
> 	return (void *)vaddr;
> }
> 
> kmap_atomic_prot() will go BUG because the pte wasn't cleared.
> 
> 
> I can only assume that this code has never been run on i386. I'd suggest
> adding a "Cc: <stable@kernel.org>" to the changelog if you have
> expectations that anyone will try to run it on i386.
> 

Right! Everyone I know runs 64bit. I will add the Cc: <stable@kernel.org>
to the patch. Thanks.

Boaz
