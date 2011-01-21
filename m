Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1AUGwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:52:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41552 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1AUGwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:52:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Jan 2011 15:46:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 5/7] memcg : fix khugepaged scan of process under buzy memcg
Message-Id: <20110121154615.a433d843.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When using khugepaged with small memory cgroup, we see khugepaged
causes soft lockup, or running process under memcg will hang

It's because khugepaged tries to scan all pmd of a process
which is under busy/small memory cgroup and tries to allocate
HUGEPAGE size resource.

This work is done under mmap_sem and can cause memory reclaim
repeatedly. This will easily raise cpu usage of khugepaged and latecy
of scanned process will goes up. Moreover, it seems succesfully
working TransHuge pages may be splitted by this memory reclaim
caused by khugepaged.

This patch adds a hint for khugepaged whether a process is
under a memory cgroup which has sufficient memory. If memcg
seems busy, a process is skipped.

How to test:
  # mount -o cgroup cgroup /cgroup/memory -o memory
  # mkdir /cgroup/memory/A
  # echo 200M (or some small) > /cgroup/memory/A/memory.limit_in_bytes
  # echo 0 > /cgroup/memory/A/tasks
  # make -j 8 kernel

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    7 +++++++
 mm/huge_memory.c           |   11 ++++++++++-
 mm/memcontrol.c            |   44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 1 deletion(-)

Index: mmotm-0107/mm/memcontrol.c
===================================================================
--- mmotm-0107.orig/mm/memcontrol.c
+++ mmotm-0107/mm/memcontrol.c
@@ -255,6 +255,9 @@ struct mem_cgroup {
 	/* For oom notifier event fd */
 	struct list_head oom_notify;
 
+	/* For transparent hugepage daemon */
+	unsigned long long recent_failcnt;
+
 	/*
 	 * Should we move charges of a task when a task is moved into this
 	 * mem_cgroup ? And what type of charges should we move ?
@@ -2190,6 +2193,47 @@ void mem_cgroup_split_huge_fixup(struct 
 	tail_pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	move_unlock_page_cgroup(head_pc, &flags);
 }
+
+bool mem_cgroup_worth_try_hugepage_scan(struct mm_struct *mm)
+{
+	struct mem_cgroup *mem;
+	bool ret = true;
+	u64 recent_charge_fail;
+
+	if (mem_cgroup_disabled())
+		return true;
+
+	mem = try_get_mem_cgroup_from_mm(mm);
+
+	if (!mem)
+		return true;
+
+	if (mem_cgroup_is_root(mem))
+		goto out;
+
+	if (mem_cgroup_check_under_limit(mem, HPAGE_SIZE))
+		goto out;
+	/*
+	 * When memory cgroup is near to full, it's required to reclaim
+	 * memory for collapsing. This requirement of 'extra charge' at
+	 * splitting seems redundant but it's safe way for now.
+	 *
+	 * We return true when no one hit limits since we visit this mm before.
+	 *
+	 * TODO: This check is very naive. Some new good should be innovated.
+	 */
+	recent_charge_fail = res_counter_read_u64(&mem->res, RES_FAILCNT);
+	if (mem->recent_failcnt
+		&& recent_charge_fail > mem->recent_failcnt) {
+		ret = false;
+	}
+	/* because this thread will fail charge by itself +1.*/
+	mem->recent_failcnt = recent_charge_fail + 1;
+out:
+	css_put(&mem->css);
+	return ret;
+}
+
 #endif
 
 /**
Index: mmotm-0107/mm/huge_memory.c
===================================================================
--- mmotm-0107.orig/mm/huge_memory.c
+++ mmotm-0107/mm/huge_memory.c
@@ -2007,11 +2007,14 @@ static unsigned int khugepaged_scan_mm_s
 	spin_unlock(&khugepaged_mm_lock);
 
 	mm = mm_slot->mm;
+
 	down_read(&mm->mmap_sem);
 	if (unlikely(khugepaged_test_exit(mm)))
 		vma = NULL;
-	else
+	else if (mem_cgroup_worth_try_hugepage_scan(mm))
 		vma = find_vma(mm, khugepaged_scan.address);
+	else
+		vma = NULL;
 
 	progress++;
 	for (; vma; vma = vma->vm_next) {
@@ -2023,6 +2026,12 @@ static unsigned int khugepaged_scan_mm_s
 			break;
 		}
 
+		if (unlikely(!mem_cgroup_worth_try_hugepage_scan(mm))) {
+			progress++;
+			vma = NULL; /* try next mm */
+			break;
+		}
+
 		if ((!(vma->vm_flags & VM_HUGEPAGE) &&
 		     !khugepaged_always()) ||
 		    (vma->vm_flags & VM_NOHUGEPAGE)) {
Index: mmotm-0107/include/linux/memcontrol.h
===================================================================
--- mmotm-0107.orig/include/linux/memcontrol.h
+++ mmotm-0107/include/linux/memcontrol.h
@@ -148,6 +148,7 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
+bool mem_cgroup_worth_try_hugepage_scan(struct mm_struct *mm);
 #endif
 
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
@@ -341,6 +342,12 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 
 static inline mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
 {
+
+}
+
+static inline bool mem_cgroup_worth_try_hugepage_scan(struct mm_struct *mm)
+{
+	return true;
 }
 
 #endif /* CONFIG_CGROUP_MEM_CONT */

