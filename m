Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1FGHeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:34:16 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:33966 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1FGHeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:34:14 -0400
Date: Tue, 7 Jun 2011 09:34:09 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.40-rc2
Message-ID: <20110607093409.6ea6abc0@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Christian Borntraeger (2):
      [S390] kvm-s390: Fix host crash on misbehaving guests
      [S390] kvm-s390: fix stfle facilities numbers >=64

Jan Glauber (1):
      [S390] qdio: Split SBAL entry flags

Martin Schwidefsky (2):
      [S390] use generic RCU page-table freeing code
      [S390] fix kvm defines for 31 bit compile

 arch/s390/Kconfig                 |    1 +
 arch/s390/include/asm/pgalloc.h   |    8 +-
 arch/s390/include/asm/pgtable.h   |   39 ++++--
 arch/s390/include/asm/qdio.h      |  119 ++++------------
 arch/s390/include/asm/tlb.h       |   94 ++++++-------
 arch/s390/kvm/kvm-s390.c          |    1 +
 arch/s390/kvm/sie64a.S            |    2 +
 arch/s390/mm/pgtable.c            |  292 +++++++++++++++----------------------
 drivers/s390/cio/qdio_main.c      |    6 +-
 drivers/s390/net/qeth_core.h      |    2 +-
 drivers/s390/net/qeth_core_main.c |   57 ++++----
 drivers/s390/scsi/zfcp_fsf.c      |   45 +++---
 drivers/s390/scsi/zfcp_qdio.c     |   11 +-
 drivers/s390/scsi/zfcp_qdio.h     |    9 +-
 14 files changed, 291 insertions(+), 395 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9fab2aa..90d77bd 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -89,6 +89,7 @@ config S390
 	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_ARCH_MUTEX_CPU_RELAX
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
+	select HAVE_RCU_TABLE_FREE if SMP
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
index f6314af..38e71eb 100644
--- a/arch/s390/include/asm/pgalloc.h
+++ b/arch/s390/include/asm/pgalloc.h
@@ -17,15 +17,15 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 
-#define check_pgt_cache()	do {} while (0)
-
 unsigned long *crst_table_alloc(struct mm_struct *);
 void crst_table_free(struct mm_struct *, unsigned long *);
-void crst_table_free_rcu(struct mm_struct *, unsigned long *);
 
 unsigned long *page_table_alloc(struct mm_struct *);
 void page_table_free(struct mm_struct *, unsigned long *);
