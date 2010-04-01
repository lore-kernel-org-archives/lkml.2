Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0DAXTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:19:08 -0400
Received: from kroah.org ([198.145.64.141]:35360 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758514Ab0DAXSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:18:45 -0400
Date: Thu, 1 Apr 2010 16:15:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.31.13
Message-ID: <20100401231512.GD11167@kroah.com>
References: <20100401231447.GC11167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401231447.GC11167@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/filesystems/tmpfs.txt b/Documentation/filesystems/tmpfs.txt
index 3015da0..fe09a2c 100644
--- a/Documentation/filesystems/tmpfs.txt
+++ b/Documentation/filesystems/tmpfs.txt
@@ -82,11 +82,13 @@ tmpfs has a mount option to set the NUMA memory allocation policy for
 all files in that instance (if CONFIG_NUMA is enabled) - which can be
 adjusted on the fly via 'mount -o remount ...'
 
-mpol=default             prefers to allocate memory from the local node
+mpol=default             use the process allocation policy
+                         (see set_mempolicy(2))
 mpol=prefer:Node         prefers to allocate memory from the given Node
 mpol=bind:NodeList       allocates memory only from nodes in NodeList
 mpol=interleave          prefers to allocate from each node in turn
 mpol=interleave:NodeList allocates from each node of NodeList in turn
+mpol=local		 prefers to allocate memory from the local node
 
 NodeList format is a comma-separated list of decimal numbers and ranges,
 a range being two hyphen-separated decimal numbers, the smallest and
@@ -134,3 +136,5 @@ Author:
    Christoph Rohland <cr@sap.com>, 1.12.01
 Updated:
    Hugh Dickins, 4 June 2007
+Updated:
+   KOSAKI Motohiro, 16 Mar 2010
diff --git a/Makefile b/Makefile
index 05c2ebf..ac8ee8e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 31
-EXTRAVERSION = .12
+EXTRAVERSION = .13
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index 014a624..5698502 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -236,14 +236,10 @@ typedef elf_vrregset_t elf_fpxregset_t;
 #ifdef __powerpc64__
 # define SET_PERSONALITY(ex)					\
 do {								\
-	unsigned long new_flags = 0;				\
 	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)		\
-		new_flags = _TIF_32BIT;				\
-	if ((current_thread_info()->flags & _TIF_32BIT)		\
-	    != new_flags)					\
-		set_thread_flag(TIF_ABI_PENDING);		\
+		set_thread_flag(TIF_32BIT);			\
 	else							\
-		clear_thread_flag(TIF_ABI_PENDING);		\
+		clear_thread_flag(TIF_32BIT);			\
 	if (personality(current->personality) != PER_LINUX32)	\
 		set_personality(PER_LINUX |			\
 			(current->personality & (~PER_MASK)));	\
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index c8b3292..aa9d383 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -111,7 +111,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
 #define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
-#define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -129,7 +128,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
-#define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
 #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 892a9f2..1ea56fd 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -554,18 +554,6 @@ void exit_thread(void)
 
 void flush_thread(void)
 {
-#ifdef CONFIG_PPC64
-	struct thread_info *t = current_thread_info();
-
-	if (test_ti_thread_flag(t, TIF_ABI_PENDING)) {
-		clear_ti_thread_flag(t, TIF_ABI_PENDING);
-		if (test_ti_thread_flag(t, TIF_32BIT))
-			clear_ti_thread_flag(t, TIF_32BIT);
-		else
-			set_ti_thread_flag(t, TIF_32BIT);
-	}
-#endif
-
 	discard_lazy_cpu_state();
 
 	if (current->thread.dabr) {
diff --git a/arch/sh/kernel/process_64.c b/arch/sh/kernel/process_64.c
index 24de742..54a5abf 100644
--- a/arch/sh/kernel/process_64.c
+++ b/arch/sh/kernel/process_64.c
@@ -367,7 +367,7 @@ void exit_thread(void)
 void flush_thread(void)
 {
 
-	/* Called by fs/exec.c (flush_old_exec) to remove traces of a
+	/* Called by fs/exec.c (setup_new_exec) to remove traces of a
 	 * previously running executable. */
 #ifdef CONFIG_SH_FPU
 	if (last_task_used_math == current) {
diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index d42e393..9968085 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -196,17 +196,10 @@ static inline unsigned int sparc64_elf_hwcap(void)
 #define ELF_PLATFORM	(NULL)
 
 #define SET_PERSONALITY(ex)				\
-do {	unsigned long new_flags = current_thread_info()->flags; \
-	new_flags &= _TIF_32BIT;			\
-	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)	\
-		new_flags |= _TIF_32BIT;		\
+do {	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)	\
+		set_thread_flag(TIF_32BIT);		\
 	else						\
-		new_flags &= ~_TIF_32BIT;		\
-	if ((current_thread_info()->flags & _TIF_32BIT) \
-	    != new_flags)				\
-		set_thread_flag(TIF_ABI_PENDING);	\
-	else						\
-		clear_thread_flag(TIF_ABI_PENDING);	\
+		clear_thread_flag(TIF_32BIT);		\
 	/* flush_thread will update pgd cache */	\
 	if (personality(current->personality) != PER_LINUX32)	\
 		set_personality(PER_LINUX |		\
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 1b45a7b..f78ad9a 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -227,12 +227,11 @@ register struct thread_info *current_thread_info_reg asm("g6");
 /* flag bit 8 is available */
 #define TIF_SECCOMP		9	/* secure computing */
 #define TIF_SYSCALL_AUDIT	10	/* syscall auditing active */
-/* flag bit 11 is available */
 /* NOTE: Thread flags >= 12 should be ones we have no interest
  *       in using in assembly, else we can't use the mask as
  *       an immediate value in instructions such as andcc.
  */
-#define TIF_ABI_PENDING		12
+/* flag bit 12 is available */
 #define TIF_MEMDIE		13
 #define TIF_POLLING_NRFLAG	14
 #define TIF_FREEZE		15	/* is freezing for suspend */
@@ -246,7 +245,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define _TIF_32BIT		(1<<TIF_32BIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
-#define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 4041f94..3714fdb 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -365,14 +365,6 @@ void flush_thread(void)
 	struct thread_info *t = current_thread_info();
 	struct mm_struct *mm;
 
-	if (test_ti_thread_flag(t, TIF_ABI_PENDING)) {
-		clear_ti_thread_flag(t, TIF_ABI_PENDING);
-		if (test_ti_thread_flag(t, TIF_32BIT))
-			clear_ti_thread_flag(t, TIF_32BIT);
-		else
-			set_ti_thread_flag(t, TIF_32BIT);
-	}
-
 	mm = t->task->mm;
 	if (mm)
 		tsb_context_switch(mm);
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 2a4d073..14531ab 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -308,14 +308,15 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (retval)
 		return retval;
 
-	regs->cs = __USER32_CS;
-	regs->r8 = regs->r9 = regs->r10 = regs->r11 = regs->r12 =
-		regs->r13 = regs->r14 = regs->r15 = 0;
-
 	/* OK, This is the point of no return */
 	set_personality(PER_LINUX);
 	set_thread_flag(TIF_IA32);
-	clear_thread_flag(TIF_ABI_PENDING);
+
+	setup_new_exec(bprm);
+
+	regs->cs = __USER32_CS;
+	regs->r8 = regs->r9 = regs->r10 = regs->r11 = regs->r12 =
+		regs->r13 = regs->r14 = regs->r15 = 0;
 
 	current->mm->end_code = ex.a_text +
 		(current->mm->start_code = N_TXTADDR(ex));
@@ -326,7 +327,6 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 456a304..8ac9d9a 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -197,14 +197,8 @@ do {							\
 	set_fs(USER_DS);				\
 } while (0)
 
-#define COMPAT_SET_PERSONALITY(ex)			\
-do {							\
-	if (test_thread_flag(TIF_IA32))			\
-		clear_thread_flag(TIF_ABI_PENDING);	\
-	else						\
-		set_thread_flag(TIF_ABI_PENDING);	\
-	current->personality |= force_personality32;	\
-} while (0)
+void set_personality_ia32(void);
+#define COMPAT_SET_PERSONALITY(ex) set_personality_ia32()
 
 #define COMPAT_ELF_PLATFORM			("i686")
 
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 7b2d71d..ebd0107 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -82,6 +82,9 @@ enum fixed_addresses {
 #endif
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	FIX_OHCI1394_BASE,
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 #endif
@@ -126,9 +129,6 @@ enum fixed_addresses {
 	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
 			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 330ee80..e9e97a3 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -159,6 +159,7 @@ extern int io_apic_get_redir_entries(int ioapic);
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
+void setup_IO_APIC_irq_extra(u32 gsi);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
diff --git a/arch/x86/include/asm/kvm_x86_emulate.h b/arch/x86/include/asm/kvm_x86_emulate.h
index b7ed2c4..7c18e12 100644
--- a/arch/x86/include/asm/kvm_x86_emulate.h
+++ b/arch/x86/include/asm/kvm_x86_emulate.h
@@ -129,7 +129,7 @@ struct decode_cache {
 	u8 seg_override;
 	unsigned int d;
 	unsigned long regs[NR_VCPU_REGS];
-	unsigned long eip;
+	unsigned long eip, eip_orig;
 	/* modrm */
 	u8 modrm;
 	u8 modrm_mod;
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index fad7d40..e4bcf0c 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -86,7 +86,6 @@ struct thread_info {
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
-#define TIF_ABI_PENDING		19
 #define TIF_MEMDIE		20
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
@@ -110,7 +109,6 @@ struct thread_info {
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
-#define _TIF_ABI_PENDING	(1 << TIF_ABI_PENDING)
 #define _TIF_DEBUG		(1 << TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6b8ca3a..36411c3 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -446,6 +446,12 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 {
 	*irq = gsi;
+
+#ifdef CONFIG_X86_IO_APIC
+	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
+		setup_IO_APIC_irq_extra(gsi);
+#endif
+
 	return 0;
 }
 
@@ -473,7 +479,8 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 	}
 #endif
-	acpi_gsi_to_irq(plat_gsi, &irq);
+	irq = plat_gsi;
+
 	return irq;
 }
 
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index d0c99ab..873f81f 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -240,6 +240,11 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 		printk(KERN_DEBUG "system APIC only can use physical flat");
 		return 1;
 	}
+
+	if (!strncmp(oem_id, "IBM", 3) && !strncmp(oem_table_id, "EXA", 3)) {
+		printk(KERN_DEBUG "IBM Summit detected, will use apic physical");
+		return 1;
+	}
 #endif
 
 	return 0;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d2ed6c5..938b69d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1558,6 +1558,56 @@ static void __init setup_IO_APIC_irqs(void)
 }
 
 /*
+ * for the gsit that is not in first ioapic
+ * but could not use acpi_register_gsi()
+ * like some special sci in IBM x3330
+ */
+void setup_IO_APIC_irq_extra(u32 gsi)
+{
+	int apic_id = 0, pin, idx, irq;
+	int node = cpu_to_node(boot_cpu_id);
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+
+	/*
+	 * Convert 'gsi' to 'ioapic.pin'.
+	 */
+	apic_id = mp_find_ioapic(gsi);
+	if (apic_id < 0)
+		return;
+
+	pin = mp_find_ioapic_pin(apic_id, gsi);
+	idx = find_irq_entry(apic_id, pin, mp_INT);
+	if (idx == -1)
+		return;
+
+	irq = pin_2_irq(idx, apic_id, pin);
+#ifdef CONFIG_SPARSE_IRQ
+	desc = irq_to_desc(irq);
+	if (desc)
+		return;
+#endif
+	desc = irq_to_desc_alloc_node(irq, node);
+	if (!desc) {
+		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+		return;
+	}
+
+	cfg = desc->chip_data;
+	add_pin_to_irq_node(cfg, node, apic_id, pin);
+
+	if (test_bit(pin, mp_ioapic_routing[apic_id].pin_programmed)) {
+		pr_debug("Pin %d-%d already programmed\n",
+			 mp_ioapics[apic_id].apicid, pin);
+		return;
+	}
+	set_bit(pin, mp_ioapic_routing[apic_id].pin_programmed);
+
+	setup_IO_APIC_irq(apic_id, pin, irq, desc,
+			irq_trigger(idx), irq_polarity(idx));
+}
+
+/*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
 static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index fde0cd3..8cbfb42 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1372,6 +1372,7 @@ static int __devexit powernowk8_cpu_exit(struct cpufreq_policy *pol)
 
 	kfree(data->powernow_table);
 	kfree(data);
+	per_cpu(powernow_data, pol->cpu) = NULL;
 
 	return 0;
 }
@@ -1391,7 +1392,7 @@ static unsigned int powernowk8_get(unsigned int cpu)
 	int err;
 
 	if (!data)
-		return -EINVAL;
+		return 0;
 
 	smp_call_function_single(cpu, query_values_on_cpu, &err, true);
 	if (err)
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9371448..0511035 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -210,8 +210,8 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 {
 	ssize_t ret = -EINVAL;
 
-	if ((len >> PAGE_SHIFT) > num_physpages) {
-		pr_err("microcode: too much data (max %ld pages)\n", num_physpages);
+	if ((len >> PAGE_SHIFT) > totalram_pages) {
+		pr_err("microcode: too much data (max %ld pages)\n", totalram_pages);
 		return ret;
 	}
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 071166a..a35fcbd 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -94,18 +94,6 @@ void flush_thread(void)
 {
 	struct task_struct *tsk = current;
 
-#ifdef CONFIG_X86_64
-	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
-		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
-		if (test_tsk_thread_flag(tsk, TIF_IA32)) {
-			clear_tsk_thread_flag(tsk, TIF_IA32);
-		} else {
-			set_tsk_thread_flag(tsk, TIF_IA32);
-			current_thread_info()->status |= TS_COMPAT;
-		}
-	}
-#endif
-
 	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 
 	tsk->thread.debugreg0 = 0;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ebefb54..80c2372 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -534,6 +534,17 @@ sys_clone(unsigned long clone_flags, unsigned long newsp,
 	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
 }
 
+void set_personality_ia32(void)
+{
+	/* inherit personality from parent */
+
+	/* Make sure to be in 32bit mode */
+	set_thread_flag(TIF_IA32);
+
+	/* Prepare the first "return" to user space */
+	current_thread_info()->status |= TS_COMPAT;
+}
+
 unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long stack;
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index ef4dfca..4b12352 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -606,6 +606,9 @@ static int do_insn_fetch(struct x86_emulate_ctxt *ctxt,
 {
 	int rc = 0;
 
+	/* x86 instructions are limited to 15 bytes. */
+	if (eip + size - ctxt->decode.eip_orig > 15)
+		return X86EMUL_UNHANDLEABLE;
 	eip += ctxt->cs_base;
 	while (size--) {
 		rc = do_fetch_insn_byte(ctxt, ops, eip++, dest++);
@@ -864,7 +867,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	/* Shadow copy of register state. Committed on successful emulation. */
 
 	memset(c, 0, sizeof(struct decode_cache));
-	c->eip = kvm_rip_read(ctxt->vcpu);
+	c->eip = c->eip_orig = kvm_rip_read(ctxt->vcpu);
 	ctxt->cs_base = seg_base(ctxt, VCPU_SREG_CS);
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 52e62e5..5da8792 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -282,6 +282,15 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		return -EINVAL;
 
 	prot = pgprot_val(vma->vm_page_prot);
+
+	/*
+ 	 * Return error if pat is not enabled and write_combine is requested.
+ 	 * Caller can followup with UC MINUS request and add a WC mtrr if there
+ 	 * is a free mtrr slot.
+ 	 */
+	if (!pat_enabled && write_combine)
+		return -EINVAL;
+
 	if (pat_enabled && write_combine)
 		prot |= _PAGE_CACHE_WC;
 	else if (pat_enabled || boot_cpu_data.x86 > 3)
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 66393d5..f6d8469 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -876,12 +876,14 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 		return(acpi_idle_enter_c1(dev, state));
 
 	local_irq_disable();
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we test
-	 * NEED_RESCHED:
-	 */
-	smp_mb();
+	if (cx->entry_method != ACPI_CSTATE_FFH) {
+		current_thread_info()->status &= ~TS_POLLING;
+		/*
+		 * TS_POLLING-cleared state must be visible before we test
+		 * NEED_RESCHED:
+		 */
+		smp_mb();
+	}
 
 	if (unlikely(need_resched())) {
 		current_thread_info()->status |= TS_POLLING;
@@ -961,12 +963,14 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	}
 
 	local_irq_disable();
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we test
-	 * NEED_RESCHED:
-	 */
-	smp_mb();
+	if (cx->entry_method != ACPI_CSTATE_FFH) {
+		current_thread_info()->status &= ~TS_POLLING;
+		/*
+		 * TS_POLLING-cleared state must be visible before we test
+		 * NEED_RESCHED:
+		 */
+		smp_mb();
+	}
 
 	if (unlikely(need_resched())) {
 		current_thread_info()->status |= TS_POLLING;
diff --git a/drivers/base/class.c b/drivers/base/class.c
index eb85e43..4317d4c 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -59,6 +59,8 @@ static void class_release(struct kobject *kobj)
 	else
 		pr_debug("class '%s' does not have a release() function, "
 			 "be careful\n", class->name);
+
+	kfree(cp);
 }
 
 static struct sysfs_ops class_sysfs_ops = {
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a52cc7f..c18bbbf 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -323,6 +323,9 @@ static int cciss_seq_show(struct seq_file *seq, void *v)
 	if (*pos > h->highest_lun)
 		return 0;
 
+	if (drv == NULL) /* it's possible for h->drv[] to have holes. */
+		return 0;
+
 	if (drv->heads == 0)
 		return 0;
 
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index cfa5a64..19ce9d6 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -114,9 +114,9 @@ static int agp_find_max(void)
 	long memory, index, result;
 
 #if PAGE_SHIFT < 20
-	memory = num_physpages >> (20 - PAGE_SHIFT);
+	memory = totalram_pages >> (20 - PAGE_SHIFT);
 #else
-	memory = num_physpages << (PAGE_SHIFT - 20);
+	memory = totalram_pages << (PAGE_SHIFT - 20);
 #endif
 	index = 1;
 
diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index ec58d8c..2171e9d 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1628,10 +1628,10 @@ static void ntty_close(struct tty_struct *tty, struct file *file)
 
 	dc->open_ttys--;
 	port->count--;
-	tty_port_tty_set(port, NULL);
 
 	if (port->count == 0) {
 		DBG1("close: %d", nport->token_dl);
+		tty_port_tty_set(port, NULL);
 		spin_lock_irqsave(&dc->spin_mutex, flags);
 		dc->last_ier &= ~(nport->token_dl);
 		writew(dc->last_ier, dc->reg_ier);
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 9fc9517..9531cf8 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1912,8 +1912,10 @@ static int tty_fasync(int fd, struct file *filp, int on)
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
+		get_pid(pid);
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
+		put_pid(pid);
 		if (retval)
 			goto out;
 	} else {
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index f060246..537c29a 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -36,17 +36,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Generic userspace <-> kernelspace connector.");
 
-static u32 cn_idx = CN_IDX_CONNECTOR;
-static u32 cn_val = CN_VAL_CONNECTOR;
-
-module_param(cn_idx, uint, 0);
-module_param(cn_val, uint, 0);
-MODULE_PARM_DESC(cn_idx, "Connector's main device idx.");
-MODULE_PARM_DESC(cn_val, "Connector's main device val.");
-
-static DEFINE_MUTEX(notify_lock);
-static LIST_HEAD(notify_list);
-
 static struct cn_dev cdev;
 
 static int cn_already_initialized;
@@ -210,54 +199,6 @@ static void cn_rx_skb(struct sk_buff *__skb)
 }
 
 /*
- * Notification routing.
- *
- * Gets id and checks if there are notification request for it's idx
- * and val.  If there are such requests notify the listeners with the
- * given notify event.
- *
- */
-static void cn_notify(struct cb_id *id, u32 notify_event)
-{
-	struct cn_ctl_entry *ent;
-
-	mutex_lock(&notify_lock);
-	list_for_each_entry(ent, &notify_list, notify_entry) {
-		int i;
-		struct cn_notify_req *req;
-		struct cn_ctl_msg *ctl = ent->msg;
-		int idx_found, val_found;
-
-		idx_found = val_found = 0;
-
-		req = (struct cn_notify_req *)ctl->data;
-		for (i = 0; i < ctl->idx_notify_num; ++i, ++req) {
-			if (id->idx >= req->first &&
-					id->idx < req->first + req->range) {
-				idx_found = 1;
-				break;
-			}
-		}
-
-		for (i = 0; i < ctl->val_notify_num; ++i, ++req) {
-			if (id->val >= req->first &&
-					id->val < req->first + req->range) {
-				val_found = 1;
-				break;
-			}
-		}
-
-		if (idx_found && val_found) {
-			struct cn_msg m = { .ack = notify_event, };
-
-			memcpy(&m.id, id, sizeof(m.id));
-			cn_netlink_send(&m, ctl->group, GFP_KERNEL);
-		}
-	}
-	mutex_unlock(&notify_lock);
-}
-
-/*
  * Callback add routing - adds callback with given ID and name.
  * If there is registered callback with the same ID it will not be added.
  *
@@ -276,8 +217,6 @@ int cn_add_callback(struct cb_id *id, char *name,
 	if (err)
 		return err;
 
-	cn_notify(id, 0);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cn_add_callback);
@@ -295,111 +234,9 @@ void cn_del_callback(struct cb_id *id)
 	struct cn_dev *dev = &cdev;
 
 	cn_queue_del_callback(dev->cbdev, id);
-	cn_notify(id, 1);
 }
 EXPORT_SYMBOL_GPL(cn_del_callback);
 
-/*
- * Checks two connector's control messages to be the same.
- * Returns 1 if they are the same or if the first one is corrupted.
- */
-static int cn_ctl_msg_equals(struct cn_ctl_msg *m1, struct cn_ctl_msg *m2)
-{
-	int i;
-	struct cn_notify_req *req1, *req2;
-
-	if (m1->idx_notify_num != m2->idx_notify_num)
-		return 0;
-
-	if (m1->val_notify_num != m2->val_notify_num)
-		return 0;
-
-	if (m1->len != m2->len)
-		return 0;
-
-	if ((m1->idx_notify_num + m1->val_notify_num) * sizeof(*req1) !=
-	    m1->len)
-		return 1;
-
-	req1 = (struct cn_notify_req *)m1->data;
-	req2 = (struct cn_notify_req *)m2->data;
-
-	for (i = 0; i < m1->idx_notify_num; ++i) {
-		if (req1->first != req2->first || req1->range != req2->range)
-			return 0;
-		req1++;
-		req2++;
-	}
-
-	for (i = 0; i < m1->val_notify_num; ++i) {
-		if (req1->first != req2->first || req1->range != req2->range)
-			return 0;
-		req1++;
-		req2++;
-	}
-
-	return 1;
-}
-
-/*
- * Main connector device's callback.
- *
- * Used for notification of a request's processing.
- */
-static void cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
-{
-	struct cn_ctl_msg *ctl;
-	struct cn_ctl_entry *ent;
-	u32 size;
-
-	if (msg->len < sizeof(*ctl))
-		return;
-
-	ctl = (struct cn_ctl_msg *)msg->data;
-
-	size = (sizeof(*ctl) + ((ctl->idx_notify_num +
-				 ctl->val_notify_num) *
-				sizeof(struct cn_notify_req)));
-
-	if (msg->len != size)
-		return;
-
-	if (ctl->len + sizeof(*ctl) != msg->len)
-		return;
-
-	/*
-	 * Remove notification.
-	 */
-	if (ctl->group == 0) {
-		struct cn_ctl_entry *n;
-
-		mutex_lock(&notify_lock);
-		list_for_each_entry_safe(ent, n, &notify_list, notify_entry) {
-			if (cn_ctl_msg_equals(ent->msg, ctl)) {
-				list_del(&ent->notify_entry);
-				kfree(ent);
-			}
-		}
-		mutex_unlock(&notify_lock);
-
-		return;
-	}
-
-	size += sizeof(*ent);
-
-	ent = kzalloc(size, GFP_KERNEL);
-	if (!ent)
-		return;
-
-	ent->msg = (struct cn_ctl_msg *)(ent + 1);
-
-	memcpy(ent->msg, ctl, size - sizeof(*ent));
-
-	mutex_lock(&notify_lock);
-	list_add(&ent->notify_entry, &notify_list);
-	mutex_unlock(&notify_lock);
-}
-
 static int cn_proc_show(struct seq_file *m, void *v)
 {
 	struct cn_queue_dev *dev = cdev.cbdev;
@@ -437,11 +274,8 @@ static const struct file_operations cn_file_ops = {
 static int __devinit cn_init(void)
 {
 	struct cn_dev *dev = &cdev;
-	int err;
 
 	dev->input = cn_rx_skb;
-	dev->id.idx = cn_idx;
-	dev->id.val = cn_val;
 
 	dev->nls = netlink_kernel_create(&init_net, NETLINK_CONNECTOR,
 					 CN_NETLINK_USERS + 0xf,
@@ -457,14 +291,6 @@ static int __devinit cn_init(void)
 
 	cn_already_initialized = 1;
 
-	err = cn_add_callback(&dev->id, "connector", &cn_callback);
-	if (err) {
-		cn_already_initialized = 0;
-		cn_queue_free_dev(dev->cbdev);
-		netlink_kernel_release(dev->nls);
-		return -EINVAL;
-	}
-
 	proc_net_fops_create(&init_net, "connector", S_IRUGO, &cn_file_ops);
 
 	return 0;
@@ -478,7 +304,6 @@ static void __devexit cn_fini(void)
 
 	proc_net_remove(&init_net, "connector");
 
-	cn_del_callback(&dev->id);
 	cn_queue_free_dev(dev->cbdev);
 	netlink_kernel_release(dev->nls);
 }
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index d335086..0bd85eb 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -577,7 +577,13 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		debugf0("\tUncorrected bits= 0x%x\n", ue_errors);
 
 		branch = EXTRACT_FBDCHAN_INDX(info->ferr_nf_fbd);
-		channel = branch;
+
+		/*
+		 * According with i5000 datasheet, bit 28 has no significance
+		 * for errors M4Err-M12Err and M17Err-M21Err, on FERR_NF_FBD
+		 */
+		channel = branch & 2;
+
 		bank = NREC_BANK(info->nrecmema);
 		rank = NREC_RANK(info->nrecmema);
 		rdwr = NREC_RDWR(info->nrecmema);
diff --git a/drivers/gpu/drm/r128/r128_cce.c b/drivers/gpu/drm/r128/r128_cce.c
index c75fd35..ebf9f63 100644
--- a/drivers/gpu/drm/r128/r128_cce.c
+++ b/drivers/gpu/drm/r128/r128_cce.c
@@ -353,6 +353,11 @@ static int r128_do_init_cce(struct drm_device * dev, drm_r128_init_t * init)
 
 	DRM_DEBUG("\n");
 
+	if (dev->dev_private) {
+		DRM_DEBUG("called when already initialized\n");
+		return -EINVAL;
+	}
+
 	dev_priv = kzalloc(sizeof(drm_r128_private_t), GFP_KERNEL);
 	if (dev_priv == NULL)
 		return -ENOMEM;
@@ -649,6 +654,8 @@ int r128_cce_start(struct drm_device *dev, void *data, struct drm_file *file_pri
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	if (dev_priv->cce_running || dev_priv->cce_mode == R128_PM4_NONPM4) {
 		DRM_DEBUG("while CCE running\n");
 		return 0;
@@ -671,6 +678,8 @@ int r128_cce_stop(struct drm_device *dev, void *data, struct drm_file *file_priv
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	/* Flush any pending CCE commands.  This ensures any outstanding
 	 * commands are exectuted by the engine before we turn it off.
 	 */
@@ -708,10 +717,7 @@ int r128_cce_reset(struct drm_device *dev, void *data, struct drm_file *file_pri
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (!dev_priv) {
-		DRM_DEBUG("called before init done\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	r128_do_cce_reset(dev_priv);
 
@@ -728,6 +734,8 @@ int r128_cce_idle(struct drm_device *dev, void *data, struct drm_file *file_priv
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	if (dev_priv->cce_running) {
 		r128_do_cce_flush(dev_priv);
 	}
@@ -741,6 +749,8 @@ int r128_engine_reset(struct drm_device *dev, void *data, struct drm_file *file_
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev->dev_private);
+
 	return r128_do_engine_reset(dev);
 }
 
diff --git a/drivers/gpu/drm/r128/r128_drv.h b/drivers/gpu/drm/r128/r128_drv.h
index 797a26c..3c60829 100644
--- a/drivers/gpu/drm/r128/r128_drv.h
+++ b/drivers/gpu/drm/r128/r128_drv.h
@@ -422,6 +422,14 @@ static __inline__ void r128_update_ring_snapshot(drm_r128_private_t * dev_priv)
  * Misc helper macros
  */
 
+#define DEV_INIT_TEST_WITH_RETURN(_dev_priv)				\
+do {									\
+	if (!_dev_priv) {						\
+		DRM_ERROR("called with no initialization\n");		\
+		return -EINVAL;						\
+	}								\
+} while (0)
+
 #define RING_SPACE_TEST_WITH_RETURN( dev_priv )				\
 do {									\
 	drm_r128_ring_buffer_t *ring = &dev_priv->ring; int i;		\
diff --git a/drivers/gpu/drm/r128/r128_state.c b/drivers/gpu/drm/r128/r128_state.c
index 026a48c..af2665c 100644
--- a/drivers/gpu/drm/r128/r128_state.c
+++ b/drivers/gpu/drm/r128/r128_state.c
@@ -1244,14 +1244,18 @@ static void r128_cce_dispatch_stipple(struct drm_device * dev, u32 * stipple)
 static int r128_cce_clear(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
-	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
+	drm_r128_sarea_t *sarea_priv;
 	drm_r128_clear_t *clear = data;
 	DRM_DEBUG("\n");
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	RING_SPACE_TEST_WITH_RETURN(dev_priv);
 
+	sarea_priv = dev_priv->sarea_priv;
+
 	if (sarea_priv->nbox > R128_NR_SAREA_CLIPRECTS)
 		sarea_priv->nbox = R128_NR_SAREA_CLIPRECTS;
 
@@ -1312,6 +1316,8 @@ static int r128_cce_flip(struct drm_device *dev, void *data, struct drm_file *fi
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	RING_SPACE_TEST_WITH_RETURN(dev_priv);
 
 	if (!dev_priv->page_flipping)
@@ -1331,6 +1337,8 @@ static int r128_cce_swap(struct drm_device *dev, void *data, struct drm_file *fi
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	RING_SPACE_TEST_WITH_RETURN(dev_priv);
 
 	if (sarea_priv->nbox > R128_NR_SAREA_CLIPRECTS)
@@ -1354,10 +1362,7 @@ static int r128_cce_vertex(struct drm_device *dev, void *data, struct drm_file *
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	DRM_DEBUG("pid=%d index=%d count=%d discard=%d\n",
 		  DRM_CURRENTPID, vertex->idx, vertex->count, vertex->discard);
@@ -1410,10 +1415,7 @@ static int r128_cce_indices(struct drm_device *dev, void *data, struct drm_file
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	DRM_DEBUG("pid=%d buf=%d s=%d e=%d d=%d\n", DRM_CURRENTPID,
 		  elts->idx, elts->start, elts->end, elts->discard);
@@ -1476,6 +1478,8 @@ static int r128_cce_blit(struct drm_device *dev, void *data, struct drm_file *fi
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	DRM_DEBUG("pid=%d index=%d\n", DRM_CURRENTPID, blit->idx);
 
 	if (blit->idx < 0 || blit->idx >= dma->buf_count) {
@@ -1501,6 +1505,8 @@ static int r128_cce_depth(struct drm_device *dev, void *data, struct drm_file *f
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	RING_SPACE_TEST_WITH_RETURN(dev_priv);
 
 	ret = -EINVAL;
@@ -1531,6 +1537,8 @@ static int r128_cce_stipple(struct drm_device *dev, void *data, struct drm_file
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	if (DRM_COPY_FROM_USER(&mask, stipple->mask, 32 * sizeof(u32)))
 		return -EFAULT;
 
@@ -1555,10 +1563,7 @@ static int r128_cce_indirect(struct drm_device *dev, void *data, struct drm_file
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	DRM_DEBUG("idx=%d s=%d e=%d d=%d\n",
 		  indirect->idx, indirect->start, indirect->end,
@@ -1620,10 +1625,7 @@ static int r128_getparam(struct drm_device *dev, void *data, struct drm_file *fi
 	drm_r128_getparam_t *param = data;
 	int value;
 
-	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	DRM_DEBUG("pid=%d\n", DRM_CURRENTPID);
 
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 303ccce..637867e 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -431,6 +431,13 @@ static const struct hid_device_id apple_devices[] = {
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
+			APPLE_ISO_KEYBOARD },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 047844d..c053721 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1259,6 +1259,9 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6301010..bee718f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -88,6 +88,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI	0x0236
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ISO	0x0237
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_JIS	0x0238
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_ATV_IRCONTROL	0x8241
diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index 262c133..14f910d 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -182,7 +182,7 @@ I2C_CLIENT_INSMOD_1(adt7462);
  *
  * Some, but not all, of these voltages have low/high limits.
  */
-#define ADT7462_VOLT_COUNT	12
+#define ADT7462_VOLT_COUNT	13
 
 #define ADT7462_VENDOR		0x41
 #define ADT7462_DEVICE		0x62
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 93c1722..2b8f439 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -191,7 +191,7 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *
 		if (err) {
 			dev_warn(dev,
 				 "Unable to access MSR 0xEE, for Tjmax, left"
-				 " at default");
+				 " at default\n");
 		} else if (eax & 0x40000000) {
 			tjmax = 85000;
 		}
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index 37ea6a4..3e51d54 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -767,6 +767,7 @@ leave:
 static int watchdog_open(struct inode *inode, struct file *filp)
 {
 	struct fschmd_data *pos, *data = NULL;
+	int watchdog_is_open;
 
 	/* We get called from drivers/char/misc.c with misc_mtx hold, and we
 	   call misc_register() from fschmd_probe() with watchdog_data_mutex
@@ -781,10 +782,12 @@ static int watchdog_open(struct inode *inode, struct file *filp)
 		}
 	}
 	/* Note we can never not have found data, so we don't check for this */
-	kref_get(&data->kref);
+	watchdog_is_open = test_and_set_bit(0, &data->watchdog_is_open);
+	if (!watchdog_is_open)
+		kref_get(&data->kref);
 	mutex_unlock(&watchdog_data_mutex);
 
-	if (test_and_set_bit(0, &data->watchdog_is_open))
+	if (watchdog_is_open)
 		return -EBUSY;
 
 	/* Start the watchdog */
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index a1787fd..2348622 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -870,17 +870,16 @@ static struct lm78_data *lm78_update_device(struct device *dev)
 static int __init lm78_isa_found(unsigned short address)
 {
 	int val, save, found = 0;
-
-	/* We have to request the region in two parts because some
-	   boards declare base+4 to base+7 as a PNP device */
-	if (!request_region(address, 4, "lm78")) {
-		pr_debug("lm78: Failed to request low part of region\n");
-		return 0;
-	}
-	if (!request_region(address + 4, 4, "lm78")) {
-		pr_debug("lm78: Failed to request high part of region\n");
-		release_region(address, 4);
-		return 0;
+	int port;
+
+	/* Some boards declare base+0 to base+7 as a PNP device, some base+4
+	 * to base+7 and some base+5 to base+6. So we better request each port
+	 * individually for the probing phase. */
+	for (port = address; port < address + LM78_EXTENT; port++) {
+		if (!request_region(port, 1, "lm78")) {
+			pr_debug("lm78: Failed to request port 0x%x\n", port);
+			goto release;
+		}
 	}
 
 #define REALLY_SLOW_IO
@@ -944,8 +943,8 @@ static int __init lm78_isa_found(unsigned short address)
 			val & 0x80 ? "LM79" : "LM78", (int)address);
 
  release:
-	release_region(address + 4, 4);
-	release_region(address, 4);
+	for (port--; port >= address; port--)
+		release_region(port, 1);
 	return found;
 }
 
diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
index 0bdab95..3c23700 100644
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -1818,17 +1818,17 @@ static int __init
 w83781d_isa_found(unsigned short address)
 {
 	int val, save, found = 0;
-
-	/* We have to request the region in two parts because some
-	   boards declare base+4 to base+7 as a PNP device */
-	if (!request_region(address, 4, "w83781d")) {
-		pr_debug("w83781d: Failed to request low part of region\n");
-		return 0;
-	}
-	if (!request_region(address + 4, 4, "w83781d")) {
-		pr_debug("w83781d: Failed to request high part of region\n");
-		release_region(address, 4);
-		return 0;
+	int port;
+
+	/* Some boards declare base+0 to base+7 as a PNP device, some base+4
+	 * to base+7 and some base+5 to base+6. So we better request each port
+	 * individually for the probing phase. */
+	for (port = address; port < address + W83781D_EXTENT; port++) {
+		if (!request_region(port, 1, "w83781d")) {
+			pr_debug("w83781d: Failed to request port 0x%x\n",
+				 port);
+			goto release;
+		}
 	}
 
 #define REALLY_SLOW_IO
@@ -1902,8 +1902,8 @@ w83781d_isa_found(unsigned short address)
 			val == 0x30 ? "W83782D" : "W83781D", (int)address);
 
  release:
-	release_region(address + 4, 4);
-	release_region(address, 4);
+	for (port--; port >= address; port--)
+		release_region(port, 1);
 	return found;
 }
 
diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
index 0ed68e2..f7346a9 100644
--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -75,7 +75,7 @@ static int pca_isa_waitforcompletion(void *pd)
 	unsigned long timeout;
 
 	if (irq > -1) {
-		ret = wait_event_interruptible_timeout(pca_wait,
+		ret = wait_event_timeout(pca_wait,
 				pca_isa_readbyte(pd, I2C_PCA_CON)
 				& I2C_PCA_CON_SI, pca_isa_ops.timeout);
 	} else {
@@ -96,7 +96,7 @@ static void pca_isa_resetchip(void *pd)
 }
 
 static irqreturn_t pca_handler(int this_irq, void *dev_id) {
-	wake_up_interruptible(&pca_wait);
+	wake_up(&pca_wait);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index c4df9d4..5b2213d 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -84,7 +84,7 @@ static int i2c_pca_pf_waitforcompletion(void *pd)
 	unsigned long timeout;
 
 	if (i2c->irq) {
-		ret = wait_event_interruptible_timeout(i2c->wait,
+		ret = wait_event_timeout(i2c->wait,
 			i2c->algo_data.read_byte(i2c, I2C_PCA_CON)
 			& I2C_PCA_CON_SI, i2c->adap.timeout);
 	} else {
@@ -122,7 +122,7 @@ static irqreturn_t i2c_pca_pf_handler(int this_irq, void *dev_id)
 	if ((i2c->algo_data.read_byte(i2c, I2C_PCA_CON) & I2C_PCA_CON_SI) == 0)
 		return IRQ_NONE;
 
-	wake_up_interruptible(&i2c->wait);
+	wake_up(&i2c->wait);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/i2c/busses/i2c-tiny-usb.c b/drivers/i2c/busses/i2c-tiny-usb.c
index b1c050f..e29b6d5 100644
--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/types.h>
 
 /* include interfaces to usb layer */
 #include <linux/usb.h>
@@ -31,8 +32,8 @@
 #define CMD_I2C_IO_END		(1<<1)
 
 /* i2c bit delay, default is 10us -> 100kHz */
-static int delay = 10;
-module_param(delay, int, 0);
+static unsigned short delay = 10;
+module_param(delay, ushort, 0);
 MODULE_PARM_DESC(delay, "bit delay in microseconds, "
 		 "e.g. 10 for 100kHz (default is 100kHz)");
 
@@ -109,7 +110,7 @@ static int usb_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs, int num)
 
 static u32 usb_func(struct i2c_adapter *adapter)
 {
-	u32 func;
+	__le32 func;
 
 	/* get functionality from adapter */
 	if (usb_read(adapter, CMD_GET_FUNC, 0, 0, &func, sizeof(func)) !=
@@ -118,7 +119,7 @@ static u32 usb_func(struct i2c_adapter *adapter)
 		return 0;
 	}
 
-	return func;
+	return le32_to_cpu(func);
 }
 
 /* This is the actual algorithm we define */
@@ -216,8 +217,7 @@ static int i2c_tiny_usb_probe(struct usb_interface *interface,
 		 "i2c-tiny-usb at bus %03d device %03d",
 		 dev->usb_dev->bus->busnum, dev->usb_dev->devnum);
 
-	if (usb_write(&dev->adapter, CMD_SET_DELAY,
-		      cpu_to_le16(delay), 0, NULL, 0) != 0) {
+	if (usb_write(&dev->adapter, CMD_SET_DELAY, delay, 0, NULL, 0) != 0) {
 		dev_err(&dev->adapter.dev,
 			"failure setting delay to %dus\n", delay);
 		retval = -EIO;
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 529d82c..b67c32c 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -752,6 +752,9 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 	   checking the returned value. */
 	res = device_for_each_child(&adap->dev, NULL, __unregister_client);
 
+	/* device name is gone after device_unregister */
+	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
+
 	/* clean up the sysfs representation */
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
@@ -764,8 +767,6 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 	idr_remove(&i2c_adapter_idr, adap->nr);
 	mutex_unlock(&core_lock);
 
-	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
-
 	/* Clear the device structure in case this adapter is ever going to be
 	   added again */
 	memset(&adap->dev, 0, sizeof(adap->dev));
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 5547e24..b172bef 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2003-2005 Peter Osterlund <petero2@telia.com>
  * Copyright (c) 2004 Dmitry Torokhov <dtor@mail.ru>
  * Copyright (c) 2005 Vojtech Pavlik <vojtech@suse.cz>
+ * Copyright (c) 2009 Sebastian Kapfer <sebastian_kapfer@gmx.net>
  *
  * ALPS detection, tap switching and status querying info is taken from
  * tpconfig utility (by C. Scott Ananian and Bruce Kall).
@@ -35,6 +36,8 @@
 #define ALPS_OLDPROTO	0x10
 #define ALPS_PASS	0x20
 #define ALPS_FW_BK_2	0x40
+#define ALPS_PS2_INTERLEAVED	0x80	/* 3-byte PS/2 packet interleaved with
+					   6-byte ALPS packet */
 
 static const struct alps_model_info alps_model_data[] = {
 	{ { 0x32, 0x02, 0x14 },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* Toshiba Salellite Pro M10 */
@@ -55,7 +58,9 @@ static const struct alps_model_info alps_model_data[] = {
 	{ { 0x20, 0x02, 0x0e },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* XXX */
 	{ { 0x22, 0x02, 0x0a },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },
 	{ { 0x22, 0x02, 0x14 }, 0xff, 0xff, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D600 */
-	{ { 0x62, 0x02, 0x14 }, 0xcf, 0xcf, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude E6500 */
+	/* Dell Latitude E5500, E6400, E6500, Precision M4400 */
+	{ { 0x62, 0x02, 0x14 }, 0xcf, 0xcf,
+		ALPS_PASS | ALPS_DUALPOINT | ALPS_PS2_INTERLEAVED },
 	{ { 0x73, 0x02, 0x50 }, 0xcf, 0xcf, ALPS_FW_BK_1 },		  /* Dell Vostro 1400 */
 };
 
@@ -66,20 +71,88 @@ static const struct alps_model_info alps_model_data[] = {
  */
 
 /*
- * ALPS abolute Mode - new format
+ * PS/2 packet format
+ *
+ * byte 0:  0    0 YSGN XSGN    1    M    R    L
+ * byte 1: X7   X6   X5   X4   X3   X2   X1   X0
+ * byte 2: Y7   Y6   Y5   Y4   Y3   Y2   Y1   Y0
+ *
+ * Note that the device never signals overflow condition.
+ *
+ * ALPS absolute Mode - new format
  *
  * byte 0:  1    ?    ?    ?    1    ?    ?    ?
  * byte 1:  0   x6   x5   x4   x3   x2   x1   x0
- * byte 2:  0   x10  x9   x8   x7    ?  fin  ges
+ * byte 2:  0  x10   x9   x8   x7    ?  fin  ges
  * byte 3:  0   y9   y8   y7    1    M    R    L
  * byte 4:  0   y6   y5   y4   y3   y2   y1   y0
  * byte 5:  0   z6   z5   z4   z3   z2   z1   z0
  *
+ * Dualpoint device -- interleaved packet format
+ *
+ * byte 0:    1    1    0    0    1    1    1    1
+ * byte 1:    0   x6   x5   x4   x3   x2   x1   x0
+ * byte 2:    0  x10   x9   x8   x7    0  fin  ges
+ * byte 3:    0    0 YSGN XSGN    1    1    1    1
+ * byte 4:   X7   X6   X5   X4   X3   X2   X1   X0
+ * byte 5:   Y7   Y6   Y5   Y4   Y3   Y2   Y1   Y0
+ * byte 6:    0   y9   y8   y7    1    m    r    l
+ * byte 7:    0   y6   y5   y4   y3   y2   y1   y0
+ * byte 8:    0   z6   z5   z4   z3   z2   z1   z0
+ *
+ * CAPITALS = stick, miniscules = touchpad
+ *
  * ?'s can have different meanings on different models,
  * such as wheel rotation, extra buttons, stick buttons
  * on a dualpoint, etc.
  */
 
+static bool alps_is_valid_first_byte(const struct alps_model_info *model,
+				     unsigned char data)
+{
+	return (data & model->mask0) == model->byte0;
+}
+
+static void alps_report_buttons(struct psmouse *psmouse,
+				struct input_dev *dev1, struct input_dev *dev2,
+				int left, int right, int middle)
+{
+	struct alps_data *priv = psmouse->private;
+	const struct alps_model_info *model = priv->i;
+
+	if (model->flags & ALPS_PS2_INTERLEAVED) {
+		struct input_dev *dev;
+
+		/*
+		 * If shared button has already been reported on the
+		 * other device (dev2) then this event should be also
+		 * sent through that device.
+		 */
+		dev = test_bit(BTN_LEFT, dev2->key) ? dev2 : dev1;
+		input_report_key(dev, BTN_LEFT, left);
+
+		dev = test_bit(BTN_RIGHT, dev2->key) ? dev2 : dev1;
+		input_report_key(dev, BTN_RIGHT, right);
+
+		dev = test_bit(BTN_MIDDLE, dev2->key) ? dev2 : dev1;
+		input_report_key(dev, BTN_MIDDLE, middle);
+
+		/*
+		 * Sync the _other_ device now, we'll do the first
+		 * device later once we report the rest of the events.
+		 */
+		input_sync(dev2);
+	} else {
+		/*
+		 * For devices with non-interleaved packets we know what
+		 * device buttons belong to so we can simply report them.
+		 */
+		input_report_key(dev1, BTN_LEFT, left);
+		input_report_key(dev1, BTN_RIGHT, right);
+		input_report_key(dev1, BTN_MIDDLE, middle);
+	}
+}
+
 static void alps_process_packet(struct psmouse *psmouse)
 {
 	struct alps_data *priv = psmouse->private;
@@ -89,18 +162,6 @@ static void alps_process_packet(struct psmouse *psmouse)
 	int x, y, z, ges, fin, left, right, middle;
 	int back = 0, forward = 0;
 
-	if ((packet[0] & 0xc8) == 0x08) {   /* 3-byte PS/2 packet */
-		input_report_key(dev2, BTN_LEFT,   packet[0] & 1);
-		input_report_key(dev2, BTN_RIGHT,  packet[0] & 2);
-		input_report_key(dev2, BTN_MIDDLE, packet[0] & 4);
-		input_report_rel(dev2, REL_X,
-			packet[1] ? packet[1] - ((packet[0] << 4) & 0x100) : 0);
-		input_report_rel(dev2, REL_Y,
-			packet[2] ? ((packet[0] << 3) & 0x100) - packet[2] : 0);
-		input_sync(dev2);
-		return;
-	}
-
 	if (priv->i->flags & ALPS_OLDPROTO) {
 		left = packet[2] & 0x10;
 		right = packet[2] & 0x08;
@@ -136,18 +197,13 @@ static void alps_process_packet(struct psmouse *psmouse)
 		input_report_rel(dev2, REL_X,  (x > 383 ? (x - 768) : x));
 		input_report_rel(dev2, REL_Y, -(y > 255 ? (y - 512) : y));
 
-		input_report_key(dev2, BTN_LEFT, left);
-		input_report_key(dev2, BTN_RIGHT, right);
-		input_report_key(dev2, BTN_MIDDLE, middle);
+		alps_report_buttons(psmouse, dev2, dev, left, right, middle);
 
-		input_sync(dev);
 		input_sync(dev2);
 		return;
 	}
 
-	input_report_key(dev, BTN_LEFT, left);
-	input_report_key(dev, BTN_RIGHT, right);
-	input_report_key(dev, BTN_MIDDLE, middle);
+	alps_report_buttons(psmouse, dev, dev2, left, right, middle);
 
 	/* Convert hardware tap to a reasonable Z value */
 	if (ges && !fin) z = 40;
@@ -188,25 +244,168 @@ static void alps_process_packet(struct psmouse *psmouse)
 	input_sync(dev);
 }
 
+static void alps_report_bare_ps2_packet(struct psmouse *psmouse,
+					unsigned char packet[],
+					bool report_buttons)
+{
+	struct alps_data *priv = psmouse->private;
+	struct input_dev *dev2 = priv->dev2;
+
+	if (report_buttons)
+		alps_report_buttons(psmouse, dev2, psmouse->dev,
+				packet[0] & 1, packet[0] & 2, packet[0] & 4);
+
+	input_report_rel(dev2, REL_X,
+		packet[1] ? packet[1] - ((packet[0] << 4) & 0x100) : 0);
+	input_report_rel(dev2, REL_Y,
+		packet[2] ? ((packet[0] << 3) & 0x100) - packet[2] : 0);
+
+	input_sync(dev2);
+}
+
+static psmouse_ret_t alps_handle_interleaved_ps2(struct psmouse *psmouse)
+{
+	struct alps_data *priv = psmouse->private;
+
+	if (psmouse->pktcnt < 6)
+		return PSMOUSE_GOOD_DATA;
+
+	if (psmouse->pktcnt == 6) {
+		/*
+		 * Start a timer to flush the packet if it ends up last
+		 * 6-byte packet in the stream. Timer needs to fire
+		 * psmouse core times out itself. 20 ms should be enough
+		 * to decide if we are getting more data or not.
+		 */
+		mod_timer(&priv->timer, jiffies + msecs_to_jiffies(20));
+		return PSMOUSE_GOOD_DATA;
+	}
+
+	del_timer(&priv->timer);
+
+	if (psmouse->packet[6] & 0x80) {
+
+		/*
+		 * Highest bit is set - that means we either had
+		 * complete ALPS packet and this is start of the
+		 * next packet or we got garbage.
+		 */
+
+		if (((psmouse->packet[3] |
+		      psmouse->packet[4] |
+		      psmouse->packet[5]) & 0x80) ||
+		    (!alps_is_valid_first_byte(priv->i, psmouse->packet[6]))) {
+			dbg("refusing packet %x %x %x %x "
+			    "(suspected interleaved ps/2)\n",
+			    psmouse->packet[3], psmouse->packet[4],
+			    psmouse->packet[5], psmouse->packet[6]);
+			return PSMOUSE_BAD_DATA;
+		}
+
+		alps_process_packet(psmouse);
+
+		/* Continue with the next packet */
+		psmouse->packet[0] = psmouse->packet[6];
+		psmouse->pktcnt = 1;
+
+	} else {
+
+		/*
+		 * High bit is 0 - that means that we indeed got a PS/2
+		 * packet in the middle of ALPS packet.
+		 *
+		 * There is also possibility that we got 6-byte ALPS
+		 * packet followed  by 3-byte packet from trackpoint. We
+		 * can not distinguish between these 2 scenarios but
+		 * becase the latter is unlikely to happen in course of
+		 * normal operation (user would need to press all
+		 * buttons on the pad and start moving trackpoint
+		 * without touching the pad surface) we assume former.
+		 * Even if we are wrong the wost thing that would happen
+		 * the cursor would jump but we should not get protocol
+		 * desynchronization.
+		 */
+
+		alps_report_bare_ps2_packet(psmouse, &psmouse->packet[3],
+					    false);
+
+		/*
+		 * Continue with the standard ALPS protocol handling,
+		 * but make sure we won't process it as an interleaved
+		 * packet again, which may happen if all buttons are
+		 * pressed. To avoid this let's reset the 4th bit which
+		 * is normally 1.
+		 */
+		psmouse->packet[3] = psmouse->packet[6] & 0xf7;
+		psmouse->pktcnt = 4;
+	}
+
+	return PSMOUSE_GOOD_DATA;
+}
+
+static void alps_flush_packet(unsigned long data)
+{
+	struct psmouse *psmouse = (struct psmouse *)data;
+
+	serio_pause_rx(psmouse->ps2dev.serio);
+
+	if (psmouse->pktcnt == 6) {
+
+		/*
+		 * We did not any more data in reasonable amount of time.
+		 * Validate the last 3 bytes and process as a standard
+		 * ALPS packet.
+		 */
+		if ((psmouse->packet[3] |
+		     psmouse->packet[4] |
+		     psmouse->packet[5]) & 0x80) {
+			dbg("refusing packet %x %x %x "
+			    "(suspected interleaved ps/2)\n",
+			    psmouse->packet[3], psmouse->packet[4],
+			    psmouse->packet[5]);
+		} else {
+			alps_process_packet(psmouse);
+		}
+		psmouse->pktcnt = 0;
+	}
+
+	serio_continue_rx(psmouse->ps2dev.serio);
+}
+
 static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 {
 	struct alps_data *priv = psmouse->private;
+	const struct alps_model_info *model = priv->i;
 
 	if ((psmouse->packet[0] & 0xc8) == 0x08) { /* PS/2 packet */
 		if (psmouse->pktcnt == 3) {
-			alps_process_packet(psmouse);
+			alps_report_bare_ps2_packet(psmouse, psmouse->packet,
+						    true);
 			return PSMOUSE_FULL_PACKET;
 		}
 		return PSMOUSE_GOOD_DATA;
 	}
 
-	if ((psmouse->packet[0] & priv->i->mask0) != priv->i->byte0)
+	/* Check for PS/2 packet stuffed in the middle of ALPS packet. */
+
+	if ((model->flags & ALPS_PS2_INTERLEAVED) &&
+	    psmouse->pktcnt >= 4 && (psmouse->packet[3] & 0x0f) == 0x0f) {
+		return alps_handle_interleaved_ps2(psmouse);
+	}
+
+	if (!alps_is_valid_first_byte(model, psmouse->packet[0])) {
+		dbg("refusing packet[0] = %x (mask0 = %x, byte0 = %x)\n",
+		    psmouse->packet[0], model->mask0, model->byte0);
 		return PSMOUSE_BAD_DATA;
+	}
 
 	/* Bytes 2 - 6 should have 0 in the highest bit */
 	if (psmouse->pktcnt >= 2 && psmouse->pktcnt <= 6 &&
-	    (psmouse->packet[psmouse->pktcnt - 1] & 0x80))
+	    (psmouse->packet[psmouse->pktcnt - 1] & 0x80)) {
+		dbg("refusing packet[%i] = %x\n",
+		    psmouse->pktcnt - 1, psmouse->packet[psmouse->pktcnt - 1]);
 		return PSMOUSE_BAD_DATA;
+	}
 
 	if (psmouse->pktcnt == 6) {
 		alps_process_packet(psmouse);
@@ -441,6 +640,7 @@ static void alps_disconnect(struct psmouse *psmouse)
 	struct alps_data *priv = psmouse->private;
 
 	psmouse_reset(psmouse);
+	del_timer_sync(&priv->timer);
 	input_unregister_device(priv->dev2);
 	kfree(priv);
 }
@@ -457,6 +657,8 @@ int alps_init(struct psmouse *psmouse)
 		goto init_fail;
 
 	priv->dev2 = dev2;
+	setup_timer(&priv->timer, alps_flush_packet, (unsigned long)psmouse);
+
 	psmouse->private = priv;
 
 	if (alps_hw_init(psmouse, &version))
diff --git a/drivers/input/mouse/alps.h b/drivers/input/mouse/alps.h
index 4bbddc9..4b60241 100644
--- a/drivers/input/mouse/alps.h
+++ b/drivers/input/mouse/alps.h
@@ -23,6 +23,7 @@ struct alps_data {
 	char phys[32];			/* Phys */
 	const struct alps_model_info *i;/* Info */
 	int prev_fin;			/* Finger bit from previous packet */
+	struct timer_list timer;
 };
 
 #ifdef CONFIG_MOUSE_PS2_ALPS
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 26690df..4d0c8d5 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1266,6 +1266,7 @@ static struct usb_device_id af9015_usb_table[] = {
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_CONCEPTRONIC_CTVDIGRCU)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_MC810)},
 	{USB_DEVICE(USB_VID_KYE,       USB_PID_GENIUS_TVGO_DVB_T03)},
+/* 25 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_399U_2)},
 	{0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1346,7 +1347,8 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 			{
 				.name = "KWorld PlusTV Dual DVB-T Stick " \
 					"(DVB-T 399U)",
-				.cold_ids = {&af9015_usb_table[4], NULL},
+				.cold_ids = {&af9015_usb_table[4],
+					     &af9015_usb_table[25], NULL},
 				.warm_ids = {NULL},
 			},
 			{
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 9593b72..5ace131 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -103,6 +103,7 @@
 #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
 #define USB_PID_INTEL_CE9500				0x9500
 #define USB_PID_KWORLD_399U				0xe399
+#define USB_PID_KWORLD_399U_2				0xe400
 #define USB_PID_KWORLD_395U				0xe396
 #define USB_PID_KWORLD_395U_2				0xe39b
 #define USB_PID_KWORLD_395U_3				0xe395
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index d603575..ec1d212 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -591,6 +591,7 @@ static int dvb_fini(struct em28xx *dev)
 
 	if (dev->dvb) {
 		unregister_dvb(dev->dvb);
+		kfree(dev->dvb);
 		dev->dvb = NULL;
 	}
 
diff --git a/drivers/media/video/pwc/pwc-ctrl.c b/drivers/media/video/pwc/pwc-ctrl.c
index 50b415e..f7f7e04 100644
--- a/drivers/media/video/pwc/pwc-ctrl.c
+++ b/drivers/media/video/pwc/pwc-ctrl.c
@@ -753,7 +753,7 @@ int pwc_set_shutter_speed(struct pwc_device *pdev, int mode, int value)
 		buf[0] = 0xff; /* fixed */
 
 	ret = send_control_msg(pdev,
-		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, sizeof(buf));
+		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, 1);
 
 	if (!mode && ret >= 0) {
 		if (value < 0)
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 04b4783..5a8a8d1 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -46,6 +46,7 @@
 unsigned int uvc_no_drop_param;
 static unsigned int uvc_quirks_param;
 unsigned int uvc_trace_param;
+unsigned int uvc_timeout_param = UVC_CTRL_STREAMING_TIMEOUT;
 
 /* ------------------------------------------------------------------------
  * Video formats
@@ -2034,6 +2035,8 @@ module_param_named(quirks, uvc_quirks_param, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(quirks, "Forced device quirks");
 module_param_named(trace, uvc_trace_param, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(trace, "Trace level bitmask");
+module_param_named(timeout, uvc_timeout_param, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(timeout, "Streaming control requests timeout");
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 01b633c..f2480c3 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -130,7 +130,7 @@ static int uvc_get_video_ctrl(struct uvc_video_device *video,
 
 	ret = __uvc_query_ctrl(video->dev, query, 0, video->streaming->intfnum,
 		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
-		UVC_CTRL_STREAMING_TIMEOUT);
+		uvc_timeout_param);
 
 	if ((query == GET_MIN || query == GET_MAX) && ret == 2) {
 		/* Some cameras, mostly based on Bison Electronics chipsets,
@@ -235,7 +235,7 @@ static int uvc_set_video_ctrl(struct uvc_video_device *video,
 	ret = __uvc_query_ctrl(video->dev, SET_CUR, 0,
 		video->streaming->intfnum,
 		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
-		UVC_CTRL_STREAMING_TIMEOUT);
+		uvc_timeout_param);
 	if (ret != size) {
 		uvc_printk(KERN_ERR, "Failed to set UVC %s control : "
 			"%d (exp. %u).\n", probe ? "probe" : "commit",
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 3c78d3c..3265fbf 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -304,7 +304,7 @@ struct uvc_xu_control {
 #define UVC_MAX_STATUS_SIZE	16
 
 #define UVC_CTRL_CONTROL_TIMEOUT	300
-#define UVC_CTRL_STREAMING_TIMEOUT	1000
+#define UVC_CTRL_STREAMING_TIMEOUT	3000
 
 /* Devices quirks */
 #define UVC_QUIRK_STATUS_INTERVAL	0x00000001
@@ -695,6 +695,7 @@ struct uvc_driver {
 
 extern unsigned int uvc_no_drop_param;
 extern unsigned int uvc_trace_param;
+extern unsigned int uvc_timeout_param;
 
 #define uvc_trace(flag, msg...) \
 	do { \
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 348443b..8393376 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -362,6 +362,7 @@ static const char *const enclosure_status [] = {
 	[ENCLOSURE_STATUS_NOT_INSTALLED] = "not installed",
 	[ENCLOSURE_STATUS_UNKNOWN] = "unknown",
 	[ENCLOSURE_STATUS_UNAVAILABLE] = "unavailable",
+	[ENCLOSURE_STATUS_MAX] = NULL,
 };
 
 static const char *const enclosure_type [] = {
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index f237ddb..111ea41 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -853,7 +853,6 @@ static long ubi_cdev_ioctl(struct file *file, unsigned int cmd,
 			break;
 		}
 
-		req.name[req.name_len] = '\0';
 		err = verify_mkvol_req(ubi, &req);
 		if (err)
 			break;
diff --git a/drivers/net/sfc/tx.c b/drivers/net/sfc/tx.c
index 14a1478..d36a289 100644
--- a/drivers/net/sfc/tx.c
+++ b/drivers/net/sfc/tx.c
@@ -823,8 +823,6 @@ static void efx_enqueue_unwind(struct efx_tx_queue *tx_queue)
 					   tx_queue->efx->type->txd_ring_mask];
 		efx_tsoh_free(tx_queue, buffer);
 		EFX_BUG_ON_PARANOID(buffer->skb);
-		buffer->len = 0;
-		buffer->continuation = true;
 		if (buffer->unmap_len) {
 			unmap_addr = (buffer->dma_addr + buffer->len -
 				      buffer->unmap_len);
@@ -838,6 +836,8 @@ static void efx_enqueue_unwind(struct efx_tx_queue *tx_queue)
 					       PCI_DMA_TODEVICE);
 			buffer->unmap_len = 0;
 		}
+		buffer->len = 0;
+		buffer->continuation = true;
 	}
 }
 
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 8ce5e4c..374f747 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5249,11 +5249,7 @@ static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
 	WepKeyRid wkr;
 	int rc;
 
-	if (keylen == 0) {
-		airo_print_err(ai->dev->name, "%s: key length to set was zero",
-			       __func__);
-		return -1;
-	}
+	WARN_ON(keylen == 0);
 
 	memset(&wkr, 0, sizeof(wkr));
 	wkr.len = cpu_to_le16(sizeof(wkr));
@@ -6399,11 +6395,7 @@ static int airo_set_encode(struct net_device *dev,
 		if (dwrq->length > MIN_KEY_SIZE)
 			key.len = MAX_KEY_SIZE;
 		else
-			if (dwrq->length > 0)
-				key.len = MIN_KEY_SIZE;
-			else
-				/* Disable the key */
-				key.len = 0;
+			key.len = MIN_KEY_SIZE;
 		/* Check if the key is not marked as invalid */
 		if(!(dwrq->flags & IW_ENCODE_NOKEY)) {
 			/* Cleanup */
@@ -6584,12 +6576,22 @@ static int airo_set_encodeext(struct net_device *dev,
 		default:
 			return -EINVAL;
 		}
-		/* Send the key to the card */
-		rc = set_wep_key(local, idx, key.key, key.len, perm, 1);
-		if (rc < 0) {
-			airo_print_err(local->dev->name, "failed to set WEP key"
-			               " at index %d: %d.", idx, rc);
-			return rc;
+		if (key.len == 0) {
+			rc = set_wep_tx_idx(local, idx, perm, 1);
+			if (rc < 0) {
+				airo_print_err(local->dev->name,
+					       "failed to set WEP transmit index to %d: %d.",
+					       idx, rc);
+				return rc;
+			}
+		} else {
+			rc = set_wep_key(local, idx, key.key, key.len, perm, 1);
+			if (rc < 0) {
+				airo_print_err(local->dev->name,
+					       "failed to set WEP key at index %d: %d.",
+					       idx, rc);
+				return rc;
+			}
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index fb32785..5eded5a 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -97,7 +97,7 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	int ret;
 	u16 val;
-	u32 cksum, offset;
+	u32 cksum, offset, eep_max = AR5K_EEPROM_INFO_MAX;
 
 	/*
 	 * Read values from EEPROM and store them in the capability structure
@@ -116,12 +116,38 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 	 * Validate the checksum of the EEPROM date. There are some
 	 * devices with invalid EEPROMs.
 	 */
-	for (cksum = 0, offset = 0; offset < AR5K_EEPROM_INFO_MAX; offset++) {
+	AR5K_EEPROM_READ(AR5K_EEPROM_SIZE_UPPER, val);
+	if (val) {
+		eep_max = (val & AR5K_EEPROM_SIZE_UPPER_MASK) <<
+			   AR5K_EEPROM_SIZE_ENDLOC_SHIFT;
+		AR5K_EEPROM_READ(AR5K_EEPROM_SIZE_LOWER, val);
+		eep_max = (eep_max | val) - AR5K_EEPROM_INFO_BASE;
+
+		/*
+		 * Fail safe check to prevent stupid loops due
+		 * to busted EEPROMs. XXX: This value is likely too
+		 * big still, waiting on a better value.
+		 */
+		if (eep_max > (3 * AR5K_EEPROM_INFO_MAX)) {
+			ATH5K_ERR(ah->ah_sc, "Invalid max custom EEPROM size: "
+				  "%d (0x%04x) max expected: %d (0x%04x)\n",
+				  eep_max, eep_max,
+				  3 * AR5K_EEPROM_INFO_MAX,
+				  3 * AR5K_EEPROM_INFO_MAX);
+			return -EIO;
+		}
+	}
+
+	for (cksum = 0, offset = 0; offset < eep_max; offset++) {
 		AR5K_EEPROM_READ(AR5K_EEPROM_INFO(offset), val);
 		cksum ^= val;
 	}
 	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
-		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
+		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM "
+			  "checksum: 0x%04x eep_max: 0x%04x (%s)\n",
+			  cksum, eep_max,
+			  eep_max == AR5K_EEPROM_INFO_MAX ?
+				"default size" : "custom size");
 		return -EIO;
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 64be73a..020bc4c 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -34,6 +34,14 @@
 #define AR5K_EEPROM_RFKILL_POLARITY_S	1
 
 #define AR5K_EEPROM_REG_DOMAIN		0x00bf	/* EEPROM regdom */
+
+/* FLASH(EEPROM) Defines for AR531X chips */
+#define AR5K_EEPROM_SIZE_LOWER		0x1b /* size info -- lower */
+#define AR5K_EEPROM_SIZE_UPPER		0x1c /* size info -- upper */
+#define AR5K_EEPROM_SIZE_UPPER_MASK	0xfff0
+#define AR5K_EEPROM_SIZE_UPPER_SHIFT	4
+#define AR5K_EEPROM_SIZE_ENDLOC_SHIFT	12
+
 #define AR5K_EEPROM_CHECKSUM		0x00c0	/* EEPROM checksum */
 #define AR5K_EEPROM_INFO_BASE		0x00c0	/* EEPROM header */
 #define AR5K_EEPROM_INFO_MAX		(0x400 - AR5K_EEPROM_INFO_BASE)
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 4044806..7797166 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -117,6 +117,7 @@
 #define B43_MMIO_TSF_2			0x636	/* core rev < 3 only */
 #define B43_MMIO_TSF_3			0x638	/* core rev < 3 only */
 #define B43_MMIO_RNG			0x65A
+#define B43_MMIO_IFSSLOT		0x684	/* Interframe slot time */
 #define B43_MMIO_IFSCTL			0x688 /* Interframe space control */
 #define  B43_MMIO_IFSCTL_USE_EDCF	0x0004
 #define B43_MMIO_POWERUP_DELAY		0x6A8
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index e71c8d9..82fb9d4 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -664,10 +664,17 @@ static void b43_upload_card_macaddress(struct b43_wldev *dev)
 static void b43_set_slot_time(struct b43_wldev *dev, u16 slot_time)
 {
 	/* slot_time is in usec. */
-	if (dev->phy.type != B43_PHYTYPE_G)
+	/* This test used to exit for all but a G PHY. */
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
 		return;
-	b43_write16(dev, 0x684, 510 + slot_time);
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x0010, slot_time);
+	b43_write16(dev, B43_MMIO_IFSSLOT, 510 + slot_time);
+	/* Shared memory location 0x0010 is the slot time and should be
+	 * set to slot_time; however, this register is initially 0 and changing
+	 * the value adversely affects the transmit rate for BCM4311
+	 * devices. Until this behavior is unterstood, delete this step
+	 *
+	 * b43_shm_write16(dev, B43_SHM_SHARED, 0x0010, slot_time);
+	 */
 }
 
 static void b43_short_slot_timing_enable(struct b43_wldev *dev)
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index a45b0c0..a6b4a5a 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1266,7 +1266,7 @@ ccio_ioc_init(struct ioc *ioc)
 	** Hot-Plug/Removal of PCI cards. (aka PCI OLARD).
 	*/
 
-	iova_space_size = (u32) (num_physpages / count_parisc_driver(&ccio_driver));
+	iova_space_size = (u32) (totalram_pages / count_parisc_driver(&ccio_driver));
 
 	/* limit IOVA space size to 1MB-1GB */
 
@@ -1305,7 +1305,7 @@ ccio_ioc_init(struct ioc *ioc)
 
 	DBG_INIT("%s() hpa 0x%p mem %luMB IOV %dMB (%d bits)\n",
 			__func__, ioc->ioc_regs,
-			(unsigned long) num_physpages >> (20 - PAGE_SHIFT),
+			(unsigned long) totalram_pages >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 123d8fe..57a6d19 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1390,7 +1390,7 @@ sba_ioc_init(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 	** for DMA hints - ergo only 30 bits max.
 	*/
 
-	iova_space_size = (u32) (num_physpages/global_ioc_cnt);
+	iova_space_size = (u32) (totalram_pages/global_ioc_cnt);
 
 	/* limit IOVA space size to 1MB-1GB */
 	if (iova_space_size < (1 << (20 - PAGE_SHIFT))) {
@@ -1415,7 +1415,7 @@ sba_ioc_init(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 	DBG_INIT("%s() hpa 0x%lx mem %ldMB IOV %dMB (%d bits)\n",
 			__func__,
 			ioc->ioc_hpa,
-			(unsigned long) num_physpages >> (20 - PAGE_SHIFT),
+			(unsigned long) totalram_pages >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
diff --git a/drivers/rtc/rtc-fm3130.c b/drivers/rtc/rtc-fm3130.c
index 3a7be11..812c667 100644
--- a/drivers/rtc/rtc-fm3130.c
+++ b/drivers/rtc/rtc-fm3130.c
@@ -376,20 +376,22 @@ static int __devinit fm3130_probe(struct i2c_client *client,
 	}
 
 	/* Disabling calibration mode */
-	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_CAL)
+	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_CAL) {
 		i2c_smbus_write_byte_data(client, FM3130_RTC_CONTROL,
 			fm3130->regs[FM3130_RTC_CONTROL] &
 				~(FM3130_RTC_CONTROL_BIT_CAL));
 		dev_warn(&client->dev, "Disabling calibration mode!\n");
+	}
 
 	/* Disabling read and write modes */
 	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_WRITE ||
-	    fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_READ)
+	    fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_READ) {
 		i2c_smbus_write_byte_data(client, FM3130_RTC_CONTROL,
 			fm3130->regs[FM3130_RTC_CONTROL] &
 				~(FM3130_RTC_CONTROL_BIT_READ |
 					FM3130_RTC_CONTROL_BIT_WRITE));
 		dev_warn(&client->dev, "Disabling READ or WRITE mode!\n");
+	}
 
 	/* oscillator off?  turn it on, so clock can tick. */
 	if (fm3130->regs[FM3130_CAL_CONTROL] & FM3130_CAL_CONTROL_BIT_nOSCEN)
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 7a838c8..4352e30 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3451,7 +3451,7 @@ out:
 	return retval;
 }
 
-static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
+static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUSR,
 		megasas_sysfs_show_poll_mode_io,
 		megasas_sysfs_set_poll_mode_io);
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c7a0870..bb65cce 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5496,6 +5496,8 @@ _scsih_remove(struct pci_dev *pdev)
 	struct _sas_port *mpt2sas_port;
 	struct _sas_device *sas_device;
 	struct _sas_node *expander_sibling;
+	struct _raid_device *raid_device, *next;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 
@@ -5509,6 +5511,21 @@ _scsih_remove(struct pci_dev *pdev)
 	if (wq)
 		destroy_workqueue(wq);
 
+	/* release all the volumes */
+	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
+	    list) {
+		if (raid_device->starget) {
+			sas_target_priv_data =
+			    raid_device->starget->hostdata;
+			sas_target_priv_data->deleted = 1;
+			scsi_remove_target(&raid_device->starget->dev);
+		}
+		printk(MPT2SAS_INFO_FMT "removing handle(0x%04x), wwid"
+		    "(0x%016llx)\n", ioc->name,  raid_device->handle,
+		    (unsigned long long) raid_device->wwid);
+		_scsih_raid_device_remove(ioc, raid_device);
+	}
+
 	/* free ports attached to the sas_host */
  retry_again:
 	list_for_each_entry(mpt2sas_port,
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 524f6ab..fa3cfbc 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -81,6 +81,9 @@ static int serial_index(struct uart_port *port)
 
 #define PASS_LIMIT	256
 
+#define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
+
+
 /*
  * We default to IRQ0 for the "no irq" hack.   Some
  * machine types want others as well - they're free
@@ -1790,7 +1793,7 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
-	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int serial8250_get_mctrl(struct uart_port *port)
@@ -1848,8 +1851,6 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
-
 /*
  *	Wait for transmitter & holding register to empty
  */
diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index d71dfe3..9fb7190 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -328,15 +328,7 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	/* U.S. Robotics 56K Voice INT PnP*/
 	{	"USR9190",		0	},
 	/* Wacom tablets */
-	{	"WACF004",		0	},
-	{	"WACF005",		0	},
-	{       "WACF006",              0       },
-	{       "WACF007",              0       },
-	{       "WACF008",              0       },
-	{       "WACF009",              0       },
-	{       "WACF00A",              0       },
-	{       "WACF00B",              0       },
-	{       "WACF00C",              0       },
+	{	"WACFXXX",		0	},
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 96f1171..355dffc 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -494,7 +494,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
 		return 0;
 	/* allocate 2^1 pages = 8K (on i386);
 	 * should be more than enough for one device */
-	pages_start = (char *)__get_free_pages(GFP_KERNEL, 1);
+	pages_start = (char *)__get_free_pages(GFP_NOIO, 1);
 	if (!pages_start)
 		return -ENOMEM;
 
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 4247ecc..5ae4099 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1139,6 +1139,13 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			free_async(as);
 			return -ENOMEM;
 		}
+		/* Isochronous input data may end up being discontiguous
+		 * if some of the packets are short.  Clear the buffer so
+		 * that the gaps don't leak kernel data to userspace.
+		 */
+		if (is_in && uurb->type == USBDEVFS_URB_TYPE_ISO)
+			memset(as->urb->transfer_buffer, 0,
+					uurb->buffer_length);
 	}
 	as->urb->dev = ps->dev;
 	as->urb->pipe = (uurb->type << 30) |
@@ -1240,10 +1247,14 @@ static int processcompl(struct async *as, void __user * __user *arg)
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer)
-		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->transfer_buffer_length))
+	if (as->userbuffer && urb->actual_length) {
+		if (urb->number_of_packets > 0)		/* Isochronous */
+			i = urb->transfer_buffer_length;
+		else					/* Non-Isoc */
+			i = urb->actual_length;
+		if (copy_to_user(as->userbuffer, urb->transfer_buffer, i))
 			goto err_out;
+	}
 	if (put_user(as->status, &userurb->status))
 		goto err_out;
 	if (put_user(urb->actual_length, &userurb->actual_length))
@@ -1262,14 +1273,11 @@ static int processcompl(struct async *as, void __user * __user *arg)
 		}
 	}
 
-	free_async(as);
-
 	if (put_user(addr, (void __user * __user *)arg))
 		return -EFAULT;
 	return 0;
 
 err_out:
-	free_async(as);
 	return -EFAULT;
 }
 
@@ -1299,8 +1307,11 @@ static struct async *reap_as(struct dev_state *ps)
 static int proc_reapurb(struct dev_state *ps, void __user *arg)
 {
 	struct async *as = reap_as(ps);
-	if (as)
-		return processcompl(as, (void __user * __user *)arg);
+	if (as) {
+		int retval = processcompl(as, (void __user * __user *)arg);
+		free_async(as);
+		return retval;
+	}
 	if (signal_pending(current))
 		return -EINTR;
 	return -EIO;
@@ -1308,11 +1319,16 @@ static int proc_reapurb(struct dev_state *ps, void __user *arg)
 
 static int proc_reapurbnonblock(struct dev_state *ps, void __user *arg)
 {
+	int retval;
 	struct async *as;
 
-	if (!(as = async_getcompleted(ps)))
-		return -EAGAIN;
-	return processcompl(as, (void __user * __user *)arg);
+	as = async_getcompleted(ps);
+	retval = -EAGAIN;
+	if (as) {
+		retval = processcompl(as, (void __user * __user *)arg);
+		free_async(as);
+	}
+	return retval;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1363,9 +1379,9 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer)
+	if (as->userbuffer && urb->actual_length)
 		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->transfer_buffer_length))
+				 urb->actual_length))
 			return -EFAULT;
 	if (put_user(as->status, &userurb->status))
 		return -EFAULT;
@@ -1385,7 +1401,6 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
 		}
 	}
 
-	free_async(as);
 	if (put_user(ptr_to_compat(addr), (u32 __user *)arg))
 		return -EFAULT;
 	return 0;
@@ -1394,8 +1409,11 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
 static int proc_reapurb_compat(struct dev_state *ps, void __user *arg)
 {
 	struct async *as = reap_as(ps);
-	if (as)
-		return processcompl_compat(as, (void __user * __user *)arg);
+	if (as) {
+		int retval = processcompl_compat(as, (void __user * __user *)arg);
+		free_async(as);
+		return retval;
+	}
 	if (signal_pending(current))
 		return -EINTR;
 	return -EIO;
@@ -1403,11 +1421,16 @@ static int proc_reapurb_compat(struct dev_state *ps, void __user *arg)
 
 static int proc_reapurbnonblock_compat(struct dev_state *ps, void __user *arg)
 {
+	int retval;
 	struct async *as;
 
-	if (!(as = async_getcompleted(ps)))
-		return -EAGAIN;
-	return processcompl_compat(as, (void __user * __user *)arg);
+	retval = -EAGAIN;
+	as = async_getcompleted(ps);
+	if (as) {
+		retval = processcompl_compat(as, (void __user * __user *)arg);
+		free_async(as);
+	}
+	return retval;
 }
 
 #endif
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b41989e..e9e1705 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3188,6 +3188,9 @@ static void hub_events(void)
 					USB_PORT_FEAT_C_SUSPEND);
 				udev = hdev->children[i-1];
 				if (udev) {
+					/* TRSMRCY = 10 msec */
+					msleep(10);
+
 					usb_lock_device(udev);
 					ret = remote_wakeup(hdev->
 							children[i-1]);
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 9720e69..8c929da 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -923,11 +923,11 @@ char *usb_cache_string(struct usb_device *udev, int index)
 	if (index <= 0)
 		return NULL;
 
-	buf = kmalloc(MAX_USB_STRING_SIZE, GFP_KERNEL);
+	buf = kmalloc(MAX_USB_STRING_SIZE, GFP_NOIO);
 	if (buf) {
 		len = usb_string(udev, index, buf, MAX_USB_STRING_SIZE);
 		if (len > 0) {
-			smallbuf = kmalloc(++len, GFP_KERNEL);
+			smallbuf = kmalloc(++len, GFP_NOIO);
 			if (!smallbuf)
 				return buf;
 			memcpy(smallbuf, buf, len);
@@ -1694,7 +1694,7 @@ int usb_set_configuration(struct usb_device *dev, int configuration)
 	if (cp) {
 		nintf = cp->desc.bNumInterfaces;
 		new_interfaces = kmalloc(nintf * sizeof(*new_interfaces),
-				GFP_KERNEL);
+				GFP_NOIO);
 		if (!new_interfaces) {
 			dev_err(&dev->dev, "Out of memory\n");
 			return -ENOMEM;
@@ -1703,7 +1703,7 @@ int usb_set_configuration(struct usb_device *dev, int configuration)
 		for (; n < nintf; ++n) {
 			new_interfaces[n] = kzalloc(
 					sizeof(struct usb_interface),
-					GFP_KERNEL);
+					GFP_NOIO);
 			if (!new_interfaces[n]) {
 				dev_err(&dev->dev, "Out of memory\n");
 				ret = -ENOMEM;
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index b5c72e4..7bc1469 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -111,6 +111,12 @@ show_speed(struct device *dev, struct device_attribute *attr, char *buf)
 	case USB_SPEED_HIGH:
 		speed = "480";
 		break;
+	case USB_SPEED_VARIABLE:
+		speed = "480";
+		break;
+	case USB_SPEED_SUPER:
+		speed = "5000";
+		break;
 	default:
 		speed = "unknown";
 	}
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 7e4b381..73502b1 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -764,9 +764,10 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 
 			/* start 20 msec resume signaling from this port,
 			 * and make khubd collect PORT_STAT_C_SUSPEND to
-			 * stop that signaling.
+			 * stop that signaling.  Use 5 ms extra for safety,
+			 * like usb_port_resume() does.
 			 */
-			ehci->reset_done [i] = jiffies + msecs_to_jiffies (20);
+			ehci->reset_done[i] = jiffies + msecs_to_jiffies(25);
 			ehci_dbg (ehci, "port %d remote wakeup\n", i + 1);
 			mod_timer(&hcd->rh_timer, ehci->reset_done[i]);
 		}
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index f46ad27..e3d5cc1 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -119,9 +119,26 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	del_timer_sync(&ehci->watchdog);
 	del_timer_sync(&ehci->iaa_watchdog);
 
-	port = HCS_N_PORTS (ehci->hcs_params);
 	spin_lock_irq (&ehci->lock);
 
+	/* Once the controller is stopped, port resumes that are already
+	 * in progress won't complete.  Hence if remote wakeup is enabled
+	 * for the root hub and any ports are in the middle of a resume or
+	 * remote wakeup, we must fail the suspend.
+	 */
+	if (hcd->self.root_hub->do_remote_wakeup) {
+		port = HCS_N_PORTS(ehci->hcs_params);
+		while (port--) {
+			if (ehci->reset_done[port] != 0) {
+				spin_unlock_irq(&ehci->lock);
+				ehci_dbg(ehci, "suspend failed because "
+						"port %d is resuming\n",
+						port + 1);
+				return -EBUSY;
+			}
+		}
+	}
+
 	/* stop schedules, clean any completed work */
 	if (HC_IS_RUNNING(hcd->state)) {
 		ehci_quiesce (ehci);
@@ -137,6 +154,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	 */
 	ehci->bus_suspended = 0;
 	ehci->owned_ports = 0;
+	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
 		u32 __iomem	*reg = &ehci->regs->port_status [port];
 		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 6b6c240..1ae9faf 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -802,9 +802,10 @@ qh_make (
 				 * But interval 1 scheduling is simpler, and
 				 * includes high bandwidth.
 				 */
-				dbg ("intr period %d uframes, NYET!",
-						urb->interval);
-				goto done;
+				urb->interval = 1;
+			} else if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period << 3;
 			}
 		} else {
 			int		think_time;
@@ -827,6 +828,10 @@ qh_make (
 					usb_calc_bus_time (urb->dev->speed,
 					is_input, 0, max_packet (maxp)));
 			qh->period = urb->interval;
+			if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period;
+			}
 		}
 	}
 
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 274751b..eb37d86 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -749,7 +749,20 @@ static int uhci_rh_suspend(struct usb_hcd *hcd)
 	spin_lock_irq(&uhci->lock);
 	if (!test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags))
 		rc = -ESHUTDOWN;
-	else if (!uhci->dead)
+	else if (uhci->dead)
+		;		/* Dead controllers tell no tales */
+
+	/* Once the controller is stopped, port resumes that are already
+	 * in progress won't complete.  Hence if remote wakeup is enabled
+	 * for the root hub and any ports are in the middle of a resume or
+	 * remote wakeup, we must fail the suspend.
+	 */
+	else if (hcd->self.root_hub->do_remote_wakeup &&
+			uhci->resuming_ports) {
+		dev_dbg(uhci_dev(uhci), "suspend failed because a port "
+				"is resuming\n");
+		rc = -EBUSY;
+	} else
 		suspend_rh(uhci, UHCI_RH_SUSPENDED);
 	spin_unlock_irq(&uhci->lock);
 	return rc;
diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
index 885b585..8270055 100644
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -167,7 +167,7 @@ static void uhci_check_ports(struct uhci_hcd *uhci)
 				/* Port received a wakeup request */
 				set_bit(port, &uhci->resuming_ports);
 				uhci->ports_timeout = jiffies +
-						msecs_to_jiffies(20);
+						msecs_to_jiffies(25);
 
 				/* Make sure we see the port again
 				 * after the resuming period is over. */
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 7170b69..6463fee 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -480,6 +480,8 @@ void usb_serial_generic_write_bulk_callback(struct urb *urb)
 	dbg("%s - port %d", __func__, port->number);
 
 	if (port->serial->type->max_in_flight_urbs) {
+		kfree(urb->transfer_buffer);
+
 		spin_lock_irqsave(&port->lock, flags);
 		--port->urbs_in_flight;
 		port->tx_bytes_flight -= urb->transfer_buffer_length;
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index ee69eae..5ef11f4 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1827,13 +1827,6 @@ UNUSUAL_DEV(  0x2735, 0x100b, 0x0000, 0x9999,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_GO_SLOW ),
 
-/* Reported by Rohan Hart <rohan.hart17@gmail.com> */
-UNUSUAL_DEV(  0x2770, 0x915d, 0x0010, 0x0010,
-		"INTOVA",
-		"Pixtreme",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY ),
-
 /* Reported by Frederic Marchal <frederic.marchal@wowcompany.com>
  * Mio Moov 330
  */
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 716c8d7..33197fa 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -430,7 +430,8 @@ static void adjust_quirks(struct us_data *us)
 	u16 vid = le16_to_cpu(us->pusb_dev->descriptor.idVendor);
 	u16 pid = le16_to_cpu(us->pusb_dev->descriptor.idProduct);
 	unsigned f = 0;
-	unsigned int mask = (US_FL_SANE_SENSE | US_FL_FIX_CAPACITY |
+	unsigned int mask = (US_FL_SANE_SENSE | US_FL_BAD_SENSE |
+			US_FL_FIX_CAPACITY |
 			US_FL_CAPACITY_HEURISTICS | US_FL_IGNORE_DEVICE |
 			US_FL_NOT_LOCKABLE | US_FL_MAX_SECTORS_64 |
 			US_FL_CAPACITY_OK | US_FL_IGNORE_RESIDUE |
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index f5bbd9e..1b7123e 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -96,11 +96,7 @@ static struct balloon_stats balloon_stats;
 /* We increase/decrease in batches which fit in a page */
 static unsigned long frame_list[PAGE_SIZE / sizeof(unsigned long)];
 
-/* VM /proc information for memory */
-extern unsigned long totalram_pages;
-
 #ifdef CONFIG_HIGHMEM
-extern unsigned long totalhigh_pages;
 #define inc_totalhigh_pages() (totalhigh_pages++)
 #define dec_totalhigh_pages() (totalhigh_pages--)
 #else
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index b639dcf..0133b5a 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -263,6 +263,7 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 #else
 	set_personality(PER_LINUX);
 #endif
+	setup_new_exec(bprm);
 
 	current->mm->end_code = ex.a_text +
 		(current->mm->start_code = N_TXTADDR(ex));
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 7c1e65d..e9b214a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -662,27 +662,6 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
 				goto out_free_interp;
 
-			/*
-			 * The early SET_PERSONALITY here is so that the lookup
-			 * for the interpreter happens in the namespace of the 
-			 * to-be-execed image.  SET_PERSONALITY can select an
-			 * alternate root.
-			 *
-			 * However, SET_PERSONALITY is NOT allowed to switch
-			 * this task into the new images's memory mapping
-			 * policy - that is, TASK_SIZE must still evaluate to
-			 * that which is appropriate to the execing application.
-			 * This is because exit_mmap() needs to have TASK_SIZE
-			 * evaluate to the size of the old image.
-			 *
-			 * So if (say) a 64-bit application is execing a 32-bit
-			 * application it is the architecture's responsibility
-			 * to defer changing the value of TASK_SIZE until the
-			 * switch really is going to happen - do this in
-			 * flush_thread().	- akpm
-			 */
-			SET_PERSONALITY(loc->elf_ex);
-
 			interpreter = open_exec(elf_interpreter);
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter))
@@ -730,9 +709,6 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		/* Verify the interpreter has a valid arch */
 		if (!elf_check_arch(&loc->interp_elf_ex))
 			goto out_free_dentry;
-	} else {
-		/* Executables without an interpreter also need a personality  */
-		SET_PERSONALITY(loc->elf_ex);
 	}
 
 	/* Flush all traces of the currently running executable */
@@ -752,7 +728,8 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
 		current->flags |= PF_RANDOMIZE;
-	arch_pick_mmap_layout(current->mm);
+
+	setup_new_exec(bprm);
 
 	/* Do this so that we can load the interpreter, if need be.  We will
 	   change some of these later */
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 20fbece..9fdbda9 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -313,6 +313,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	 * defunct, deceased, etc. after this point we have to exit via
 	 * error_kill */
 	set_personality(PER_LINUX_FDPIC);
+
+	setup_new_exec(bprm);
+
 	set_binfmt(&elf_fdpic_format);
 
 	current->mm->start_code = 0;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index e92f229..4510022 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -521,6 +521,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 
 		/* OK, This is the point of no return */
 		set_personality(PER_LINUX_32BIT);
+		setup_new_exec(bprm);
 	}
 
 	/*
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index eff74b9..35cf002 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -227,6 +227,7 @@ load_som_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	/* OK, This is the point of no return */
 	current->flags &= ~PF_FORKNOEXEC;
 	current->personality = PER_HPUX;
+	setup_new_exec(bprm);
 
 	/* Set the task size for HP-UX processes such that
 	 * the gateway page is outside the address space.
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 01ce279..f55d42b 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -666,6 +666,7 @@ static int cifs_get_name_from_search_buf(struct qstr *pqst,
 					   min(len, max_len), nlt,
 					   cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		pqst->len -= nls_nullsize(nlt);
 	} else {
 		pqst->name = filename;
 		pqst->len = len;
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index f0b53df..e7c0bc4 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1745,7 +1745,7 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 			    char *cipher_name, size_t *key_size)
 {
 	char dummy_key[ECRYPTFS_MAX_KEY_BYTES];
-	char *full_alg_name;
+	char *full_alg_name = NULL;
 	int rc;
 
 	*key_tfm = NULL;
@@ -1760,7 +1760,6 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 	if (rc)
 		goto out;
 	*key_tfm = crypto_alloc_blkcipher(full_alg_name, 0, CRYPTO_ALG_ASYNC);
-	kfree(full_alg_name);
 	if (IS_ERR(*key_tfm)) {
 		rc = PTR_ERR(*key_tfm);
 		printk(KERN_ERR "Unable to allocate crypto cipher with name "
@@ -1782,6 +1781,7 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 		goto out;
 	}
 out:
+	kfree(full_alg_name);
 	return rc;
 }
 
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 9e94405..1744f17 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -191,13 +191,6 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 				      | ECRYPTFS_ENCRYPTED);
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
-	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
-	    && !(file->f_flags & O_RDONLY)) {
-		rc = -EPERM;
-		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
-		       "file must hence be opened RO\n", __func__);
-		goto out;
-	}
 	if (!ecryptfs_inode_to_private(inode)->lower_file) {
 		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
 		if (rc) {
@@ -208,6 +201,13 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 			goto out;
 		}
 	}
+	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
+	    && !(file->f_flags & O_RDONLY)) {
+		rc = -EPERM;
+		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
+		       "file must hence be opened RO\n", __func__);
+		goto out;
+	}
 	ecryptfs_set_file_lower(
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
diff --git a/fs/exec.c b/fs/exec.c
index 172ceb6..62cd056 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -928,9 +928,7 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 
 int flush_old_exec(struct linux_binprm * bprm)
 {
-	char * name;
-	int i, ch, retval;
-	char tcomm[sizeof(current->comm)];
+	int retval;
 
 	/*
 	 * Make sure we have a private signal table and that
@@ -951,6 +949,25 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	bprm->mm = NULL;		/* We're using it now */
 
+	current->flags &= ~PF_RANDOMIZE;
+	flush_thread();
+	current->personality &= ~bprm->per_clear;
+
+	return 0;
+
+out:
+	return retval;
+}
+EXPORT_SYMBOL(flush_old_exec);
+
+void setup_new_exec(struct linux_binprm * bprm)
+{
+	int i, ch;
+	char * name;
+	char tcomm[sizeof(current->comm)];
+
+	arch_pick_mmap_layout(current->mm);
+
 	/* This is the point of no return */
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
@@ -972,9 +989,6 @@ int flush_old_exec(struct linux_binprm * bprm)
 	tcomm[i] = '\0';
 	set_task_comm(current, tcomm);
 
-	current->flags &= ~PF_RANDOMIZE;
-	flush_thread();
-
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
 	 * some architectures like powerpc
@@ -990,8 +1004,6 @@ int flush_old_exec(struct linux_binprm * bprm)
 		set_dumpable(current->mm, suid_dumpable);
 	}
 
-	current->personality &= ~bprm->per_clear;
-
 	/*
 	 * Flush performance counters when crossing a
 	 * security domain:
@@ -1006,14 +1018,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 			
 	flush_signal_handlers(current, 0);
 	flush_old_files(current->files);
-
-	return 0;
-
-out:
-	return retval;
 }
-
-EXPORT_SYMBOL(flush_old_exec);
+EXPORT_SYMBOL(setup_new_exec);
 
 /*
  * Prepare credentials and lock ->cred_guard_mutex.
@@ -1855,8 +1861,9 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	/*
 	 * Dont allow local users get cute and trick others to coredump
 	 * into their pre-created files:
+	 * Note, this is not relevant for pipes
 	 */
-	if (inode->i_uid != current_fsuid())
+	if (!ispipe && (inode->i_uid != current_fsuid()))
 		goto close_fail;
 	if (!file->f_op)
 		goto close_fail;
diff --git a/fs/namei.c b/fs/namei.c
index b224905..20ab69f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -823,6 +823,17 @@ fail:
 }
 
 /*
+ * This is a temporary kludge to deal with "automount" symlinks; proper
+ * solution is to trigger them on follow_mount(), so that do_lookup()
+ * would DTRT.  To be killed before 2.6.34-final.
+ */
+static inline int follow_on_final(struct inode *inode, unsigned lookup_flags)
+{
+	return inode && unlikely(inode->i_op->follow_link) &&
+		((lookup_flags & LOOKUP_FOLLOW) || S_ISDIR(inode->i_mode));
+}
+
+/*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
  * the final dentry. We expect 'base' to be positive and a directory.
@@ -964,8 +975,7 @@ last_component:
 		if (err)
 			break;
 		inode = next.dentry->d_inode;
-		if ((lookup_flags & LOOKUP_FOLLOW)
-		    && inode && inode->i_op->follow_link) {
+		if (follow_on_final(inode, lookup_flags)) {
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 379be67..a81d05b 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -337,21 +337,20 @@ void nfs_fscache_reset_inode_cookie(struct inode *inode)
  */
 int nfs_fscache_release_page(struct page *page, gfp_t gfp)
 {
-	struct nfs_inode *nfsi = NFS_I(page->mapping->host);
-	struct fscache_cookie *cookie = nfsi->fscache;
-
-	BUG_ON(!cookie);
-
-	if (fscache_check_page_write(cookie, page)) {
-		if (!(gfp & __GFP_WAIT))
-			return 0;
-		fscache_wait_on_page_write(cookie, page);
-	}
-
 	if (PageFsCache(page)) {
+		struct nfs_inode *nfsi = NFS_I(page->mapping->host);
+		struct fscache_cookie *cookie = nfsi->fscache;
+
+		BUG_ON(!cookie);
 		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
 			 cookie, page, nfsi);
 
+		if (fscache_check_page_write(cookie, page)) {
+			if (!(gfp & __GFP_WAIT))
+				return 0;
+			fscache_wait_on_page_write(cookie, page);
+		}
+
 		fscache_uncache_page(cookie, page);
 		nfs_add_fscache_stats(page->mapping->host,
 				      NFSIOS_FSCACHE_PAGES_UNCACHED, 1);
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 828a889..7e54e52 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -91,6 +91,7 @@ static int dnotify_handle_event(struct fsnotify_group *group,
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct fown_struct *fown;
+	__u32 test_mask = event->mask & ~FS_EVENT_ON_CHILD;
 
 	to_tell = event->to_tell;
 
@@ -106,7 +107,7 @@ static int dnotify_handle_event(struct fsnotify_group *group,
 	spin_lock(&entry->lock);
 	prev = &dnentry->dn;
 	while ((dn = *prev) != NULL) {
-		if ((dn->dn_mask & event->mask) == 0) {
+		if ((dn->dn_mask & test_mask) == 0) {
 			prev = &dn->dn_next;
 			continue;
 		}
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index c9ee67b..1afb0a1 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -121,7 +121,7 @@ static int idr_callback(int id, void *p, void *data)
 	if (warned)
 		return 0;
 
-	warned = false;
+	warned = true;
 	entry = p;
 	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index dcd2040..ca44337 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -558,7 +558,7 @@ retry:
 
 	spin_lock(&group->inotify_data.idr_lock);
 	ret = idr_get_new_above(&group->inotify_data.idr, &tmp_ientry->fsn_entry,
-				group->inotify_data.last_wd,
+				group->inotify_data.last_wd+1,
 				&tmp_ientry->wd);
 	spin_unlock(&group->inotify_data.idr_lock);
 	if (ret) {
@@ -638,7 +638,7 @@ static struct fsnotify_group *inotify_new_group(struct user_struct *user, unsign
 
 	spin_lock_init(&group->inotify_data.idr_lock);
 	idr_init(&group->inotify_data.idr);
-	group->inotify_data.last_wd = 1;
+	group->inotify_data.last_wd = 0;
 	group->inotify_data.user = user;
 	group->inotify_data.fa = NULL;
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 3816d57..b8bf53b 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -143,7 +143,7 @@ static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new
 			/* remember, after old was put on the wait_q we aren't
 			 * allowed to look at the inode any more, only thing
 			 * left to check was if the file_name is the same */
-			if (old->name_len &&
+			if (!old->name_len ||
 			    !strcmp(old->file_name, new->file_name))
 				return true;
 			break;
diff --git a/fs/ntfs/malloc.h b/fs/ntfs/malloc.h
index cd0be3f..a44b14c 100644
--- a/fs/ntfs/malloc.h
+++ b/fs/ntfs/malloc.h
@@ -47,7 +47,7 @@ static inline void *__ntfs_malloc(unsigned long size, gfp_t gfp_mask)
 		return kmalloc(PAGE_SIZE, gfp_mask & ~__GFP_HIGHMEM);
 		/* return (void *)__get_free_page(gfp_mask); */
 	}
-	if (likely(size >> PAGE_SHIFT < num_physpages))
+	if (likely((size >> PAGE_SHIFT) < totalram_pages))
 		return __vmalloc(size, gfp_mask, PAGE_KERNEL);
 	return NULL;
 }
diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 038a602..49cfd5f 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -1,7 +1,9 @@
 /************************************************************
  * EFI GUID Partition Table handling
- * Per Intel EFI Specification v1.02
- * http://developer.intel.com/technology/efi/efi.htm
+ *
+ * http://www.uefi.org/specs/
+ * http://www.intel.com/technology/efi/
+ *
  * efi.[ch] by Matt Domsch <Matt_Domsch@dell.com>
  *   Copyright 2000,2001,2002,2004 Dell Inc.
  *
@@ -92,6 +94,7 @@
  *
  ************************************************************/
 #include <linux/crc32.h>
+#include <linux/math64.h>
 #include "check.h"
 #include "efi.h"
 
@@ -141,7 +144,8 @@ last_lba(struct block_device *bdev)
 {
 	if (!bdev || !bdev->bd_inode)
 		return 0;
-	return (bdev->bd_inode->i_size >> 9) - 1ULL;
+	return div_u64(bdev->bd_inode->i_size,
+		       bdev_logical_block_size(bdev)) - 1ULL;
 }
 
 static inline int
@@ -188,6 +192,7 @@ static size_t
 read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
 {
 	size_t totalreadcount = 0;
+	sector_t n = lba * (bdev_logical_block_size(bdev) / 512);
 
 	if (!bdev || !buffer || lba > last_lba(bdev))
                 return 0;
@@ -195,7 +200,7 @@ read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
 	while (count) {
 		int copied = 512;
 		Sector sect;
-		unsigned char *data = read_dev_sector(bdev, lba++, &sect);
+		unsigned char *data = read_dev_sector(bdev, n++, &sect);
 		if (!data)
 			break;
 		if (copied > count)
@@ -257,15 +262,16 @@ static gpt_header *
 alloc_read_gpt_header(struct block_device *bdev, u64 lba)
 {
 	gpt_header *gpt;
+	unsigned ssz = bdev_logical_block_size(bdev);
+
 	if (!bdev)
 		return NULL;
 
-	gpt = kzalloc(sizeof (gpt_header), GFP_KERNEL);
+	gpt = kzalloc(ssz, GFP_KERNEL);
 	if (!gpt)
 		return NULL;
 
-	if (read_lba(bdev, lba, (u8 *) gpt,
-		     sizeof (gpt_header)) < sizeof (gpt_header)) {
+	if (read_lba(bdev, lba, (u8 *) gpt, ssz) < ssz) {
 		kfree(gpt);
                 gpt=NULL;
 		return NULL;
@@ -601,6 +607,7 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
 	gpt_header *gpt = NULL;
 	gpt_entry *ptes = NULL;
 	u32 i;
+	unsigned ssz = bdev_logical_block_size(bdev) / 512;
 
 	if (!find_valid_gpt(bdev, &gpt, &ptes) || !gpt || !ptes) {
 		kfree(gpt);
@@ -611,13 +618,14 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
 	pr_debug("GUID Partition Table is valid!  Yea!\n");
 
 	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
+		u64 start = le64_to_cpu(ptes[i].starting_lba);
+		u64 size = le64_to_cpu(ptes[i].ending_lba) -
+			   le64_to_cpu(ptes[i].starting_lba) + 1ULL;
+
 		if (!is_pte_valid(&ptes[i], last_lba(bdev)))
 			continue;
 
-		put_partition(state, i+1, le64_to_cpu(ptes[i].starting_lba),
-				 (le64_to_cpu(ptes[i].ending_lba) -
-                                  le64_to_cpu(ptes[i].starting_lba) +
-				  1ULL));
+		put_partition(state, i+1, start * ssz, size * ssz);
 
 		/* If this is a RAID volume, tell md */
 		if (!efi_guidcmp(ptes[i].partition_type_guid,
diff --git a/fs/partitions/efi.h b/fs/partitions/efi.h
index 2cc89d0..6998b58 100644
--- a/fs/partitions/efi.h
+++ b/fs/partitions/efi.h
@@ -37,7 +37,6 @@
 #define EFI_PMBR_OSTYPE_EFI 0xEF
 #define EFI_PMBR_OSTYPE_EFI_GPT 0xEE
 
-#define GPT_BLOCK_SIZE 512
 #define GPT_HEADER_SIGNATURE 0x5452415020494645ULL
 #define GPT_HEADER_REVISION_V1 0x00010000
 #define GPT_PRIMARY_PARTITION_TABLE_LBA 1
@@ -79,7 +78,12 @@ typedef struct _gpt_header {
 	__le32 num_partition_entries;
 	__le32 sizeof_partition_entry;
 	__le32 partition_entry_array_crc32;
-	u8 reserved2[GPT_BLOCK_SIZE - 92];
+
+	/* The rest of the logical block is reserved by UEFI and must be zero.
+	 * EFI standard handles this by:
+	 *
+	 * uint8_t		reserved2[ BlockSize - 92 ];
+	 */
 } __attribute__ ((packed)) gpt_header;
 
 typedef struct _gpt_entry_attributes {
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index a14d6cd..d240c15 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2531,6 +2531,12 @@ static int reiserfs_writepage(struct page *page, struct writeback_control *wbc)
 	return reiserfs_write_full_page(page, wbc);
 }
 
+static void reiserfs_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	reiserfs_truncate_file(inode, 0);
+}
+
 static int reiserfs_write_begin(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
@@ -2597,6 +2603,8 @@ static int reiserfs_write_begin(struct file *file,
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
+		/* Truncate allocated blocks */
+		reiserfs_truncate_failed_write(inode);
 	}
 	return ret;
 }
@@ -2689,8 +2697,7 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 	 ** transaction tracking stuff when the size changes.  So, we have
 	 ** to do the i_size updates here.
 	 */
-	pos += copied;
-	if (pos > inode->i_size) {
+	if (pos + copied > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
 		reiserfs_write_lock(inode->i_sb);
 		/* If the file have grown beyond the border where it
@@ -2708,7 +2715,7 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 			goto journal_error;
 		}
 		reiserfs_update_inode_transaction(inode);
-		inode->i_size = pos;
+		inode->i_size = pos + copied;
 		/*
 		 * this will just nest into our transaction.  It's important
 		 * to use mark_inode_dirty so the inode gets pushed around on the
@@ -2735,6 +2742,10 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
       out:
 	unlock_page(page);
 	page_cache_release(page);
+
+	if (pos + len > inode->i_size)
+		reiserfs_truncate_failed_write(inode);
+
 	return ret == 0 ? copied : ret;
 
       journal_error:
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 2046b5b..f1da7e4 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -101,6 +101,7 @@ extern int prepare_binprm(struct linux_binprm *);
 extern int __must_check remove_arg_zero(struct linux_binprm *);
 extern int search_binary_handler(struct linux_binprm *,struct pt_regs *);
 extern int flush_old_exec(struct linux_binprm * bprm);
+extern void setup_new_exec(struct linux_binprm * bprm);
 
 extern int suid_dumpable;
 #define SUID_DUMP_DISABLE	0	/* No setuid dumping */
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 3a14615..ecb61c4 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -24,9 +24,6 @@
 
 #include <linux/types.h>
 
-#define CN_IDX_CONNECTOR		0xffffffff
-#define CN_VAL_CONNECTOR		0xffffffff
-
 /*
  * Process Events connector unique ids -- used for message routing
  */
@@ -73,30 +70,6 @@ struct cn_msg {
 	__u8 data[0];
 };
 
-/*
- * Notify structure - requests notification about
- * registering/unregistering idx/val in range [first, first+range].
- */
-struct cn_notify_req {
-	__u32 first;
-	__u32 range;
-};
-
-/*
- * Main notification control message
- * *_notify_num 	- number of appropriate cn_notify_req structures after 
- *				this struct.
- * group 		- notification receiver's idx.
- * len 			- total length of the attached data.
- */
-struct cn_ctl_msg {
-	__u32 idx_notify_num;
-	__u32 val_notify_num;
-	__u32 group;
-	__u32 len;
-	__u8 data[0];
-};
-
 #ifdef __KERNEL__
 
 #include <asm/atomic.h>
@@ -149,11 +122,6 @@ struct cn_callback_entry {
 	u32 seq, group;
 };
 
-struct cn_ctl_entry {
-	struct list_head notify_entry;
-	struct cn_ctl_msg *msg;
-};
-
 struct cn_dev {
 	struct cb_id id;
 
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 4332442..cceb406 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -42,6 +42,8 @@ enum enclosure_status {
 	ENCLOSURE_STATUS_NOT_INSTALLED,
 	ENCLOSURE_STATUS_UNKNOWN,
 	ENCLOSURE_STATUS_UNAVAILABLE,
+	/* last element for counting purposes */
+	ENCLOSURE_STATUS_MAX
 };
 
 /* SFF-8485 activity light settings */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9a72cc7..ef36039 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -25,6 +25,7 @@ extern unsigned long max_mapnr;
 #endif
 
 extern unsigned long num_physpages;
+extern unsigned long totalram_pages;
 extern void * high_memory;
 extern int page_cluster;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d3e910b..1e174ca 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1296,7 +1296,7 @@ struct task_struct {
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())
-				     - initialized normally by flush_old_exec */
+				     - initialized normally by setup_new_exec */
 /* file system info */
 	int link_count, total_link_count;
 #ifdef CONFIG_SYSVIPC
@@ -2485,6 +2485,28 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
+static inline unsigned long task_rlimit(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_cur);
+}
+
+static inline unsigned long task_rlimit_max(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_max);
+}
+
+static inline unsigned long rlimit(unsigned int limit)
+{
+	return task_rlimit(current, limit);
+}
+
+static inline unsigned long rlimit_max(unsigned int limit)
+{
+	return task_rlimit_max(current, limit);
+}
+
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/init/main.c b/init/main.c
index 1ec6347..7901959 100644
--- a/init/main.c
+++ b/init/main.c
@@ -686,12 +686,12 @@ asmlinkage void __init start_kernel(void)
 #endif
 	thread_info_cache_init();
 	cred_init();
-	fork_init(num_physpages);
+	fork_init(totalram_pages);
 	proc_caches_init();
 	buffer_init();
 	key_init();
 	security_init();
-	vfs_caches_init(num_physpages);
+	vfs_caches_init(totalram_pages);
 	radix_tree_init();
 	signals_init();
 	/* rootfs populating might need page-writeback */
diff --git a/ipc/msg.c b/ipc/msg.c
index 2ceab7f..779f762 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -125,6 +125,7 @@ void msg_init_ns(struct ipc_namespace *ns)
 void msg_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &msg_ids(ns), freeque);
+	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
 }
 #endif
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 87c2b64..2f2a479 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -129,6 +129,7 @@ void sem_init_ns(struct ipc_namespace *ns)
 void sem_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &sem_ids(ns), freeary);
+	idr_destroy(&ns->ids[IPC_SEM_IDS].ipcs_idr);
 }
 #endif
 
diff --git a/ipc/shm.c b/ipc/shm.c
index 30162a5..9f779ab 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -101,6 +101,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 void shm_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &shm_ids(ns), do_shm_rmid);
+	idr_destroy(&ns->ids[IPC_SHM_IDS].ipcs_idr);
 }
 #endif
 
diff --git a/kernel/futex.c b/kernel/futex.c
index ba7f0be..fdc88aa 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -531,8 +531,25 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 				return -EINVAL;
 
 			WARN_ON(!atomic_read(&pi_state->refcount));
-			WARN_ON(pid && pi_state->owner &&
-				pi_state->owner->pid != pid);
+
+			/*
+			 * When pi_state->owner is NULL then the owner died
+			 * and another waiter is on the fly. pi_state->owner
+			 * is fixed up by the task which acquires
+			 * pi_state->rt_mutex.
+			 *
+			 * We do not check for pid == 0 which can happen when
+			 * the owner died and robust_list_exit() cleared the
+			 * TID.
+			 */
+			if (pid && pi_state->owner) {
+				/*
+				 * Bail out if user space manipulated the
+				 * futex value.
+				 */
+				if (pid != task_pid_vnr(pi_state->owner))
+					return -EINVAL;
+			}
 
 			atomic_inc(&pi_state->refcount);
 			*ps = pi_state;
@@ -759,6 +776,13 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	if (!pi_state)
 		return -EINVAL;
 
+	/*
+	 * If current does not own the pi_state then the futex is
+	 * inconsistent and user space fiddled with the futex value.
+	 */
+	if (pi_state->owner != current)
+		return -EINVAL;
+
 	spin_lock(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
@@ -1950,7 +1974,7 @@ retry_private:
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
-	goto out;
+	goto out_put_key;
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 9484be4..0d809ae 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -20,6 +20,8 @@
 #include <linux/sysdev.h>
 #include <linux/tick.h>
 
+#include "tick-internal.h"
+
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);
@@ -258,7 +260,8 @@ void clockevents_notify(unsigned long reason, void *arg)
 		cpu = *((int *)arg);
 		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
 			if (cpumask_test_cpu(cpu, dev->cpumask) &&
-			    cpumask_weight(dev->cpumask) == 1) {
+			    cpumask_weight(dev->cpumask) == 1 &&
+			    !tick_is_broadcast_device(dev)) {
 				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 				list_del(&dev->list);
 			}
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4545d59..f29d8d7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2122,8 +2122,8 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 			char *rest = nodelist;
 			while (isdigit(*rest))
 				rest++;
-			if (!*rest)
-				err = 0;
+			if (*rest)
+				goto out;
 		}
 		break;
 	case MPOL_INTERLEAVE:
@@ -2132,7 +2132,6 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		 */
 		if (!nodelist)
 			nodes = node_states[N_HIGH_MEMORY];
-		err = 0;
 		break;
 	case MPOL_LOCAL:
 		/*
@@ -2142,11 +2141,19 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 			goto out;
 		mode = MPOL_PREFERRED;
 		break;
-
-	/*
-	 * case MPOL_BIND:    mpol_new() enforces non-empty nodemask.
-	 * case MPOL_DEFAULT: mpol_new() enforces empty nodemask, ignores flags.
-	 */
+	case MPOL_DEFAULT:
+		/*
+		 * Insist on a empty nodelist
+		 */
+		if (!nodelist)
+			err = 0;
+		goto out;
+	case MPOL_BIND:
+		/*
+		 * Insist on a nodelist
+		 */
+		if (!nodelist)
+			goto out;
 	}
 
 	mode_flags = 0;
@@ -2160,13 +2167,14 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		else if (!strcmp(flags, "relative"))
 			mode_flags |= MPOL_F_RELATIVE_NODES;
 		else
-			err = 1;
+			goto out;
 	}
 
 	new = mpol_new(mode, mode_flags, &nodes);
 	if (IS_ERR(new))
-		err = 1;
-	else {
+		goto out;
+
+	{
 		int ret;
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
@@ -2177,13 +2185,15 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 			ret = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
 		if (ret) {
-			err = 1;
 			mpol_put(new);
-		} else if (no_context) {
-			/* save for contextualization */
-			new->w.user_nodemask = nodes;
+			goto out;
 		}
 	}
+	err = 0;
+	if (no_context) {
+		/* save for contextualization */
+		new->w.user_nodemask = nodes;
+	}
 
 out:
 	/* Restore string for error message */
diff --git a/mm/migrate.c b/mm/migrate.c
index 598abad..eebfb79 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -937,6 +937,9 @@ static int do_pages_move(struct mm_struct *mm, struct task_struct *task,
 				goto out_pm;
 
 			err = -ENODEV;
+			if (node < 0 || node >= MAX_NUMNODES)
+				goto out_pm;
+
 			if (!node_state(node, N_HIGH_MEMORY))
 				goto out_pm;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 957b551..d04c842 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1167,10 +1167,10 @@ again:
 		}
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
-		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
 	}
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
diff --git a/mm/slab.c b/mm/slab.c
index 7b5d4de..7dfa481 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1384,7 +1384,7 @@ void __init kmem_cache_init(void)
 	 * Fragmentation resistance on low memory - only use bigger
 	 * page orders on machines with more than 32MB of memory.
 	 */
-	if (num_physpages > (32 << 20) >> PAGE_SHIFT)
+	if (totalram_pages > (32 << 20) >> PAGE_SHIFT)
 		slab_break_gfp_order = BREAK_GFP_ORDER_HI;
 
 	/* Bootstrap is tricky, because several objects are allocated
diff --git a/mm/swap.c b/mm/swap.c
index cb29ae5..9387f17 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -496,7 +496,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
  */
 void __init swap_setup(void)
 {
-	unsigned long megs = num_physpages >> (20 - PAGE_SHIFT);
+	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
 
 #ifdef CONFIG_SWAP
 	bdi_init(swapper_space.backing_dev_info);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f8189a4..f603667 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -546,10 +546,8 @@ static void __purge_vmap_area_lazy(unsigned long *start, unsigned long *end,
 	}
 	rcu_read_unlock();
 
-	if (nr) {
-		BUG_ON(nr > atomic_read(&vmap_lazy_nr));
+	if (nr)
 		atomic_sub(nr, &vmap_lazy_nr);
-	}
 
 	if (nr || force_flush)
 		flush_tlb_kernel_range(*start, *end);
@@ -1368,7 +1366,7 @@ void *vmap(struct page **pages, unsigned int count,
 
 	might_sleep();
 
-	if (count > num_physpages)
+	if (count > totalram_pages)
 		return NULL;
 
 	area = get_vm_area_caller((count << PAGE_SHIFT), flags,
@@ -1475,7 +1473,7 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 	unsigned long real_size = size;
 
 	size = PAGE_ALIGN(size);
-	if (!size || (size >> PAGE_SHIFT) > num_physpages)
+	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		return NULL;
 
 	area = __get_vm_area_node(size, VM_ALLOC, VMALLOC_START, VMALLOC_END,
diff --git a/net/core/sock.c b/net/core/sock.c
index dd120d8..a8c9b14 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1196,12 +1196,12 @@ EXPORT_SYMBOL_GPL(sk_setup_caps);
 
 void __init sk_init(void)
 {
-	if (num_physpages <= 4096) {
+	if (totalram_pages <= 4096) {
 		sysctl_wmem_max = 32767;
 		sysctl_rmem_max = 32767;
 		sysctl_wmem_default = 32767;
 		sysctl_rmem_default = 32767;
-	} else if (num_physpages >= 131072) {
+	} else if (totalram_pages >= 131072) {
 		sysctl_wmem_max = 131071;
 		sysctl_rmem_max = 131071;
 	}
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 1bca920..d9c44d8 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1049,10 +1049,10 @@ static int __init dccp_init(void)
 	 *
 	 * The methodology is similar to that of the buffer cache.
 	 */
-	if (num_physpages >= (128 * 1024))
-		goal = num_physpages >> (21 - PAGE_SHIFT);
+	if (totalram_pages >= (128 * 1024))
+		goal = totalram_pages >> (21 - PAGE_SHIFT);
 	else
-		goal = num_physpages >> (23 - PAGE_SHIFT);
+		goal = totalram_pages >> (23 - PAGE_SHIFT);
 
 	if (thash_entries)
 		goal = (thash_entries *
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 1d6ca8a..44d0d3b 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1750,7 +1750,7 @@ void __init dn_route_init(void)
 	dn_route_timer.expires = jiffies + decnet_dst_gc_interval * HZ;
 	add_timer(&dn_route_timer);
 
-	goal = num_physpages >> (26 - PAGE_SHIFT);
+	goal = totalram_pages >> (26 - PAGE_SHIFT);
 
 	for(order = 0; (1UL << order) < goal; order++)
 		/* NOTHING */;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 278f46f..62ccdf1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3412,7 +3412,7 @@ int __init ip_rt_init(void)
 		alloc_large_system_hash("IP route cache",
 					sizeof(struct rt_hash_bucket),
 					rhash_entries,
-					(num_physpages >= 128 * 1024) ?
+					(totalram_pages >= 128 * 1024) ?
 					15 : 17,
 					0,
 					&rt_hash_log,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9114524..33ed849 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2862,7 +2862,7 @@ void __init tcp_init(void)
 		alloc_large_system_hash("TCP established",
 					sizeof(struct inet_ehash_bucket),
 					thash_entries,
-					(num_physpages >= 128 * 1024) ?
+					(totalram_pages >= 128 * 1024) ?
 					13 : 15,
 					0,
 					&tcp_hashinfo.ehash_size,
@@ -2879,7 +2879,7 @@ void __init tcp_init(void)
 		alloc_large_system_hash("TCP bind",
 					sizeof(struct inet_bind_hashbucket),
 					tcp_hashinfo.ehash_size,
-					(num_physpages >= 128 * 1024) ?
+					(totalram_pages >= 128 * 1024) ?
 					13 : 15,
 					0,
 					&tcp_hashinfo.bhash_size,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4299db7..e7407e5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1245,9 +1245,9 @@ static int nf_conntrack_init_init_net(void)
 	 * machine has 512 buckets. >= 1GB machines have 16384 buckets. */
 	if (!nf_conntrack_htable_size) {
 		nf_conntrack_htable_size
-			= (((num_physpages << PAGE_SHIFT) / 16384)
+			= (((totalram_pages << PAGE_SHIFT) / 16384)
 			   / sizeof(struct hlist_head));
-		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
+		if (totalram_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
 			nf_conntrack_htable_size = 16384;
 		if (nf_conntrack_htable_size < 32)
 			nf_conntrack_htable_size = 32;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 025d1a0..0319516 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -617,7 +617,7 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	int cpu;
 
 	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
-	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > num_physpages)
+	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
 	newinfo = kzalloc(XT_TABLE_INFO_SZ, GFP_KERNEL);
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 219dcdb..dd16e40 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -194,9 +194,9 @@ static int htable_create_v0(struct xt_hashlimit_info *minfo, u_int8_t family)
 	if (minfo->cfg.size)
 		size = minfo->cfg.size;
 	else {
-		size = ((num_physpages << PAGE_SHIFT) / 16384) /
+		size = ((totalram_pages << PAGE_SHIFT) / 16384) /
 		       sizeof(struct list_head);
-		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
+		if (totalram_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
 			size = 8192;
 		if (size < 16)
 			size = 16;
@@ -266,9 +266,9 @@ static int htable_create(struct xt_hashlimit_mtinfo1 *minfo, u_int8_t family)
 	if (minfo->cfg.size) {
 		size = minfo->cfg.size;
 	} else {
-		size = (num_physpages << PAGE_SHIFT) / 16384 /
+		size = (totalram_pages << PAGE_SHIFT) / 16384 /
 		       sizeof(struct list_head);
-		if (num_physpages > 1024 * 1024 * 1024 / PAGE_SIZE)
+		if (totalram_pages > 1024 * 1024 * 1024 / PAGE_SIZE)
 			size = 8192;
 		if (size < 16)
 			size = 16;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 2936fa3..8b9a87c 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2026,10 +2026,10 @@ static int __init netlink_proto_init(void)
 	if (!nl_table)
 		goto panic;
 
-	if (num_physpages >= (128 * 1024))
-		limit = num_physpages >> (21 - PAGE_SHIFT);
+	if (totalram_pages >= (128 * 1024))
+		limit = totalram_pages >> (21 - PAGE_SHIFT);
 	else
-		limit = num_physpages >> (23 - PAGE_SHIFT);
+		limit = totalram_pages >> (23 - PAGE_SHIFT);
 
 	order = get_bitmask_order(limit) - 1 + PAGE_SHIFT;
 	limit = (1UL << order) / sizeof(struct hlist_head);
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index a76da65..4905051 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1186,10 +1186,10 @@ SCTP_STATIC __init int sctp_init(void)
 	/* Size and allocate the association hash table.
 	 * The methodology is similar to that of the tcp hash tables.
 	 */
-	if (num_physpages >= (128 * 1024))
-		goal = num_physpages >> (22 - PAGE_SHIFT);
+	if (totalram_pages >= (128 * 1024))
+		goal = totalram_pages >> (22 - PAGE_SHIFT);
 	else
-		goal = num_physpages >> (24 - PAGE_SHIFT);
+		goal = totalram_pages >> (24 - PAGE_SHIFT);
 
 	for (order = 0; (1UL << order) < goal; order++)
 		;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 8d8b69c..43f26dd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2360,7 +2360,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(rlim->rlim_cur);
+		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
 	}
 }
 
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index d6f93b0..7ea92f5 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1839,6 +1839,12 @@ static int azx_position_ok(struct azx *chip, struct azx_dev *azx_dev)
 
 	if (!bdl_pos_adj[chip->dev_index])
 		return 1; /* no delayed ack */
+	if (azx_dev->period_bytes == 0) {
+		printk(KERN_WARNING
+		       "hda-intel: Divide by zero was avoided "
+		       "in azx_dev->period_bytes.\n");
+		return 0;
+	}
 	if (pos % azx_dev->period_bytes > azx_dev->period_bytes / 2)
 		return 0; /* NG - it's below the period boundary */
 	return 1; /* OK, it's fine */
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index b70527a..8da53c5 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -1934,7 +1934,7 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
 	struct snd_usb_stream *as = snd_pcm_substream_chip(substream);
 	struct snd_usb_substream *subs = &as->substream[direction];
 
-	if (subs->interface >= 0) {
+	if (!as->chip->shutdown && subs->interface >= 0) {
 		usb_set_interface(subs->dev, subs->interface, 0);
 		subs->interface = -1;
 	}
