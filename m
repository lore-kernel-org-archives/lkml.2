Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab2JCOD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:03:56 -0400
Received: from mga10.intel.com ([192.55.52.92]:33985 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932111Ab2JCODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:03:54 -0400
Message-ID: <1349273028.7223.35.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map in
 trampoline_pgd
From: Matt Fleming <matt.fleming@intel.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, x86@kernel.org,
        mjg@redhat.com, linux-efi@vger.kernel.org, hpa@zytor.com
Date: Wed, 03 Oct 2012 15:03:48 +0100
In-Reply-To: <506C4C3A020000780008D041@nat28.tlf.novell.com>
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
	 <1349269157-25956-2-git-send-email-matt@console-pimps.org>
	 <506C4C3A020000780008D041@nat28.tlf.novell.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 14:31 +0100, Jan Beulich wrote:
> >>> Matt Fleming <matt@console-pimps.org> 10/03/12 2:59 PM >>>
> >+static int insert_identity_mapping(resource_size_t paddr, unsigned long vaddr,
> >+                    unsigned long size)
> >+{
> >+    unsigned long end = vaddr + size;
> >+    unsigned long next;
> >+    pgd_t *vpgd, *ppgd;
> >+
> >+#ifdef CONFIG_X86_32
> >+    ppgd = initial_page_table + pgd_index(paddr);
> >+
> >+    if (paddr >= PAGE_OFFSET || paddr + size > PAGE_OFFSET)
> >+        return 1;
> >+#else
> >+    ppgd = __va(real_mode_header->trampoline_pgd) + pgd_index(paddr);
> 
> Missing equivalent code (to the 32-bit one above) here - after all, you're trying
> to potentially insert a 52-bit physical address into 48-bit virtual space.

Ah, true.

> >+#endif
> >+
> >+    vpgd = pgd_offset_k(vaddr);
> >+    do {
> >+        next = pgd_addr_end(vaddr, end);
> >+
> >+        if (!pgd_present(*ppgd)) {
> >+            pud_t *ppud = (pud_t *)get_zeroed_page(GFP_KERNEL);
> >+            if (!ppud)
> >+                return 1;
> >+
> >+            set_pgd(ppgd, __pgd(_KERNPG_TABLE | __pa(ppud)));
> >+        }
> >+
> >+        if (ident_pud_range(paddr, vaddr, ppgd, vpgd, next))
> >+            return 1;
> >+    } while (ppgd++, vpgd++, vaddr = next, vaddr != end);
> >+
> >+    return 0;
> >+}
> >+
>  >/*
> >* Remap an arbitrary physical address space into the kernel virtual
> >* address space. Needed when the kernel wants to access high addresses
> >@@ -163,6 +258,10 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
> >    ret_addr = (void __iomem *) (vaddr + offset);
> >    mmiotrace_ioremap(unaligned_phys_addr, unaligned_size, ret_addr);
>  >
> >+    if (insert_identity_mapping(phys_addr, vaddr, size))
> >+        printk(KERN_WARNING "ioremap: unable to map 0x%llx in identity pagetable\n",
> >+                    (unsigned long long)phys_addr);
> 
> Isn't that going to trigger quite frequently on 32-bit kernels?

Hmmm... yeah, probably, though it didn't during my testing. If it is
likely to trigger a lot then we might be best only inserting the
identity mmio mapping for 64-bit, and addressing the 32-bit case if we
ever actually need the identity pagetable.

