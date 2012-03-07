Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab2CGA1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:27:24 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58446 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759311Ab2CGA1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:27:23 -0500
Message-ID: <4F56AB74.2080301@gmail.com>
Date: Tue, 06 Mar 2012 19:27:32 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [PATCH] fix bug introduced in "mm: simplify find_vma_prev()"
References: <Pine.LNX.4.64.1203041946430.3487@file.rdu.redhat.com> <CA+55aFzX9Nj_jSdFR6PJO-G4MPi7R13TLHAxwzZo9C0MHNRBfw@mail.gmail.com> <Pine.LNX.4.64.1203061326120.22195@file.rdu.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1203061326120.22195@file.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(3/6/12 1:57 PM), Mikulas Patocka wrote:
>
>
> On Sun, 4 Mar 2012, Linus Torvalds wrote:
>
>> On Sun, Mar 4, 2012 at 4:52 PM, Mikulas Patocka<mpatocka@redhat.com>  wrote:
>>>
>>> This patch fixes a bug introduced in "mm: simplify find_vma_prev()". You
>>> can apply this, or alternatively revert the original patch.
>>
>> Hmm.
>>
>> I realize the patch is a bug-fix, but I do wonder if we shouldn't look
>> at alternatives.
>>
>> In particular, how about we just change the rule to be clearer, and
>> make the rule be:
>>
>>   - no more find_vma_prev() AT ALL.
>>
>>   - callers get turned into "find_vma()" and then we have a
>> "vma_prev()", which basically does your thing.
>>
>>   - many of the callers seem to be interested in "prev" *only* if they
>> found a vma. For example, the do_mlock() kind of logic seems to be
>> common:
>>
>>      vma = find_vma_prev(current->mm, start,&prev);
>>      if (!vma || vma->vm_start>  start)
>>          return -ENOMEM;
>>
>>     which implies that the current find_vma_prev() semantics are really
>> wrong, because they force us to do extra work in this case where we
>> really really don't care about the result.
>>
>> So we could do an entirely mechanical conversion of
>>
>>     vma = find_vma_prev(mm, address,&prev_vma);
>>
>> into
>>
>>     vma = find_vma(mm, address);
>>     prev_vma = vma_prev(vma);
>>
>> and then after we've done that conversion, it looks like the bulk of
>> them will not care about "prev_vma" if vma is NULL, so they can then
>> be replaced with a pure
>>
>>     prev_vma = vma->vm_prev;
>>
>> instead. Leaving just the (few) cases that may care about the
>> "previous vma may be the last vma of the VM" case.
>>
>> Hmm? And we'd get away from that horrible "find_vma_prev()" interface
>> that uses pointers to vma pointers for return values. Ugh. There only
>> seems to be nine callers in the whole kernel.
>>
>>                   Linus
>
> You can try this to remove most users of find_vma_prev (only three are
> left --- those dealing with up-growing stack). But the patch should be
> delayed until the next merge window.
>
> Mikulas
>

Thank you, Mikulas for finding and fixing the bug. And sorry for the long
delay. I was offlined a while.

Following is the replacing last three caller of find_vma_prev. oh, I use
find_last_vma() instead vma_prev(vma) because parisc need last vma search
when Milulas's original testcase. Does this make sense to you? if yes, we
can remove find_vma_prev() completely.



=========================
Subject: [PATCH] mm: introduce find_last_vma()

Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
  arch/ia64/mm/fault.c   |   20 +++++++++++++-------
  arch/parisc/mm/fault.c |    6 +++---
  include/linux/mm.h     |    3 +++
  mm/mmap.c              |   32 +++++++++++++++++++++++++++++++-
  4 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/mm/fault.c b/arch/ia64/mm/fault.c
index 20b3593..27ca30c 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -112,18 +112,16 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
  
  	down_read(&mm->mmap_sem);
  
-	vma = find_vma_prev(mm, address, &prev_vma);
-	if (!vma && !prev_vma )
-		goto bad_area;
+	vma = find_vma(mm, address);
  