-void page_table_free_rcu(struct mm_struct *, unsigned long *);
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+void page_table_free_rcu(struct mmu_gather *, unsigned long *);
+void __tlb_remove_table(void *_table);
+#endif
 
 static inline void clear_table(unsigned long *s, unsigned long val, size_t n)
 {
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index e4efacf..801fbe1 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -293,19 +293,6 @@ extern unsigned long VMALLOC_START;
  * swap pte is 1011 and 0001, 0011, 0101, 0111 are invalid.
  */
 
-/* Page status table bits for virtualization */
-#define RCP_ACC_BITS	0xf000000000000000UL
-#define RCP_FP_BIT	0x0800000000000000UL
-#define RCP_PCL_BIT	0x0080000000000000UL
-#define RCP_HR_BIT	0x0040000000000000UL
-#define RCP_HC_BIT	0x0020000000000000UL
-#define RCP_GR_BIT	0x0004000000000000UL
-#define RCP_GC_BIT	0x0002000000000000UL
-
-/* User dirty / referenced bit for KVM's migration feature */
-#define KVM_UR_BIT	0x0000800000000000UL
-#define KVM_UC_BIT	0x0000400000000000UL
-
 #ifndef __s390x__
 
 /* Bits in the segment table address-space-control-element */
@@ -325,6 +312,19 @@ extern unsigned long VMALLOC_START;
 #define _SEGMENT_ENTRY		(_SEGMENT_ENTRY_PTL)
 #define _SEGMENT_ENTRY_EMPTY	(_SEGMENT_ENTRY_INV)
 
+/* Page status table bits for virtualization */
+#define RCP_ACC_BITS	0xf0000000UL
+#define RCP_FP_BIT	0x08000000UL
+#define RCP_PCL_BIT	0x00800000UL
+#define RCP_HR_BIT	0x00400000UL
+#define RCP_HC_BIT	0x00200000UL
+#define RCP_GR_BIT	0x00040000UL
+#define RCP_GC_BIT	0x00020000UL
+
+/* User dirty / referenced bit for KVM's migration feature */
+#define KVM_UR_BIT	0x00008000UL
+#define KVM_UC_BIT	0x00004000UL
+
 #else /* __s390x__ */
 
 /* Bits in the segment/region table address-space-control-element */
@@ -367,6 +367,19 @@ extern unsigned long VMALLOC_START;
 #define _SEGMENT_ENTRY_LARGE	0x400	/* STE-format control, large page   */
 #define _SEGMENT_ENTRY_CO	0x100	/* change-recording override   */
 
+/* Page status table bits for virtualization */
+#define RCP_ACC_BITS	0xf000000000000000UL
+#define RCP_FP_BIT	0x0800000000000000UL
+#define RCP_PCL_BIT	0x0080000000000000UL
+#define RCP_HR_BIT	0x0040000000000000UL
+#define RCP_HC_BIT	0x0020000000000000UL
+#define RCP_GR_BIT	0x0004000000000000UL
+#define RCP_GC_BIT	0x0002000000000000UL
+
+/* User dirty / referenced bit for KVM's migration feature */
+#define KVM_UR_BIT	0x0000800000000000UL
+#define KVM_UC_BIT	0x0000400000000000UL
+
 #endif /* __s390x__ */
 
 /*
diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index 350e7ee..15c9762 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -139,110 +139,47 @@ struct slib {
 	struct slibe slibe[QDIO_MAX_BUFFERS_PER_Q];
 } __attribute__ ((packed, aligned(2048)));
 
-/**
- * struct sbal_flags - storage block address list flags
- * @last: last entry
- * @cont: contiguous storage
- * @frag: fragmentation
- */
-struct sbal_flags {
-	u8	: 1;
-	u8 last : 1;
-	u8 cont : 1;
-	u8	: 1;
-	u8 frag : 2;
-	u8	: 2;
-} __attribute__ ((packed));
-
-#define SBAL_FLAGS_FIRST_FRAG		0x04000000UL
-#define SBAL_FLAGS_MIDDLE_FRAG		0x08000000UL
-#define SBAL_FLAGS_LAST_FRAG		0x0c000000UL
-#define SBAL_FLAGS_LAST_ENTRY		0x40000000UL
-#define SBAL_FLAGS_CONTIGUOUS		0x20000000UL
+#define SBAL_EFLAGS_LAST_ENTRY		0x40
+#define SBAL_EFLAGS_CONTIGUOUS		0x20
+#define SBAL_EFLAGS_FIRST_FRAG		0x04
+#define SBAL_EFLAGS_MIDDLE_FRAG		0x08
+#define SBAL_EFLAGS_LAST_FRAG		0x0c
+#define SBAL_EFLAGS_MASK		0x6f
 
-#define SBAL_FLAGS0_DATA_CONTINUATION	0x20UL
+#define SBAL_SFLAGS0_PCI_REQ		0x40
+#define SBAL_SFLAGS0_DATA_CONTINUATION	0x20
 
 /* Awesome OpenFCP extensions */
-#define SBAL_FLAGS0_TYPE_STATUS		0x00UL
-#define SBAL_FLAGS0_TYPE_WRITE		0x08UL
-#define SBAL_FLAGS0_TYPE_READ		0x10UL
-#define SBAL_FLAGS0_TYPE_WRITE_READ	0x18UL
-#define SBAL_FLAGS0_MORE_SBALS		0x04UL
-#define SBAL_FLAGS0_COMMAND		0x02UL
-#define SBAL_FLAGS0_LAST_SBAL		0x00UL
-#define SBAL_FLAGS0_ONLY_SBAL		SBAL_FLAGS0_COMMAND
-#define SBAL_FLAGS0_MIDDLE_SBAL		SBAL_FLAGS0_MORE_SBALS
-#define SBAL_FLAGS0_FIRST_SBAL SBAL_FLAGS0_MORE_SBALS | SBAL_FLAGS0_COMMAND
-#define SBAL_FLAGS0_PCI			0x40
-
-/**
- * struct sbal_sbalf_0 - sbal flags for sbale 0
- * @pci: PCI indicator
- * @cont: data continuation
- * @sbtype: storage-block type (FCP)
- */
-struct sbal_sbalf_0 {
-	u8	  : 1;
-	u8 pci	  : 1;
-	u8 cont   : 1;
-	u8 sbtype : 2;
-	u8	  : 3;
-} __attribute__ ((packed));
-
-/**
- * struct sbal_sbalf_1 - sbal flags for sbale 1
- * @key: storage key
- */
-struct sbal_sbalf_1 {
-	u8     : 4;
-	u8 key : 4;
-} __attribute__ ((packed));
-
-/**
- * struct sbal_sbalf_14 - sbal flags for sbale 14
- * @erridx: error index
- */
-struct sbal_sbalf_14 {
-	u8	  : 4;
-	u8 erridx : 4;
-} __attribute__ ((packed));
-
-/**
- * struct sbal_sbalf_15 - sbal flags for sbale 15
- * @reason: reason for error state
- */
-struct sbal_sbalf_15 {
-	u8 reason;
-} __attribute__ ((packed));
-
-/**
- * union sbal_sbalf - storage block address list flags
- * @i0: sbalf0
- * @i1: sbalf1
- * @i14: sbalf14
- * @i15: sblaf15
- * @value: raw value
- */
-union sbal_sbalf {
-	struct sbal_sbalf_0  i0;
-	struct sbal_sbalf_1  i1;
-	struct sbal_sbalf_14 i14;
-	struct sbal_sbalf_15 i15;
-	u8 value;
-};
+#define SBAL_SFLAGS0_TYPE_STATUS	0x00
+#define SBAL_SFLAGS0_TYPE_WRITE		0x08
+#define SBAL_SFLAGS0_TYPE_READ		0x10
+#define SBAL_SFLAGS0_TYPE_WRITE_READ	0x18
+#define SBAL_SFLAGS0_MORE_SBALS		0x04
+#define SBAL_SFLAGS0_COMMAND		0x02
+#define SBAL_SFLAGS0_LAST_SBAL		0x00
+#define SBAL_SFLAGS0_ONLY_SBAL		SBAL_SFLAGS0_COMMAND
+#define SBAL_SFLAGS0_MIDDLE_SBAL	SBAL_SFLAGS0_MORE_SBALS
+#define SBAL_SFLAGS0_FIRST_SBAL (SBAL_SFLAGS0_MORE_SBALS | SBAL_SFLAGS0_COMMAND)
 
 /**
  * struct qdio_buffer_element - SBAL entry
- * @flags: flags
+ * @eflags: SBAL entry flags
+ * @scount: SBAL count
+ * @sflags: whole SBAL flags
  * @length: length
  * @addr: address
 */
 struct qdio_buffer_element {
-	u32 flags;
+	u8 eflags;
+	/* private: */
+	u8 res1;
+	/* public: */
+	u8 scount;
+	u8 sflags;
 	u32 length;
 #ifdef CONFIG_32BIT
 	/* private: */
-	void *reserved;
+	void *res2;
 	/* public: */
 #endif
 	void *addr;
diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 77eee54..c687a2c 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -26,67 +26,60 @@
 #include <linux/swap.h>
 #include <asm/processor.h>
 #include <asm/pgalloc.h>
-#include <asm/smp.h>
 #include <asm/tlbflush.h>
 
 struct mmu_gather {
 	struct mm_struct *mm;
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	struct mmu_table_batch *batch;
+#endif
 	unsigned int fullmm;
-	unsigned int nr_ptes;
-	unsigned int nr_pxds;
-	unsigned int max;
-	void **array;
-	void *local[8];
+	unsigned int need_flush;
 };
 
-static inline void __tlb_alloc_page(struct mmu_gather *tlb)
-{
-	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+struct mmu_table_batch {
+	struct rcu_head		rcu;
+	unsigned int		nr;
+	void			*tables[0];
+};
 
-	if (addr) {
-		tlb->array = (void *) addr;
-		tlb->max = PAGE_SIZE / sizeof(void *);
-	}
-}
+#define MAX_TABLE_BATCH		\
+	((PAGE_SIZE - sizeof(struct mmu_table_batch)) / sizeof(void *))
+
+extern void tlb_table_flush(struct mmu_gather *tlb);
+extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
+#endif
 
 static inline void tlb_gather_mmu(struct mmu_gather *tlb,
 				  struct mm_struct *mm,
 				  unsigned int full_mm_flush)
 {
 	tlb->mm = mm;
-	tlb->max = ARRAY_SIZE(tlb->local);
-	tlb->array = tlb->local;
 	tlb->fullmm = full_mm_flush;
+	tlb->need_flush = 0;
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	tlb->batch = NULL;
+#endif
 	if (tlb->fullmm)
 		__tlb_flush_mm(mm);
-	else
-		__tlb_alloc_page(tlb);
-	tlb->nr_ptes = 0;
-	tlb->nr_pxds = tlb->max;
 }
 
 static inline void tlb_flush_mmu(struct mmu_gather *tlb)
 {
-	if (!tlb->fullmm && (tlb->nr_ptes > 0 || tlb->nr_pxds < tlb->max))
-		__tlb_flush_mm(tlb->mm);
-	while (tlb->nr_ptes > 0)
-		page_table_free_rcu(tlb->mm, tlb->array[--tlb->nr_ptes]);
-	while (tlb->nr_pxds < tlb->max)
-		crst_table_free_rcu(tlb->mm, tlb->array[tlb->nr_pxds++]);
+	if (!tlb->need_flush)
+		return;
+	tlb->need_flush = 0;
+	__tlb_flush_mm(tlb->mm);
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	tlb_table_flush(tlb);
+#endif
 }
 
 static inline void tlb_finish_mmu(struct mmu_gather *tlb,
 				  unsigned long start, unsigned long end)
 {
 	tlb_flush_mmu(tlb);
-
-	rcu_table_freelist_finish();
-
-	/* keep the page table cache within bounds */
-	check_pgt_cache();
-
-	if (tlb->array != tlb->local)
-		free_pages((unsigned long) tlb->array, 0);
 }
 
 /*
@@ -112,12 +105,11 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 				unsigned long address)
 {
-	if (!tlb->fullmm) {
-		tlb->array[tlb->nr_ptes++] = pte;
-		if (tlb->nr_ptes >= tlb->nr_pxds)
-			tlb_flush_mmu(tlb);
-	} else
-		page_table_free(tlb->mm, (unsigned long *) pte);
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	if (!tlb->fullmm)
+		return page_table_free_rcu(tlb, (unsigned long *) pte);
+#endif
+	page_table_free(tlb->mm, (unsigned long *) pte);
 }
 
 /*
@@ -133,12 +125,11 @@ static inline void pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
 #ifdef __s390x__
 	if (tlb->mm->context.asce_limit <= (1UL << 31))
 		return;
-	if (!tlb->fullmm) {
-		tlb->array[--tlb->nr_pxds] = pmd;
-		if (tlb->nr_ptes >= tlb->nr_pxds)
-			tlb_flush_mmu(tlb);
-	} else
-		crst_table_free(tlb->mm, (unsigned long *) pmd);
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	if (!tlb->fullmm)
+		return tlb_remove_table(tlb, pmd);
+#endif
+	crst_table_free(tlb->mm, (unsigned long *) pmd);
 #endif
 }
 
@@ -155,12 +146,11 @@ static inline void pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 #ifdef __s390x__
 	if (tlb->mm->context.asce_limit <= (1UL << 42))
 		return;
-	if (!tlb->fullmm) {
-		tlb->array[--tlb->nr_pxds] = pud;
-		if (tlb->nr_ptes >= tlb->nr_pxds)
-			tlb_flush_mmu(tlb);
-	} else
-		crst_table_free(tlb->mm, (unsigned long *) pud);
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	if (!tlb->fullmm)
+		return tlb_remove_table(tlb, pud);
+#endif
+	crst_table_free(tlb->mm, (unsigned long *) pud);
 #endif
 }
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 30ca85c..67345ae 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -731,6 +731,7 @@ static int __init kvm_s390_init(void)
 	}
 	memcpy(facilities, S390_lowcore.stfle_fac_list, 16);
 	facilities[0] &= 0xff00fff3f47c0000ULL;
+	facilities[1] &= 0x201c000000000000ULL;
 	return 0;
 }
 
diff --git a/arch/s390/kvm/sie64a.S b/arch/s390/kvm/sie64a.S
index ab0e041..5faa1b1 100644
--- a/arch/s390/kvm/sie64a.S
+++ b/arch/s390/kvm/sie64a.S
@@ -93,4 +93,6 @@ sie_err:
 
 	.section __ex_table,"a"
 	.quad	sie_inst,sie_err
+	.quad	sie_exit,sie_err
+	.quad	sie_reenter,sie_err
 	.previous
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index b09763f..37a23c22 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -24,94 +24,12 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 
-struct rcu_table_freelist {
-	struct rcu_head rcu;
-	struct mm_struct *mm;
-	unsigned int pgt_index;
-	unsigned int crst_index;
-	unsigned long *table[0];
-};
-
-#define RCU_FREELIST_SIZE \
-	((PAGE_SIZE - sizeof(struct rcu_table_freelist)) \
-	  / sizeof(unsigned long))
-
-static DEFINE_PER_CPU(struct rcu_table_freelist *, rcu_table_freelist);
-
-static void __page_table_free(struct mm_struct *mm, unsigned long *table);
-
-static struct rcu_table_freelist *rcu_table_freelist_get(struct mm_struct *mm)
-{
-	struct rcu_table_freelist **batchp = &__get_cpu_var(rcu_table_freelist);
-	struct rcu_table_freelist *batch = *batchp;
-
-	if (batch)
-		return batch;
-	batch = (struct rcu_table_freelist *) __get_free_page(GFP_ATOMIC);
-	if (batch) {
-		batch->mm = mm;
-		batch->pgt_index = 0;
-		batch->crst_index = RCU_FREELIST_SIZE;
-		*batchp = batch;
-	}
-	return batch;
-}
-
-static void rcu_table_freelist_callback(struct rcu_head *head)
-{
-	struct rcu_table_freelist *batch =
-		container_of(head, struct rcu_table_freelist, rcu);
-
-	while (batch->pgt_index > 0)
-		__page_table_free(batch->mm, batch->table[--batch->pgt_index]);
-	while (batch->crst_index < RCU_FREELIST_SIZE)
-		crst_table_free(batch->mm, batch->table[batch->crst_index++]);
-	free_page((unsigned long) batch);
-}
-
-void rcu_table_freelist_finish(void)
-{
-	struct rcu_table_freelist **batchp = &get_cpu_var(rcu_table_freelist);
-	struct rcu_table_freelist *batch = *batchp;
-
-	if (!batch)
-		goto out;
-	call_rcu(&batch->rcu, rcu_table_freelist_callback);
-	*batchp = NULL;
-out:
-	put_cpu_var(rcu_table_freelist);
-}
-
-static void smp_sync(void *arg)
-{
-}
-
 #ifndef CONFIG_64BIT
 #define ALLOC_ORDER	1
-#define TABLES_PER_PAGE	4
-#define FRAG_MASK	15UL
-#define SECOND_HALVES	10UL
-
-void clear_table_pgstes(unsigned long *table)
-{
-	clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE/4);
-	memset(table + 256, 0, PAGE_SIZE/4);
-	clear_table(table + 512, _PAGE_TYPE_EMPTY, PAGE_SIZE/4);
-	memset(table + 768, 0, PAGE_SIZE/4);
-}
-
+#define FRAG_MASK	0x0f
 #else
 #define ALLOC_ORDER	2
-#define TABLES_PER_PAGE	2
-#define FRAG_MASK	3UL
-#define SECOND_HALVES	2UL
-
-void clear_table_pgstes(unsigned long *table)
-{
-	clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE/2);
-	memset(table + 256, 0, PAGE_SIZE/2);
-}
-
+#define FRAG_MASK	0x03
 #endif
 
 unsigned long VMALLOC_START = VMALLOC_END - VMALLOC_SIZE;
@@ -140,29 +58,6 @@ void crst_table_free(struct mm_struct *mm, unsigned long *table)
 	free_pages((unsigned long) table, ALLOC_ORDER);
 }
 
-void crst_table_free_rcu(struct mm_struct *mm, unsigned long *table)
-{
-	struct rcu_table_freelist *batch;
-
-	preempt_disable();
-	if (atomic_read(&mm->mm_users) < 2 &&
-	    cpumask_equal(mm_cpumask(mm), cpumask_of(smp_processor_id()))) {
-		crst_table_free(mm, table);
-		goto out;
-	}
-	batch = rcu_table_freelist_get(mm);
-	if (!batch) {
-		smp_call_function(smp_sync, NULL, 1);
-		crst_table_free(mm, table);
-		goto out;
-	}
-	batch->table[--batch->crst_index] = table;
-	if (batch->pgt_index >= batch->crst_index)
-		rcu_table_freelist_finish();
-out:
-	preempt_enable();
-}
-
 #ifdef CONFIG_64BIT
 int crst_table_upgrade(struct mm_struct *mm, unsigned long limit)
 {
@@ -238,124 +133,175 @@ void crst_table_downgrade(struct mm_struct *mm, unsigned long limit)
 }
 #endif
 
+static inline unsigned int atomic_xor_bits(atomic_t *v, unsigned int bits)
+{
+	unsigned int old, new;
+
+	do {
+		old = atomic_read(v);
+		new = old ^ bits;
+	} while (atomic_cmpxchg(v, old, new) != old);
+	return new;
+}
+
 /*
  * page table entry allocation/free routines.
  */
+#ifdef CONFIG_PGSTE
+static inline unsigned long *page_table_alloc_pgste(struct mm_struct *mm)
+{
+	struct page *page;
+	unsigned long *table;
+
+	page = alloc_page(GFP_KERNEL|__GFP_REPEAT);
+	if (!page)
+		return NULL;
+	pgtable_page_ctor(page);
+	atomic_set(&page->_mapcount, 3);
+	table = (unsigned long *) page_to_phys(page);
+	clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE/2);
+	clear_table(table + PTRS_PER_PTE, 0, PAGE_SIZE/2);
+	return table;
+}
+
+static inline void page_table_free_pgste(unsigned long *table)
+{
+	struct page *page;
+
+	page = pfn_to_page(__pa(table) >> PAGE_SHIFT);
+	pgtable_page_ctor(page);
+	atomic_set(&page->_mapcount, -1);
+	__free_page(page);
+}
+#endif
+
 unsigned long *page_table_alloc(struct mm_struct *mm)
 {
 	struct page *page;
 	unsigned long *table;
-	unsigned long bits;
+	unsigned int mask, bit;
 
-	bits = (mm->context.has_pgste) ? 3UL : 1UL;
+#ifdef CONFIG_PGSTE
+	if (mm_has_pgste(mm))
+		return page_table_alloc_pgste(mm);
+#endif
+	/* Allocate fragments of a 4K page as 1K/2K page table */
 	spin_lock_bh(&mm->context.list_lock);
-	page = NULL;
+	mask = FRAG_MASK;
 	if (!list_empty(&mm->context.pgtable_list)) {
 		page = list_first_entry(&mm->context.pgtable_list,
 					struct page, lru);
-		if ((page->flags & FRAG_MASK) == ((1UL << TABLES_PER_PAGE) - 1))
-			page = NULL;
+		table = (unsigned long *) page_to_phys(page);
+		mask = atomic_read(&page->_mapcount);
+		mask = mask | (mask >> 4);
 	}
-	if (!page) {
+	if ((mask & FRAG_MASK) == FRAG_MASK) {
 		spin_unlock_bh(&mm->context.list_lock);
 		page = alloc_page(GFP_KERNEL|__GFP_REPEAT);
 		if (!page)
 			return NULL;
 		pgtable_page_ctor(page);
-		page->flags &= ~FRAG_MASK;
+		atomic_set(&page->_mapcount, 1);
 		table = (unsigned long *) page_to_phys(page);
-		if (mm->context.has_pgste)
-			clear_table_pgstes(table);
-		else
-			clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE);
+		clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE);
 		spin_lock_bh(&mm->context.list_lock);
 		list_add(&page->lru, &mm->context.pgtable_list);
+	} else {
+		for (bit = 1; mask & bit; bit <<= 1)
+			table += PTRS_PER_PTE;
+		mask = atomic_xor_bits(&page->_mapcount, bit);
+		if ((mask & FRAG_MASK) == FRAG_MASK)
+			list_del(&page->lru);
 	}
-	table = (unsigned long *) page_to_phys(page);
-	while (page->flags & bits) {
-		table += 256;
-		bits <<= 1;
-	}
-	page->flags |= bits;
-	if ((page->flags & FRAG_MASK) == ((1UL << TABLES_PER_PAGE) - 1))
-		list_move_tail(&page->lru, &mm->context.pgtable_list);
 	spin_unlock_bh(&mm->context.list_lock);
 	return table;
 }
 
