Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1K3JBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:01:54 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45766 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab1K3JBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:01:52 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 30 Nov 2011 14:29:59 +0530
Message-Id: <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com>
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V3 2/4] kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks
x-cbid: 11113009-3352-0000-0000-0000011241D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a hypercall to KVM hypervisor to support pv-ticketlocks 

KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu out of halt state.
    
The presence of these hypercalls is indicated to guest via
KVM_FEATURE_KICK_VCPU/KVM_CAP_KICK_VCPU.

Qemu needs a corresponding patch to pass up the presence of this feature to 
guest via cpuid. Patch to qemu will be sent separately.

There is no Xen/KVM hypercall interface to await kick from.
    
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 734c376..8b1d65d 100644
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
+#define KVM_FEATURE_KICK_VCPU		6
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c38efd7..6e1c8b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2103,6 +2103,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
 	case KVM_CAP_GET_TSC_KHZ:
+	case KVM_CAP_KICK_VCPU:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2577,7 +2578,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
-			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
+			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+			     (1 << KVM_FEATURE_KICK_VCPU);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
@@ -5305,6 +5307,26 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/*
+ * kvm_pv_kick_cpu_op:  Kick a vcpu.
+ *
+ * @cpu - vcpu to be kicked.
+ */
+static void kvm_pv_kick_cpu_op(struct kvm *kvm, int cpu)
+{
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
+	struct kvm_mp_state mp_state;
+
+	mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
+	if (vcpu) {
+		vcpu->kicked = 1;
+		/* Ensure kicked is always set before wakeup */
+		barrier();
+	}
+	kvm_arch_vcpu_ioctl_set_mpstate(vcpu, &mp_state);
+	kvm_vcpu_kick(vcpu);
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -5341,6 +5363,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_MMU_OP:
 		r = kvm_pv_mmu_op(vcpu, a0, hc_gpa(vcpu, a1, a2), &ret);
 		break;
+	case KVM_HC_KICK_CPU:
+		kvm_pv_kick_cpu_op(vcpu->kvm, a0);
+		ret = 0;
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f47fcd3..e760035 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -558,6 +558,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_HIOR 67
 #define KVM_CAP_PPC_PAPR 68
 #define KVM_CAP_S390_GMAP 71
+#define KVM_CAP_KICK_VCPU 72
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d526231..ff3b6ff 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -154,6 +154,11 @@ struct kvm_vcpu {
 #endif
 
 	struct kvm_vcpu_arch arch;
+
+	/*
+	 * blocked vcpu wakes up by checking this flag set by unlocker.
+	 */
+	int kicked;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index 47a070b..19f10bd 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_KICK_CPU			5
 
 /*
  * hypercalls use architecture specific
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9cfb78..8f4b6db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -226,6 +226,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
+	vcpu->kicked = 0;
 	init_waitqueue_head(&vcpu->wq);
 	kvm_async_pf_vcpu_init(vcpu);
 