-        /*
-         * find_vma_prev() returns vma such that address < vma->vm_end or NULL
+	/*
+         * find_vma() returns vma such that address < vma->vm_end or NULL
           *
           * May find no vma, but could be that the last vm area is the
           * register backing store that needs to expand upwards, in
-         * this case vma will be null, but prev_vma will ne non-null
+         * this case vma will be null and a stack need to be expanded.
           */
-        if (( !vma && prev_vma ) || (address < vma->vm_start) )
+	if (!vma || (address < vma->vm_start))
  		goto check_expansion;
  
    good_area:
@@ -177,6 +175,14 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
  	return;
  
    check_expansion:
+	if (vma)
+		prev_vma = vma->vm_prev;
+	else {
+		prev_vma = find_last_vma(mm);
+		if (!prev_vma)
+			goto bad_area;
+	}
+
  	if (!(prev_vma && (prev_vma->vm_flags & VM_GROWSUP) && (address == prev_vma->vm_end))) {
  		if (!vma)
  			goto bad_area;
diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index 18162ce..7b5a466 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -170,7 +170,7 @@ int fixup_exception(struct pt_regs *regs)
  void do_page_fault(struct pt_regs *regs, unsigned long code,
  			      unsigned long address)
  {
-	struct vm_area_struct *vma, *prev_vma;
+	struct vm_area_struct *vma;
  	struct task_struct *tsk = current;
  	struct mm_struct *mm = tsk->mm;
  	unsigned long acc_type;
@@ -180,7 +180,7 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
  		goto no_context;
  
  	down_read(&mm->mmap_sem);
-	vma = find_vma_prev(mm, address, &prev_vma);
+	vma = find_vma(mm, address);
  	if (!vma || address < vma->vm_start)
  		goto check_expansion;
  /*
@@ -222,7 +222,7 @@ good_area:
  	return;
  
  check_expansion:
-	vma = prev_vma;
+	vma = vma ? vma->vm_prev : find_last_vma(mm);
  	if (vma && (expand_stack(vma, address) == 0))
  		goto good_area;
  
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17b27cd..d758818 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1463,6 +1463,9 @@ extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
  
  /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
  extern struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr);
+#if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
+extern struct vm_area_struct *find_last_vma(struct mm_struct *mm);
+#endif
  extern struct vm_area_struct * find_vma_prev(struct mm_struct * mm, unsigned long addr,
  					     struct vm_area_struct **pprev);
  
diff --git a/mm/mmap.c b/mm/mmap.c
index 22e1a0b..3e9c186 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1605,6 +1605,32 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
  
  EXPORT_SYMBOL(find_vma);
  
+#if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
+/* Look up the last VMA,  NULL if mm have no vma. */
+struct vm_area_struct *find_last_vma(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma = NULL;
+	struct rb_node *rb_node;
+
+	BUG_ON(!mm);
+
+	rb_node = mm->mm_rb.rb_node;
+	while (rb_node) {
+		vma = rb_entry(rb_node, struct vm_area_struct, vm_rb);
+		rb_node = rb_node->rb_right;
+	}
+
+	/*
+	 * This function is mainly used for a page fault. Thus recording vma
+	 * may improve the performance.
+	 */
+	if (vma)
+		mm->mmap_cache = vma;
+
+	return vma;
+}
+#endif
+
  /*
   * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
   * Note: pprev is set to NULL when return value is NULL.
@@ -1789,9 +1815,13 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
  	struct vm_area_struct *vma, *prev;
  
  	addr &= PAGE_MASK;
-	vma = find_vma_prev(mm, addr, &prev);
+	vma = find_vma(mm, addr);
  	if (vma && (vma->vm_start <= addr))
  		return vma;
+
+	prev = vma->vm_prev;
+	if (!prev)
+		prev = find_last_vma(mm);
  	if (!prev || expand_stack(prev, addr))
  		return NULL;
  	if (prev->vm_flags & VM_LOCKED) {
-- 
1.7.1


