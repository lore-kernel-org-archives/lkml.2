Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0EJXGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:06:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933261Ab0EJXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:05:09 -0400
Date: Mon, 10 May 2010 16:03:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Dan Carpenter <error27@gmail.com>, Benny Halevy <bhalevy@panasas.com>,
       Avishay Traeger <avishay@gmail.com>, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] exofs: confusion between kmap() and kmap_atomic() api
Message-Id: <20100510160322.6e80d9e0.akpm@linux-foundation.org>
In-Reply-To: <4BE68B86.50707@panasas.com>
References: <20100507090532.GD27064@bicker>
	<4BE68B86.50707@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 May 2010 13:16:38 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 05/07/2010 12:05 PM, Dan Carpenter wrote:
> > For kmap_atomic() we call kunmap_atomic() on the returned pointer.
> > That's different from kmap() and kunmap() and so it's easy to get them
> > backwards.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> 
> Thank you Dan, I'll push it ASAP. 

> Looks like a bad bug. So this is actually a leak, right? kunmap_atomic
> would detect the bad pointer and do nothing?

void kunmap_atomic(void *kvaddr, enum km_type type)
{
	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();

	/*
	 * Force other mappings to Oops if they'll try to access this pte
	 * without first remap it.  Keeping stale mappings around is a bad idea
	 * also, in case the page changes cacheability attributes or becomes
	 * a protected page in a hypervisor.
	 */
	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
		kpte_clear_flush(kmap_pte-idx, vaddr);
	else {
#ifdef CONFIG_DEBUG_HIGHMEM
		BUG_ON(vaddr < PAGE_OFFSET);
		BUG_ON(vaddr >= (unsigned long)high_memory);
#endif
	}

	pagefault_enable();
}

if CONFIG_DEBUG_HIGHMEM=y, kunmap_atomic() will go BUG.

if CONFIG_DEBUG_HIGHMEM=n, kunmap_atomic() will do nothing, leaving the
pte pointing at the old page.  Next time someone tries to use that
kmap_atomic() slot,

void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
{
	enum fixed_addresses idx;
	unsigned long vaddr;

	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
	pagefault_disable();

	if (!PageHighMem(page))
		return page_address(page);

	debug_kmap_atomic(type);

	idx = type + KM_TYPE_NR*smp_processor_id();
	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
	BUG_ON(!pte_none(*(kmap_pte-idx)));
	set_pte(kmap_pte-idx, mk_pte(page, prot));

	return (void *)vaddr;
}

kmap_atomic_prot() will go BUG because the pte wasn't cleared.


I can only assume that this code has never been run on i386. I'd suggest
adding a "Cc: <stable@kernel.org>" to the changelog if you have
expectations that anyone will try to run it on i386.

