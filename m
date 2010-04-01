Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0DAGFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:05:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59322 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0DAGFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:05:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
Cc: kosaki.motohiro@jp.fujitsu.com, Matt Mackall <mpm@selenic.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, n-horiguchi@ah.jp.nec.com
In-Reply-To: <20100401145509.47f7f1c3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100401144329.BE42.A69D9226@jp.fujitsu.com> <20100401145509.47f7f1c3.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20100401150128.BE45.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Apr 2010 15:05:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I just recommend simply do double buffering.
> > 
> Like this ?
> CC'ed Horiguchi, he touched hugepage part of this code recently.

I like this patch. but I have few comment.

> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> In initial design, walk_page_range() was designed just for walking page table and
> it didn't require mmap_sem. Now, find_vma() etc.. are used in walk_page_range()
> and we need mmap_sem around it.
> 
> This patch adds mmap_sem around walk_page_range().
> 
> Because /proc/<pid>/pagemap's callback routine use put_user(), we have to get
> rid of it to do sane fix.
> 
> Reported-by: San Mehat <san@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  fs/proc/task_mmu.c |   89 ++++++++++++++++++++++-------------------------------
>  1 file changed, 38 insertions(+), 51 deletions(-)
> 
> Index: linux-2.6.34-rc3/fs/proc/task_mmu.c
> ===================================================================
> --- linux-2.6.34-rc3.orig/fs/proc/task_mmu.c
> +++ linux-2.6.34-rc3/fs/proc/task_mmu.c
> @@ -406,8 +406,11 @@ static int show_smap(struct seq_file *m,
>  
>  	memset(&mss, 0, sizeof mss);
>  	mss.vma = vma;
> -	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
> +	if (vma->vm_mm && !is_vm_hugetlb_page(vma)) {
> +		down_read(&vma->vm_mm->mmap_sem);
>  		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
> +		up_read(&vma->vm_mm->mmap_sem);
> +	}

m_start already take mmap_sem. then I don't think this part is necessary.


>  
>  	show_map_vma(m, vma);
>  
> @@ -552,7 +555,8 @@ const struct file_operations proc_clear_
>  };
>  
>  struct pagemapread {
> -	u64 __user *out, *end;
> +	int pos, len;
> +	u64 *buffer;
>  };
>  
>  #define PM_ENTRY_BYTES      sizeof(u64)
> @@ -575,10 +579,8 @@ struct pagemapread {
>  static int add_to_pagemap(unsigned long addr, u64 pfn,
>  			  struct pagemapread *pm)
>  {
> -	if (put_user(pfn, pm->out))
> -		return -EFAULT;
> -	pm->out++;
> -	if (pm->out >= pm->end)
> +	pm->buffer[pm->pos++] = pfn;
> +	if (pm->pos >= pm->len)
>  		return PM_END_OF_BUFFER;
>  	return 0;
>  }
> @@ -720,21 +722,20 @@ static int pagemap_hugetlb_range(pte_t *
>   * determine which areas of memory are actually mapped and llseek to
>   * skip over unmapped regions.
>   */
> +#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
>  static ssize_t pagemap_read(struct file *file, char __user *buf,
>  			    size_t count, loff_t *ppos)
>  {
>  	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
> -	struct page **pages, *page;
> -	unsigned long uaddr, uend;
>  	struct mm_struct *mm;
>  	struct pagemapread pm;
> -	int pagecount;
>  	int ret = -ESRCH;
>  	struct mm_walk pagemap_walk = {};
>  	unsigned long src;
>  	unsigned long svpfn;
>  	unsigned long start_vaddr;
>  	unsigned long end_vaddr;
> +	int copied = 0;
>  
>  	if (!task)
>  		goto out;
> @@ -757,34 +758,10 @@ static ssize_t pagemap_read(struct file 
>  	if (!mm)
>  		goto out_task;
>  
> -
> -	uaddr = (unsigned long)buf & PAGE_MASK;
> -	uend = (unsigned long)(buf + count);
> -	pagecount = (PAGE_ALIGN(uend) - uaddr) / PAGE_SIZE;
> -	ret = 0;
> -	if (pagecount == 0)
> +	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
> +	pm.buffer = kmalloc(pm.len, GFP_KERNEL);

In /proc interface, GFP_TEMPORARY is recommened rather than GFP_KERNEL.
it help to prevent unnecessary external fragmentation.


> +	if (!pm.buffer)
>  		goto out_mm;
> -	pages = kcalloc(pagecount, sizeof(struct page *), GFP_KERNEL);
> -	ret = -ENOMEM;
> -	if (!pages)
> -		goto out_mm;
> -
> -	down_read(&current->mm->mmap_sem);
> -	ret = get_user_pages(current, current->mm, uaddr, pagecount,
> -			     1, 0, pages, NULL);
> -	up_read(&current->mm->mmap_sem);
> -
> -	if (ret < 0)
> -		goto out_free;
> -
> -	if (ret != pagecount) {
> -		pagecount = ret;
> -		ret = -EFAULT;
> -		goto out_pages;
> -	}
> -
> -	pm.out = (u64 __user *)buf;
> -	pm.end = (u64 __user *)(buf + count);
>  
>  	pagemap_walk.pmd_entry = pagemap_pte_range;
>  	pagemap_walk.pte_hole = pagemap_pte_hole;
> @@ -807,23 +784,33 @@ static ssize_t pagemap_read(struct file 
>  	 * user buffer is tracked in "pm", and the walk
>  	 * will stop when we hit the end of the buffer.
>  	 */
> -	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
> -	if (ret == PM_END_OF_BUFFER)
> -		ret = 0;
> -	/* don't need mmap_sem for these, but this looks cleaner */
> -	*ppos += (char __user *)pm.out - buf;
> -	if (!ret)
> -		ret = (char __user *)pm.out - buf;
> -
> -out_pages:
> -	for (; pagecount; pagecount--) {
> -		page = pages[pagecount-1];
> -		if (!PageReserved(page))
> -			SetPageDirty(page);
> -		page_cache_release(page);
> +	while (count && (start_vaddr < end_vaddr)) {
> +		int len;
> +		unsigned long end;
> +		pm.pos = 0;
> +		start_vaddr += PAGEMAP_WALK_SIZE;
> +		end = start_vaddr + PAGEMAP_WALK_SIZE;
> +		down_read(&mm->mmap_sem);
> +		ret = walk_page_range(start_vaddr, end, &pagemap_walk);
> +		up_read(&mm->mmap_sem);
> +
> +		len = PM_ENTRY_BYTES * pm.pos;
> +		if (len > count)
> +			len = count;
> +		if (copy_to_user((char __user *)buf, pm.buffer, len) < 0) {
> +			ret = -EFAULT;
> +			goto out_free;
> +		}
> +		copied += len;
> +		buf += len;
> +		count -= len;
>  	}
> +	*ppos += copied;
> +	if (!ret || ret == PM_END_OF_BUFFER)
> +		ret = copied;
> +
>  out_free:
> -	kfree(pages);
> +	kfree(pm.buffer);
>  out_mm:
>  	mmput(mm);
>  out_task:
> 



