Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2DRMF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 08:05:58 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58467 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2DRMF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:05:56 -0400
Date: Wed, 18 Apr 2012 14:05:46 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.4-rc3
Message-ID: <20120418140546.481de8fe@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12041812-2966-0000-0000-000003D3093B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive a couple of bug fixes, one of them is a TLB flush fix.
Included as well is one small coding style patch and a patch to update
the default configuration.

Dennis Chen (1):
      [S390] s390/char/vmur.c: fix memory leak

Heiko Carstens (2):
      [S390] irq: simple coding style change
      [S390] cpum_cf: get rid of compile warnings

Julia Lawall (1):
      [S390] drivers/s390/block/dasd_eckd.c: add missing dasd_sfree_request

Martin Schwidefsky (2):
      [S390] fix tlb flushing for page table pages
      [S390] Fix compile error in swab.h

Michael Holzheu (3):
      [S390] kernel: Use local_irq_save() for memcpy_real()
      [S390] update default configuration
      [S390] Fix stfle() lowcore protection problem

 arch/s390/Kconfig                |    1 -
 arch/s390/defconfig              |   37 +++++++++++-----------
 arch/s390/include/asm/facility.h |    3 +-
 arch/s390/include/asm/pgalloc.h  |    3 --
 arch/s390/include/asm/swab.h     |    2 +-
 arch/s390/include/asm/tlb.h      |   22 +------------
 arch/s390/kernel/head.S          |    2 +-
 arch/s390/kernel/irq.c           |    9 ++++--
 arch/s390/kernel/perf_cpum_cf.c  |    4 +--
 arch/s390/mm/maccess.c           |   27 ++++++++++------
 arch/s390/mm/pgtable.c           |   63 ++++++++++++++++++++++++++++++++++++--
 drivers/s390/block/dasd_eckd.c   |   24 ++++++++++-----
 drivers/s390/char/vmur.c         |    2 +-
 13 files changed, 125 insertions(+), 74 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2b7c0fb..9015060 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -90,7 +90,6 @@ config S390
 	select HAVE_KERNEL_XZ
 	select HAVE_ARCH_MUTEX_CPU_RELAX
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
-	select HAVE_RCU_TABLE_FREE if SMP
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index 6cf8e26..1957a9d 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,8 +1,12 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
+CONFIG_FHANDLE=y
+CONFIG_TASKSTATS=y
+CONFIG_TASK_DELAY_ACCT=y
+CONFIG_TASK_XACCT=y
+CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
-CONFIG_RCU_TRACE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
@@ -14,16 +18,22 @@ CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
+CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_RD_BZIP2=y
+CONFIG_RD_LZMA=y
+CONFIG_RD_XZ=y
+CONFIG_RD_LZO=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
-CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=y
 CONFIG_KPROBES=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODVERSIONS=y
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_IBM_PARTITION=y
 CONFIG_DEFAULT_DEADLINE=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
@@ -34,18 +44,15 @@ CONFIG_KSM=y
 CONFIG_BINFMT_MISC=m
 CONFIG_CMM=m
 CONFIG_HZ_100=y
-CONFIG_KEXEC=y
-CONFIG_PM=y
+CONFIG_CRASH_DUMP=y
 CONFIG_HIBERNATION=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_NET_KEY=y
-CONFIG_AFIUCV=m
 CONFIG_INET=y
 CONFIG_IP_MULTICAST=y
 # CONFIG_INET_LRO is not set
 CONFIG_IPV6=y
-CONFIG_NET_SCTPPROBE=m
 CONFIG_L2TP=m
 CONFIG_L2TP_DEBUGFS=m
 CONFIG_VLAN_8021Q=y
@@ -84,15 +91,14 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_ZFCP=y
-CONFIG_ZFCP_DIF=y
 CONFIG_NETDEVICES=y
-CONFIG_DUMMY=m
 CONFIG_BONDING=m
+CONFIG_DUMMY=m
 CONFIG_EQUALIZER=m
 CONFIG_TUN=m
-CONFIG_NET_ETHERNET=y
 CONFIG_VIRTIO_NET=y
 CONFIG_RAW_DRIVER=m
