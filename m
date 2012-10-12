Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2JLLZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:25:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2JLLZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:25:07 -0400
Date: Fri, 12 Oct 2012 04:24:52 -0700
From: tip-bot for Rik van Riel <riel@redhat.com>
Message-ID: <tip-vm3rkzevahelwhejx5uwm8ex@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm:
  Only flush the TLB when clearing an accessible pte
Git-Commit-ID: 154e911b453560aa1e6e11d47e5f95289817b932
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 12 Oct 2012 04:24:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  154e911b453560aa1e6e11d47e5f95289817b932
Gitweb:     http://git.kernel.org/tip/154e911b453560aa1e6e11d47e5f95289817b932
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Tue, 9 Oct 2012 15:31:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Oct 2012 12:07:16 +0200

mm: Only flush the TLB when clearing an accessible pte

If ptep_clear_flush() is called to clear a page table entry that is
accessible anyway by the CPU, eg. a _PAGE_PROTNONE page table entry,
there is no need to flush the TLB on remote CPUs.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-vm3rkzevahelwhejx5uwm8ex@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/pgtable-generic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 74c0dda..0996d34 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -88,7 +88,8 @@ pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long address,
 {
 	pte_t pte;
 	pte = ptep_get_and_clear((vma)->vm_mm, address, ptep);
-	flush_tlb_page(vma, address);
+	if (pte_accessible(pte))
+		flush_tlb_page(vma, address);
 	return pte;
 }
 #endif
