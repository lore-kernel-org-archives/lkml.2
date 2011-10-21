Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1JUMWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:22:20 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:48269 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab1JUMWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:22:18 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LTF10Z-02-1UG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        <akpm@linux-foundation.org>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] mm: Disable tlb_fast_mode() when mm has notifiers
Date: Fri, 21 Oct 2011 14:21:46 +0200
Message-ID: <1319199708-17777-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319199708-17777-1-git-send-email-joerg.roedel@amd.com>
References: <1319199708-17777-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the MMU-Notifiers are used to manage non-CPU TLBs the
tlb_fast_mode can't be used anymore. So disable it when an
mm has notifiers.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/asm-generic/tlb.h    |    2 +-
 include/linux/mmu_notifier.h |    1 +
 mm/memory.c                  |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index e58fa77..8c6cc1b 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -100,7 +100,7 @@ struct mmu_gather {
 
 static inline int tlb_fast_mode(struct mmu_gather *tlb)
 {
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) || defined(CONFIG_MMU_NOTIFIER)
 	return tlb->fast_mode;
 #else
 	/*
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 1d1b1e1..b9469d6 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -373,6 +373,7 @@ static inline void mmu_notifier_mm_destroy(struct mm_struct *mm)
 #define pmdp_clear_flush_notify pmdp_clear_flush
 #define pmdp_splitting_flush_notify pmdp_splitting_flush
 #define set_pte_at_notify set_pte_at
+#define mm_has_notifiers(mm) 0
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
diff --git a/mm/memory.c b/mm/memory.c
index a56e3ba..b31f9e0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -230,7 +230,7 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
 
 	tlb->fullmm     = fullmm;
 	tlb->need_flush = 0;
-	tlb->fast_mode  = (num_possible_cpus() == 1);
+	tlb->fast_mode  = (num_possible_cpus() == 1) && !mm_has_notifiers(mm);
 	tlb->local.next = NULL;
 	tlb->local.nr   = 0;
 	tlb->local.max  = ARRAY_SIZE(tlb->__pages);
-- 
1.7.5.4