+CONFIG_VIRTIO_BALLOON=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
@@ -103,27 +109,21 @@ CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
 # CONFIG_NETWORK_FILESYSTEMS is not set
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_IBM_PARTITION=y
-CONFIG_DLM=m
 CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_KERNEL=y
 CONFIG_TIMER_STATS=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_PROVE_RCU=y
 CONFIG_LOCK_STAT=y
 CONFIG_DEBUG_LOCKDEP=y
-CONFIG_DEBUG_SPINLOCK_SLEEP=y
 CONFIG_DEBUG_LIST=y
 CONFIG_DEBUG_NOTIFIERS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+CONFIG_RCU_TRACE=y
 CONFIG_KPROBES_SANITY_TEST=y
 CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
 CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
 CONFIG_LATENCYTOP=y
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_DEBUG_PAGEALLOC=y
-# CONFIG_FTRACE is not set
+CONFIG_BLK_DEV_IO_TRACE=y
 # CONFIG_STRICT_DEVMEM is not set
 CONFIG_CRYPTO_NULL=m
 CONFIG_CRYPTO_CRYPTD=m
@@ -173,4 +173,3 @@ CONFIG_CRYPTO_SHA512_S390=m
 CONFIG_CRYPTO_DES_S390=m
 CONFIG_CRYPTO_AES_S390=m
 CONFIG_CRC7=m
-CONFIG_VIRTIO_BALLOON=y
diff --git a/arch/s390/include/asm/facility.h b/arch/s390/include/asm/facility.h
index 1e5b27e..2ee66a6 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -38,12 +38,11 @@ static inline void stfle(u64 *stfle_fac_list, int size)
 	unsigned long nr;
 
 	preempt_disable();
