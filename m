Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2JDKda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:33:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2JDKd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:33:27 -0400
Date: Thu, 4 Oct 2012 03:33:03 -0700
From: tip-bot for David Rientjes <rientjes@google.com>
Message-ID: <tip-d886931968a1c7e7bc7d4891cbd12cecf3111bd0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, riel@redhat.com,
        tglx@linutronix.de, rientjes@google.com
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.00.1210021312140.8537@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1210021312140.8537@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Fix build warning for UMA kernels
Git-Commit-ID: d886931968a1c7e7bc7d4891cbd12cecf3111bd0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 04 Oct 2012 03:33:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d886931968a1c7e7bc7d4891cbd12cecf3111bd0
Gitweb:     http://git.kernel.org/tip/d886931968a1c7e7bc7d4891cbd12cecf3111bd0
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Tue, 2 Oct 2012 13:14:10 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 4 Oct 2012 10:15:16 +0200

mm/mpol: Fix build warning for UMA kernels

Commit "mm, mpol: Use special PROT_NONE to migrate pages"
causes a build warning when CONFIG_NUMA is not enabled:

  mm/huge_memory.c: In function 'do_huge_pmd_prot_none':
  mm/huge_memory.c:745: warning: unused variable 'node'

"node" is only used once, so avoid using it altogether.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: pjt@google.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1210021312140.8537@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4a9ea86..2e2a814 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -768,7 +768,6 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 {
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 	struct page *page = NULL;
-	int node;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(*pmd, entry)))
@@ -791,8 +790,7 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * XXX should we serialize against split_huge_page ?
 	 */
 
-	node = mpol_misplaced(page, vma, haddr, mm->numa_big);
-	if (node == -1)
+	if (mpol_misplaced(page, vma, haddr, mm->numa_big) == -1)
 		goto do_fixup;
 
 	/*
