Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab0JVS56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:57:58 -0400
Received: from kroah.org ([198.145.64.141]:34518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759568Ab0JVS5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:19 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:36 2010
Message-Id: <20101022185236.538650794@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:52:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Bader <stefan.bader@canonical.com>
Subject: [103/103] mm: Move vma_stack_continue into mm.h
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit 39aa3cb3e8250db9188a6f1e3fb62ffa1a717678 upstream.

So it can be used by all that need to check for that.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |    3 ++-
 include/linux/mm.h |    6 ++++++
 mm/mlock.c         |    6 ------
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -224,7 +224,8 @@ static void show_map_vma(struct seq_file
 	/* We don't show the stack guard page in /proc/maps */
 	start = vma->vm_start;
 	if (vma->vm_flags & VM_GROWSDOWN)
-		start += PAGE_SIZE;
+		if (!vma_stack_continue(vma->vm_prev, vma->vm_start))
+			start += PAGE_SIZE;
 
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 			start,
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -863,6 +863,12 @@ int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
+/* Is the vma a continuation of the stack vma above it? */
+static inline int vma_stack_continue(struct vm_area_struct *vma, unsigned long addr)
+{
+	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
+}
+
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len);
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -135,12 +135,6 @@ void munlock_vma_page(struct page *page)
 	}
 }
 
-/* Is the vma a continuation of the stack vma above it? */
-static inline int vma_stack_continue(struct vm_area_struct *vma, unsigned long addr)
-{
-	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
-}
-
 static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
 {
 	return (vma->vm_flags & VM_GROWSDOWN) &&