-	S390_lowcore.stfl_fac_list = 0;
 	asm volatile(
 		"	.insn s,0xb2b10000,0(0)\n" /* stfl */
 		"0:\n"
 		EX_TABLE(0b, 0b)
-		: "=m" (S390_lowcore.stfl_fac_list));
+		: "+m" (S390_lowcore.stfl_fac_list));
 	nr = 4; /* bytes stored by stfl */
 	memcpy(stfle_fac_list, &S390_lowcore.stfl_fac_list, 4);
 	if (S390_lowcore.stfl_fac_list & 0x01000000) {
diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
index 8eef9b5..78e3041 100644
--- a/arch/s390/include/asm/pgalloc.h
+++ b/arch/s390/include/asm/pgalloc.h
@@ -22,10 +22,7 @@ void crst_table_free(struct mm_struct *, unsigned long *);
 
 unsigned long *page_table_alloc(struct mm_struct *, unsigned long);
 void page_table_free(struct mm_struct *, unsigned long *);
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
 void page_table_free_rcu(struct mmu_gather *, unsigned long *);
-void __tlb_remove_table(void *_table);
-#endif
 
 static inline void clear_table(unsigned long *s, unsigned long val, size_t n)
 {
diff --git a/arch/s390/include/asm/swab.h b/arch/s390/include/asm/swab.h
index 6bdee21..a3e4ebb 100644
--- a/arch/s390/include/asm/swab.h
+++ b/arch/s390/include/asm/swab.h
@@ -77,7 +77,7 @@ static inline __u16 __arch_swab16p(const __u16 *x)
 	
 	asm volatile(
 #ifndef __s390x__
-		"	icm	%0,2,%O+1(%R1)\n"
+		"	icm	%0,2,%O1+1(%R1)\n"
 		"	ic	%0,%1\n"
 		: "=&d" (result) : "Q" (*x) : "cc");
 #else /* __s390x__ */
diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index c687a2c..775a5ee 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -30,14 +30,10 @@
 
 struct mmu_gather {
 	struct mm_struct *mm;
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	struct mmu_table_batch *batch;
-#endif
 	unsigned int fullmm;
-	unsigned int need_flush;
 };
 
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
 struct mmu_table_batch {
 	struct rcu_head		rcu;
 	unsigned int		nr;
@@ -49,7 +45,6 @@ struct mmu_table_batch {
 
 extern void tlb_table_flush(struct mmu_gather *tlb);
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
-#endif
 
 static inline void tlb_gather_mmu(struct mmu_gather *tlb,
 				  struct mm_struct *mm,
@@ -57,29 +52,20 @@ static inline void tlb_gather_mmu(struct mmu_gather *tlb,
 {
 	tlb->mm = mm;
 	tlb->fullmm = full_mm_flush;
-	tlb->need_flush = 0;
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb->batch = NULL;
-#endif
 	if (tlb->fullmm)
 		__tlb_flush_mm(mm);
 }
 
 static inline void tlb_flush_mmu(struct mmu_gather *tlb)
 {
-	if (!tlb->need_flush)
-		return;
-	tlb->need_flush = 0;
-	__tlb_flush_mm(tlb->mm);
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
-#endif
 }
 
 static inline void tlb_finish_mmu(struct mmu_gather *tlb,
 				  unsigned long start, unsigned long end)
 {
-	tlb_flush_mmu(tlb);
+	tlb_table_flush(tlb);
 }
 
 /*
@@ -105,10 +91,8 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 				unsigned long address)
 {
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	if (!tlb->fullmm)
 		return page_table_free_rcu(tlb, (unsigned long *) pte);
-#endif
 	page_table_free(tlb->mm, (unsigned long *) pte);
 }
 
@@ -125,10 +109,8 @@ static inline void pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
 #ifdef __s390x__
 	if (tlb->mm->context.asce_limit <= (1UL << 31))
 		return;
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	if (!tlb->fullmm)
 		return tlb_remove_table(tlb, pmd);
-#endif
 	crst_table_free(tlb->mm, (unsigned long *) pmd);
 #endif
 }
@@ -146,10 +128,8 @@ static inline void pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 #ifdef __s390x__
 	if (tlb->mm->context.asce_limit <= (1UL << 42))
 		return;
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	if (!tlb->fullmm)
 		return tlb_remove_table(tlb, pud);
-#endif
 	crst_table_free(tlb->mm, (unsigned long *) pud);
 #endif
 }
diff --git a/arch/s390/kernel/head.S b/arch/s390/kernel/head.S
index c27a072..adccd90 100644
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -474,9 +474,9 @@ ENTRY(startup_kdump)
 	stck	__LC_LAST_UPDATE_CLOCK
 	spt	5f-.LPG0(%r13)
 	mvc	__LC_LAST_UPDATE_TIMER(8),5f-.LPG0(%r13)
+	xc	__LC_STFL_FAC_LIST(8),__LC_STFL_FAC_LIST
 #ifndef CONFIG_MARCH_G5
 	# check capabilities against MARCH_{G5,Z900,Z990,Z9_109,Z10}
-	xc	__LC_STFL_FAC_LIST(8),__LC_STFL_FAC_LIST
 	.insn	s,0xb2b10000,__LC_STFL_FAC_LIST	# store facility list
 	tm	__LC_STFL_FAC_LIST,0x01	# stfle available ?
 	jz	0f
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index 1c2cdd5..8a22c27 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -118,9 +118,10 @@ asmlinkage void do_softirq(void)
 				         "a" (__do_softirq)
 				     : "0", "1", "2", "3", "4", "5", "14",
 				       "cc", "memory" );
-		} else
+		} else {
 			/* We are already on the async stack. */
 			__do_softirq();
+		}
 	}
 
 	local_irq_restore(flags);
@@ -192,11 +193,12 @@ int unregister_external_interrupt(u16 code, ext_int_handler_t handler)
 	int index = ext_hash(code);
 
 	spin_lock_irqsave(&ext_int_hash_lock, flags);
-	list_for_each_entry_rcu(p, &ext_int_hash[index], entry)
+	list_for_each_entry_rcu(p, &ext_int_hash[index], entry) {
 		if (p->code == code && p->handler == handler) {
 			list_del_rcu(&p->entry);
 			kfree_rcu(p, rcu);
 		}
+	}
 	spin_unlock_irqrestore(&ext_int_hash_lock, flags);
 	return 0;
 }
@@ -211,9 +213,10 @@ void __irq_entry do_extint(struct pt_regs *regs, struct ext_code ext_code,
 
 	old_regs = set_irq_regs(regs);
 	irq_enter();
-	if (S390_lowcore.int_clock >= S390_lowcore.clock_comparator)
+	if (S390_lowcore.int_clock >= S390_lowcore.clock_comparator) {
 		/* Serve timer interrupts first. */
 		clock_comparator_work();
+	}
 	kstat_cpu(smp_processor_id()).irqs[EXTERNAL_INTERRUPT]++;
 	if (ext_code.code != 0x1004)
 		__get_cpu_var(s390_idle).nohz_delay = 1;
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 4640508..cb019f4 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -178,7 +178,7 @@ static void cpumf_pmu_enable(struct pmu *pmu)
 	err = lcctl(cpuhw->state);
 	if (err) {
 		pr_err("Enabling the performance measuring unit "
-		       "failed with rc=%lx\n", err);
+		       "failed with rc=%x\n", err);
 		return;
 	}
 
@@ -203,7 +203,7 @@ static void cpumf_pmu_disable(struct pmu *pmu)
 	err = lcctl(inactive);
 	if (err) {
 		pr_err("Disabling the performance measuring unit "
-		       "failed with rc=%lx\n", err);
+		       "failed with rc=%x\n", err);
 		return;
 	}
 
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 7bb15fc..e1335dc 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -61,21 +61,14 @@ long probe_kernel_write(void *dst, const void *src, size_t size)
 	return copied < 0 ? -EFAULT : 0;
 }
 
-/*
- * Copy memory in real mode (kernel to kernel)
- */
-int memcpy_real(void *dest, void *src, size_t count)
+static int __memcpy_real(void *dest, void *src, size_t count)
 {
 	register unsigned long _dest asm("2") = (unsigned long) dest;
 	register unsigned long _len1 asm("3") = (unsigned long) count;
 	register unsigned long _src  asm("4") = (unsigned long) src;
 	register unsigned long _len2 asm("5") = (unsigned long) count;
-	unsigned long flags;
 	int rc = -EFAULT;
 
-	if (!count)
-		return 0;
-	flags = __arch_local_irq_stnsm(0xf8UL);
 	asm volatile (
 		"0:	mvcle	%1,%2,0x0\n"
 		"1:	jo	0b\n"
@@ -86,7 +79,23 @@ int memcpy_real(void *dest, void *src, size_t count)
 		  "+d" (_len2), "=m" (*((long *) dest))
 		: "m" (*((long *) src))
 		: "cc", "memory");
-	arch_local_irq_restore(flags);
+	return rc;
+}
+
+/*
+ * Copy memory in real mode (kernel to kernel)
+ */
+int memcpy_real(void *dest, void *src, size_t count)
+{
+	unsigned long flags;
+	int rc;
+
+	if (!count)
+		return 0;
+	local_irq_save(flags);
+	__arch_local_irq_stnsm(0xfbUL);
+	rc = __memcpy_real(dest, src, count);
+	local_irq_restore(flags);
 	return rc;
 }
 
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 373adf6..6e765bf 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -678,8 +678,6 @@ void page_table_free(struct mm_struct *mm, unsigned long *table)
 	}
 }
 
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
-
 static void __page_table_free_rcu(void *table, unsigned bit)
 {
 	struct page *page;
@@ -733,7 +731,66 @@ void __tlb_remove_table(void *_table)
 		free_pages((unsigned long) table, ALLOC_ORDER);
 }
 
