Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1BOQhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:37:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43088 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab1BOQg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:36:59 -0500
Date: Tue, 15 Feb 2011 17:36:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110215163652.GA2732@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Note, there a crash-debugging related patch in this tree that looked useful for 
-stable although it is not a regression fix. If that's not appropriate we can delay 
it to .39 easily - it's last in the list of commits.

out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/firmware/dmi_scan.c        # 84e383b: x86, dmi, debug: Log board name (

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86: Fix mwait_usable section mismatch

Jan Beulich (1):
      x86: Fix section mismatch in LAPIC initialization

Naga Chumbalkar (1):
      x86, dmi, debug: Log board name (when present) in dmesg/oops output

Paul Bolle (1):
      x86, ioapic: Don't warn about non-existing IOAPICs if we have none

Thomas Gleixner (1):
      x86: Readd missing irq_to_desc() in fixup_irq()


 arch/x86/include/asm/apic.h    |    1 +
 arch/x86/include/asm/cpu.h     |    2 +-
 arch/x86/kernel/apic/apic.c    |    9 +++++++--
 arch/x86/kernel/apic/io_apic.c |    3 +++
 arch/x86/kernel/irq.c          |    3 ++-
 arch/x86/kernel/process.c      |   24 +++++++++++++++++-------
 arch/x86/kernel/smpboot.c      |    4 ++--
 drivers/firmware/dmi_scan.c    |   11 +++++++++--
 8 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 5e3969c..3c89694 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -233,6 +233,7 @@ extern void sync_Arb_IDs(void);
 extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
 extern void end_local_APIC_setup(void);
+extern void bsp_end_local_APIC_setup(void);
 extern void init_apic_mappings(void);
 void register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 6e6e755..4564c8e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,6 +32,6 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
-int __cpuinit mwait_usable(const struct cpuinfo_x86 *);
+int mwait_usable(const struct cpuinfo_x86 *);
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 06c196d..76b96d7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1381,12 +1381,17 @@ void __cpuinit end_local_APIC_setup(void)
 #endif
 
 	apic_pm_activate();
+}
+
+void __init bsp_end_local_APIC_setup(void)
+{
+	end_local_APIC_setup();
 
 	/*
 	 * Now that local APIC setup is completed for BP, configure the fault
 	 * handling for interrupt remapping.
 	 */
-	if (!smp_processor_id() && intr_remapping_enabled)
+	if (intr_remapping_enabled)
 		enable_drhd_fault_handling();
 
 }
@@ -1756,7 +1761,7 @@ int __init APIC_init_uniprocessor(void)
 		enable_IO_APIC();
 #endif
 
-	end_local_APIC_setup();
+	bsp_end_local_APIC_setup();
 
 #ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 697dc34..ca9e2a3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4002,6 +4002,9 @@ int mp_find_ioapic(u32 gsi)
 {
 	int i = 0;
 
+	if (nr_ioapics == 0)
+		return -1;
+
 	/* Find the IOAPIC that manages this GSI. */
 	for (i = 0; i < nr_ioapics; i++) {
 		if ((gsi >= mp_gsi_routing[i].gsi_base)
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 52945da..387b6a0 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -367,7 +367,8 @@ void fixup_irqs(void)
 		if (irr  & (1 << (vector % 32))) {
 			irq = __this_cpu_read(vector_irq[vector]);
 
-			data = irq_get_irq_data(irq);
+			desc = irq_to_desc(irq);
+			data = &desc->irq_data;
 			raw_spin_lock(&desc->lock);
 			if (data->chip->irq_retrigger)
 				data->chip->irq_retrigger(data);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e764fc0..ff45541 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -92,21 +92,31 @@ void show_regs(struct pt_regs *regs)
 
 void show_regs_common(void)
 {
-	const char *board, *product;
+	const char *vendor, *product, *board;
 
-	board = dmi_get_system_info(DMI_BOARD_NAME);
-	if (!board)
-		board = "";
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	if (!vendor)
+		vendor = "";
 	product = dmi_get_system_info(DMI_PRODUCT_NAME);
 	if (!product)
 		product = "";
 
+	/* Board Name is optional */
+	board = dmi_get_system_info(DMI_BOARD_NAME);
+
 	printk(KERN_CONT "\n");
-	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
+	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version, board, product);
+		init_utsname()->version);
+	printk(KERN_CONT " ");
+	printk(KERN_CONT "%s %s", vendor, product);
+	if (board) {
+		printk(KERN_CONT "/");
+		printk(KERN_CONT "%s", board);
+	}
+	printk(KERN_CONT "\n");
 }
 
 void flush_thread(void)
@@ -506,7 +516,7 @@ static void poll_idle(void)
 #define MWAIT_ECX_EXTENDED_INFO		0x01
 #define MWAIT_EDX_C1			0xf0
 
-int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+int mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 03273b6..08776a9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1060,7 +1060,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 
 		connect_bsp_APIC();
 		setup_local_APIC();
-		end_local_APIC_setup();
+		bsp_end_local_APIC_setup();
 		return -1;
 	}
 
@@ -1137,7 +1137,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	if (!skip_ioapic_setup && nr_ioapics)
 		enable_IO_APIC();
 
-	end_local_APIC_setup();
+	bsp_end_local_APIC_setup();
 
 	map_cpu_to_logical_apicid();
 
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index e28e41668..bcb1126 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -378,10 +378,17 @@ static void __init print_filtered(const char *info)
 
 static void __init dmi_dump_ids(void)
 {
+	const char *board;	/* Board Name is optional */
+
 	printk(KERN_DEBUG "DMI: ");
-	print_filtered(dmi_get_system_info(DMI_BOARD_NAME));
-	printk(KERN_CONT "/");
+	print_filtered(dmi_get_system_info(DMI_SYS_VENDOR));
+	printk(KERN_CONT " ");
 	print_filtered(dmi_get_system_info(DMI_PRODUCT_NAME));
+	board = dmi_get_system_info(DMI_BOARD_NAME);
+	if (board) {
+		printk(KERN_CONT "/");
+		print_filtered(board);
+	}
 	printk(KERN_CONT ", BIOS ");
 	print_filtered(dmi_get_system_info(DMI_BIOS_VERSION));
 	printk(KERN_CONT " ");