-static void __page_table_free(struct mm_struct *mm, unsigned long *table)
+void page_table_free(struct mm_struct *mm, unsigned long *table)
 {
 	struct page *page;
-	unsigned long bits;
+	unsigned int bit, mask;
 
-	bits = ((unsigned long) table) & 15;
-	table = (unsigned long *)(((unsigned long) table) ^ bits);
+#ifdef CONFIG_PGSTE
+	if (mm_has_pgste(mm))
+		return page_table_free_pgste(table);
+#endif
+	/* Free 1K/2K page table fragment of a 4K page */
 	page = pfn_to_page(__pa(table) >> PAGE_SHIFT);
-	page->flags ^= bits;
-	if (!(page->flags & FRAG_MASK)) {
+	bit = 1 << ((__pa(table) & ~PAGE_MASK)/(PTRS_PER_PTE*sizeof(pte_t)));
+	spin_lock_bh(&mm->context.list_lock);
+	if ((atomic_read(&page->_mapcount) & FRAG_MASK) != FRAG_MASK)
+		list_del(&page->lru);
+	mask = atomic_xor_bits(&page->_mapcount, bit);
+	if (mask & FRAG_MASK)
+		list_add(&page->lru, &mm->context.pgtable_list);
+	spin_unlock_bh(&mm->context.list_lock);
+	if (mask == 0) {
 		pgtable_page_dtor(page);
+		atomic_set(&page->_mapcount, -1);
 		__free_page(page);
 	}
 }
 
-void page_table_free(struct mm_struct *mm, unsigned long *table)
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+
+static void __page_table_free_rcu(void *table, unsigned bit)
 {
 	struct page *page;
-	unsigned long bits;
 
-	bits = (mm->context.has_pgste) ? 3UL : 1UL;
-	bits <<= (__pa(table) & (PAGE_SIZE - 1)) / 256 / sizeof(unsigned long);
+#ifdef CONFIG_PGSTE
+	if (bit == FRAG_MASK)
+		return page_table_free_pgste(table);
+#endif
+	/* Free 1K/2K page table fragment of a 4K page */
 	page = pfn_to_page(__pa(table) >> PAGE_SHIFT);
-	spin_lock_bh(&mm->context.list_lock);
-	page->flags ^= bits;
-	if (page->flags & FRAG_MASK) {
-		/* Page now has some free pgtable fragments. */
-		if (!list_empty(&page->lru))
-			list_move(&page->lru, &mm->context.pgtable_list);
-		page = NULL;
-	} else
-		/* All fragments of the 4K page have been freed. */
-		list_del(&page->lru);
-	spin_unlock_bh(&mm->context.list_lock);
-	if (page) {
+	if (atomic_xor_bits(&page->_mapcount, bit) == 0) {
 		pgtable_page_dtor(page);
+		atomic_set(&page->_mapcount, -1);
 		__free_page(page);
 	}
 }
 
-void page_table_free_rcu(struct mm_struct *mm, unsigned long *table)
+void page_table_free_rcu(struct mmu_gather *tlb, unsigned long *table)
 {
-	struct rcu_table_freelist *batch;
+	struct mm_struct *mm;
 	struct page *page;
-	unsigned long bits;
+	unsigned int bit, mask;
 
-	preempt_disable();
-	if (atomic_read(&mm->mm_users) < 2 &&
-	    cpumask_equal(mm_cpumask(mm), cpumask_of(smp_processor_id()))) {
-		page_table_free(mm, table);
-		goto out;
-	}
-	batch = rcu_table_freelist_get(mm);
-	if (!batch) {
-		smp_call_function(smp_sync, NULL, 1);
-		page_table_free(mm, table);
-		goto out;
+	mm = tlb->mm;
+#ifdef CONFIG_PGSTE
+	if (mm_has_pgste(mm)) {
+		table = (unsigned long *) (__pa(table) | FRAG_MASK);
+		tlb_remove_table(tlb, table);
+		return;
 	}
-	bits = (mm->context.has_pgste) ? 3UL : 1UL;
-	bits <<= (__pa(table) & (PAGE_SIZE - 1)) / 256 / sizeof(unsigned long);
+#endif
+	bit = 1 << ((__pa(table) & ~PAGE_MASK) / (PTRS_PER_PTE*sizeof(pte_t)));
 	page = pfn_to_page(__pa(table) >> PAGE_SHIFT);
 	spin_lock_bh(&mm->context.list_lock);
-	/* Delayed freeing with rcu prevents reuse of pgtable fragments */
-	list_del_init(&page->lru);
+	if ((atomic_read(&page->_mapcount) & FRAG_MASK) != FRAG_MASK)
+		list_del(&page->lru);
+	mask = atomic_xor_bits(&page->_mapcount, bit | (bit << 4));
+	if (mask & FRAG_MASK)
+		list_add_tail(&page->lru, &mm->context.pgtable_list);
 	spin_unlock_bh(&mm->context.list_lock);
-	table = (unsigned long *)(((unsigned long) table) | bits);
-	batch->table[batch->pgt_index++] = table;
-	if (batch->pgt_index >= batch->crst_index)
-		rcu_table_freelist_finish();
-out:
-	preempt_enable();
+	table = (unsigned long *) (__pa(table) | (bit << 4));
+	tlb_remove_table(tlb, table);
 }
 
+void __tlb_remove_table(void *_table)
+{
+	void *table = (void *)((unsigned long) _table & PAGE_MASK);
+	unsigned type = (unsigned long) _table & ~PAGE_MASK;
+
+	if (type)
+		__page_table_free_rcu(table, type);
+	else
+		free_pages((unsigned long) table, ALLOC_ORDER);
+}
+
+#endif
+
 /*
  * switch on pgstes for its userspace process (for kvm)
  */
@@ -369,7 +315,7 @@ int s390_enable_sie(void)
 		return -EINVAL;
 
 	/* Do we have pgstes? if yes, we are done */
-	if (tsk->mm->context.has_pgste)
+	if (mm_has_pgste(tsk->mm))
 		return 0;
 
 	/* lets check if we are allowed to replace the mm */
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 55e8f72..570d4da 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -416,7 +416,7 @@ static void process_buffer_error(struct qdio_q *q, int count)
 
 	/* special handling for no target buffer empty */
 	if ((!q->is_input_q &&
-	    (q->sbal[q->first_to_check]->element[15].flags & 0xff) == 0x10)) {
+	    (q->sbal[q->first_to_check]->element[15].sflags) == 0x10)) {
 		qperf_inc(q, target_full);
 		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "OUTFULL FTC:%02x",
 			      q->first_to_check);
@@ -427,8 +427,8 @@ static void process_buffer_error(struct qdio_q *q, int count)
 	DBF_ERROR((q->is_input_q) ? "IN:%2d" : "OUT:%2d", q->nr);
 	DBF_ERROR("FTC:%3d C:%3d", q->first_to_check, count);
 	DBF_ERROR("F14:%2x F15:%2x",
-		  q->sbal[q->first_to_check]->element[14].flags & 0xff,
-		  q->sbal[q->first_to_check]->element[15].flags & 0xff);
+		  q->sbal[q->first_to_check]->element[14].sflags,
+		  q->sbal[q->first_to_check]->element[15].sflags);
 
 	/*
 	 * Interrupts may be avoided as long as the error is present
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 55c6aa1..d3cee33 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -361,7 +361,7 @@ enum qeth_header_ids {
 
 static inline int qeth_is_last_sbale(struct qdio_buffer_element *sbale)
 {
-	return (sbale->flags & SBAL_FLAGS_LAST_ENTRY);
+	return (sbale->eflags & SBAL_EFLAGS_LAST_ENTRY);
 }
 
 enum qeth_qdio_buffer_states {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 503678a..dd08f7b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -890,7 +890,7 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 	struct sk_buff *skb;
 
 	/* is PCI flag set on buffer? */
-	if (buf->buffer->element[0].flags & 0x40)
+	if (buf->buffer->element[0].sflags & SBAL_SFLAGS0_PCI_REQ)
 		atomic_dec(&queue->set_pci_flags_count);
 
 	skb = skb_dequeue(&buf->skb_list);
@@ -906,9 +906,11 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 		buf->is_header[i] = 0;
 		buf->buffer->element[i].length = 0;
 		buf->buffer->element[i].addr = NULL;
-		buf->buffer->element[i].flags = 0;
+		buf->buffer->element[i].eflags = 0;
+		buf->buffer->element[i].sflags = 0;
 	}
