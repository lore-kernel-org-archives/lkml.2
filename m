Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1E2Oqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 10:46:37 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:41008 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1E2Oqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 10:46:35 -0400
Date: Sun, 29 May 2011 16:46:32 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.40-rc1
Message-ID: <20110529144632.GA2328@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

There are only two bug fixes. One is an important one since it fixes our
dirty bit handling which got broken during the merge window. Therefore it
fixes potential data corruption...

Heiko Carstens (2):
      [S390] mm: fix storage key handling
      [S390] mm: fix mmu_gather rework

 arch/s390/include/asm/pgtable.h |   16 ++++++++--------
 arch/s390/mm/pgtable.c          |   23 ++++++++++++++++-------
 include/linux/page-flags.h      |    2 +-
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index c4773a2..e4efacf 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -577,16 +577,16 @@ static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
 static inline pgste_t pgste_update_all(pte_t *ptep, pgste_t pgste)
 {
 #ifdef CONFIG_PGSTE
-	unsigned long pfn, bits;
+	unsigned long address, bits;
 	unsigned char skey;
 
-	pfn = pte_val(*ptep) >> PAGE_SHIFT;
-	skey = page_get_storage_key(pfn);
+	address = pte_val(*ptep) & PAGE_MASK;
+	skey = page_get_storage_key(address);
 	bits = skey & (_PAGE_CHANGED | _PAGE_REFERENCED);
 	/* Clear page changed & referenced bit in the storage key */
 	if (bits) {
 		skey ^= bits;
-		page_set_storage_key(pfn, skey, 1);
+		page_set_storage_key(address, skey, 1);
 	}
 	/* Transfer page changed & referenced bit to guest bits in pgste */
 	pgste_val(pgste) |= bits << 48;		/* RCP_GR_BIT & RCP_GC_BIT */
@@ -628,16 +628,16 @@ static inline pgste_t pgste_update_young(pte_t *ptep, pgste_t pgste)
 static inline void pgste_set_pte(pte_t *ptep, pgste_t pgste)
 {
 #ifdef CONFIG_PGSTE
-	unsigned long pfn;
+	unsigned long address;
 	unsigned long okey, nkey;
 
-	pfn = pte_val(*ptep) >> PAGE_SHIFT;
-	okey = nkey = page_get_storage_key(pfn);
+	address = pte_val(*ptep) & PAGE_MASK;
+	okey = nkey = page_get_storage_key(address);
 	nkey &= ~(_PAGE_ACC_BITS | _PAGE_FP_BIT);
 	/* Set page access key and fetch protection bit from pgste */
 	nkey |= (pgste_val(pgste) & (RCP_ACC_BITS | RCP_FP_BIT)) >> 56;
 	if (okey != nkey)
-		page_set_storage_key(pfn, nkey, 1);
+		page_set_storage_key(address, nkey, 1);
 #endif
 }
 
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 14c6fae..b09763f 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -71,12 +71,15 @@ static void rcu_table_freelist_callback(struct rcu_head *head)
 
 void rcu_table_freelist_finish(void)
 {
-	struct rcu_table_freelist *batch = __get_cpu_var(rcu_table_freelist);
+	struct rcu_table_freelist **batchp = &get_cpu_var(rcu_table_freelist);
+	struct rcu_table_freelist *batch = *batchp;
 
 	if (!batch)
-		return;
+		goto out;
 	call_rcu(&batch->rcu, rcu_table_freelist_callback);
-	__get_cpu_var(rcu_table_freelist) = NULL;
+	*batchp = NULL;
+out:
+	put_cpu_var(rcu_table_freelist);
 }
 
 static void smp_sync(void *arg)
@@ -141,20 +144,23 @@ void crst_table_free_rcu(struct mm_struct *mm, unsigned long *table)
 {
 	struct rcu_table_freelist *batch;
 
+	preempt_disable();
 	if (atomic_read(&mm->mm_users) < 2 &&
 	    cpumask_equal(mm_cpumask(mm), cpumask_of(smp_processor_id()))) {
 		crst_table_free(mm, table);
-		return;
+		goto out;
 	}
 	batch = rcu_table_freelist_get(mm);
 	if (!batch) {
 		smp_call_function(smp_sync, NULL, 1);
 		crst_table_free(mm, table);
-		return;
+		goto out;
 	}
 	batch->table[--batch->crst_index] = table;
 	if (batch->pgt_index >= batch->crst_index)
 		rcu_table_freelist_finish();
+out:
+	preempt_enable();
 }
 
 #ifdef CONFIG_64BIT
@@ -323,16 +329,17 @@ void page_table_free_rcu(struct mm_struct *mm, unsigned long *table)
 	struct page *page;
 	unsigned long bits;
 
+	preempt_disable();
 	if (atomic_read(&mm->mm_users) < 2 &&
 	    cpumask_equal(mm_cpumask(mm), cpumask_of(smp_processor_id()))) {
 		page_table_free(mm, table);
-		return;
+		goto out;
 	}
 	batch = rcu_table_freelist_get(mm);
 	if (!batch) {
 		smp_call_function(smp_sync, NULL, 1);
 		page_table_free(mm, table);
-		return;
+		goto out;
 	}
 	bits = (mm->context.has_pgste) ? 3UL : 1UL;
 	bits <<= (__pa(table) & (PAGE_SIZE - 1)) / 256 / sizeof(unsigned long);
@@ -345,6 +352,8 @@ void page_table_free_rcu(struct mm_struct *mm, unsigned long *table)
 	batch->table[batch->pgt_index++] = table;
 	if (batch->pgt_index >= batch->crst_index)
 		rcu_table_freelist_finish();
+out:
+	preempt_enable();
 }
 
 /*
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 79a6700..6081493 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -308,7 +308,7 @@ static inline void SetPageUptodate(struct page *page)
 {
 #ifdef CONFIG_S390
 	if (!test_and_set_bit(PG_uptodate, &page->flags))
-		page_set_storage_key(page_to_pfn(page), PAGE_DEFAULT_KEY, 0);
+		page_set_storage_key(page_to_phys(page), PAGE_DEFAULT_KEY, 0);
 #else
 	/*
 	 * Memory barrier must be issued before setting the PG_uptodate bit,
