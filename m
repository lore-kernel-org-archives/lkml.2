Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2J2K4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:56:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2J2K4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:56:48 -0400
Date: Mon, 29 Oct 2012 03:56:13 -0700
From: tip-bot for Johannes Weiner <hannes@cmpxchg.org>
Message-ID: <tip-9db1bdb2eaa80a787f55806603b38d0068a89f1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        hannes@cmpxchg.org, riel@redhat.com, akpm@linux-foundation.org,
        aarcange@redhat.com, zliu@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        hannes@cmpxchg.org, riel@redhat.com, akpm@linux-foundation.org,
        zliu@redhat.com, aarcange@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched, numa, mm:
  Add memcg support to do_huge_pmd_numa_page()
Git-Commit-ID: 9db1bdb2eaa80a787f55806603b38d0068a89f1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 29 Oct 2012 03:56:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9db1bdb2eaa80a787f55806603b38d0068a89f1e
Gitweb:     http://git.kernel.org/tip/9db1bdb2eaa80a787f55806603b38d0068a89f1e
Author:     Johannes Weiner <hannes@cmpxchg.org>
AuthorDate: Thu, 25 Oct 2012 12:49:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 29 Oct 2012 07:54:23 +0100

sched, numa, mm: Add memcg support to do_huge_pmd_numa_page()

Add memory control group support to hugepage migration.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Zhouping Liu <zliu@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-rDk9mgpoyhZlwh2xhlykvgnp@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7361fd9..1fc805e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -742,6 +742,7 @@ void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			   unsigned int flags, pmd_t entry)
 {
 	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct mem_cgroup *memcg = NULL;
 	struct page *new_page = NULL;
 	struct page *page = NULL;
 	int node, lru;
@@ -832,6 +833,14 @@ migrate:
 
 		return;
 	}
+	/*
+	 * Traditional migration needs to prepare the memcg charge
+	 * transaction early to prevent the old page from being
+	 * uncharged when installing migration entries.  Here we can
+	 * save the potential rollback and start the charge transfer
+	 * only when migration is already known to end successfully.
+	 */
+	mem_cgroup_prepare_migration(page, new_page, &memcg);
 
 	entry = mk_pmd(new_page, vma->vm_page_prot);
 	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
@@ -842,6 +851,12 @@ migrate:
 	set_pmd_at(mm, haddr, pmd, entry);
 	update_mmu_cache_pmd(vma, address, entry);
 	page_remove_rmap(page);
+	/*
+	 * Finish the charge transaction under the page table lock to
+	 * prevent split_huge_page() from dividing up the charge
+	 * before it's fully transferred to the new page.
+	 */
+	mem_cgroup_end_migration(memcg, page, new_page, true);
 	spin_unlock(&mm->page_table_lock);
 
 	put_page(page);			/* Drop the rmap reference */
