Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1HLHhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:37:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34542 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1HLHhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:37:08 -0400
MIME-Version: 1.0
Date: Fri, 12 Aug 2011 15:37:07 +0800
Message-ID: <CAPtRRT9h6yWNB41tfjO9ryx+BppkiTGNWRgNjNTUkwXv-B0eYw@mail.gmail.com>
Subject: Need help about how linux to handle translation fault
From: Pecker Hu <pecker.hu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all:

I am a newer,I hope someone can help me about how linux to handle
translation fault(ARM architecture)

I define a string arrary in user space code:
unsignd char str[20] = "abcdefg";

And I send the address of str to kernel space using IOCTL interface.
ioctl(fd, VM_TEST_GET_VADDR, str);

When I try to use pgd to find the physical address, I don't find it
.But after calling copy_from_user,I can find physical address through
pgd.I don' know why?
/* user space address convert to physical address , if pte is NULL ,
it will return zero */
static unsigned long uva_to_pa(struct mm_struct *mm, unsigned long addr)
{
	unsigned long ret = 0UL;
	pgd_t *pgd;
	pud_t *pud;
	pmd_t *pmd;
	pte_t *pte;

	pgd = pgd_offset(mm, addr);
	if (!pgd_none(*pgd)) {
		pud = pud_offset(pgd, addr);
		if (!pud_none(*pud)) {
			pmd = pmd_offset(pud, addr);
			if (!pmd_none(*pmd)) {
				pte = pte_offset_map(pmd, addr);
				if (!pte_none(*pte) && pte_present(*pte)) {
					/* Use hard PTE */
					pte = (pte_t *)((u32)pte - 2048);
					if(pte)
						ret = (*pte & 0xfffff000) | (addr & 0xfff);
				} else {
					printk("pet is not present:0x%08x\n", (*pte & 0xfffff000) | (addr
& 0xfff));
				}
			}
		}
	}
	return ret;
}

So I think string array is located in data cache not in physical
memory, after I call copy_from_user, kernel will allocate page for it,
then we can access it, is it right?


Thanks
Best regards.

Pecker Hu
