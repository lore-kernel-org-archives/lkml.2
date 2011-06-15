Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1FOK3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:29:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:26367 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab1FOK3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:29:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,369,1304319600"; 
   d="scan'208";a="16468778"
Date: Wed, 15 Jun 2011 18:29:09 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH]mm: use correct address for pte_unmap_unlock in
 zap_pte_range
Message-ID: <20110615102909.GA23759@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boot an i386 kernel, I got:
[    3.766613] WARNING: at /workshop/kernel/git/my/linux/arch/x86/mm/highmem_32.c:81 __kunmap_atomic+0x6f/0x113()
[    3.766615] Hardware name: Studio XPS 8000
[    3.766617] Modules linked in:
[    3.766619] Pid: 214, comm: blkid Not tainted 3.0.0-rc3+ #529
[    3.766621] Call Trace:
[    3.766625]  [<c1063803>] warn_slowpath_common+0x6a/0x7f
[    3.766628]  [<c104f494>] ? __kunmap_atomic+0x6f/0x113
[    3.766631]  [<c106382c>] warn_slowpath_null+0x14/0x18
[    3.766633]  [<c104f494>] __kunmap_atomic+0x6f/0x113
[    3.766637]  [<c10e6033>] zap_pte_range+0x291/0x2b4
[    3.766641]  [<c105a37d>] ? get_parent_ip+0xb/0x31
[    3.766644]  [<c10e6180>] unmap_page_range+0x12a/0x147
[    3.766647]  [<c10e6243>] unmap_vmas+0xa6/0xe2
[    3.766650]  [<c10e7c26>] exit_mmap+0x78/0xd3
[    3.766654]  [<c106207a>] mmput+0x39/0x99
[    3.766657]  [<c106582f>] exit_mm+0x101/0x109
[    3.766660]  [<c1066d83>] do_exit+0x1e6/0x312
[    3.766664]  [<c10fff66>] ? fput+0x18/0x1a
[    3.766666]  [<c1066f16>] do_group_exit+0x67/0x8a
[    3.766669]  [<c1066f51>] sys_exit_group+0x18/0x1c
[    3.766673]  [<c1620154>] syscall_call+0x7/0xb

the zap_pte_range does:
	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
	do {
		...
	             if (force_flush)
                     	break;
		...
        } while (pte++, addr += PAGE_SIZE, addr != end);

        pte_unmap_unlock(pte - 1, ptl);

the pte_unmap_unlock(pte - 1) only works if pte++ does once.

this is a regression introduced by d16dfc550f5326a4000f3(mm: mmu_gather
rework)

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/mm/memory.c b/mm/memory.c
index 6953d39..f624945 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1112,11 +1112,11 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	int force_flush = 0;
 	int rss[NR_MM_COUNTERS];
 	spinlock_t *ptl;
-	pte_t *pte;
+	pte_t *pte, *orig_pte;
 
 again:
 	init_rss_vec(rss);
-	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = *pte;
@@ -1196,7 +1196,7 @@ again:
 
 	add_mm_rss_vec(mm, rss);
 	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap_unlock(orig_pte, ptl);
 
 	/*
 	 * mmu_gather ran out of room to batch pages, we break out of
