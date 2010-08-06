Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066Ab0HFT1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:27:47 -0400
Received: from kroah.org ([198.145.64.141]:43453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab0HFT1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:27:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:14 2010
Message-Id: <20100806192114.528469832@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:19:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>
Subject: [01/36] mm: fix ia64 crash when gcore reads gate area
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit de51257aa301652876ab6e8f13ea4eadbe4a3846 upstream.

Debian's ia64 autobuilders have been seeing kernel freeze or reboot
when running the gdb testsuite (Debian bug 588574): dannf bisected to
2.6.32 62eede62dafb4a6633eae7ffbeb34c60dba5e7b1 "mm: ZERO_PAGE without
PTE_SPECIAL"; and reproduced it with gdb's gcore on a simple target.

I'd missed updating the gate_vma handling in __get_user_pages(): that
happens to use vm_normal_page() (nowadays failing on the zero page),
yet reported success even when it failed to get a page - boom when
access_process_vm() tried to copy that to its intermediate buffer.

Fix this, resisting cleanups: in particular, leave it for now reporting
success when not asked to get any pages - very probably safe to change,
but let's not risk it without testing exposure.

Why did ia64 crash with 16kB pages, but succeed with 64kB pages?
Because setup_gate() pads each 64kB of its gate area with zero pages.

Reported-by: Andreas Barth <aba@not.so.argh.org>
Bisected-by: dann frazier <dannf@debian.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: dann frazier <dannf@dannf.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1385,10 +1385,20 @@ int __get_user_pages(struct task_struct
 				return i ? : -EFAULT;
 			}
 			if (pages) {
-				struct page *page = vm_normal_page(gate_vma, start, *pte);
+				struct page *page;
+
+				page = vm_normal_page(gate_vma, start, *pte);
+				if (!page) {
+					if (!(gup_flags & FOLL_DUMP) &&
+					     is_zero_pfn(pte_pfn(*pte)))
+						page = pte_page(*pte);
+					else {
+						pte_unmap(pte);
+						return i ? : -EFAULT;
+					}
+				}
 				pages[i] = page;
-				if (page)
-					get_page(page);
+				get_page(page);
 			}
 			pte_unmap(pte);
 			if (vmas)


