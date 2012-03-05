Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2CEAxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:53:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab2CEAxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:53:02 -0500
Date: Sun, 4 Mar 2012 19:52:03 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fix bug introduced in "mm: simplify find_vma_prev()"
Message-ID: <Pine.LNX.4.64.1203041946430.3487@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch fixes a bug introduced in "mm: simplify find_vma_prev()". You 
can apply this, or alternatively revert the original patch.

Mikulas

---

mm: fix find_vma_prev

The commit mm: simplify find_vma_prev()
[6bd4837de96e7d9f9bf33e59117c24fc230862ac] broke memory management on PA-RISC.

After application of the patch, programs that allocate big arrays on the stack
crash with segfault, for example, this will crash if compiled without
optimization:
int main()
{
	char array[200000];
	array[199999] = 0;
	return 0;
}

The reason is that PA-RISC has up-growing stack and the stack is usually the
last memory area. In the above example, a page fault happens above the stack.

Previously, if we passed too high address to find_vma_prev, it returned NULL
and stored the last VMA in *pprev. After "simplify find_vma_prev" change, it
stores NULL in *pprev. Consequently, the stack area is not found and it is
not expanded, as it used to be before the change.

This patch restores the old behavior and makes it return the last VMA in *pprev
if the requested address is higher than address of any other VMA.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 mm/mmap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-3.3-rc6-fast/mm/mmap.c
===================================================================
--- linux-3.3-rc6-fast.orig/mm/mmap.c	2012-03-05 01:25:52.000000000 +0100
+++ linux-3.3-rc6-fast/mm/mmap.c	2012-03-05 01:29:22.000000000 +0100
@@ -1605,7 +1605,6 @@ EXPORT_SYMBOL(find_vma);
 
 /*
  * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
- * Note: pprev is set to NULL when return value is NULL.
  */
 struct vm_area_struct *
 find_vma_prev(struct mm_struct *mm, unsigned long addr,
@@ -1614,7 +1613,16 @@ find_vma_prev(struct mm_struct *mm, unsi
 	struct vm_area_struct *vma;
 
 	vma = find_vma(mm, addr);
-	*pprev = vma ? vma->vm_prev : NULL;
+	if (vma) {
+		*pprev = vma->vm_prev;
+	} else {
+		struct rb_node *rb_node = mm->mm_rb.rb_node;
+		*pprev = NULL;
+		while (rb_node) {
+			*pprev = rb_entry(rb_node, struct vm_area_struct, vm_rb);
+			rb_node = rb_node->rb_right;
+		}
+	}
 	return vma;
 }
 
