Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab2JPEf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:35:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38749 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab2JPEf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:35:27 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v1 1/2] x86,
 apic: Introduce boot_cpu_is_bsp indicating whether boot cpu is BSP or
 not
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, vgoyal@redhat.com, ebiederm@xmission.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        d.hatayama@jp.fujitsu.com
Date: Tue, 16 Oct 2012 13:35:23 +0900
Message-ID: <20121016043523.20003.11838.stgit@localhost6.localdomain6>
In-Reply-To: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of boot-up code assumes booting CPU is BSP, but kexec can enter
the 2nd kernel with AP. To be able to distinguish these throughout
kernel processing, introduce boot_cpu_is_bsp.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 arch/x86/include/asm/mpspec.h |    3 +++
 arch/x86/kernel/apic/apic.c   |   13 +++++++++++++
 arch/x86/kernel/setup.c       |    2 ++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 3e2f42a..d56f253 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -47,10 +47,13 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 extern unsigned int boot_cpu_physical_apicid;
+extern bool boot_cpu_is_bsp;
 extern unsigned int max_physical_apicid;
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
 
+extern void boot_cpu_is_bsp_init(void);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 extern int smp_found_config;
 #else
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b17416e..d8d69e4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -62,6 +62,10 @@ unsigned disabled_cpus __cpuinitdata;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
 
+/* Indicates whether the processor that is doing the boot up, is BSP
+ * processor or not */
+bool boot_cpu_is_bsp;
+
 /*
  * The highest APIC ID seen during enumeration.
  */
@@ -2515,3 +2519,12 @@ static int __init lapic_insert_resource(void)
  * that is using request_resource
  */
 late_initcall(lapic_insert_resource);
+
+void boot_cpu_is_bsp_init(void)
+{
+	u32 l, h;
+
+	rdmsr(MSR_IA32_APICBASE, l, h);
+
+	boot_cpu_is_bsp = (l & MSR_IA32_APICBASE_BSP) ? true : false;
+}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a2bb18e..6ecb9bc 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -988,6 +988,8 @@ void __init setup_arch(char **cmdline_p)
 
 	early_quirks();
 
+	boot_cpu_is_bsp_init();
+
 	/*
 	 * Read APIC and some other early information from ACPI tables.
 	 */

