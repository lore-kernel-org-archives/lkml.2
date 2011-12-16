Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889Ab1LPTwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:52:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791Ab1LPTvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:51:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:08 2011
Message-Id: <20111216194208.548776916@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Youquan Song <youquan.song@intel.com>
Subject: [11/45] thp: set compound tail page _count to zero
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youquan Song <youquan.song@intel.com>

commit 58a84aa92723d1ac3e1cc4e3b0ff49291663f7e1 upstream.

Commit 70b50f94f1644 ("mm: thp: tail page refcounting fix") keeps all
page_tail->_count zero at all times.  But the current kernel does not
set page_tail->_count to zero if a 1GB page is utilized.  So when an
IOMMU 1GB page is used by KVM, it wil result in a kernel oops because a
tail page's _count does not equal zero.

  kernel BUG at include/linux/mm.h:386!
  invalid opcode: 0000 [#1] SMP
  Call Trace:
    gup_pud_range+0xb8/0x19d
    get_user_pages_fast+0xcb/0x192
    ? trace_hardirqs_off+0xd/0xf
    hva_to_pfn+0x119/0x2f2
    gfn_to_pfn_memslot+0x2c/0x2e
    kvm_iommu_map_pages+0xfd/0x1c1
    kvm_iommu_map_memslots+0x7c/0xbd
    kvm_iommu_map_guest+0xaa/0xbf
    kvm_vm_ioctl_assigned_device+0x2ef/0xa47
    kvm_vm_ioctl+0x36c/0x3a2
    do_vfs_ioctl+0x49e/0x4e4
    sys_ioctl+0x5a/0x7c
    system_call_fastpath+0x16/0x1b
  RIP  gup_huge_pud+0xf2/0x159

Signed-off-by: Youquan Song <youquan.song@intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c    |    1 +
 mm/page_alloc.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -575,6 +575,7 @@ static void prep_compound_gigantic_page(
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		__SetPageTail(p);
+		set_page_count(p, 0);
 		p->first_page = page;
 	}
 }
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -355,8 +355,8 @@ void prep_compound_page(struct page *pag
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
-
 		__SetPageTail(p);
+		set_page_count(p, 0);
 		p->first_page = page;
 	}
 }


