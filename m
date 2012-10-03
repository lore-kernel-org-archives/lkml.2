Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2JCNba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:31:30 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51513 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2JCNb1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:2>);
	Wed, 3 Oct 2012 09:31:27 -0400
Message-Id: <506C4C3A020000780008D041@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 03 Oct 2012 14:31:22 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <matt@console-pimps.org>, <linux-kernel@vger.kernel.org>
Cc: <matt.fleming@intel.com>, <mingo@kernel.org>, <x86@kernel.org>,
        <mjg@redhat.com>, <linux-efi@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map
 in trampoline_pgd
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
 <1349269157-25956-2-git-send-email-matt@console-pimps.org>
In-Reply-To: <1349269157-25956-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Matt Fleming <matt@console-pimps.org> 10/03/12 2:59 PM >>>
>+static int insert_identity_mapping(resource_size_t paddr, unsigned long vaddr,
>+                    unsigned long size)
>+{
>+    unsigned long end = vaddr + size;
>+    unsigned long next;
>+    pgd_t *vpgd, *ppgd;
>+
>+#ifdef CONFIG_X86_32
>+    ppgd = initial_page_table + pgd_index(paddr);
>+
>+    if (paddr >= PAGE_OFFSET || paddr + size > PAGE_OFFSET)
>+        return 1;
>+#else
>+    ppgd = __va(real_mode_header->trampoline_pgd) + pgd_index(paddr);

Missing equivalent code (to the 32-bit one above) here - after all, you're trying
to potentially insert a 52-bit physical address into 48-bit virtual space.

>+#endif
>+
>+    vpgd = pgd_offset_k(vaddr);
>+    do {
>+        next = pgd_addr_end(vaddr, end);
>+
>+        if (!pgd_present(*ppgd)) {
>+            pud_t *ppud = (pud_t *)get_zeroed_page(GFP_KERNEL);
>+            if (!ppud)
>+                return 1;
>+
>+            set_pgd(ppgd, __pgd(_KERNPG_TABLE | __pa(ppud)));
>+        }
>+
>+        if (ident_pud_range(paddr, vaddr, ppgd, vpgd, next))
>+            return 1;
>+    } while (ppgd++, vpgd++, vaddr = next, vaddr != end);
>+
>+    return 0;
>+}
>+
 >/*
>* Remap an arbitrary physical address space into the kernel virtual
>* address space. Needed when the kernel wants to access high addresses
>@@ -163,6 +258,10 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>    ret_addr = (void __iomem *) (vaddr + offset);
>    mmiotrace_ioremap(unaligned_phys_addr, unaligned_size, ret_addr);
 >
>+    if (insert_identity_mapping(phys_addr, vaddr, size))
>+        printk(KERN_WARNING "ioremap: unable to map 0x%llx in identity pagetable\n",
>+                    (unsigned long long)phys_addr);

Isn't that going to trigger quite frequently on 32-bit kernels?

Jan

