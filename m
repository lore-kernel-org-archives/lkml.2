Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1KZDow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 22:44:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:4740 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab1KZDos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 22:44:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,575,1315206000"; 
   d="scan'208";a="79261283"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        aarcange@redhat.com
Cc: stable@vger.kernel.org, david.woodhouse@intel.com, allen.m.kay@intel.com,
        mtosatti@redhat.com, chrisw@redhat.com, andi@firstfloor.org,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 2/2] thp: Set compound tail page _count to zero
Date: Sat, 26 Nov 2011 11:23:53 +0800
Message-Id: <1322277833-31798-2-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1322277833-31798-1-git-send-email-youquan.song@intel.com>
References: <1322277833-31798-1-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 70b50f94f1644e2aa7cb374819cfd93f3c28d725 "mm: thp: tail page refcounting fix"
 it keep all page_tail->_count zero at all times.
But kernel with THP, it does not set page_tail->_count to zero if 1GiB page is
utilized.
So when IOMMU 1GiB page is used at KVM, it wil result in kernel oops because
a tail page its _count does not equal zero.

kernel BUG at include/linux/mm.h:386!
invalid opcode: 0000 [#1] SMP
Call Trace:
 [<ffffffff81072f7f>] gup_pud_range+0xb8/0x19d
 [<ffffffff8107312f>] get_user_pages_fast+0xcb/0x192
 [<ffffffff810bc450>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81006a24>] hva_to_pfn+0x119/0x2f2
 [<ffffffff81006c29>] gfn_to_pfn_memslot+0x2c/0x2e
 [<ffffffff8100b909>] kvm_iommu_map_pages+0xfd/0x1c1
 [<ffffffff8100ba49>] kvm_iommu_map_memslots+0x7c/0xbd
 [<ffffffff8100b9cd>] ? kvm_iommu_map_pages+0x1c1/0x1c1
 [<ffffffff8100bb34>] kvm_iommu_map_guest+0xaa/0xbf
 [<ffffffff8100aeb0>] kvm_vm_ioctl_assigned_device+0x2ef/0xa47
 [<ffffffff8100ac6d>] ? kvm_vm_ioctl_assigned_device+0xac/0xa47
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff810b0c02>] ? sched_clock_cpu+0x45/0xd4
 [<ffffffff810bc450>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810b0cd2>] ? local_clock+0x41/0x5a
 [<ffffffff810bc8a1>] ? lock_release_holdtime+0x2c/0x129
 [<ffffffff8115762d>] ? cmpxchg_double_slab+0xd0/0x12b
 [<ffffffff81248f47>] ? avc_has_perm_noaudit+0x388/0x399
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff8104f2e8>] ? sched_clock+0x9/0xd
 [<ffffffff81007dcb>] kvm_vm_ioctl+0x36c/0x3a2
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff8104f2e8>] ? sched_clock+0x9/0xd
 [<ffffffff81174b10>] do_vfs_ioctl+0x49e/0x4e4
 [<ffffffff81174bb0>] sys_ioctl+0x5a/0x7c
 [<ffffffff81500e02>] system_call_fastpath+0x16/0x1b
RIP  [<ffffffff81072d13>] gup_huge_pud+0xf2/0x159

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org> # 3.0.x
Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 mm/hugetlb.c    |    1 +
 mm/page_alloc.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bb28a5f..73f17c0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -576,6 +576,7 @@ static void prep_compound_gigantic_page(struct page *page, unsigned long order)
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		__SetPageTail(p);
+		set_page_count(p, 0);
 		p->first_page = page;
 	}
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9dd443d..850009a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -356,8 +356,8 @@ void prep_compound_page(struct page *page, unsigned long order)
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
-
 		__SetPageTail(p);
+		set_page_count(p, 0);
 		p->first_page = page;
 	}
 }
-- 
1.6.4.2

