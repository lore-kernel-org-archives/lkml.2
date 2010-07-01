Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab0GAV27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:28:59 -0400
Received: from kroah.org ([198.145.64.141]:33272 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933176Ab0GAVPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:35 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:02 2010
Message-Id: <20100701174302.732817596@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shane Wang <shane.wang@intel.com>, Avi Kivity <avi@redhat.com>
Subject: [192/200] KVM: VMX: enable VMXON check with SMX enabled (Intel TXT)
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Wang <shane.wang@intel.com>

Per document, for feature control MSR:

  Bit 1 enables VMXON in SMX operation. If the bit is clear, execution
        of VMXON in SMX operation causes a general-protection exception.
  Bit 2 enables VMXON outside SMX operation. If the bit is clear, execution
        of VMXON outside SMX operation causes a general-protection exception.

This patch is to enable this kind of check with SMX for VMXON in KVM.

Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit cafd66595d92591e4bd25c3904e004fc6f897e2d)
---
 arch/x86/include/asm/msr-index.h |    5 +++--
 arch/x86/kernel/tboot.c          |    1 +
 arch/x86/kvm/vmx.c               |   32 +++++++++++++++++++++-----------
 include/linux/tboot.h            |    1 +
 4 files changed, 26 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -199,8 +199,9 @@
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 
-#define FEATURE_CONTROL_LOCKED		(1<<0)
-#define FEATURE_CONTROL_VMXON_ENABLED	(1<<2)
+#define FEATURE_CONTROL_LOCKED				(1<<0)
+#define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
+#define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
 
 #define MSR_IA32_APICBASE		0x0000001b
 #define MSR_IA32_APICBASE_BSP		(1<<8)
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -46,6 +46,7 @@
 
 /* Global pointer to shared data; NULL means no measured launch. */
 struct tboot *tboot __read_mostly;
+EXPORT_SYMBOL(tboot);
 
 /* timeout for APs (in secs) to enter wait-for-SIPI state during shutdown */
 #define AP_WAIT_TIMEOUT		1
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -27,6 +27,7 @@
 #include <linux/moduleparam.h>
 #include <linux/ftrace_event.h>
 #include <linux/slab.h>
+#include <linux/tboot.h>
 #include "kvm_cache_regs.h"
 #include "x86.h"
 
@@ -1176,9 +1177,16 @@ static __init int vmx_disabled_by_bios(v
 	u64 msr;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
-	return (msr & (FEATURE_CONTROL_LOCKED |
-		       FEATURE_CONTROL_VMXON_ENABLED))
-	    == FEATURE_CONTROL_LOCKED;
+	if (msr & FEATURE_CONTROL_LOCKED) {
+		if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX)
+			&& tboot_enabled())
+			return 1;
+		if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX)
+			&& !tboot_enabled())
+			return 1;
+	}
+
+	return 0;
 	/* locked but not enabled */
 }
 
@@ -1186,21 +1194,23 @@ static int hardware_enable(void *garbage
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
-	u64 old;
+	u64 old, test_bits;
 
 	if (read_cr4() & X86_CR4_VMXE)
 		return -EBUSY;
 
 	INIT_LIST_HEAD(&per_cpu(vcpus_on_cpu, cpu));
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-	if ((old & (FEATURE_CONTROL_LOCKED |
-		    FEATURE_CONTROL_VMXON_ENABLED))
-	    != (FEATURE_CONTROL_LOCKED |
-		FEATURE_CONTROL_VMXON_ENABLED))
+
+	test_bits = FEATURE_CONTROL_LOCKED;
+	test_bits |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
+	if (tboot_enabled())
+		test_bits |= FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX;
+
+	if ((old & test_bits) != test_bits) {
 		/* enable and lock */
-		wrmsrl(MSR_IA32_FEATURE_CONTROL, old |
-		       FEATURE_CONTROL_LOCKED |
-		       FEATURE_CONTROL_VMXON_ENABLED);
+		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | test_bits);
+	}
 	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
 	asm volatile (ASM_VMX_VMXON_RAX
 		      : : "a"(&phys_addr), "m"(phys_addr)
--- a/include/linux/tboot.h
+++ b/include/linux/tboot.h
@@ -150,6 +150,7 @@ extern int tboot_force_iommu(void);
 
 #else
 
+#define tboot_enabled()			0
 #define tboot_probe()			do { } while (0)
 #define tboot_shutdown(shutdown_type)	do { } while (0)
 #define tboot_sleep(sleep_state, pm1a_control, pm1b_control)	\


