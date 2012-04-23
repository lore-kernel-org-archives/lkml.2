Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2DWOEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:04:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372Ab2DWOEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:04:36 -0400
Date: Mon, 23 Apr 2012 17:04:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC dontapply 5/5] kvm_para: guest side for eoi avoidance
Message-ID: <5e1399d9e743668a87f31d8f2b83cad862c60728.1334833141.git.mst@redhat.com>
References: <cover.1334833140.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1334833140.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is simple: there's a bit, per APIC, in guest memory,
that tells the guest that it does not need EOI.
Guest tests it using a single est and clear operation - this is
necessary so that host can detect interrupt nesting - and if set, it can
skip the EOI MSR.

This patch is not final yet, pls don't apply
until host side is also finalized. Including
it here for completeness to show another user
of the new eoi_write interface.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/bitops.h   |    6 +++-
 arch/x86/include/asm/kvm_para.h |    2 +
 arch/x86/kernel/kvm.c           |   51 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 54 insertions(+), 5 deletions(-)

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
index 734c376..195840d 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -22,6 +22,7 @@
 #define KVM_FEATURE_CLOCKSOURCE2        3
 #define KVM_FEATURE_ASYNC_PF		4
 #define KVM_FEATURE_STEAL_TIME		5
+#define KVM_FEATURE_EOI			6
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -37,6 +38,7 @@
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
+#define MSR_KVM_EOI_EN      0x4b564d04
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ba6e4..ad66cdd 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -39,6 +39,8 @@
 #include <asm/desc.h>
 #include <asm/tlbflush.h>
 #include <asm/idle.h>
+#include <asm/apic.h>
+#include <asm/apicdef.h>
 
 static int kvmapf = 1;
 
@@ -290,6 +292,27 @@ static void kvm_register_steal_time(void)
 		cpu, __pa(st));
 }
 
+static DEFINE_PER_CPU(u16, kvm_apic_eoi) __aligned(2) = 0;
+
+/* Our own copy of __test_and_clear_bit to make sure
+ * it is done with a single instruction */
+static inline int kvm_test_and_clear_bit(int nr, volatile u16* addr)
+{
+	int oldbit;
+
+	asm volatile("btr %2,%1\n\t"
+		     "sbb %0,%0"
+		     : "=r" (oldbit), BITOP_ADDR_CONSTRAINT(*addr) : "Ir" (nr));
+	return oldbit;
+}
+
+static void kvm_guest_apic_eoi_write(u32 reg, u32 val)
+{
+	if (kvm_test_and_clear_bit(0, &__get_cpu_var(kvm_apic_eoi)))
+		return;
+	apic->write(APIC_EOI, APIC_EOI_ACK);
+}
+
 void __cpuinit kvm_guest_cpu_init(void)
 {
 	if (!kvm_para_available())
@@ -307,11 +330,17 @@ void __cpuinit kvm_guest_cpu_init(void)
 		       smp_processor_id());
 	}
 
+	if (kvm_para_has_feature(KVM_FEATURE_EOI)) {
+		__get_cpu_var(kvm_apic_eoi) = 0;
+		wrmsrl(MSR_KVM_EOI_EN, __pa(&__get_cpu_var(kvm_apic_eoi)) |
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
@@ -323,11 +352,18 @@ static void kvm_pv_disable_apf(void *unused)
 	       smp_processor_id());
 }
 
+static void kvm_pv_guest_cpu_reboot(void *unused)
+{
+	if (kvm_para_has_feature(KVM_FEATURE_EOI))
+		wrmsrl(MSR_KVM_EOI_EN, 0);
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
 
@@ -378,7 +414,9 @@ static void __cpuinit kvm_guest_cpu_online(void *dummy)
 static void kvm_guest_cpu_offline(void *dummy)
 {
 	kvm_disable_steal_time();
-	kvm_pv_disable_apf(NULL);
+	if (kvm_para_has_feature(KVM_FEATURE_EOI))
+		wrmsrl(MSR_KVM_EOI_EN, 0);
+	kvm_pv_disable_apf();
 	apf_task_wake_all();
 }
 
@@ -431,6 +469,13 @@ void __init kvm_guest_init(void)
 		pv_time_ops.steal_clock = kvm_steal_clock;
 	}
 
+	if (kvm_para_has_feature(KVM_FEATURE_EOI)) {
+		/* Should happen once after apic is initialized */
+		BUG_ON(!apic);
+		BUG_ON(apic->eoi_write == kvm_guest_apic_eoi_write);
+		apic->eoi_write = kvm_guest_apic_eoi_write;
+	}
+
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
 	register_cpu_notifier(&kvm_cpu_notifier);
-- 
1.7.9.111.gf3fb0
