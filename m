Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2EQIYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:24:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39334 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab2EQIYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:24:30 -0400
Date: Thu, 17 May 2012 10:24:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120517082424.GA19645@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: c3709e6734daa4d9b37fe31592ebb0eb57bae1bb x86, kvm: KVM paravirt kernels don't check for CPUID being unavailable

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86, kvm: KVM paravirt kernels don't check for CPUID being unavailable

Jan Beulich (1):
      x86: Fix section annotation of acpi_map_cpu2node()

Srivatsa S. Bhat (1):
      x86/microcode: Ensure that module is only loaded on supported Intel CPUs


 arch/x86/include/asm/kvm_para.h   |    3 +++
 arch/x86/kernel/acpi/boot.c       |    2 +-
 arch/x86/kernel/microcode_intel.c |   14 ++++++++------
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 734c376..183922e 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -170,6 +170,9 @@ static inline int kvm_para_available(void)
 	unsigned int eax, ebx, ecx, edx;
 	char signature[13];
 
+	if (boot_cpu_data.cpuid_level < 0)
+		return 0;	/* So we don't blow up on old processors */
+
 	cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
 	memcpy(signature + 0, &ebx, 4);
 	memcpy(signature + 4, &ecx, 4);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index a415b1f..7c439fe 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -593,7 +593,7 @@ void __init acpi_set_irq_model_ioapic(void)
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 #include <acpi/processor.h>
 
-static void __cpuinitdata acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
+static void __cpuinit acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 {
 #ifdef CONFIG_ACPI_NUMA
 	int nid;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 3ca42d0..0327e2b 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -147,12 +147,6 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 
 	memset(csig, 0, sizeof(*csig));
 
-	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
-	    cpu_has(c, X86_FEATURE_IA64)) {
-		pr_err("CPU%d not a capable Intel processor\n", cpu_num);
-		return -1;
-	}
-
 	csig->sig = cpuid_eax(0x00000001);
 
 	if ((c->x86_model >= 5) || (c->x86 > 6)) {
@@ -463,6 +457,14 @@ static struct microcode_ops microcode_intel_ops = {
 
 struct microcode_ops * __init init_intel_microcode(void)
 {
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
+	    cpu_has(c, X86_FEATURE_IA64)) {
+		pr_err("Intel CPU family 0x%x not supported\n", c->x86);
+		return NULL;
+	}
+
 	return &microcode_intel_ops;
 }
 
