Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936896Ab0COVlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:41:11 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43346 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936834Ab0COVlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EY+5t6RAKeZqM9Z7R07fZaxgOgEpPASRU+PJmHiJ7iPT1olHulgYSIkVCbbX4MMKhf
         ZrCZJ56q84K8mTP0owEa38Pb2TlZUlE64WeUFOt/PpzYMFJgT+CCGR6ctg/s+DbBtLa5
         wobnRWMxNCNOviRhi0rWqpbHNm00t6U3rKgLo=
MIME-Version: 1.0
In-Reply-To: <817ecb6f1003151120s3e6f34acl39563fc0dc8fa9db@mail.gmail.com>
References: <4B9B812F.3030306@free.fr>
	 <817ecb6f1003151120s3e6f34acl39563fc0dc8fa9db@mail.gmail.com>
Date: Mon, 15 Mar 2010 17:40:59 -0400
Message-ID: <817ecb6f1003151440s62918b34hae919618c3bd2750@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 2:20 PM, Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
> On Sat, Mar 13, 2010 at 8:12 AM, matthieu castet
> <castet.matthieu@free.fr> wrote:
>> Hi,
>>
>>> > looking for c17ebdb8 in system.map points to a location in pgd_lock:
>>> > ============================================
>>> > $grep c17ebd System.map
>>> > c17ebd68 d bios_check_work
>>> > c17ebda8 d highmem_pages
>>> > c17ebdac D pgd_lock
>>> > c17ebdc8 D pgd_list
>>> > c17ebdd0 D show_unhandled_signals
>>> > c17ebdd4 d cpa_lock
>>> > c17ebdf0 d memtype_lock
>>> > ============================================
[ . . . ]
>>> Here is a trace of printk's that I added to troubleshoot this issue:
>>> =========================
>>> [    3.072003] try_preserve_large_page - enter
>>> [    3.073185] try_preserve_large_page - address: 0xc1600000
>>> [    3.074513] try_preserve_large_page - 2M page
>>> [    3.075606] try_preserve_large_page - about to call static_protections
>>> [    3.076000] try_preserve_large_page - back from static_protections
>>> [    3.076000] try_preserve_large_page - past loop
>>> [    3.076000] try_preserve_large_page - new_prot != old_prot
>>> [    3.076000] try_preserve_large_page - the address is aligned and
>>> the number of pages covers the full range
>>> [    3.076000] try_preserve_large_page - about to call __set_pmd_pte
>>> [    3.076000] __set_pmd_pte - enter
>>> [    3.076000] __set_pmd_pte - address: 0xc1600000
>>> [    3.076000] __set_pmd_pte - about to call
>>> set_pte_atomic(*0xc18c0058(low=0x16001e3, high=0x0), (low=0x16001e1,
>>> high=0x80000000))
>>> [lock-up here]
>>> =========================
>>>
[...]
>> 0xc1600000 2MB page is in 0xc1600000-0xc1800000 range.  pgd_lock
>> (0xc17ebdac) seems to be in that range.
[ . . . ]
>> You change attribute from (low=0x16001e3, high=0x0) to (low=0x16001e1,
>> high=0x80000000). IE you set
>> NX bit (bit 63), but you also clear R/W bit (bit 2). So the page become read
>> only, but you are using a lock
>> inside this page that need RW access. So you got a page fault.
[ . . . ]
>> Now I don't know what should be done.
>> Is that normal we set the page RO ?
>
> No, this page should not be RO, as it contains kernel's RW data.
> The interesting part is that the call that initiates the change is
> set_memory_nx(), so it should not be clearing RW bit... The
> interesting part is that the kernel does not crash with lock debugging
> disabled.

Turns out that address is indeed within .rodata range, so
static_protections() flips RW bit to 0:

