Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030341Ab2EPLqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:46:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030240Ab2EPLqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:46:00 -0400
Date: Wed, 16 May 2012 14:45:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv4 1/5] kvm_para: guest side for eoi avoidance
Message-ID: <37112f9f8ec6711541a30942304af391dd81ca4b.1337168687.git.mst@redhat.com>
References: <cover.1337168687.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1337168687.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is simple: there's a bit, per APIC, in guest memory,
that tells the guest that it does not need EOI.
Guest tests it using a single est and clear operation - this is
necessary so that host can detect interrupt nesting - and if set, it can
skip the EOI MSR.

I run a simple microbenchmark to show exit reduction
(note: for testing, need to apply follow-up patch
'kvm: host side for eoi optimization' + a qemu patch
 I posted separately, on host):

Before:

Performance counter stats for 'sleep 1s':

            47,357 kvm:kvm_entry                                                [99.98%]
                 0 kvm:kvm_hypercall                                            [99.98%]
                 0 kvm:kvm_hv_hypercall                                         [99.98%]
             5,001 kvm:kvm_pio                                                  [99.98%]
                 0 kvm:kvm_cpuid                                                [99.98%]
            22,124 kvm:kvm_apic                                                 [99.98%]
            49,849 kvm:kvm_exit                                                 [99.98%]
            21,115 kvm:kvm_inj_virq                                             [99.98%]
                 0 kvm:kvm_inj_exception                                        [99.98%]
                 0 kvm:kvm_page_fault                                           [99.98%]
            22,937 kvm:kvm_msr                                                  [99.98%]
                 0 kvm:kvm_cr                                                   [99.98%]
                 0 kvm:kvm_pic_set_irq                                          [99.98%]
                 0 kvm:kvm_apic_ipi                                             [99.98%]
            22,207 kvm:kvm_apic_accept_irq                                      [99.98%]
            22,421 kvm:kvm_eoi                                                  [99.98%]
                 0 kvm:kvm_pv_eoi                                               [99.99%]
                 0 kvm:kvm_nested_vmrun                                         [99.99%]
                 0 kvm:kvm_nested_intercepts                                    [99.99%]
                 0 kvm:kvm_nested_vmexit                                        [99.99%]
                 0 kvm:kvm_nested_vmexit_inject                                    [99.99%]
                 0 kvm:kvm_nested_intr_vmexit                                    [99.99%]
                 0 kvm:kvm_invlpga                                              [99.99%]
                 0 kvm:kvm_skinit                                               [99.99%]
                57 kvm:kvm_emulate_insn                                         [99.99%]
                 0 kvm:vcpu_match_mmio                                          [99.99%]
                 0 kvm:kvm_userspace_exit                                       [99.99%]
                 2 kvm:kvm_set_irq                                              [99.99%]
                 2 kvm:kvm_ioapic_set_irq                                       [99.99%]
            23,609 kvm:kvm_msi_set_irq                                          [99.99%]
                 1 kvm:kvm_ack_irq                                              [99.99%]
               131 kvm:kvm_mmio                                                 [99.99%]
               226 kvm:kvm_fpu                                                  [100.00%]
                 0 kvm:kvm_age_page                                             [100.00%]
                 0 kvm:kvm_try_async_get_page                                    [100.00%]
                 0 kvm:kvm_async_pf_doublefault                                    [100.00%]
                 0 kvm:kvm_async_pf_not_present                                    [100.00%]
                 0 kvm:kvm_async_pf_ready                                       [100.00%]
                 0 kvm:kvm_async_pf_completed

       1.002100578 seconds time elapsed

