Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab0KCPiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab0KCPa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:30:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 21 of 66] add pmd mmu_notifier helpers
X-Mercurial-Node: a148bf94a2d46d6cbaa6cafb0ff7ad8f793b3116
Message-Id: <a148bf94a2d46d6cbaa6.1288798076@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:27:56 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Adam Litke <agl@us.ibm.com>,
        Avi Kivity <avi@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

Add mmu notifier helpers to handle pmd huge operations.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
---

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -243,6 +243,32 @@ static inline void mmu_notifier_mm_destr
 	__pte;								\
 })
 
+#define pmdp_clear_flush_notify(__vma, __address, __pmdp)		\
+({									\
+	pmd_t __pmd;							\
+	struct vm_area_struct *___vma = __vma;				\
+	unsigned long ___address = __address;				\
+	VM_BUG_ON(__address & ~HPAGE_PMD_MASK);				\
+	mmu_notifier_invalidate_range_start(___vma->vm_mm, ___address,	\
+					    (__address)+HPAGE_PMD_SIZE);\
+	__pmd = pmdp_clear_flush(___vma, ___address, __pmdp);		\
+	mmu_notifier_invalidate_range_end(___vma->vm_mm, ___address,	\
+					  (__address)+HPAGE_PMD_SIZE);	\
+	__pmd;								\
+})
+
+#define pmdp_splitting_flush_notify(__vma, __address, __pmdp)		\
+({									\
+	struct vm_area_struct *___vma = __vma;				\
+	unsigned long ___address = __address;				\
+	VM_BUG_ON(__address & ~HPAGE_PMD_MASK);				\
+	mmu_notifier_invalidate_range_start(___vma->vm_mm, ___address,	\
+					    (__address)+HPAGE_PMD_SIZE);\
+	pmdp_splitting_flush(___vma, ___address, __pmdp);		\
+	mmu_notifier_invalidate_range_end(___vma->vm_mm, ___address,	\
+					  (__address)+HPAGE_PMD_SIZE);	\
+})
+
 #define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
 ({									\
 	int __young;							\
@@ -254,6 +280,17 @@ static inline void mmu_notifier_mm_destr
 	__young;							\
 })
 
+#define pmdp_clear_flush_young_notify(__vma, __address, __pmdp)		\
+({									\
+	int __young;							\
+	struct vm_area_struct *___vma = __vma;				\
+	unsigned long ___address = __address;				\
+	__young = pmdp_clear_flush_young(___vma, ___address, __pmdp);	\
+	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
+						  ___address);		\
+	__young;							\
+})
+
 #define set_pte_at_notify(__mm, __address, __ptep, __pte)		\
 ({									\
 	struct mm_struct *___mm = __mm;					\
@@ -305,7 +342,10 @@ static inline void mmu_notifier_mm_destr
 }
 
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
+#define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_flush_notify ptep_clear_flush
+#define pmdp_clear_flush_notify pmdp_clear_flush
+#define pmdp_splitting_flush_notify pmdp_splitting_flush
 #define set_pte_at_notify set_pte_at
 
 #endif /* CONFIG_MMU_NOTIFIER */
