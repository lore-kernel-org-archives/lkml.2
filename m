Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab2IFLbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:31:09 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59500 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2IFLaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:30:24 -0400
X-AuditID: b753bd60-9395fba000007c38-85-504888c8ce34
X-AuditID: b753bd60-9395fba000007c38-85-504888c8ce34
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 08/21] KVM: Add KVM_GET_SLAVE_CPU and KVM_SET_SLAVE_CPU
 to vCPU ioctl
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:28:01 +0900
Message-ID: <20120906112800.13320.73999.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an interface to set/get slave CPU dedicated to the vCPUs.

By calling ioctl with KVM_GET_SLAVE_CPU, users can get the slave CPU id
for the vCPU. -1 is returned if a slave CPU is not set.

By calling ioctl with KVM_SET_SLAVE_CPU, users can dedicate the specified
slave CPU to the vCPU. The CPU must be offlined before calling ioctl.
The CPU is activated as slave CPU for the vCPU when the correct id is set.
The slave CPU is freed and offlined by setting -1 as slave CPU id.

Whether getting/setting slave CPUs are supported by KVM or not can be
known by checking KVM_CAP_SLAVE_CPU.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/vmx.c              |    7 +++++
 arch/x86/kvm/x86.c              |   58 +++++++++++++++++++++++++++++++++++++++
 include/linux/kvm.h             |    4 +++
 4 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8dc1a0a..0ea04c9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -718,6 +718,8 @@ struct kvm_x86_ops {
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage);
+
+	void (*set_slave_mode)(struct kvm_vcpu *vcpu, bool slave);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c5db714..7bbfa01 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1698,6 +1698,11 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	vmx_set_interrupt_shadow(vcpu, 0);
 }
 
+static void vmx_set_slave_mode(struct kvm_vcpu *vcpu, bool slave)
+{
+	/* Nothing */
+}
+
 /*
  * KVM wants to inject page-faults which it got to the guest. This function
  * checks whether in a nested guest, we need to inject them to L1 or L2.
@@ -7344,6 +7349,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_tdp_cr3 = vmx_set_cr3,
 
 	.check_intercept = vmx_check_intercept,
+
+	.set_slave_mode = vmx_set_slave_mode,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 579c41c..b62f59c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2183,6 +2183,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_PCI_2_3:
 	case KVM_CAP_KVMCLOCK_CTRL:
+#ifdef CONFIG_SLAVE_CPU
+	case KVM_CAP_SLAVE_CPU:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2657,6 +2660,48 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+#ifdef CONFIG_SLAVE_CPU
+/* vcpu currently running on each slave CPU */
+static DEFINE_PER_CPU(struct kvm_vcpu *, slave_vcpu);
+
+static int kvm_arch_vcpu_ioctl_set_slave_cpu(struct kvm_vcpu *vcpu,
+					     int slave, int set_slave_mode)
+{
+	int old = vcpu->arch.slave_cpu;
+	int r = -EINVAL;
+
+	if (slave >= nr_cpu_ids || (slave >= 0 && cpu_online(slave)))
+		goto out;
+	if (slave >= 0 && slave != old && cpu_slave(slave))
+		goto out; /* new slave cpu must be offlined */
+
+	if (old >= 0 && slave != old) {
+		BUG_ON(old >= nr_cpu_ids || !cpu_slave(old));
+		per_cpu(slave_vcpu, old) = NULL;
+		r = slave_cpu_down(old);
+		if (r) {
+			pr_err("kvm: slave_cpu_down %d failed\n", old);
+			goto out;
+		}
+	}
+
+	if (slave >= 0) {
+		r = slave_cpu_up(slave);
+		if (r)
+			goto out;
+		BUG_ON(!cpu_slave(slave));
+		per_cpu(slave_vcpu, slave) = vcpu;
+	}
+
+	vcpu->arch.slave_cpu = slave;
+	if (set_slave_mode && kvm_x86_ops->set_slave_mode)
+		kvm_x86_ops->set_slave_mode(vcpu, slave >= 0);
+out:
+	return r;
+}
+
+#endif
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -2937,6 +2982,16 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_set_guest_paused(vcpu);
 		goto out;
 	}
+#ifdef CONFIG_SLAVE_CPU
+	case KVM_SET_SLAVE_CPU: {
+		r = kvm_arch_vcpu_ioctl_set_slave_cpu(vcpu, (int)arg, 1);
+		goto out;
+	}
+	case KVM_GET_SLAVE_CPU: {
+		r = vcpu->arch.slave_cpu;
+		goto out;
+	}
+#endif
 	default:
 		r = -EINVAL;
 	}
@@ -6154,6 +6209,9 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	kvmclock_reset(vcpu);
+#ifdef CONFIG_SLAVE_CPU
+	kvm_arch_vcpu_ioctl_set_slave_cpu(vcpu, -1, 0);
+#endif
 
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	fx_free(vcpu);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2ce09aa..c2d1604 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -618,6 +618,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_GET_SMMU_INFO 78
 #define KVM_CAP_S390_COW 79
 #define KVM_CAP_PPC_ALLOC_HTAB 80
+#define KVM_CAP_SLAVE_CPU 81
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -904,6 +905,9 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
 /* VM is being stopped by host */
 #define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xad)
+/* Available with KVM_CAP_SLAVE_CPU */
+#define KVM_GET_SLAVE_CPU	  _IO(KVMIO,  0xae)
+#define KVM_SET_SLAVE_CPU	  _IO(KVMIO,  0xaf)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)