-	buf->buffer->element[15].flags = 0;
+	buf->buffer->element[15].eflags = 0;
+	buf->buffer->element[15].sflags = 0;
 	buf->next_element_to_fill = 0;
 	atomic_set(&buf->state, QETH_QDIO_BUF_EMPTY);
 }
@@ -2368,9 +2370,10 @@ static int qeth_init_input_buffer(struct qeth_card *card,
 		buf->buffer->element[i].length = PAGE_SIZE;
 		buf->buffer->element[i].addr =  pool_entry->elements[i];
 		if (i == QETH_MAX_BUFFER_ELEMENTS(card) - 1)
-			buf->buffer->element[i].flags = SBAL_FLAGS_LAST_ENTRY;
+			buf->buffer->element[i].eflags = SBAL_EFLAGS_LAST_ENTRY;
 		else
-			buf->buffer->element[i].flags = 0;
+			buf->buffer->element[i].eflags = 0;
+		buf->buffer->element[i].sflags = 0;
 	}
 	return 0;
 }
@@ -2718,11 +2721,11 @@ int qeth_check_qdio_errors(struct qeth_card *card, struct qdio_buffer *buf,
 	if (qdio_error) {
 		QETH_CARD_TEXT(card, 2, dbftext);
 		QETH_CARD_TEXT_(card, 2, " F15=%02X",
-			       buf->element[15].flags & 0xff);
+			       buf->element[15].sflags);
 		QETH_CARD_TEXT_(card, 2, " F14=%02X",
-			       buf->element[14].flags & 0xff);
+			       buf->element[14].sflags);
 		QETH_CARD_TEXT_(card, 2, " qerr=%X", qdio_error);
