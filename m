Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab0DBAPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 20:15:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42300 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0DBAP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 20:15:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Apr 2010 09:11:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Matt Mackall <mpm@selenic.com>, San Mehat <san@google.com>,
       linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, n-horiguchi@ah.jp.nec.com
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
Message-Id: <20100402091129.bca35057.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LFD.2.00.1004010747540.3707@i5.linux-foundation.org>
References: <20100401144329.BE42.A69D9226@jp.fujitsu.com>
	<20100401145509.47f7f1c3.kamezawa.hiroyu@jp.fujitsu.com>
	<20100401150128.BE45.A69D9226@jp.fujitsu.com>
	<20100401150956.4f6821c2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100401153428.d49c6345.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1004010747540.3707@i5.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010 08:10:40 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > +	while (count && (start_vaddr < end_vaddr)) {
> > +		int len;
> > +		unsigned long end;
> > +
> > +		pm.pos = 0;
> > +		end = min(start_vaddr + PAGEMAP_WALK_SIZE, end_vaddr);
> > +		down_read(&mm->mmap_sem);
> > +		ret = walk_page_range(start_vaddr, end, &pagemap_walk);
> > +		up_read(&mm->mmap_sem);
> > +		start_vaddr += PAGEMAP_WALK_SIZE;
> 
> I think "start_vaddr + PAGEMAP_WALK_SIZE" might overflow, and then 'end' 
> ends up being odd. You'll never notice on architectures where the user 
> space doesn't go all the way up to the end (walk_page_range will return 0 
> etc), but it will do the wrong thing if 'start' is close to the end, end 
> is _at_ the end, and you'll not be able to read that range (because of the 
> overflow).
> 
I didn't noticed that. thanks.

> So I do think you should do something like
> 
> 	end = start_vaddr + PAGEMAP_WALK_SIZE;
> 	/* overflow?  or final chunk? */
> 	if (end < start_vaddr || end > end_vaddr)
> 		end = end_vaddr;
> 
> instead of using 'min()'.
> 
Ok, here. now
	end = start_vaddr _ PAGEMAP_WALK_SIZE;
	if (end < start_vaddr || end > end_vaddr)
		end = end_vaddr;
	....walk....
	start_vaddr =end;

Only tested on x86-64. 
Thanks,
-Kame

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In initial design, walk_page_range() was designed just for walking page table and
it didn't require mmap_sem. Now, find_vma() etc.. are used in walk_page_range()
and we need mmap_sem around it.

This patch adds mmap_sem around walk_page_range().

Because /proc/<pid>/pagemap's callback routine use put_user(), we have to get
rid of it to do sane fix.

Changelog: 2010/Apr/2
 - fixed start_vaddr and end overflow
Changelog: 2010/Apr/1
 - fixed start_vaddr calculation
 - removed unnecessary cast.
 - removed unnecessary change in smaps.
 - use GFP_TEMPORARY instead of GFP_KERNEL

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/task_mmu.c |   87 ++++++++++++++++++++++-------------------------------
 1 file changed, 37 insertions(+), 50 deletions(-)

Index: linux-2.6.34-rc3/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.34-rc3.orig/fs/proc/task_mmu.c
+++ linux-2.6.34-rc3/fs/proc/task_mmu.c
@@ -406,6 +406,7 @@ static int show_smap(struct seq_file *m,
 
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
+	/* mmap_sem is held in m_start */
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
 
@@ -552,7 +553,8 @@ const struct file_operations proc_clear_
 };
 
 struct pagemapread {
-	u64 __user *out, *end;
+	int pos, len;
+	u64 *buffer;
 };
 
 #define PM_ENTRY_BYTES      sizeof(u64)
