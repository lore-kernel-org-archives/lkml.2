Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1KPJa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:30:56 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57538 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1KPJax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:30:53 -0500
Date: Wed, 16 Nov 2011 10:30:49 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.2-rc3
Message-ID: <20111116103049.1d00eeb3@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i486-pc-linux-gnu)
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

Heiko Carstens (3):
      [S390] wire up process_vm syscalls
      [S390] pfault: ignore leftover completion interrupts
      [S390] topology: fix topology on z10 machines

Holger Dengler (1):
      [S390] ap: Setup processing for messages in request queue.

Jan Glauber (2):
      [S390] avoid STCKF if running in ESA mode
      [S390] crypto: avoid MSA3 and MSA4 instructions in ESA mode

Martin Schwidefsky (2):
      [S390] fix pgste update logic
      [S390] incorrect note program header

Michael Holzheu (2):
      [S390] Kconfig: Select CONFIG_KEXEC for CONFIG_CRASH_DUMP
      [S390] zfcpdump: Do not initialize zfcpdump in kdump mode

 arch/s390/Kconfig                 |    1 +
 arch/s390/crypto/crypt_s390.h     |    7 ++++-
 arch/s390/include/asm/pgtable.h   |   12 +++++++--
 arch/s390/include/asm/setup.h     |    3 ++
 arch/s390/include/asm/timex.h     |    2 +-
 arch/s390/include/asm/unistd.h    |    4 ++-
 arch/s390/kernel/compat_wrapper.S |   20 ++++++++++++++++
 arch/s390/kernel/early.c          |    2 +
 arch/s390/kernel/setup.c          |    4 ++-
 arch/s390/kernel/syscalls.S       |    2 +
 arch/s390/kernel/topology.c       |   45 +++++++++++++++++++++++++++++++-----
 arch/s390/kernel/vmlinux.lds.S    |    2 +
 arch/s390/mm/fault.c              |    9 +++++-
 drivers/s390/char/zcore.c         |    2 +
 drivers/s390/crypto/ap_bus.c      |   23 ++++++++++++++-----
 15 files changed, 115 insertions(+), 23 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index a9fbd43..373679b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -572,6 +572,7 @@ config KEXEC
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on 64BIT
+	select KEXEC
 	help
 	  Generate crash dump after being started by kexec.
 	  Crash dump kernels are loaded in the main kernel with kexec-tools