After:

 Performance counter stats for 'sleep 1s':

            28,354 kvm:kvm_entry                                                [99.98%]
                 0 kvm:kvm_hypercall                                            [99.98%]
                 0 kvm:kvm_hv_hypercall                                         [99.98%]
             1,347 kvm:kvm_pio                                                  [99.98%]
                 0 kvm:kvm_cpuid                                                [99.98%]
             1,931 kvm:kvm_apic                                                 [99.98%]
            29,595 kvm:kvm_exit                                                 [99.98%]
            24,884 kvm:kvm_inj_virq                                             [99.98%]
                 0 kvm:kvm_inj_exception                                        [99.98%]
                 0 kvm:kvm_page_fault                                           [99.98%]
             1,986 kvm:kvm_msr                                                  [99.98%]
                 0 kvm:kvm_cr                                                   [99.98%]
                 0 kvm:kvm_pic_set_irq                                          [99.98%]
                 0 kvm:kvm_apic_ipi                                             [99.99%]
            25,953 kvm:kvm_apic_accept_irq                                      [99.99%]
            26,132 kvm:kvm_eoi                                                  [99.99%]
            26,593 kvm:kvm_pv_eoi                                               [99.99%]
                 0 kvm:kvm_nested_vmrun                                         [99.99%]
                 0 kvm:kvm_nested_intercepts                                    [99.99%]
                 0 kvm:kvm_nested_vmexit                                        [99.99%]
                 0 kvm:kvm_nested_vmexit_inject                                    [99.99%]
                 0 kvm:kvm_nested_intr_vmexit                                    [99.99%]
                 0 kvm:kvm_invlpga                                              [99.99%]
                 0 kvm:kvm_skinit                                               [99.99%]
               284 kvm:kvm_emulate_insn                                         [99.99%]
                68 kvm:vcpu_match_mmio                                          [99.99%]
                68 kvm:kvm_userspace_exit                                       [99.99%]
                 2 kvm:kvm_set_irq                                              [99.99%]
                 2 kvm:kvm_ioapic_set_irq                                       [99.99%]
            28,288 kvm:kvm_msi_set_irq                                          [99.99%]
                 1 kvm:kvm_ack_irq                                              [99.99%]
               131 kvm:kvm_mmio                                                 [100.00%]
               588 kvm:kvm_fpu                                                  [100.00%]
                 0 kvm:kvm_age_page                                             [100.00%]
                 0 kvm:kvm_try_async_get_page                                    [100.00%]
                 0 kvm:kvm_async_pf_doublefault                                    [100.00%]
                 0 kvm:kvm_async_pf_not_present                                    [100.00%]
                 0 kvm:kvm_async_pf_ready                                       [100.00%]
                 0 kvm:kvm_async_pf_completed

       1.002039622 seconds time elapsed

We see that # of exits is almost halved.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/bitops.h   |    6 +++-
 arch/x86/include/asm/kvm_para.h |    7 +++++
 arch/x86/kernel/kvm.c           |   51 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index b97596e..c9c70ea 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -26,11 +26,13 @@
 #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
 /* Technically wrong, but this avoids compilation errors on some gcc
    versions. */
-#define BITOP_ADDR(x) "=m" (*(volatile long *) (x))
+#define BITOP_ADDR_CONSTRAINT "=m"
 #else
-#define BITOP_ADDR(x) "+m" (*(volatile long *) (x))
+#define BITOP_ADDR_CONSTRAINT "+m"
 #endif
 