[    0.000000] Memory: 889320k/914776k available (5836k kernel code,
25064k reserved, 2564k data, 540k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd58000 - 0xfffff000   (2716 kB)
[    0.000000]     vmalloc : 0xf8556000 - 0xffd56000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7d56000   ( 893 MB)
[    0.000000]       .init : 0xc1834000 - 0xc18bb000   ( 540 kB)
[    0.000000]       .data : 0xc15b3000 - 0xc1834000   (2564 kB)
[    0.000000]     .rodata : 0xc15b4000 - 0xc17e3000   (2236 kB)
[    0.000000]       .text : 0xc1000000 - 0xc15b3000   (5836 kB)
[    0.000000] pgd_lock address: 0xc17ebdac
[...]
[    3.496969] try_preserve_large_page - enter
[    3.500004] try_preserve_large_page - address: 0xc1600000
[    3.501730] try_preserve_large_page - 2M page
[    3.503100] try_preserve_large_page - NX:1 RW:1
[    3.504000] try_preserve_large_page - about to call static_protections
[    3.504000] static_protections - .rodata  PFN:0x1600  VA:0xc1600000
[    3.504000] try_preserve_large_page - back from static_protections
[    3.504000] try_preserve_large_page - NX:1 RW:0

So, her is what we have:
1. RO-data is at 0xc15b4000 - 0xc17e3000
2. pgd_lock is at 0xc17ebdac
3. single large page maps tail end of RO-data, and a head of RW-data,
including pgd_lock
4. static_protections says that 0xc1600000 - 0xc17e2000 should be
read-only, and that is true
5. However, try_preserve_large_page assumes that whole large page is
RO since whole requested RO-range fits within the page (0xc1600000 -
0xc1800000) -- FALSE. The problem is that try_preserve_large_page()
never checks static_protections() for the remainder of the page, which
is wrong.

The bug seems to be in the following piece of code (arch/x86/mm/pageattr.c:434):
================================================
        /*
         * We need to check the full range, whether
         * static_protection() requires a different pgprot for one of
         * the pages in the range we try to preserve:
         */
        addr = address + PAGE_SIZE;
        pfn++;
        for (i = 1; i < cpa->numpages; i++, addr += PAGE_SIZE, pfn++) {
                pgprot_t chk_prot = static_protections(new_prot, addr, pfn);

                if (pgprot_val(chk_prot) != pgprot_val(new_prot))
                        goto out_unlock;
        }
================================================

It seems to me that the for loop needs to run for EACH small page
within large page, instead of just from addr through cpa->numpages:
================================================
-        addr = address + PAGE_SIZE;
-        pfn++;
-        for (i = 1; i < cpa->numpages; i++, addr += PAGE_SIZE, pfn++) {
+        addr = address & pmask;
+        pfn = pte_pfn(old_pte);
+        for ( i = 0; i < (psize >> PAGE_SHIFT); i++, addr +=
PAGE_SIZE, pfn++) {
                pgprot_t chk_prot = static_protections(new_prot, addr, pfn);

                if (pgprot_val(chk_prot) != pgprot_val(new_prot))
                        goto out_unlock;
        }
================================================


Further, I do not think that the conditions for "whole-pageness" are
correct (arch/x86/mm/pageattr.c:457)
================================================
        /*
         * We need to change the attributes. Check, whether we can
         * change the large page in one go. We request a split, when
         * the address is not aligned and the number of pages is
         * smaller than the number of pages in the large page. Note
         * that we limited the number of possible pages already to
         * the number of pages in the large page.
         */
-         if (address == (nextpage_addr - psize) && cpa->numpages == numpages) {
+        if (address == (address & pmask) && cpa->numpages == (psize
>> PAGE_SHIFT)) {
                /*
                 * The address is aligned and the number of pages
                 * covers the full page.
                 */
                new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
                __set_pmd_pte(kpte, address, new_pte);
                cpa->flags |= CPA_FLUSHTLB;
                do_split = 0;
        }
================================================

Please let me know if this makes any sense, and I will submit a proper patch.

Thank you.
