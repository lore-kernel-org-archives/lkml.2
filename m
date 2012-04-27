Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab2D0QY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:24:28 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53441 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab2D0QYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:24:25 -0400
Subject: [RFC PATCH v1 1/5] KVM Guest: Add VCPU running/pre-empted state for
 guest
To: peterz@infradead.org, mingo@elte.hu
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org, x86@kernel.org,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, avi@redhat.com,
        hpa@zytor.com
Date: Fri, 27 Apr 2012 21:53:33 +0530
Message-ID: <20120427162314.27082.13703.stgit@abhimanyu>
In-Reply-To: <20120427161727.27082.43096.stgit@abhimanyu>
References: <20120427161727.27082.43096.stgit@abhimanyu>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12042716-5816-0000-0000-000002530099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds guest code for msr between guest and hypervisor. The
msr will export the vcpu running/pre-empted information to the guest
from host. This will enable guest to intelligently send ipi to running
vcpus and set flag for pre-empted vcpus. This will prevent waiting for
vcpus that are not running.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_para.h |   10 ++++++++++
 arch/x86/kernel/kvm.c           |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 77266d3..f57b5cc 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -24,6 +24,7 @@
 #define KVM_FEATURE_ASYNC_PF		4
 #define KVM_FEATURE_STEAL_TIME		5
 #define KVM_FEATURE_PV_UNHALT		6
+#define KVM_FEATURE_VCPU_STATE          7
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -39,6 +40,7 @@
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
+#define MSR_KVM_VCPU_STATE  0x4b564d04
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -51,6 +53,14 @@ struct kvm_steal_time {
 #define KVM_STEAL_VALID_BITS ((-1ULL << (KVM_STEAL_ALIGNMENT_BITS + 1)))
 #define KVM_STEAL_RESERVED_MASK (((1 << KVM_STEAL_ALIGNMENT_BITS) - 1 ) << 1)
 
+struct kvm_vcpu_state {
+	__u32 state;
+	__u32 pad[15];
+};
+
+#define KVM_VCPU_STATE_ALIGN_BITS 5
+#define KVM_VCPU_STATE_VALID_BITS ((-1ULL << (KVM_VCPU_STATE_ALIGN_BITS + 1)))
+
 #define KVM_MAX_MMU_OP_BATCH           32
 
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 98f0378..bb686a6 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -64,6 +64,9 @@ static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
 static int has_steal_clock = 0;
 
+DEFINE_PER_CPU(struct kvm_vcpu_state, vcpu_state) __aligned(64);
+static int has_vcpu_state;
+
 /*
  * No need for any "IO delay" on KVM
  */
@@ -291,6 +294,22 @@ static void kvm_register_steal_time(void)
 		cpu, __pa(st));
 }
 
+static void kvm_register_vcpu_state(void)
+{
+	int cpu = smp_processor_id();
+	struct kvm_vcpu_state *v_state;
+
+	if (!has_vcpu_state)
+		return;
+
+	v_state = &per_cpu(vcpu_state, cpu);
+	memset(v_state, 0, sizeof(*v_state));
+
+	wrmsrl(MSR_KVM_VCPU_STATE, (__pa(v_state) | KVM_MSR_ENABLED));
+	printk(KERN_INFO "kvm-vcpustate: cpu %d, msr %lu\n",
+		cpu, __pa(v_state));
+}
+
 void __cpuinit kvm_guest_cpu_init(void)
 {
 	if (!kvm_para_available())
@@ -310,6 +329,9 @@ void __cpuinit kvm_guest_cpu_init(void)
 
 	if (has_steal_clock)
 		kvm_register_steal_time();
+
+	if (has_vcpu_state)
+		kvm_register_vcpu_state();
 }
 
 static void kvm_pv_disable_apf(void *unused)
@@ -361,6 +383,14 @@ void kvm_disable_steal_time(void)
 	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
 }
 
+void kvm_disable_vcpu_state(void)
+{
+	if (!has_vcpu_state)
+		return;
+
+	wrmsr(MSR_KVM_VCPU_STATE, 0, 0);
+}
+
 #ifdef CONFIG_SMP
 static void __init kvm_smp_prepare_boot_cpu(void)
 {
@@ -379,6 +409,7 @@ static void __cpuinit kvm_guest_cpu_online(void *dummy)
 
 static void kvm_guest_cpu_offline(void *dummy)
 {
+	kvm_disable_vcpu_state();
 	kvm_disable_steal_time();
 	kvm_pv_disable_apf(NULL);
 	apf_task_wake_all();
@@ -433,6 +464,8 @@ void __init kvm_guest_init(void)
 		pv_time_ops.steal_clock = kvm_steal_clock;
 	}
 
+	has_vcpu_state = 1;
+
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
 	register_cpu_notifier(&kvm_cpu_notifier);