@@ -575,10 +577,8 @@ struct pagemapread {
 static int add_to_pagemap(unsigned long addr, u64 pfn,
 			  struct pagemapread *pm)
 {
-	if (put_user(pfn, pm->out))
-		return -EFAULT;
-	pm->out++;
-	if (pm->out >= pm->end)
+	pm->buffer[pm->pos++] = pfn;
+	if (pm->pos >= pm->len)
 		return PM_END_OF_BUFFER;
 	return 0;
 }
@@ -720,21 +720,20 @@ static int pagemap_hugetlb_range(pte_t *
  * determine which areas of memory are actually mapped and llseek to
  * skip over unmapped regions.
  */
+#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
 static ssize_t pagemap_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
-	struct page **pages, *page;
-	unsigned long uaddr, uend;
 	struct mm_struct *mm;
 	struct pagemapread pm;
-	int pagecount;
 	int ret = -ESRCH;
 	struct mm_walk pagemap_walk = {};
 	unsigned long src;
 	unsigned long svpfn;
 	unsigned long start_vaddr;
 	unsigned long end_vaddr;
+	int copied = 0;
 
 	if (!task)
 		goto out;
@@ -757,34 +756,10 @@ static ssize_t pagemap_read(struct file 
 	if (!mm)
 		goto out_task;
 
-
-	uaddr = (unsigned long)buf & PAGE_MASK;
-	uend = (unsigned long)(buf + count);
-	pagecount = (PAGE_ALIGN(uend) - uaddr) / PAGE_SIZE;
-	ret = 0;
-	if (pagecount == 0)
+	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
+	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
+	if (!pm.buffer)
 		goto out_mm;
-	pages = kcalloc(pagecount, sizeof(struct page *), GFP_KERNEL);
-	ret = -ENOMEM;
-	if (!pages)
-		goto out_mm;
-
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(current, current->mm, uaddr, pagecount,
-			     1, 0, pages, NULL);
-	up_read(&current->mm->mmap_sem);
-
-	if (ret < 0)
-		goto out_free;
-
-	if (ret != pagecount) {
-		pagecount = ret;
-		ret = -EFAULT;
-		goto out_pages;
-	}
-
-	pm.out = (u64 __user *)buf;
-	pm.end = (u64 __user *)(buf + count);
 
 	pagemap_walk.pmd_entry = pagemap_pte_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
@@ -807,23 +782,35 @@ static ssize_t pagemap_read(struct file 
 	 * user buffer is tracked in "pm", and the walk
 	 * will stop when we hit the end of the buffer.
 	 */
-	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
-	if (ret == PM_END_OF_BUFFER)
-		ret = 0;
-	/* don't need mmap_sem for these, but this looks cleaner */
-	*ppos += (char __user *)pm.out - buf;
-	if (!ret)
-		ret = (char __user *)pm.out - buf;
-
-out_pages:
-	for (; pagecount; pagecount--) {
-		page = pages[pagecount-1];
-		if (!PageReserved(page))
-			SetPageDirty(page);
-		page_cache_release(page);
+	while (count && (start_vaddr < end_vaddr)) {
+		int len;
+		unsigned long end;
+
+		pm.pos = 0;
+		end = start_vaddr + PAGEMAP_WALK_SIZE;
+		/* overflow ? */
+		if (end < start_vaddr || end > end_vaddr)
+			end = end_vaddr;
+		down_read(&mm->mmap_sem);
+		ret = walk_page_range(start_vaddr, end, &pagemap_walk);
+		up_read(&mm->mmap_sem);
+		start_vaddr = end;
+
+		len = min(count, PM_ENTRY_BYTES * pm.pos);
+		if (copy_to_user(buf, pm.buffer, len) < 0) {
+			ret = -EFAULT;
+			goto out_free;
+		}
+		copied += len;
+		buf += len;
+		count -= len;
 	}
+	*ppos += copied;
+	if (!ret || ret == PM_END_OF_BUFFER)
+		ret = copied;
+
 out_free:
-	kfree(pages);
+	kfree(pm.buffer);
 out_mm:
 	mmput(mm);
 out_task:




