Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab1ASRMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:12:47 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53894 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab1ASRMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:12:45 -0500
Date: Wed, 19 Jan 2011 22:42:39 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: [PATCH 2/3] kvm hypervisor : Add hypercalls to support
 pv-ticketlock
Message-ID: <20110119171239.GB726@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <20110119164432.GA30669@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119164432.GA30669@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two hypercalls to KVM hypervisor to support pv-ticketlocks.

KVM_HC_WAIT_FOR_KICK blocks the calling vcpu until another vcpu kicks it or it
is woken up because of an event like interrupt.

KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu.

The presence of these hypercalls is indicated to guest via
KVM_FEATURE_WAIT_FOR_KICK/KVM_CAP_WAIT_FOR_KICK. Qemu needs a corresponding
patch to pass up the presence of this feature to guest via cpuid. Patch to qemu
will be sent separately.


Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>

---
 arch/x86/include/asm/kvm_para.h |    2 +
 arch/x86/kvm/x86.c              |   69 +++++++++++++++++++++++++++++++++++++++-
 include/linux/kvm.h             |    1 
 include/linux/kvm_host.h        |    1 
 include/linux/kvm_para.h        |    2 +
 virt/kvm/kvm_main.c             |    1 
 6 files changed, 75 insertions(+), 1 deletion(-)

Index: linux-2.6.37/arch/x86/include/asm/kvm_para.h
===================================================================
--- linux-2.6.37.orig/arch/x86/include/asm/kvm_para.h
+++ linux-2.6.37/arch/x86/include/asm/kvm_para.h
@@ -16,6 +16,8 @@
 #define KVM_FEATURE_CLOCKSOURCE		0
 #define KVM_FEATURE_NOP_IO_DELAY	1
 #define KVM_FEATURE_MMU_OP		2
+#define KVM_FEATURE_WAIT_FOR_KICK       4
+
 /* This indicates that the new set of kvmclock msrs
  * are available. The use of 0x11 and 0x12 is deprecated
  */
Index: linux-2.6.37/arch/x86/kvm/x86.c
===================================================================
--- linux-2.6.37.orig/arch/x86/kvm/x86.c
+++ linux-2.6.37/arch/x86/kvm/x86.c
@@ -1922,6 +1922,7 @@ int kvm_dev_ioctl_check_extension(long e
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 	case KVM_CAP_XSAVE:
+	case KVM_CAP_WAIT_FOR_KICK:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2340,7 +2341,8 @@ static void do_cpuid_ent(struct kvm_cpui
 		entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
 			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
-			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
+			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+			     (1 << KVM_FEATURE_WAIT_FOR_KICK);
 		entry->ebx = 0;
 		entry->ecx = 0;
 		entry->edx = 0;
@@ -4766,6 +4768,63 @@ int kvm_hv_hypercall(struct kvm_vcpu *vc
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
+	do {
+		/*
+		 * Somebody has already tried kicking us. Acknowledge that
+		 * and terminate the wait.
+		 */
+		if (vcpu->kicked) {
+			vcpu->kicked = 0;
+			break;
+		}
+
+		/* Let's wait for either KVM_HC_KICK_CPU or someother event
+		 * to wake us up.
+		 */
+
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+		schedule();
+		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	} while (0);
+
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
@@ -4802,6 +4861,14 @@ int kvm_emulate_hypercall(struct kvm_vcp
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
Index: linux-2.6.37/include/linux/kvm.h
===================================================================
--- linux-2.6.37.orig/include/linux/kvm.h
+++ linux-2.6.37/include/linux/kvm.h
@@ -540,6 +540,7 @@ struct kvm_ppc_pvinfo {
 #endif
 #define KVM_CAP_PPC_GET_PVINFO 57
 #define KVM_CAP_PPC_IRQ_LEVEL 58
+#define KVM_CAP_WAIT_FOR_KICK 59
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
Index: linux-2.6.37/include/linux/kvm_host.h
===================================================================
--- linux-2.6.37.orig/include/linux/kvm_host.h
+++ linux-2.6.37/include/linux/kvm_host.h
@@ -105,6 +105,7 @@ struct kvm_vcpu {
 #endif
 
 	struct kvm_vcpu_arch arch;
+	int kicked;
 };
 
 /*
Index: linux-2.6.37/include/linux/kvm_para.h
===================================================================
--- linux-2.6.37.orig/include/linux/kvm_para.h
+++ linux-2.6.37/include/linux/kvm_para.h
@@ -19,6 +19,8 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_WAIT_FOR_KICK            5
+#define KVM_HC_KICK_CPU		        6
 
 /*
  * hypercalls use architecture specific
Index: linux-2.6.37/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.37.orig/virt/kvm/kvm_main.c
+++ linux-2.6.37/virt/kvm/kvm_main.c
@@ -185,6 +185,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu,
 	vcpu->cpu = -1;
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
+	vcpu->kicked = 0;
 	init_waitqueue_head(&vcpu->wq);
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);

 