-		if ((buf->element[15].flags & 0xff) == 0x12) {
+		if ((buf->element[15].sflags) == 0x12) {
 			card->stats.rx_dropped++;
 			return 0;
 		} else
@@ -2798,7 +2801,7 @@ EXPORT_SYMBOL_GPL(qeth_queue_input_buffer);
 static int qeth_handle_send_error(struct qeth_card *card,
 		struct qeth_qdio_out_buffer *buffer, unsigned int qdio_err)
 {
-	int sbalf15 = buffer->buffer->element[15].flags & 0xff;
+	int sbalf15 = buffer->buffer->element[15].sflags;
 
 	QETH_CARD_TEXT(card, 6, "hdsnderr");
 	if (card->info.type == QETH_CARD_TYPE_IQD) {
@@ -2907,8 +2910,8 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 
 	for (i = index; i < index + count; ++i) {
 		buf = &queue->bufs[i % QDIO_MAX_BUFFERS_PER_Q];
-		buf->buffer->element[buf->next_element_to_fill - 1].flags |=
-				SBAL_FLAGS_LAST_ENTRY;
+		buf->buffer->element[buf->next_element_to_fill - 1].eflags |=
+				SBAL_EFLAGS_LAST_ENTRY;
 
 		if (queue->card->info.type == QETH_CARD_TYPE_IQD)
 			continue;
@@ -2921,7 +2924,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 				/* it's likely that we'll go to packing
 				 * mode soon */
 				atomic_inc(&queue->set_pci_flags_count);
-				buf->buffer->element[0].flags |= 0x40;
+				buf->buffer->element[0].sflags |= SBAL_SFLAGS0_PCI_REQ;
 			}
 		} else {
 			if (!atomic_read(&queue->set_pci_flags_count)) {
@@ -2934,7 +2937,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 				 * further send was requested by the stack
 				 */
 				atomic_inc(&queue->set_pci_flags_count);
-				buf->buffer->element[0].flags |= 0x40;
+				buf->buffer->element[0].sflags |= SBAL_SFLAGS0_PCI_REQ;
 			}
 		}
 	}
@@ -3180,20 +3183,20 @@ static inline void __qeth_fill_buffer(struct sk_buff *skb,
 		if (!length) {
 			if (first_lap)
 				if (skb_shinfo(skb)->nr_frags)
-					buffer->element[element].flags =
-						SBAL_FLAGS_FIRST_FRAG;
+					buffer->element[element].eflags =
+						SBAL_EFLAGS_FIRST_FRAG;
 				else
-					buffer->element[element].flags = 0;
+					buffer->element[element].eflags = 0;
 			else
-				buffer->element[element].flags =
-				    SBAL_FLAGS_MIDDLE_FRAG;
+				buffer->element[element].eflags =
+				    SBAL_EFLAGS_MIDDLE_FRAG;
 		} else {
 			if (first_lap)
-				buffer->element[element].flags =
-				    SBAL_FLAGS_FIRST_FRAG;
+				buffer->element[element].eflags =
+				    SBAL_EFLAGS_FIRST_FRAG;
 			else
-				buffer->element[element].flags =
-				    SBAL_FLAGS_MIDDLE_FRAG;
+				buffer->element[element].eflags =
+				    SBAL_EFLAGS_MIDDLE_FRAG;
 		}
 		data += length_here;
 		element++;
@@ -3205,12 +3208,12 @@ static inline void __qeth_fill_buffer(struct sk_buff *skb,
 		buffer->element[element].addr = (char *)page_to_phys(frag->page)
 			+ frag->page_offset;
 		buffer->element[element].length = frag->size;
-		buffer->element[element].flags = SBAL_FLAGS_MIDDLE_FRAG;
+		buffer->element[element].eflags = SBAL_EFLAGS_MIDDLE_FRAG;
 		element++;
 	}
 
-	if (buffer->element[element - 1].flags)
-		buffer->element[element - 1].flags = SBAL_FLAGS_LAST_FRAG;
+	if (buffer->element[element - 1].eflags)
+		buffer->element[element - 1].eflags = SBAL_EFLAGS_LAST_FRAG;
 	*next_element_to_fill = element;
 }
 
@@ -3234,7 +3237,7 @@ static inline int qeth_fill_buffer(struct qeth_qdio_out_q *queue,
 		/*fill first buffer entry only with header information */
 		buffer->element[element].addr = skb->data;
 		buffer->element[element].length = hdr_len;
-		buffer->element[element].flags = SBAL_FLAGS_FIRST_FRAG;
+		buffer->element[element].eflags = SBAL_EFLAGS_FIRST_FRAG;
 		buf->next_element_to_fill++;
 		skb->data += hdr_len;
 		skb->len  -= hdr_len;
@@ -3246,7 +3249,7 @@ static inline int qeth_fill_buffer(struct qeth_qdio_out_q *queue,
 		buffer->element[element].addr = hdr;
 		buffer->element[element].length = sizeof(struct qeth_hdr) +
 							hd_len;
-		buffer->element[element].flags = SBAL_FLAGS_FIRST_FRAG;
+		buffer->element[element].eflags = SBAL_EFLAGS_FIRST_FRAG;
 		buf->is_header[element] = 1;
 		buf->next_element_to_fill++;
 	}
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 8512b5c..022fb6a 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -640,7 +640,7 @@ static struct fsf_qtcb *zfcp_qtcb_alloc(mempool_t *pool)
 }
 
 static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
-						u32 fsf_cmd, u32 sbtype,
+						u32 fsf_cmd, u8 sbtype,
 						mempool_t *pool)
 {
 	struct zfcp_adapter *adapter = qdio->adapter;
@@ -841,7 +841,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *scmnd)
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_ABORT_FCP_CMND,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  qdio->adapter->pool.scsi_abort);
 	if (IS_ERR(req)) {
 		req = NULL;
@@ -1012,7 +1012,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_GENERIC,
-				  SBAL_FLAGS0_TYPE_WRITE_READ, pool);
+				  SBAL_SFLAGS0_TYPE_WRITE_READ, pool);
 
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
@@ -1110,7 +1110,7 @@ int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_ELS,
-				  SBAL_FLAGS0_TYPE_WRITE_READ, NULL);
+				  SBAL_SFLAGS0_TYPE_WRITE_READ, NULL);
 
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
@@ -1156,7 +1156,7 @@ int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_CONFIG_DATA,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1198,7 +1198,7 @@ int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *qdio,
 		goto out_unlock;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_CONFIG_DATA,
-				  SBAL_FLAGS0_TYPE_READ, NULL);
+				  SBAL_SFLAGS0_TYPE_READ, NULL);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -1250,7 +1250,7 @@ int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_PORT_DATA,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1296,7 +1296,7 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *qdio,
 		goto out_unlock;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_PORT_DATA,
-				  SBAL_FLAGS0_TYPE_READ, NULL);
+				  SBAL_SFLAGS0_TYPE_READ, NULL);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -1412,7 +1412,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_PORT_WITH_DID,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1478,7 +1478,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PORT,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1553,7 +1553,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_PORT_WITH_DID,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1606,7 +1606,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PORT,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1698,7 +1698,7 @@ int zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PHYSICAL_PORT,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1812,7 +1812,7 @@ int zfcp_fsf_open_lun(struct zfcp_erp_action *erp_action)
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_LUN,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1901,7 +1901,7 @@ int zfcp_fsf_close_lun(struct zfcp_erp_action *erp_action)
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_LUN,
-				  SBAL_FLAGS0_TYPE_READ,
+				  SBAL_SFLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -2161,7 +2161,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 {
 	struct zfcp_fsf_req *req;
 	struct fcp_cmnd *fcp_cmnd;
-	unsigned int sbtype = SBAL_FLAGS0_TYPE_READ;
+	u8 sbtype = SBAL_SFLAGS0_TYPE_READ;
 	int real_bytes, retval = -EIO, dix_bytes = 0;
 	struct scsi_device *sdev = scsi_cmnd->device;
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
@@ -2181,7 +2181,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 	}
 
 	if (scsi_cmnd->sc_data_direction == DMA_TO_DEVICE)
