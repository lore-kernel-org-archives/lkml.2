Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab0LTXrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:47:08 -0500
Received: from claw.goop.org ([74.207.240.146]:42550 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0LTXrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:47:07 -0500
Message-ID: <4D0FEAF4.2080409@goop.org>
Date: Mon, 20 Dec 2010 15:47:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: do pmd_populate with lazy mmu updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the set_pmd to be batched with whatever setup
paravirt_alloc_pte() needs to do.  pmd_populate() is always called
under the pagetable lock, so this is safe.

With a corresponding change in the Xen-specific code, this allows
the setup of a new pte page to be done with 1 hypercall rather than 3.
This results in a 3-8% improvement in fork performance, depending on
process size (more improvement on larger processes).  I expect a similar
improvement in time spent touching a virgin part of the address space.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index 271de94..15e1153f 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -71,8 +71,10 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 {
 	unsigned long pfn = page_to_pfn(pte);
 
+	arch_enter_lazy_mmu_mode();
 	paravirt_alloc_pte(mm, pfn);
 	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
+	arch_leave_lazy_mmu_mode();
 }
 
 #define pmd_pgtable(pmd) pmd_page(pmd)