+#define BITOP_ADDR(x) BITOP_ADDR_CONSTRAINT (*(volatile long *) (x))
+
 #define ADDR				BITOP_ADDR(addr)
 
 /*
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 734c376..6203ffb 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -22,6 +22,7 @@
 #define KVM_FEATURE_CLOCKSOURCE2        3
 #define KVM_FEATURE_ASYNC_PF		4
 #define KVM_FEATURE_STEAL_TIME		5
+#define KVM_FEATURE_PV_EOI		6
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -37,6 +38,7 @@
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
+#define MSR_KVM_PV_EOI_EN      0x4b564d04
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -89,6 +91,11 @@ struct kvm_vcpu_pv_apf_data {
 	__u32 enabled;
 };
 
+#define KVM_PV_EOI_BIT 0
+#define KVM_PV_EOI_MASK (0x1 << KVM_PV_EOI_BIT)
+#define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
+#define KVM_PV_EOI_DISABLED 0x0
+
 #ifdef __KERNEL__
 #include <asm/processor.h>
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index e554e5a..85cd6ac 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -39,6 +39,8 @@
 #include <asm/desc.h>
 #include <asm/tlbflush.h>
 #include <asm/idle.h>
+#include <asm/apic.h>
+#include <asm/apicdef.h>
 
 static int kvmapf = 1;
 
@@ -283,6 +285,24 @@ static void kvm_register_steal_time(void)
 		cpu, __pa(st));
 }
 
+/* size alignment is implied but just to make it explicit. */
+static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) __aligned(2) =
+	KVM_PV_EOI_DISABLED;
+
+static void kvm_guest_apic_eoi_write(u32 reg, u32 val)
+{
+	/**
+	 * This relies on __test_and_clear_bit to modify the memory
+	 * in a way that is atomic with respect to the local CPU.
+	 * The hypervisor only accesses this memory from the local CPU so
+	 * there's no need for lock or memory barriers.
+	 * An optimization barrier is implied in apic write.
+	 */
+	if (__test_and_clear_bit(KVM_PV_EOI_BIT, &__get_cpu_var(kvm_apic_eoi)))
+		return;
+	apic->write(APIC_EOI, APIC_EOI_ACK);
+}
+
 void __cpuinit kvm_guest_cpu_init(void)
 {
 	if (!kvm_para_available())
@@ -300,11 +320,17 @@ void __cpuinit kvm_guest_cpu_init(void)
 		       smp_processor_id());
 	}
 
+	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
+		__get_cpu_var(kvm_apic_eoi) = 0;
+		wrmsrl(MSR_KVM_PV_EOI_EN, __pa(&__get_cpu_var(kvm_apic_eoi)) |
+		       KVM_MSR_ENABLED);
+	}
+
 	if (has_steal_clock)
 		kvm_register_steal_time();
 }
 
-static void kvm_pv_disable_apf(void *unused)
+static void kvm_pv_disable_apf(void)
 {
 	if (!__get_cpu_var(apf_reason).enabled)
 		return;
@@ -316,11 +342,18 @@ static void kvm_pv_disable_apf(void *unused)
 	       smp_processor_id());
 }
 
+static void kvm_pv_guest_cpu_reboot(void *unused)
+{
+	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
+		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+	kvm_pv_disable_apf();
+}
+
 static int kvm_pv_reboot_notify(struct notifier_block *nb,
 				unsigned long code, void *unused)
 {
 	if (code == SYS_RESTART)
-		on_each_cpu(kvm_pv_disable_apf, NULL, 1);
+		on_each_cpu(kvm_pv_guest_cpu_reboot, NULL, 1);
 	return NOTIFY_DONE;
 }
 
@@ -371,7 +404,9 @@ static void __cpuinit kvm_guest_cpu_online(void *dummy)
 static void kvm_guest_cpu_offline(void *dummy)
 {
 	kvm_disable_steal_time();
-	kvm_pv_disable_apf(NULL);
+	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
+		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+	kvm_pv_disable_apf();
 	apf_task_wake_all();
 }
 
@@ -424,6 +459,16 @@ void __init kvm_guest_init(void)
 		pv_time_ops.steal_clock = kvm_steal_clock;
 	}
 
+	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
+		struct apic **drv;
+
+		for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+			/* Should happen once for each apic */
+			WARN_ON((*drv)->eoi_write == kvm_guest_apic_eoi_write);
+			(*drv)->eoi_write = kvm_guest_apic_eoi_write;
+		}
+	}
+
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
 	register_cpu_notifier(&kvm_cpu_notifier);
-- 
MST

