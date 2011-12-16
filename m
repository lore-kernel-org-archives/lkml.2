Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651Ab1LPUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:09:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760245Ab1LPTsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:48:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:56 2011
Message-Id: <20111216194556.124725446@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Youquan Song <youquan.song@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [13/53] thp: add compound tail page _mapcount when mapped
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youquan Song <youquan.song@intel.com>

commit b6999b19120931ede364fa3b685e698a61fed31d upstream.

With the 3.2-rc kernel, IOMMU 2M pages in KVM works.  But when I tried
to use IOMMU 1GB pages in KVM, I encountered an oops and the 1GB page
failed to be used.

The root cause is that 1GB page allocation calls gup_huge_pud() while 2M
page calls gup_huge_pmd.  If compound pages are used and the page is a
tail page, gup_huge_pmd() increases _mapcount to record tail page are
mapped while gup_huge_pud does not do that.

So when the mapped page is relesed, it will result in kernel oops
because the page is not marked mapped.

This patch add tail process for compound page in 1GB huge page which
keeps the same process as 2M page.

Reproduce like:
1. Add grub boot option: hugepagesz=1G hugepages=8
2. mount -t hugetlbfs -o pagesize=1G hugetlbfs /dev/hugepages
3. qemu-kvm -m 2048 -hda os-kvm.img -cpu kvm64 -smp 4 -mem-path /dev/hugepages
	-net none -device pci-assign,host=07:00.1

  kernel BUG at mm/swap.c:114!
  invalid opcode: 0000 [#1] SMP
  Call Trace:
    put_page+0x15/0x37
    kvm_release_pfn_clean+0x31/0x36
    kvm_iommu_put_pages+0x94/0xb1
    kvm_iommu_unmap_memslots+0x80/0xb6
    kvm_assign_device+0xba/0x117
    kvm_vm_ioctl_assigned_device+0x301/0xa47
    kvm_vm_ioctl+0x36c/0x3a2
    do_vfs_ioctl+0x49e/0x4e4
    sys_ioctl+0x5a/0x7c
    system_call_fastpath+0x16/0x1b
  RIP  put_compound_page+0xd4/0x168

Signed-off-by: Youquan Song <youquan.song@intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -201,6 +201,8 @@ static noinline int gup_huge_pud(pud_t p
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
+		if (PageTail(page))
+			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;


