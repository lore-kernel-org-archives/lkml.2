Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2JLLYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:24:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2JLLYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:24:10 -0400
Date: Fri, 12 Oct 2012 04:23:54 -0700
From: tip-bot for Rik van Riel <riel@redhat.com>
Message-ID: <tip-zb7fqnz7byn1xmaei148pl6n@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] x86/mm:
  Reduce tlb flushes from ptep_set_access_flags()
Git-Commit-ID: d8769ca9a6272795acf650698abe29d8ed149888
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 12 Oct 2012 04:23:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8769ca9a6272795acf650698abe29d8ed149888
Gitweb:     http://git.kernel.org/tip/d8769ca9a6272795acf650698abe29d8ed149888
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Tue, 9 Oct 2012 15:31:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Oct 2012 12:07:15 +0200

x86/mm: Reduce tlb flushes from ptep_set_access_flags()

If ptep_set_access_flags() is invoked to upgrade access permissions
on a PTE, there is no security or data integrity reason to do a
remote TLB flush.

Lazily letting another CPU incur a spurious page fault occasionally
is (much!) cheaper than aggressively flushing everybody else's TLB.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-zb7fqnz7byn1xmaei148pl6n@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pgtable.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..fc82cf1 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -306,11 +306,26 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 			  pte_t entry, int dirty)
 {
 	int changed = !pte_same(*ptep, entry);
+	/*
+	 * If the page used to be inaccessible (_PAGE_PROTNONE), or
+	 * this call upgrades the access permissions on the same page,
+	 * it is safe to skip the remote TLB flush.
+	 */
+	bool flush_remote = false;
+	if (!pte_accessible(*ptep))
+		flush_remote = false;
+	else if (pte_pfn(*ptep) != pte_pfn(entry) ||
+			(pte_write(*ptep) && !pte_write(entry)) ||
+			(pte_exec(*ptep) && !pte_exec(entry)))
+		flush_remote = true;
 
 	if (changed && dirty) {
 		*ptep = entry;
 		pte_update_defer(vma->vm_mm, address, ptep);
-		flush_tlb_page(vma, address);
+		if (flush_remote)
+			flush_tlb_page(vma, address);
+		else
+			__flush_tlb_one(address);
 	}
 
 	return changed;
