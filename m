Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab1JWTG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:06:28 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53061 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1JWTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:06:26 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen <xen-devel@lists.xensource.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Date: Mon, 24 Oct 2011 00:35:59 +0530
Message-Id: <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V2 3/5] kvm hypervisor : Add two hypercalls to support pv-ticketlock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two hypercalls to KVM hypervisor to support pv-ticketlocks.
    
KVM_HC_WAIT_FOR_KICK blocks the calling vcpu until another vcpu kicks it or it
is woken up because of an event like interrupt.
   
KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu.
    
The presence of these hypercalls is indicated to guest via
KVM_FEATURE_WAIT_FOR_KICK/KVM_CAP_WAIT_FOR_KICK.

Qemu needs a corresponding patch to pass up the presence of this feature to 
guest via cpuid. Patch to qemu will be sent separately.

There is no Xen/KVM hypercall interface to await kick from.
    
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 734c376..2874c19 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -16,12 +16,14 @@
 #define KVM_FEATURE_CLOCKSOURCE		0
 #define KVM_FEATURE_NOP_IO_DELAY	1
 #define KVM_FEATURE_MMU_OP		2
+
 /* This indicates that the new set of kvmclock msrs
  * are available. The use of 0x11 and 0x12 is deprecated
  */
 #define KVM_FEATURE_CLOCKSOURCE2        3
 #define KVM_FEATURE_ASYNC_PF		4
 #define KVM_FEATURE_STEAL_TIME		5
+#define KVM_FEATURE_WAIT_FOR_KICK       6
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 84a28ea..b43fd18 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2077,6 +2077,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
 	case KVM_CAP_GET_TSC_KHZ:
+	case KVM_CAP_WAIT_FOR_KICK:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2548,7 +2549,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
-			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
+			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+			     (1 << KVM_FEATURE_WAIT_FOR_KICK);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
@@ -5231,6 +5233,61 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/*
+ * kvm_pv_wait_for_kick_op : Block until kicked by either a KVM_HC_KICK_CPU
+ * hypercall or a event like interrupt.
+ *
+ * @vcpu : vcpu which is blocking.
+ */
+static void kvm_pv_wait_for_kick_op(struct kvm_vcpu *vcpu)
+{
+	DEFINE_WAIT(wait);
+
+	/*
+	 * Blocking on vcpu->wq allows us to wake up sooner if required to
+	 * service pending events (like interrupts).
+	 *
+	 * Also set state to TASK_INTERRUPTIBLE before checking vcpu->kicked to
+	 * avoid racing with kvm_pv_kick_cpu_op().
+	 */
+	prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
+
+	/*
+	 * Somebody has already tried kicking us. Acknowledge that
+	 * and terminate the wait.
+	 */
+	if (vcpu->kicked) {
+		vcpu->kicked = 0;
+		goto end_wait;
+	}
+
+	/* Let's wait for either KVM_HC_KICK_CPU or someother event
+	 * to wake us up.
+	 */
+
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	schedule();
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+end_wait:
+	finish_wait(&vcpu->wq, &wait);
+}
+
+/*
+ * kvm_pv_kick_cpu_op:  Kick a vcpu.
+ *
+ * @cpu - vcpu to be kicked.
+ */
+static void kvm_pv_kick_cpu_op(struct kvm *kvm, int cpu)
+{
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
+
+	if (vcpu) {
+		vcpu->kicked = 1;
+		wake_up_interruptible(&vcpu->wq);
+	}
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -5267,6 +5324,14 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_MMU_OP:
 		r = kvm_pv_mmu_op(vcpu, a0, hc_gpa(vcpu, a1, a2), &ret);
 		break;
+	case KVM_HC_WAIT_FOR_KICK:
+		kvm_pv_wait_for_kick_op(vcpu);
+		ret = 0;
+		break;
+	case KVM_HC_KICK_CPU:
+		kvm_pv_kick_cpu_op(vcpu->kvm, a0);
+		ret = 0;
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index aace6b8..736acc0 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -553,6 +553,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_SPAPR_TCE 63
 #define KVM_CAP_PPC_SMT 64
 #define KVM_CAP_PPC_RMA	65
+#define KVM_CAP_WAIT_FOR_KICK 66
 #define KVM_CAP_S390_GMAP 71
 
 #ifdef KVM_CAP_IRQ_ROUTING
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eabb21a..2946563 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -152,6 +152,11 @@ struct kvm_vcpu {
 #endif
 
 	struct kvm_vcpu_arch arch;
+
+	/*
+	 * blocked vcpu wakes up by checking this flag set by unlocker
+	 */
+	int kicked;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index 47a070b..4efee4d 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -19,6 +19,8 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_WAIT_FOR_KICK            5
+#define KVM_HC_KICK_CPU		        6
 
 /*
  * hypercalls use architecture specific
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aefdda3..d09982d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -224,6 +224,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
+	vcpu->kicked = 0;
 	init_waitqueue_head(&vcpu->wq);
 	kvm_async_pf_vcpu_init(vcpu);
 
