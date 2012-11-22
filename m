Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2KVXYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:24:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2KVXYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 18:24:10 -0500
Date: Thu, 22 Nov 2012 15:22:39 -0800
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-5e4bf1a55da976a5ed60901bb8801f1024ef9774@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        hannes@cmpxchg.org, hughd@google.com, cl@linux.com, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com,
        Lee.Schermerhorn@hp.com, mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        hannes@cmpxchg.org, cl@linux.com, hughd@google.com, riel@redhat.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <20121120120251.GA15742@gmail.com>
References: <20121120120251.GA15742@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Don't flush the TLB on #WP pmd fixups
Git-Commit-ID: 5e4bf1a55da976a5ed60901bb8801f1024ef9774
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 22 Nov 2012 15:22:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e4bf1a55da976a5ed60901bb8801f1024ef9774
Gitweb:     http://git.kernel.org/tip/5e4bf1a55da976a5ed60901bb8801f1024ef9774
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Tue, 20 Nov 2012 13:02:51 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 Nov 2012 21:52:06 +0100

x86/mm: Don't flush the TLB on #WP pmd fixups

If we have a write protection #PF and fix up the pmd then the
hugetlb code [the only user of pmdp_set_access_flags], in its
do_huge_pmd_wp_page() page fault resolution function calls
pmdp_set_access_flags() to mark the pmd permissive again,
and flushes the TLB.

This TLB flush is unnecessary: a flush on #PF is guaranteed on
most (all?) x86 CPUs, and even in the worst-case we'll generate
a spurious fault.

So remove it.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Link: http://lkml.kernel.org/r/20121120120251.GA15742@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pgtable.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..8a828d7 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -328,7 +328,12 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
 	if (changed && dirty) {
 		*pmdp = entry;
 		pmd_update_defer(vma->vm_mm, address, pmdp);
-		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+		/*
+		 * We had a write-protection fault here and changed the pmd
+		 * to to more permissive. No need to flush the TLB for that,
+		 * #PF is architecturally guaranteed to do that and in the
+		 * worst-case we'll generate a spurious fault.
+		 */
 	}
 
 	return changed;