-		sbtype = SBAL_FLAGS0_TYPE_WRITE;
+		sbtype = SBAL_SFLAGS0_TYPE_WRITE;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_FCP_CMND,
 				  sbtype, adapter->pool.scsi_req);
@@ -2280,7 +2280,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_FCP_CMND,
-				  SBAL_FLAGS0_TYPE_WRITE,
+				  SBAL_SFLAGS0_TYPE_WRITE,
 				  qdio->adapter->pool.scsi_req);
 
 	if (IS_ERR(req)) {
@@ -2328,17 +2328,18 @@ struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
 	struct zfcp_qdio *qdio = adapter->qdio;
 	struct zfcp_fsf_req *req = NULL;
 	struct fsf_qtcb_bottom_support *bottom;
-	int direction, retval = -EIO, bytes;
+	int retval = -EIO, bytes;
+	u8 direction;
 
 	if (!(adapter->adapter_features & FSF_FEATURE_CFDC))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	switch (fsf_cfdc->command) {
 	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
-		direction = SBAL_FLAGS0_TYPE_WRITE;
+		direction = SBAL_SFLAGS0_TYPE_WRITE;
 		break;
 	case FSF_QTCB_UPLOAD_CONTROL_FILE:
-		direction = SBAL_FLAGS0_TYPE_READ;
+		direction = SBAL_SFLAGS0_TYPE_READ;
 		break;
 	default:
 		return ERR_PTR(-EINVAL);
@@ -2413,7 +2414,7 @@ void zfcp_fsf_reqid_check(struct zfcp_qdio *qdio, int sbal_idx)
 		fsf_req->qdio_req.sbal_response = sbal_idx;
 		zfcp_fsf_req_complete(fsf_req);
 
-		if (likely(sbale->flags & SBAL_FLAGS_LAST_ENTRY))
+		if (likely(sbale->eflags & SBAL_EFLAGS_LAST_ENTRY))
 			break;
 	}
 }
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 98e97d9..d9c40ea 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -124,7 +124,7 @@ zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 
 	/* set last entry flag in current SBALE of current SBAL */
 	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
