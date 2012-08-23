Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270Ab2HWXPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:15:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52432 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2HWXOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:14:43 -0400
Subject: [PATCH RFC 2/3] Add a hypercall to retrieve the cpu entitlement value
 from the host.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com
Date: Thu, 23 Aug 2012 18:14:34 -0500
Message-ID: <20120823231433.11681.7644.stgit@lambeau>
In-Reply-To: <20120823231346.11681.1502.stgit@lambeau>
References: <20120823231346.11681.1502.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082323-2356-0000-0000-0000018A9F30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the hypercall is not implemented on the host a default value of
100 will be used. This value will be stored in /proc/sys/kernel/cpu_entitlements.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |    8 ++++++++
 fs/proc/stat.c           |    9 +++++++++
 include/linux/kvm.h      |    3 +++
 include/linux/kvm_host.h |    3 +++
 include/linux/kvm_para.h |    1 +
 virt/kvm/kvm_main.c      |    7 +++++++
 6 files changed, 31 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42bce48..734bc3d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5052,6 +5052,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_VAPIC_POLL_IRQ:
 		ret = 0;
 		break;
+	case KVM_HC_CPU_ENTITLEMENT:
+		ret = vcpu->kvm->vcpu_entitlement;
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -5897,6 +5900,11 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+int kvm_arch_vcpu_ioctl_set_entitlement(struct kvm *kvm, long entitlement)
+{
+	kvm->vcpu_entitlement = (int) entitlement;
+	return 0;
+}
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct i387_fxsave_struct *fxsave =
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 14e26c8..cf66665 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -11,6 +11,7 @@
 #include <linux/irqnr.h>
 #include <asm/cputime.h>
 #include <linux/tick.h>
+#include <linux/kvm_para.h>
 
 int cpu_entitlement = 100;
 #ifndef arch_irq_stat_cpu
@@ -213,6 +214,14 @@ static const struct file_operations proc_stat_operations = {
 
 static int __init proc_stat_init(void)
 {
+	long ret;
+
+	if (kvm_para_available()) {
+		ret = kvm_hypercall0(KVM_HC_CPU_ENTITLEMENT);
+		if (ret > 0)
+			cpu_entitlement = (int) ret;
+	}
+
 	proc_create("stat", 0, NULL, &proc_stat_operations);
 	return 0;
 }
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2ce09aa..fccd08e 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -904,6 +904,9 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
 /* VM is being stopped by host */
 #define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xad)
+/* Set the cpu entitlement this will be used to adjust stealtime reporting */
+#define KVM_SET_ENTITLEMENT  _IOW(KVMIO, 0xae, unsigned long)
+
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b70b48b..71e3d73 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -276,6 +276,7 @@ struct kvm {
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	atomic_t online_vcpus;
 	int last_boosted_vcpu;
+	int vcpu_entitlement;
 	struct list_head vm_list;
 	struct mutex lock;
 	struct kvm_io_bus *buses[KVM_NR_BUSES];
@@ -538,6 +539,8 @@ void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_ioctl_set_entitlement(struct kvm *kvm,
+						long entitlement);
 
 void kvm_free_physmem(struct kvm *kvm);
 
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index ff476dd..95f3387 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_CPU_ENTITLEMENT          5
 
 /*
  * hypercalls use architecture specific
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2468523..a0a4939 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2093,6 +2093,13 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif
+	case KVM_SET_ENTITLEMENT: {
+		r = kvm_arch_vcpu_ioctl_set_entitlement(kvm, arg);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 		if (r == -ENOTTY)

