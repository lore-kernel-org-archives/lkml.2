Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1GYOSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:18:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38109 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1GYOSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:18:02 -0400
MIME-Version: 1.0
Reply-To: matvejchikov@gmail.com
From: Matvejchikov Ilya <matvejchikov@gmail.com>
Date: Mon, 25 Jul 2011 18:17:40 +0400
Message-ID: <CAKh5naZyhFKefrxsSfmctNDRJ7jWcmdkkjbtvU6QQ3p7riEExw@mail.gmail.com>
Subject: Question: Is it possible to clean memory in unmap_vmas?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I need to implement an on-free memory-cleanning feature within the
kernel module. I've dig a kernel and found that that task may be
accomplished with the unmap_vmas function. So, I hook it with the JUMP
(on x86) and get the control when the process tries to free it's
memory. Next, I get an address range and walk through the page table
entries and then if the PTE is present, writable I looked for the page
structure it corresponds. Then, if page_count(page) is equals to 1 I
write a data from the kernel page to the user space. All is fine
except for some cases when huge processes like chrome and firefox are
crashed. It seems that I spoil some parts of their memory space
thinking that it's need to be fried as unmap_vmas called.

So the first question, it that method can work or am I miss something?..
.. and the second one -- given the following code where might be an error?

I'll be happy to get any sugesstion,
Thanks.

---- code sample

#define PAGE_SIZE_4K			PAGE_SIZE
#define PAGE_SIZE_2M			PAGE_SIZE_4K * 512
#define PAGE_SIZE_4M			PAGE_SIZE_4K * 512 * 2
#define PAGE_SIZE_1G			PAGE_SIZE_4K * 512 * 512

/* invalid */
#define PAGE_SIZE_LEVEL0		0
/* 1G mapping */
#define PAGE_SIZE_LEVEL1		PAGE_SIZE_1G
/* 2M or 4M mapping */
#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
#define PAGE_SIZE_LEVEL2		PAGE_SIZE_2M
#else
#define PAGE_SIZE_LEVEL2		PAGE_SIZE_4M
#endif
/* 4K mapping */
#define PAGE_SIZE_LEVEL3		PAGE_SIZE_4K

static int follow_virtual_address(struct mm_struct * mm, unsigned long
address, pte_t * ppte)
{
	int size = PAGE_SIZE_LEVEL0;
	pgd_t * pgd; pud_t * pud; pmd_t * pmd; pte_t * pte;

	pgd = pgd_offset(mm, address);
	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
		goto return_result;

	pud = pud_offset(pgd, address);
	if (pud_none(*pud))
		goto return_result;
	if (pud_large(*pud)) {
		size = PAGE_SIZE_LEVEL1;
		*ppte = *(pte_t *)pud;
		goto return_result;
	}
	if (unlikely(pud_bad(*pud)))
		goto return_result;

	pmd = pmd_offset(pud, address);
	if (pmd_none(*pmd))
		goto return_result;
	if (pmd_large(*pmd)) {
		size = PAGE_SIZE_LEVEL2;
		*ppte = *(pte_t *)pmd;
		goto return_result;
	}
	if (unlikely(pmd_bad(*pmd)))
		goto return_result;

	pte = pte_offset_map(pmd, address);
	if (pte) {
		size = PAGE_SIZE_LEVEL3;
		*ppte = *(pte_t *)pte;
		pte_unmap(pte);
	}

return_result:
	return size;
}

static void inline __clear_memory_range(unsigned long address, int size)
{
	int count = size / PAGE_SIZE;

	printk("Clean: at %p clearing %d pages\n", address, count);

	while (count--) {
		copy_to_user((void *)address, (void *)zero_page, PAGE_SIZE);
		address += PAGE_SIZE;
	}
}

static void clear_memory_range(struct mm_struct * mm, unsigned long
start, unsigned long end)
{
	int size;
	pte_t pte;

	printk("Clean: memory range <%.16lx - %.16lx> [%s]\n", start, end,
current->comm);

	while (start < end) {
		size = follow_virtual_address(mm, start, &pte);
		if (size != PAGE_SIZE_LEVEL0) {
			if (pte_present(pte) && pte_write(pte)) {
				struct page * page = pte_page(pte);

				if (page && page_count(page) == 1) {
					__clear_memory_range(start, size);
				}
			}
		} else {
			size = PAGE_SIZE;
		}
		start += size;
	}
}

static int my_unmap_vmas(void * tlb, struct vm_area_struct * vma, \
			    unsigned long start_addr, unsigned long end_addr, \
			    unsigned long * accounted, void * details)
{
	unsigned long start, end;
	struct vm_area_struct * vms;

	for (vms = vma; vms && vms->vm_start < end_addr; vms = vms->vm_next) {
		start = max(vms->vm_start, start_addr);
		if (start >= vms->vm_end)
			continue;
		end = min(vms->vm_end, end_addr);
		if (end <= vms->vm_start)
			continue;

		clear_memory_range(vms->vm_mm, start, end);
	}

	return real_unmap_vmas(unmap_vmas, tlb, vma, start_addr, end_addr,
accounted, details);
}

---- code sample ends