-	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
+	sbale->eflags |= SBAL_EFLAGS_LAST_ENTRY;
 
 	/* don't exceed last allowed SBAL */
 	if (q_req->sbal_last == q_req->sbal_limit)
@@ -132,7 +132,7 @@ zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 
 	/* set chaining flag in first SBALE of current SBAL */
 	sbale = zfcp_qdio_sbale_req(qdio, q_req);
-	sbale->flags |= SBAL_FLAGS0_MORE_SBALS;
+	sbale->sflags |= SBAL_SFLAGS0_MORE_SBALS;
 
 	/* calculate index of next SBAL */
 	q_req->sbal_last++;
@@ -147,7 +147,7 @@ zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 
 	/* set storage-block type for new SBAL */
 	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
-	sbale->flags |= q_req->sbtype;
+	sbale->sflags |= q_req->sbtype;
 
 	return sbale;
 }
@@ -177,7 +177,7 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
 
 	/* set storage-block type for this request */
 	sbale = zfcp_qdio_sbale_req(qdio, q_req);
-	sbale->flags |= q_req->sbtype;
+	sbale->sflags |= q_req->sbtype;
 
 	for (; sg; sg = sg_next(sg)) {
 		sbale = zfcp_qdio_sbale_next(qdio, q_req);
@@ -384,7 +384,8 @@ int zfcp_qdio_open(struct zfcp_qdio *qdio)
 	for (cc = 0; cc < QDIO_MAX_BUFFERS_PER_Q; cc++) {
 		sbale = &(qdio->res_q[cc]->element[0]);
 		sbale->length = 0;
-		sbale->flags = SBAL_FLAGS_LAST_ENTRY;
+		sbale->eflags = SBAL_EFLAGS_LAST_ENTRY;
+		sbale->sflags = 0;
 		sbale->addr = NULL;
 	}
 
diff --git a/drivers/s390/scsi/zfcp_qdio.h b/drivers/s390/scsi/zfcp_qdio.h
index 2297d8d..54e22ac 100644
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -67,7 +67,7 @@ struct zfcp_qdio {
  * @qdio_outb_usage: usage of outbound queue
  */
 struct zfcp_qdio_req {
-	u32	sbtype;
+	u8	sbtype;
 	u8	sbal_number;
 	u8	sbal_first;
 	u8	sbal_last;
@@ -116,7 +116,7 @@ zfcp_qdio_sbale_curr(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
  */
 static inline
 void zfcp_qdio_req_init(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
-			unsigned long req_id, u32 sbtype, void *data, u32 len)
+			unsigned long req_id, u8 sbtype, void *data, u32 len)
 {
 	struct qdio_buffer_element *sbale;
 	int count = min(atomic_read(&qdio->req_q_free),
@@ -131,7 +131,8 @@ void zfcp_qdio_req_init(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
 
 	sbale = zfcp_qdio_sbale_req(qdio, q_req);
 	sbale->addr = (void *) req_id;
-	sbale->flags = SBAL_FLAGS0_COMMAND | sbtype;
+	sbale->eflags = 0;
+	sbale->sflags = SBAL_SFLAGS0_COMMAND | sbtype;
 
 	if (unlikely(!data))
 		return;
@@ -173,7 +174,7 @@ void zfcp_qdio_set_sbale_last(struct zfcp_qdio *qdio,
 	struct qdio_buffer_element *sbale;
 
 	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
-	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
+	sbale->eflags |= SBAL_EFLAGS_LAST_ENTRY;
 }
 
 /**
