Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2JPEfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:35:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48431 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab2JPEfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:35:31 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, vgoyal@redhat.com, ebiederm@xmission.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        d.hatayama@jp.fujitsu.com
Date: Tue, 16 Oct 2012 13:35:28 +0900
Message-ID: <20121016043528.20003.601.stgit@localhost6.localdomain6>
In-Reply-To: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We disable BSP if boot cpu is AP.

INIT-INIT-SIPI sequence, a protocal to initiate AP, cannot be used for
BSP since it causes BSP jump to BIOS init code; typical visible
behaviour is hang or immediate reset, depending on the BIOS init code.

INIT can be used to reset AP in a fatal system error state as
described in MP spec 3.7.3 Processor-specific INIT. In contrast, there
is no processor-specific INIT for BSP to initilize from a fatal system
error. It might be possible to do so by NMI plus any hand-crafted
reset code that is carefully designed, but at least I have no idea in
this direction now.

By the way, my motivation is to generate crash dump quickly on the
system with huge memory. I think we can assume such system also has a
lot of cpus. If so, it would be no problem if only one cpu gets
unavailable.

We lookup ACPI table or MP table to get BSP information because we
cannot run rdmsr instruction on the CPU we are about to wake up just
now.

One thing to be concerned about here is that ACPI guidlines BIOS
*should* list the BSP in the first MADT LAPIC entry; not *must*. In
this sense, this logic relis on BIOS following ACPI's guideline. On
the other hand, we don't need to worry about this in MP table case
because it has explit BSP flag.

To avoid any undesirable bahaviour caused by any broken BIOS that
doesn't conform to the guideline, it's enough to limit the number of
cpus to 1 by specifying maxcpu=1 or nr_cpus=1, as is currently done in
default kdump configuration. (Of course, it's problematic in maxcpu=1
case if trying to wake up other cpus in user space later.)

Some firmware features such as hibernation and suspend needs to switch
its CPU to BSP before transitting its execution to firmware, so these
features are unavailable on the BSP-disabled setting. This is no
problem because we don't need hibernation and suspend in the kdump 2nd
kernel.

SFI and devicetree doesn't provide BSP information, so there's no
functionality change in their codes, only assigning false for all the
entries, keeping interface uniform.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 arch/x86/include/asm/mpspec.h |    2 +-
 arch/x86/kernel/acpi/boot.c   |   10 +++++++++-
 arch/x86/kernel/apic/apic.c   |   21 ++++++++++++++++++++-
 arch/x86/kernel/devicetree.c  |    2 +-
 arch/x86/kernel/mpparse.c     |   15 +++++++++++++--
 arch/x86/platform/sfi/sfi.c   |    2 +-
 6 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index d56f253..b5d8e23 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -97,7 +97,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 #define default_get_smp_config x86_init_uint_noop
 #endif
 
-void __cpuinit generic_processor_info(int apicid, int version);
+void __cpuinit generic_processor_info(int apicid, bool isbsp, int version);
 #ifdef CONFIG_ACPI
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index e651f7a..e873c09 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -198,6 +198,7 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
 static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
+	bool isbsp = false;
 
 	if (id >= (MAX_LOCAL_APIC-1)) {
 		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
@@ -212,7 +213,14 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 	if (boot_cpu_physical_apicid != -1U)
 		ver = apic_version[boot_cpu_physical_apicid];
 
-	generic_processor_info(id, ver);
+	/*
+	 * ACPI says BIOS should list BSP in the first MADT LAPIC
+	 * entry.
+	 */
+	if (!num_processors && !disabled_cpus)
+		isbsp = true;
+
+	generic_processor_info(id, isbsp, ver);
 }
 
 static int __init
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d8d69e4..4184853 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2034,13 +2034,32 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 	apic_write(APIC_LVT1, value);
 }
 
-void __cpuinit generic_processor_info(int apicid, int version)
+void __cpuinit generic_processor_info(int apicid, bool isbsp, int version)
 {
 	int cpu, max = nr_cpu_ids;
 	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
 				phys_cpu_present_map);
 
 	/*
+	 * If boot cpu is AP, we now don't have any way to initialize
+	 * BSP. To save memory consumed, we disable BSP this case.
+	 *
+	 * Then, we cannot use the features specific to BSP such as
+	 * hibernation and suspend. This is no problem because AP
+	 * becomes boot cpu only on kexec triggered by crash.
+	 */
+	if (isbsp && !boot_cpu_is_bsp) {
+		int thiscpu = num_processors + disabled_cpus;
+
+		pr_warning("ACPI: The boot cpu is not BSP."
+			   " The BSP Processor %d/0x%x ignored.\n", thiscpu,
+			   apicid);
+
+		disabled_cpus++;
+		return;
+	}
+
+	/*
 	 * If boot cpu has not been detected yet, then only allow upto
 	 * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
 	 */
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index b158152..efdacc9 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -182,7 +182,7 @@ static void __init dtb_lapic_setup(void)
 	smp_found_config = 1;
 	pic_mode = 1;
 	register_lapic_address(r.start);
-	generic_processor_info(boot_cpu_physical_apicid,
+	generic_processor_info(boot_cpu_physical_apicid, false,
 			       GET_APIC_VERSION(apic_read(APIC_LVR)));
 #endif
 }
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d2b5648..33167e5 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -54,6 +54,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 {
 	int apicid;
 	char *bootup_cpu = "";
+	bool isbsp = false;
 
 	if (!(m->cpuflag & CPU_ENABLED)) {
 		disabled_cpus++;
@@ -64,11 +65,21 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 
 	if (m->cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
-		boot_cpu_physical_apicid = m->apicid;
+		/*
+		 * boot cpu can not be BSP if any crash happens on AP
+		 * and kexec enters the 2nd kernel.
+		 *
+		 * Also, boot_cpu_physical_apicid can be initialized
+		 * before reaching here; for example, in
+		 * register_lapic_address().
+		 */
+		if (boot_cpu_is_bsp && boot_cpu_physical_apicid == -1U)
+			boot_cpu_physical_apicid = m->apicid;
+		isbsp = true;
 	}
 
 	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);
-	generic_processor_info(apicid, m->apicver);
+	generic_processor_info(apicid, isbsp, m->apicver);
 }
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index 7785b72..e646041 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -45,7 +45,7 @@ static void __cpuinit mp_sfi_register_lapic(u8 id)
 
 	pr_info("registering lapic[%d]\n", id);
 
-	generic_processor_info(id, GET_APIC_VERSION(apic_read(APIC_LVR)));
+	generic_processor_info(id, false, GET_APIC_VERSION(apic_read(APIC_LVR)));
 }
 
 static int __init sfi_parse_cpus(struct sfi_table_header *table)

