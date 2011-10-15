Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1JOTFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:05:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab1JOTFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:05:40 -0400
Date: Sat, 15 Oct 2011 21:01:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/X] uprobes: xol_add_vma: fix ->uprobes_xol_area
	initialization
Message-ID: <20111015190113.GD30243@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111015190007.GA30243@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xol_add_vma() can race with another thread which sets ->uprobes_xol_area,
in this case we can't rely on per-thread task_lock() and we should unmap
xol_vma.

Move the setting of mm->uprobes_xol_area into xol_add_vma(), it has to
take mmap_sem for writing anyway, this also simplifies the code.

Change xol_add_vma() to do do_munmap() if it fails after do_mmap_pgoff().
---
 kernel/uprobes.c |   34 ++++++++++++++++------------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index fd9c8e3..6fe2b20 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1049,18 +1049,18 @@ static int xol_add_vma(struct uprobes_xol_area *area)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	unsigned long addr;
-	int ret = -ENOMEM;
+	int ret;
 
 	mm = get_task_mm(current);
 	if (!mm)
 		return -ESRCH;
 
 	down_write(&mm->mmap_sem);
-	if (mm->uprobes_xol_area) {
-		ret = -EALREADY;
+	ret = -EALREADY;
+	if (mm->uprobes_xol_area)
 		goto fail;
-	}
 
+	ret = -ENOMEM;
 	/*
 	 * Find the end of the top mapping and skip a page.
 	 * If there is no space for PAGE_SIZE above
@@ -1078,15 +1078,19 @@ static int xol_add_vma(struct uprobes_xol_area *area)
 
 	if (addr & ~PAGE_MASK)
 		goto fail;
-	vma = find_vma(mm, addr);
 
+	vma = find_vma(mm, addr);
 	/* Don't expand vma on mremap(). */
 	vma->vm_flags |= VM_DONTEXPAND | VM_DONTCOPY;
 	area->vaddr = vma->vm_start;
 	if (get_user_pages(current, mm, area->vaddr, 1, 1, 1, &area->page,
-				&vma) > 0)
-		ret = 0;
+				&vma) != 1) {
+		do_munmap(mm, addr, PAGE_SIZE);
+		goto fail;
+	}
 
+	mm->uprobes_xol_area = area;
+	ret = 0;
 fail:
 	up_write(&mm->mmap_sem);
 	mmput(mm);
@@ -1102,7 +1106,7 @@ fail:
  */
 static struct uprobes_xol_area *xol_alloc_area(void)
 {
-	struct uprobes_xol_area *area = NULL;
+	struct uprobes_xol_area *area;
 
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
@@ -1110,22 +1114,16 @@ static struct uprobes_xol_area *xol_alloc_area(void)
 
 	area->bitmap = kzalloc(BITS_TO_LONGS(UINSNS_PER_PAGE) * sizeof(long),
 								GFP_KERNEL);
-
 	if (!area->bitmap)
 		goto fail;
 
 	init_waitqueue_head(&area->wq);
 	spin_lock_init(&area->slot_lock);
-	if (!xol_add_vma(area) && !current->mm->uprobes_xol_area) {
-		task_lock(current);
-		if (!current->mm->uprobes_xol_area) {
-			current->mm->uprobes_xol_area = area;
-			task_unlock(current);
-			return area;
-		}
-		task_unlock(current);
-	}
 
+	if (xol_add_vma(area))
+		goto fail;
+
+	return area;
 fail:
 	kfree(area->bitmap);
 	kfree(area);
-- 
1.5.5.1