diff --git a/arch/s390/crypto/crypt_s390.h b/arch/s390/crypto/crypt_s390.h
index 4967677..ffd1ac2 100644
--- a/arch/s390/crypto/crypt_s390.h
+++ b/arch/s390/crypto/crypt_s390.h
@@ -368,9 +368,12 @@ static inline int crypt_s390_func_available(int func,
 
 	if (facility_mask & CRYPT_S390_MSA && !test_facility(17))
 		return 0;
-	if (facility_mask & CRYPT_S390_MSA3 && !test_facility(76))
+
+	if (facility_mask & CRYPT_S390_MSA3 &&
+	    (!test_facility(2) || !test_facility(76)))
 		return 0;
-	if (facility_mask & CRYPT_S390_MSA4 && !test_facility(77))
+	if (facility_mask & CRYPT_S390_MSA4 &&
+	    (!test_facility(2) || !test_facility(77)))
 		return 0;
 
 	switch (func & CRYPT_S390_OP_MASK) {
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 34ede0e..524d23b 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -593,6 +593,8 @@ static inline pgste_t pgste_update_all(pte_t *ptep, pgste_t pgste)
 	unsigned long address, bits;
 	unsigned char skey;
 
+	if (!pte_present(*ptep))
+		return pgste;
 	address = pte_val(*ptep) & PAGE_MASK;
 	skey = page_get_storage_key(address);
 	bits = skey & (_PAGE_CHANGED | _PAGE_REFERENCED);
@@ -625,6 +627,8 @@ static inline pgste_t pgste_update_young(pte_t *ptep, pgste_t pgste)
 #ifdef CONFIG_PGSTE
 	int young;
 
+	if (!pte_present(*ptep))
+		return pgste;
 	young = page_reset_referenced(pte_val(*ptep) & PAGE_MASK);
 	/* Transfer page referenced bit to pte software bit (host view) */
 	if (young || (pgste_val(pgste) & RCP_HR_BIT))
@@ -638,13 +642,15 @@ static inline pgste_t pgste_update_young(pte_t *ptep, pgste_t pgste)
 
 }
 
-static inline void pgste_set_pte(pte_t *ptep, pgste_t pgste)
+static inline void pgste_set_pte(pte_t *ptep, pgste_t pgste, pte_t entry)
 {
 #ifdef CONFIG_PGSTE
 	unsigned long address;
 	unsigned long okey, nkey;
 
-	address = pte_val(*ptep) & PAGE_MASK;
+	if (!pte_present(entry))
+		return;
+	address = pte_val(entry) & PAGE_MASK;
 	okey = nkey = page_get_storage_key(address);
 	nkey &= ~(_PAGE_ACC_BITS | _PAGE_FP_BIT);
 	/* Set page access key and fetch protection bit from pgste */
@@ -712,7 +718,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 
 	if (mm_has_pgste(mm)) {
 		pgste = pgste_get_lock(ptep);
-		pgste_set_pte(ptep, pgste);
+		pgste_set_pte(ptep, pgste, entry);
 		*ptep = entry;
 		pgste_set_unlock(ptep, pgste);
 	} else
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index 5a09971..097183c 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -82,6 +82,7 @@ extern unsigned int user_mode;
 #define MACHINE_FLAG_LPAR	(1UL << 12)
 #define MACHINE_FLAG_SPP	(1UL << 13)
 #define MACHINE_FLAG_TOPOLOGY	(1UL << 14)
+#define MACHINE_FLAG_STCKF	(1UL << 15)
 
 #define MACHINE_IS_VM		(S390_lowcore.machine_flags & MACHINE_FLAG_VM)
 #define MACHINE_IS_KVM		(S390_lowcore.machine_flags & MACHINE_FLAG_KVM)
@@ -100,6 +101,7 @@ extern unsigned int user_mode;
 #define MACHINE_HAS_PFMF	(0)
 #define MACHINE_HAS_SPP		(0)
 #define MACHINE_HAS_TOPOLOGY	(0)
+#define MACHINE_HAS_STCKF	(0)
 #else /* __s390x__ */
 #define MACHINE_HAS_IEEE	(1)
 #define MACHINE_HAS_CSP		(1)
@@ -111,6 +113,7 @@ extern unsigned int user_mode;
 #define MACHINE_HAS_PFMF	(S390_lowcore.machine_flags & MACHINE_FLAG_PFMF)
 #define MACHINE_HAS_SPP		(S390_lowcore.machine_flags & MACHINE_FLAG_SPP)
 #define MACHINE_HAS_TOPOLOGY	(S390_lowcore.machine_flags & MACHINE_FLAG_TOPOLOGY)
+#define MACHINE_HAS_STCKF	(S390_lowcore.machine_flags & MACHINE_FLAG_STCKF)
 #endif /* __s390x__ */
 
 #define ZFCPDUMP_HSA_SIZE	(32UL<<20)
diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index d610bef..c447a27 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -90,7 +90,7 @@ static inline unsigned long long get_clock_fast(void)
 {
 	unsigned long long clk;
 
-	if (test_facility(25))
+	if (MACHINE_HAS_STCKF)
 		asm volatile(".insn	s,0xb27c0000,%0" : "=Q" (clk) : : "cc");
 	else
 		clk = get_clock();
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index 404bdb9..58de4c9 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -277,7 +277,9 @@
 #define __NR_clock_adjtime	337
 #define __NR_syncfs		338
 #define __NR_setns		339
-#define NR_syscalls 340
+#define __NR_process_vm_readv	340
+#define __NR_process_vm_writev	341
+#define NR_syscalls 342
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 5006a1d..18c51df 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1627,3 +1627,23 @@ ENTRY(sys_setns_wrapper)
 	lgfr	%r2,%r2			# int
 	lgfr	%r3,%r3			# int
 	jg	sys_setns
+
+ENTRY(compat_sys_process_vm_readv_wrapper)
+	lgfr	%r2,%r2			# compat_pid_t
+	llgtr	%r3,%r3			# struct compat_iovec __user *
+	llgfr	%r4,%r4			# unsigned long
+	llgtr	%r5,%r5			# struct compat_iovec __user *
+	llgfr	%r6,%r6			# unsigned long
+	llgf	%r0,164(%r15)		# unsigned long
+	stg	%r0,160(%r15)
+	jg	sys_process_vm_readv
+
+ENTRY(compat_sys_process_vm_writev_wrapper)
+	lgfr	%r2,%r2			# compat_pid_t
+	llgtr	%r3,%r3			# struct compat_iovec __user *
+	llgfr	%r4,%r4			# unsigned long
+	llgtr	%r5,%r5			# struct compat_iovec __user *
+	llgfr	%r6,%r6			# unsigned long
+	llgf	%r0,164(%r15)		# unsigned long
+	stg	%r0,160(%r15)
+	jg	sys_process_vm_writev
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 37394b3..c9ffe00 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -390,6 +390,8 @@ static __init void detect_machine_facilities(void)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_MVCOS;
 	if (test_facility(40))
 		S390_lowcore.machine_flags |= MACHINE_FLAG_SPP;
+	if (test_facility(25))
+		S390_lowcore.machine_flags |= MACHINE_FLAG_STCKF;
 #endif
 }
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 8ac6bfa..e58a462 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -211,6 +211,8 @@ static void __init setup_zfcpdump(unsigned int console_devno)
 
 	if (ipl_info.type != IPL_TYPE_FCP_DUMP)
 		return;
+	if (OLDMEM_BASE)
+		return;
 	if (console_devno != -1)
 		sprintf(str, " cio_ignore=all,!0.0.%04x,!0.0.%04x",
 			ipl_info.data.fcp.dev_id.devno, console_devno);
@@ -482,7 +484,7 @@ static void __init setup_memory_end(void)
 
 
 #ifdef CONFIG_ZFCPDUMP
-	if (ipl_info.type == IPL_TYPE_FCP_DUMP) {
+	if (ipl_info.type == IPL_TYPE_FCP_DUMP && !OLDMEM_BASE) {
 		memory_end = ZFCPDUMP_HSA_SIZE;
 		memory_end_set = 1;
 	}
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 73eb08c..bcab2f0 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -348,3 +348,5 @@ SYSCALL(sys_open_by_handle_at,sys_open_by_handle_at,compat_sys_open_by_handle_at
 SYSCALL(sys_clock_adjtime,sys_clock_adjtime,compat_sys_clock_adjtime_wrapper)
 SYSCALL(sys_syncfs,sys_syncfs,sys_syncfs_wrapper)
 SYSCALL(sys_setns,sys_setns,sys_setns_wrapper)
+SYSCALL(sys_process_vm_readv,sys_process_vm_readv,compat_sys_process_vm_readv_wrapper) /* 340 */
+SYSCALL(sys_process_vm_writev,sys_process_vm_writev,compat_sys_process_vm_writev_wrapper)
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 77b8942..fdb5b8c 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -68,8 +68,10 @@ static cpumask_t cpu_group_map(struct mask_info *info, unsigned int cpu)
 	return mask;
 }
 
-static void add_cpus_to_mask(struct topology_cpu *tl_cpu,
-			     struct mask_info *book, struct mask_info *core)
+static struct mask_info *add_cpus_to_mask(struct topology_cpu *tl_cpu,
+					  struct mask_info *book,
+					  struct mask_info *core,
+					  int z10)
 {
 	unsigned int cpu;
 
@@ -88,10 +90,16 @@ static void add_cpus_to_mask(struct topology_cpu *tl_cpu,
 			cpu_book_id[lcpu] = book->id;
 #endif
 			cpumask_set_cpu(lcpu, &core->mask);
-			cpu_core_id[lcpu] = core->id;
+			if (z10) {
+				cpu_core_id[lcpu] = rcpu;
+				core = core->next;
+			} else {
+				cpu_core_id[lcpu] = core->id;
+			}
 			smp_cpu_polarization[lcpu] = tl_cpu->pp;
 		}
 	}
+	return core;
 }
 
 static void clear_masks(void)
@@ -123,18 +131,41 @@ static void tl_to_cores(struct sysinfo_15_1_x *info)
 {
 #ifdef CONFIG_SCHED_BOOK
 	struct mask_info *book = &book_info;
+	struct cpuid cpu_id;
 #else
 	struct mask_info *book = NULL;
 #endif
 	struct mask_info *core = &core_info;
 	union topology_entry *tle, *end;
+	int z10 = 0;
 
-
+#ifdef CONFIG_SCHED_BOOK
+	get_cpu_id(&cpu_id);
+	z10 = cpu_id.machine == 0x2097 || cpu_id.machine == 0x2098;
+#endif
 	spin_lock_irq(&topology_lock);
 	clear_masks();
 	tle = info->tle;
 	end = (union topology_entry *)((unsigned long)info + info->length);
 	while (tle < end) {
+#ifdef CONFIG_SCHED_BOOK
+		if (z10) {
+			switch (tle->nl) {
+			case 1:
+				book = book->next;
+				book->id = tle->container.id;
+				break;
+			case 0:
+				core = add_cpus_to_mask(&tle->cpu, book, core, z10);
+				break;
+			default:
+				clear_masks();
+				goto out;
+			}
+			tle = next_tle(tle);
+			continue;
+		}
+#endif
 		switch (tle->nl) {
 #ifdef CONFIG_SCHED_BOOK
 		case 2:
@@ -147,7 +178,7 @@ static void tl_to_cores(struct sysinfo_15_1_x *info)
 			core->id = tle->container.id;
 			break;
 		case 0:
-			add_cpus_to_mask(&tle->cpu, book, core);
+			add_cpus_to_mask(&tle->cpu, book, core, z10);
 			break;
 		default:
 			clear_masks();
@@ -328,8 +359,8 @@ void __init s390_init_cpu_topology(void)
 	for (i = 0; i < TOPOLOGY_NR_MAG; i++)
 		printk(" %d", info->mag[i]);
 	printk(" / %d\n", info->mnest);
-	alloc_masks(info, &core_info, 2);
+	alloc_masks(info, &core_info, 1);
 #ifdef CONFIG_SCHED_BOOK
-	alloc_masks(info, &book_info, 3);
+	alloc_masks(info, &book_info, 2);
 #endif
 }
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 56fe6bc..e4c79eb 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -43,6 +43,8 @@ SECTIONS
 
 	NOTES :text :note
 
+	.dummy : { *(.dummy) } :data
+
 	RODATA
 
 #ifdef CONFIG_SHARED_KERNEL
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 1766def..a9a3018 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -587,8 +587,13 @@ static void pfault_interrupt(unsigned int ext_int_code,
 		} else {
 			/* Completion interrupt was faster than initial
 			 * interrupt. Set pfault_wait to -1 so the initial
-			 * interrupt doesn't put the task to sleep. */
-			tsk->thread.pfault_wait = -1;
+			 * interrupt doesn't put the task to sleep.
+			 * If the task is not running, ignore the completion
+			 * interrupt since it must be a leftover of a PFAULT
+			 * CANCEL operation which didn't remove all pending
+			 * completion interrupts. */
+			if (tsk->state == TASK_RUNNING)
+				tsk->thread.pfault_wait = -1;
 		}
 		put_task_struct(tsk);
 	} else {
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 43068fb..1b6d924 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -641,6 +641,8 @@ static int __init zcore_init(void)
 
 	if (ipl_info.type != IPL_TYPE_FCP_DUMP)
 		return -ENODATA;
+	if (OLDMEM_BASE)
+		return -ENODATA;
 
 	zcore_dbf = debug_register("zcore", 4, 1, 4 * sizeof(long));
 	debug_register_view(zcore_dbf, &debug_sprintf_view);
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index b77ae51..ec94f04 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1271,18 +1271,16 @@ ap_config_timeout(unsigned long ptr)
 }
 
 /**
- * ap_schedule_poll_timer(): Schedule poll timer.
+ * __ap_schedule_poll_timer(): Schedule poll timer.
  *
  * Set up the timer to run the poll tasklet
  */
-static inline void ap_schedule_poll_timer(void)
+static inline void __ap_schedule_poll_timer(void)
 {
 	ktime_t hr_time;
 
 	spin_lock_bh(&ap_poll_timer_lock);
-	if (ap_using_interrupts() || ap_suspend_flag)
-		goto out;
-	if (hrtimer_is_queued(&ap_poll_timer))
+	if (hrtimer_is_queued(&ap_poll_timer) || ap_suspend_flag)
 		goto out;
 	if (ktime_to_ns(hrtimer_expires_remaining(&ap_poll_timer)) <= 0) {
 		hr_time = ktime_set(0, poll_timeout);
@@ -1294,6 +1292,18 @@ out:
 }
 
 /**
+ * ap_schedule_poll_timer(): Schedule poll timer.
+ *
+ * Set up the timer to run the poll tasklet
+ */
+static inline void ap_schedule_poll_timer(void)
+{
+	if (ap_using_interrupts())
+		return;
+	__ap_schedule_poll_timer();
+}
+
+/**
  * ap_poll_read(): Receive pending reply messages from an AP device.
  * @ap_dev: pointer to the AP device
  * @flags: pointer to control flags, bit 2^0 is set if another poll is
@@ -1374,8 +1384,9 @@ static int ap_poll_write(struct ap_device *ap_dev, unsigned long *flags)
 			*flags |= 1;
 		*flags |= 2;
 		break;
-	case AP_RESPONSE_Q_FULL:
 	case AP_RESPONSE_RESET_IN_PROGRESS:
+		__ap_schedule_poll_timer();
+	case AP_RESPONSE_Q_FULL:
 		*flags |= 2;
 		break;
 	case AP_RESPONSE_MESSAGE_TOO_BIG:
