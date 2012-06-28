Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab2F1PmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:42:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab2F1PmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:42:11 -0400
Date: Thu, 28 Jun 2012 08:42:00 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-597e1c3580b7cfd95bb0f3167e2b297bf8a5a3ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1340845344-27557-7-git-send-email-alex.shi@intel.com>
References: <1340845344-27557-7-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] mm/mmu_gather:
  enable tlb flush range in generic mmu_gather
Git-Commit-ID: 597e1c3580b7cfd95bb0f3167e2b297bf8a5a3ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 28 Jun 2012 08:42:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  597e1c3580b7cfd95bb0f3167e2b297bf8a5a3ae
Gitweb:     http://git.kernel.org/tip/597e1c3580b7cfd95bb0f3167e2b297bf8a5a3ae
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 28 Jun 2012 09:02:21 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 27 Jun 2012 19:29:11 -0700

mm/mmu_gather: enable tlb flush range in generic mmu_gather

This patch enabled the tlb flush range support in generic mmu layer.

Most of arch has self tlb flush range support, like ARM/IA64 etc.
X86 arch has no this support in hardware yet. But another instruction
'invlpg' can implement this function in some degree. So, enable this
feather in generic layer for x86 now. and maybe useful for other archs
in further.

Generic mmu_gather struct is protected by micro
HAVE_GENERIC_MMU_GATHER. Other archs that has flush range supported
own self mmu_gather struct. So, now this change is safe for them.

In future we may unify this struct and related functions on multiple
archs.

Thanks for Peter Zijlstra time and time reminder for multiple
architecture code safe!

Signed-off-by: Alex Shi <alex.shi@intel.com>
Link: http://lkml.kernel.org/r/1340845344-27557-7-git-send-email-alex.shi@intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-generic/tlb.h |    2 ++
 mm/memory.c               |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 75e888b..ed6642a 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -86,6 +86,8 @@ struct mmu_gather {
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	struct mmu_table_batch	*batch;
 #endif
+	unsigned long		start;
+	unsigned long		end;
 	unsigned int		need_flush : 1,	/* Did free PTEs */
 				fast_mode  : 1; /* No batching   */
 
diff --git a/mm/memory.c b/mm/memory.c
index 1b7dc66..32c9943 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -206,6 +206,8 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
 	tlb->mm = mm;
 
 	tlb->fullmm     = fullmm;
+	tlb->start	= -1UL;
+	tlb->end	= 0;
 	tlb->need_flush = 0;
 	tlb->fast_mode  = (num_possible_cpus() == 1);
 	tlb->local.next = NULL;
@@ -248,6 +250,8 @@ void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long e
 {
 	struct mmu_gather_batch *batch, *next;
 
+	tlb->start = start;
+	tlb->end   = end;
 	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
@@ -1204,6 +1208,11 @@ again:
 	 */
 	if (force_flush) {
 		force_flush = 0;
+
+#ifdef HAVE_GENERIC_MMU_GATHER
+		tlb->start = addr;
+		tlb->end = end;
+#endif
 		tlb_flush_mmu(tlb);
 		if (addr != end)
 			goto again;
