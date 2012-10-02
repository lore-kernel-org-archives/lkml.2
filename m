Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2JBUOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:14:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64713 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2JBUOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:14:12 -0400
Date: Tue, 2 Oct 2012 13:14:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de
cc: pjt@google.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: [patch sched/numa] mm/mpol: Fix build warning for UMA kernels
In-Reply-To: <tip-e98gyl8kr9jzooh2s4piuils@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1210021312140.8537@chino.kir.corp.google.com>
References: <tip-e98gyl8kr9jzooh2s4piuils@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"mm, mpol: Use special PROT_NONE to migrate pages" causes a build warning
when CONFIG_NUMA is not enabled:

mm/huge_memory.c: In function 'do_huge_pmd_prot_none':
mm/huge_memory.c:745: warning: unused variable 'node'

"node" is only used once, so avoid using it altogether.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/huge_memory.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -742,7 +742,6 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 {
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 	struct page *page = NULL;
-	int node;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(*pmd, entry)))
@@ -765,8 +764,7 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * XXX should we serialize against split_huge_page ?
 	 */
 
-	node = mpol_misplaced(page, vma, haddr, mm->numa_big);
-	if (node == -1)
+	if (mpol_misplaced(page, vma, haddr, mm->numa_big) == -1)
 		goto do_fixup;
 
 	/*
