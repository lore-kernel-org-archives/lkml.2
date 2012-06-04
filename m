Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab2FDFJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:09:27 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48836 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2FDFJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:09:26 -0400
Subject: [PATCH v2 7/7] Flush page-table pages before freeing them
To: peterz@infradead.org, mingo@elte.hu, mtosatti@redhat.com, avi@redhat.com
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Date: Mon, 04 Jun 2012 10:38:50 +0530
Message-ID: <20120604050842.4560.81070.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060405-2000-0000-0000-000007CAEF90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Certain architecture(viz. x86, arm, s390) have hardware page-table
walkers(#PF). So during the RCU page-table teardown process make sure
we do a tlb flush of page-table pages on all relevant CPUs to
synchronize against hardware walkers, and then free the pages.

Moreover, the (mm_users < 2) condition does not hold good for the above
architectures, as the hardware engine is one of the user.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 arch/Kconfig     |    3 +++
 arch/x86/Kconfig |   12 ++++++++++++
 mm/memory.c      |   24 ++++++++++++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 684eb5a..abc3739 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -196,6 +196,9 @@ config HAVE_ARCH_MUTEX_CPU_RELAX
 config HAVE_RCU_TABLE_FREE
 	bool
 
+config ARCH_HW_WALKS_PAGE_TABLE
+       bool
+
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a9ec0da..b0a9f11 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -617,6 +617,18 @@ config PARAVIRT_SPINLOCKS
 
 	  If you are unsure how to answer this question, answer N.
 
+config PARAVIRT_TLB_FLUSH
+	bool "Paravirtualization layer for TLB Flush"
+	depends on PARAVIRT && SMP && EXPERIMENTAL
+	select HAVE_RCU_TABLE_FREE
+	select ARCH_HW_WALKS_PAGE_TABLE
+	---help---
+	  Paravirtualized Flush TLB replace the native implementation
+	  with something virtualization-friendly (for example, set a
+	  flag for sleeping vcpu and do not wait for it).
+
+	  If you are unsure how to answer this question, answer N.
+
 config PARAVIRT_CLOCK
 	bool
 
diff --git a/mm/memory.c b/mm/memory.c
index c12685d..acfadb8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -335,11 +335,27 @@ static void tlb_remove_table_rcu(struct rcu_head *head)
 	free_page((unsigned long)batch);
 }
 
+#ifdef CONFIG_ARCH_HW_WALKS_PAGE_TABLE
+/*
+ * Some architectures(x86, arm, s390) HW walks the page tables when
+ * the page-table tear down might be happening. So make sure that
+ * before freeing the page-table pages, flush their tlbs
+ */
+static inline void tlb_table_flush_mmu(struct mmu_gather *tlb)
+{
+	tlb_flush_mmu(tlb);
+}
+
+#else
+#define tlb_table_flush_mmu(tlb) do {} while (0)
+#endif
+
 void tlb_table_flush(struct mmu_gather *tlb)
 {
 	struct mmu_table_batch **batch = &tlb->batch;
 
 	if (*batch) {
+		tlb_table_flush_mmu(tlb);
 		call_rcu_sched(&(*batch)->rcu, tlb_remove_table_rcu);
 		*batch = NULL;
 	}
@@ -351,18 +367,22 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
 
 	tlb->need_flush = 1;
 
+#ifndef CONFIG_ARCH_HW_WALKS_PAGE_TABLE
 	/*
-	 * When there's less then two users of this mm there cannot be a
-	 * concurrent page-table walk.
+	 * When there's less then two users of this mm there cannot be
+	 * a concurrent page-table walk for architectures that do not
+	 * have hardware page-table walkers.
 	 */
 	if (atomic_read(&tlb->mm->mm_users) < 2) {
 		__tlb_remove_table(table);
 		return;
 	}
+#endif
 
 	if (*batch == NULL) {
 		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
 		if (*batch == NULL) {
+			tlb_table_flush_mmu(tlb);
 			tlb_remove_table_one(table);
 			return;
 		}