-#endif
+static void tlb_remove_table_smp_sync(void *arg)
+{
+	/* Simply deliver the interrupt */
+}
+
+static void tlb_remove_table_one(void *table)
+{
+	/*
+	 * This isn't an RCU grace period and hence the page-tables cannot be
+	 * assumed to be actually RCU-freed.
+	 *
+	 * It is however sufficient for software page-table walkers that rely
+	 * on IRQ disabling. See the comment near struct mmu_table_batch.
+	 */
+	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+	__tlb_remove_table(table);
+}
+
+static void tlb_remove_table_rcu(struct rcu_head *head)
+{
+	struct mmu_table_batch *batch;
+	int i;
+
+	batch = container_of(head, struct mmu_table_batch, rcu);
+
+	for (i = 0; i < batch->nr; i++)
+		__tlb_remove_table(batch->tables[i]);
+
+	free_page((unsigned long)batch);
+}
+
+void tlb_table_flush(struct mmu_gather *tlb)
+{
+	struct mmu_table_batch **batch = &tlb->batch;
+
+	if (*batch) {
+		__tlb_flush_mm(tlb->mm);
+		call_rcu_sched(&(*batch)->rcu, tlb_remove_table_rcu);
+		*batch = NULL;
+	}
+}
+
+void tlb_remove_table(struct mmu_gather *tlb, void *table)
+{
+	struct mmu_table_batch **batch = &tlb->batch;
+
+	if (*batch == NULL) {
+		*batch = (struct mmu_table_batch *)
+			__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
+		if (*batch == NULL) {
+			__tlb_flush_mm(tlb->mm);
+			tlb_remove_table_one(table);
+			return;
+		}
+		(*batch)->nr = 0;
+	}
+	(*batch)->tables[(*batch)->nr++] = table;
+	if ((*batch)->nr == MAX_TABLE_BATCH)
+		tlb_table_flush(tlb);
+}
 
 /*
  * switch on pgstes for its userspace process (for kvm)
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index c21871a..bc2e8a7 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2844,6 +2844,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 	sector_t recid, trkid;
 	unsigned int offs;
 	unsigned int count, count_to_trk_end;
+	int ret;
 
 	basedev = block->base;
 	if (rq_data_dir(req) == READ) {
@@ -2884,8 +2885,8 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 
 	itcw = itcw_init(cqr->data, itcw_size, itcw_op, 0, ctidaw, 0);
 	if (IS_ERR(itcw)) {
-		dasd_sfree_request(cqr, startdev);
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto out_error;
 	}
 	cqr->cpaddr = itcw_get_tcw(itcw);
 	if (prepare_itcw(itcw, first_trk, last_trk,
@@ -2897,8 +2898,8 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 		/* Clock not in sync and XRC is enabled.
 		 * Try again later.
 		 */
