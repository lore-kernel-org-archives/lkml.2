Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916Ab2JREHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 00:07:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41061 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2JREHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 00:07:12 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <507F803A.8000900@jp.fujitsu.com>
Date: Thu, 18 Oct 2012 13:06:18 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.7 v2] mm, mempolicy: avoid taking mutex inside spinlock
 when reading numa_maps
References: <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com> <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com> <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com> <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com> <20121017040515.GA13505@redhat.com> <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com> <20121017181413.GA16805@redhat.com> <alpine.DEB.2.00.1210171219010.28214@chino.kir.corp.google.com> <20121017193229.GC16805@redhat.com> <alpine.DEB.2.00.1210171237130.28214@chino.kir.corp.google.com> <20121017194501.GA24400@redhat.com> <alpine.DEB.2.00.1210171318400.28214@chino.kir.corp.google.com> <alpine.DEB.2.00.1210171428540.20712@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210171428540.20712@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/18 6:31), David Rientjes wrote:
> As a result of commit 32f8516a8c73 ("mm, mempolicy: fix printing stack
> contents in numa_maps"), the mutex protecting a shared policy can be
> inadvertently taken while holding task_lock(task).
>
> Recently, commit b22d127a39dd ("mempolicy: fix a race in
> shared_policy_replace()") switched the spinlock within a shared policy to
> a mutex so sp_alloc() could block.  Thus, a refcount must be grabbed on
> all mempolicies returned by get_vma_policy() so it isn't freed while being
> passed to mpol_to_str() when reading /proc/pid/numa_maps.
>
> This patch only takes task_lock() while dereferencing task->mempolicy in
> get_vma_policy() if it's non-NULL in the lockess check to increment its
> refcount.  This ensures it will remain in memory until dropped by
> __mpol_put() after mpol_to_str() is called.
>
> Refcounts of shared policies are grabbed by the ->get_policy() function of
> the vma, all others will be grabbed directly in get_vma_policy().  Now
> that this is done, all callers now unconditionally drop the refcount.
>

please add original problem description....

from your 1st patch.
> When reading /proc/pid/numa_maps, it's possible to return the contents of
> the stack where the mempolicy string should be printed if the policy gets
> freed from beneath us.
>
> This happens because mpol_to_str() may return an error the
> stack-allocated buffer is then printed without ever being stored.
.....

Hmm, I've read the whole thread again...and, I'm sorry if I misunderstand something.

I think Kosaki mentioned the commit 52cd3b0740. It avoids refcounting in get_vma_policy()
because it's called every time alloc_pages_vma() is called, at every page fault.
So, it seems he doesn't agree this fix because of performance concern on big NUMA,


Can't we have another way to fix ? like this ? too ugly ?
Again, I'm sorry if I misunderstand the points.

==

 From bfe7e2ab1c1375b134ec12efce6517149318f75d Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 18 Oct 2012 13:17:25 +0900
Subject: [PATCH] hold task->mempolicy while numa_maps scans.

  /proc/<pid>/numa_maps scans vma and show mempolicy under
  mmap_sem. It sometimes accesses task->mempolicy which can
  be freed without mmap_sem and numa_maps can show some
  garbage while scanning.

This patch tries to take reference count of task->mempolicy at reading
numa_maps before calling get_vma_policy(). By this, task->mempolicy
will not be freed until numa_maps reaches its end.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
  fs/proc/task_mmu.c |   20 ++++++++++++++++++++
  1 file changed, 20 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 14df880..d92e868 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -94,6 +94,11 @@ static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
  {
  	if (vma && vma != priv->tail_vma) {
  		struct mm_struct *mm = vma->vm_mm;
+#ifdef CONFIG_NUMA
+		task_lock(priv->task);
+		__mpol_put(priv->task->mempolicy);
+		task_unlock(priv->task);
+#endif
  		up_read(&mm->mmap_sem);
  		mmput(mm);
  	}
@@ -130,6 +135,16 @@ static void *m_start(struct seq_file *m, loff_t *pos)
  		return mm;
  	down_read(&mm->mmap_sem);
  
+	/*
+	 * task->mempolicy can be freed even if mmap_sem is down (see kernel/exit.c)
+	 * We grab refcount for stable access.
+	 * repleacement of task->mmpolicy is guarded by mmap_sem.
+	 */
+#ifdef CONFIG_NUMA
+	task_lock(priv->task);
+	mpol_get(priv->task->mempolicy);
+	task_unlock(priv->task);
+#endif
  	tail_vma = get_gate_vma(priv->task->mm);
  	priv->tail_vma = tail_vma;
  
@@ -161,6 +176,11 @@ out:
  
  	/* End of vmas has been reached */
  	m->version = (tail_vma != NULL)? 0: -1UL;
+#ifdef CONFIG_NUMA
+	task_lock(priv->task);
+	__mpol_put(priv->task->mempolicy);
+	task_unlock(priv->task);
+#endif
  	up_read(&mm->mmap_sem);
  	mmput(mm);
  	return tail_vma;
-- 
1.7.10.2













