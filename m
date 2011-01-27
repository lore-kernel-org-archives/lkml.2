Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1A0NLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:11:48 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:43789 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006Ab1A0NLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:11:47 -0500
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2011 08:11:46 EST
Date: Thu, 27 Jan 2011 21:05:30 +0800
From: Xiaowei Yang <xiaowei.yang@huawei.com>
Subject: One (possible) x86 get_user_pages bug
To: Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jan Beulich <JBeulich@novell.com>
Cc: Kenneth Lee <liguozhu@huawei.com>, wangzhenguo@huawei.com,
        linqaingmin <linqiangmin@huawei.com>, fanhenglong@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        Kaushik Barde <kbarde@huawei.com>
Message-id: <4D416D9A.9010603@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9)
 Gecko/20100317 Thunderbird/3.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually this bug is met with a SLES11 SP1 dom0 kernel 
(2.6.32.12-0.7-xen), and we still can't reproduce it with a native 
2.6.32 kernel. But as we suspect the native kernel might have the same 
issue, we send it to LKML for consultant.

At first the error message looks like this:
----------------------------------------------------------------
[201674.150162] BUG: Bad page state in process java  pfn:d13b8
[201674.151345] page:ffff8800075c7040 flags:4000000000200000 count:0 
mapcount:0        mapping:(null) index:7f093bdfd
[201674.152474] Pid: 14793, comm: java Tainted: G          N 
2.6.32.12-0.7-xen #2
[201674.153585] Call Trace:
[201674.154643]  [<ffffffff80009a75>] dump_trace+0x65/0x180
[201674.155686]  [<ffffffff80369f26>] dump_stack+0x69/0x73
[201674.156744]  [<ffffffff8009c0df>] bad_page+0xdf/0x160
[201674.157773]  [<ffffffff800614f1>] get_futex_key+0x71/0x1a0
[201674.158820]  [<ffffffff80061f72>] futex_wake+0x52/0x130
[201674.159852]  [<ffffffff8006414f>] do_futex+0x11f/0xc40
[201674.160875]  [<ffffffff80064cf2>] sys_futex+0x82/0x160
[201674.161907]  [<ffffffff8003aa26>] mm_release+0xb6/0x110
[201674.162960]  [<ffffffff8003f65e>] exit_mm+0x1e/0x150
[201674.163991]  [<ffffffff80040567>] do_exit+0x127/0x7e0
[201674.165028]  [<ffffffff80040c32>] sys_exit+0x12/0x20
[201674.166070]  [<ffffffff80007388>] system_call_fastpath+0x16/0x1b
[201674.167130]  [<00007f098db046b0>] 0x7f098db046b0
----------------------------------------------------------------

After CONFIG_DEBUG_VM option turned on (kind of), the faulting spot is 
captured -- get_page() in gup_pte_range() is used upon a free page and 
it triggers a BUG_ON.

We created a scenario to reproduce the bug:
----------------------------------------------------------------
// proc1/proc1.2 are 2 threads sharing one page table.
// proc1 is the parent of proc2.

proc1               proc2          proc1.2
...                 ...            // in gup_pte_range()
...                 ...            pte = gup_get_pte()
...                 ...            page1 = pte_page(pte)  // (1)
do_wp_page(page1)   ...            ...
...                 exit_map()     ...
...                 ...            get_page(page1)        // (2)
-----------------------------------------------------------------

do_wp_page() and exit_map() cause page1 to be released into free list 
before get_page() in proc1.2 is called. The longer the delay between 
(1)&(2), the easier the BUG_ON shows.

An experimental patch is made to prevent the PTE being modified in the 
middle of gup_pte_range(). The BUG_ON disappears afterward.

However, from the comments embedded in gup.c, it seems deliberate to 
avoid the lock in the fast path. The question is: if so, how to avoid 
the above scenario?

Thanks,
xiaowei

--------------------------------------------------------------------
--- /usr/src/linux-2.6.32.12-0.7/arch/x86/mm/gup.c.org  2011-01-27 
20:11:45.000000000 +0800
+++ /usr/src/linux-2.6.32.12-0.7/arch/x86/mm/gup.c      2011-01-27 
20:11:22.000000000 +0800
@@ -72,17 +72,18 @@static noinline int gup_pte_range(pmd_t pmd, unsigned 
long addr,
                                unsigned long end, int write, struct 
page **pages, int *nr)
  {
         unsigned long mask;
         pte_t *ptep;
+       spinlock_t *ptl;

         mask = _PAGE_PRESENT|_PAGE_USER;
         if (write)
                 mask |= _PAGE_RW;
-       ptep = pte_offset_map(&pmd, addr);
+       ptep = pte_offset_map_lock(current->mm, &pmd, addr, &ptl);
         do {
                 pte_t pte = gup_get_pte(ptep);
                 struct page *page;

                 if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
-                       pte_unmap(ptep);
+                       pte_unmap_unlock(ptep, ptl);
                         return 0;
                 }
                 VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
@@ -90,8 +91,9 @@
                 get_page(page);
                 pages[*nr] = page;
                 (*nr)++;

         } while (ptep++, addr += PAGE_SIZE, addr != end);
-       pte_unmap(ptep - 1);
+       pte_unmap_unlock(ptep - 1, ptl);

         return 1;
  }