-		dasd_sfree_request(cqr, startdev);
-		return ERR_PTR(-EAGAIN);
+		ret = -EAGAIN;
+		goto out_error;
 	}
 	len_to_track_end = 0;
 	/*
@@ -2937,8 +2938,10 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 					tidaw_flags = 0;
 				last_tidaw = itcw_add_tidaw(itcw, tidaw_flags,
 							    dst, part_len);
-				if (IS_ERR(last_tidaw))
-					return ERR_PTR(-EINVAL);
+				if (IS_ERR(last_tidaw)) {
+					ret = -EINVAL;
+					goto out_error;
+				}
 				dst += part_len;
 			}
 		}
@@ -2947,8 +2950,10 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 			dst = page_address(bv->bv_page) + bv->bv_offset;
 			last_tidaw = itcw_add_tidaw(itcw, 0x00,
 						    dst, bv->bv_len);
-			if (IS_ERR(last_tidaw))
-				return ERR_PTR(-EINVAL);
+			if (IS_ERR(last_tidaw)) {
+				ret = -EINVAL;
+				goto out_error;
+			}
 		}
 	}
 	last_tidaw->flags |= TIDAW_FLAGS_LAST;
@@ -2968,6 +2973,9 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
+out_error:
+	dasd_sfree_request(cqr, startdev);
+	return ERR_PTR(ret);
 }
 
 static struct dasd_ccw_req *dasd_eckd_build_cp(struct dasd_device *startdev,
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index 85f4a9a..73bef0b 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -903,7 +903,7 @@ static int ur_set_online(struct ccw_device *cdev)
 		goto fail_urdev_put;
 	}
 
-	cdev_init(urd->char_device, &ur_fops);
+	urd->char_device->ops = &ur_fops;
 	urd->char_device->dev = MKDEV(major, minor);
 	urd->char_device->owner = ur_fops.owner;
 

