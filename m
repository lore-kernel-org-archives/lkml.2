Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab1KYGIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 01:08:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:11111 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab1KYGIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 01:08:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,569,1315206000"; 
   d="scan'208";a="79020975"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        aarcange@redhat.com, wli@holomorphy.com
Cc: david.woodhouse@intel.com, allen.m.kay@intel.com, mtosatti@redhat.com,
        chrisw@redhat.com, andi@firstfloor.org, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 1/2] thp: Add compound tail page _mapcount when mapped
Date: Fri, 25 Nov 2011 13:47:09 +0800
Message-Id: <1322200030-26350-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.2-rc kernel, the IOMMU 2M page in KVM works. While I try to us IOMMU
1GB page in KVM, I encounter a oops and 1GB page total fail to be used.
The root cause is that 1GB page allocation calls gup_huge_pud() while 2M
 page calls gup_huge_pmd. If compound pages are used and the page is tail page,
gup_huge_pmd increase _mapcount to record tail page are mapped while
gup_huge_pud does not include this process. So when the mapped page is relesed,
it will result in kernel oops because the page does not mark mapped.

This patch add tail process for compound page in 1GB huge page which keeps the
same process as 2M page.

Reproduce like:
1. Add grub boot option: hugepagesz=1G hugepages=8
2. mount -t hugetlbfs -o pagesize=1G hugetlbfs /dev/hugepages
3.qemu-kvm -m 2048 -hda os-kvm.img -cpu kvm64 -smp 4 -mem-path /dev/hugepages
 -net none -device pci-assign,host=07:00.1

kernel BUG at mm/swap.c:114!
invalid opcode: 0000 [#1] SMP
Call Trace:
 [<ffffffff81127482>] put_page+0x15/0x37
 [<ffffffff810067c4>] kvm_release_pfn_clean+0x31/0x36
 [<ffffffff8100b69c>] kvm_iommu_put_pages+0x94/0xb1
 [<ffffffff8100b739>] kvm_iommu_unmap_memslots+0x80/0xb6
 [<ffffffff8100b6b9>] ? kvm_iommu_put_pages+0xb1/0xb1
 [<ffffffff81425cf3>] ? intel_iommu_attach_device+0x13b/0x144
 [<ffffffff8100bc03>] kvm_assign_device+0xba/0x117
 [<ffffffff8100aec2>] kvm_vm_ioctl_assigned_device+0x301/0xa47
 [<ffffffff8100ac6d>] ? kvm_vm_ioctl_assigned_device+0xac/0xa47
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff810b0be2>] ? sched_clock_cpu+0x45/0xd4
 [<ffffffff810bc430>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810b0cb2>] ? local_clock+0x41/0x5a
 [<ffffffff810bc881>] ? lock_release_holdtime+0x2c/0x129
 [<ffffffff8115760d>] ? cmpxchg_double_slab+0xd0/0x12b
 [<ffffffff81248f27>] ? avc_has_perm_noaudit+0x388/0x399
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff8104f2e8>] ? sched_clock+0x9/0xd
 [<ffffffff81007dcb>] kvm_vm_ioctl+0x36c/0x3a2
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff8104f2e8>] ? sched_clock+0x9/0xd
 [<ffffffff81174af0>] do_vfs_ioctl+0x49e/0x4e4
 [<ffffffff81174b90>] sys_ioctl+0x5a/0x7c
 [<ffffffff81500dc2>] system_call_fastpath+0x16/0x1b
RIP  [<ffffffff811273d9>] put_compound_page+0xd4/0x168

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 arch/x86/mm/gup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index ea30585..dd74e46 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -201,6 +201,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
+		if (PageTail(page))
+			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
-- 
1.6.4.2

