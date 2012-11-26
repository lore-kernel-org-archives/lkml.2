Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2KZUhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:37:34 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45885 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab2KZUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:37:30 -0500
Subject: [PATCH 5/5] Add an ioctl to communicate the consign limit to the
 host.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: riel@redhat.com, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, glommer@parallels.com, mingo@redhat.com
Date: Mon, 26 Nov 2012 14:37:17 -0600
Message-ID: <20121126203717.28840.77239.stgit@lambeau>
In-Reply-To: <20121126203603.28840.38736.stgit@lambeau>
References: <20121126203603.28840.38736.stgit@lambeau>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12112620-5564-0000-0000-00000584AB87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an ioctl to communicate the consign limit to the host.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |    6 ++++++
 include/linux/kvm_host.h |    2 ++
 include/uapi/linux/kvm.h |    2 ++
 virt/kvm/kvm_main.c      |    7 +++++++
 4 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c91f4c9..5d57469 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5938,6 +5938,12 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+int kvm_arch_vcpu_ioctl_set_entitlement(struct kvm_vcpu *vcpu, long entitlement)
+{
+	vcpu->arch.consigned_limit = entitlement;
+	return 0;
+}
+
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct i387_fxsave_struct *fxsave =
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0e2212f..de13648 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -590,6 +590,8 @@ void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_ioctl_set_entitlement(struct kvm_vcpu *vcpu,
+					long entitlement);
 
 void kvm_free_physmem(struct kvm *kvm);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0a6d6ba..86f24bb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -921,6 +921,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
 /* VM is being stopped by host */
 #define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xad)
+/* Set the consignment limit which will be used to separete steal time */
+#define KVM_SET_ENTITLEMENT	  _IOW(KVMIO, 0xae, unsigned long)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be70035..c712fe5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2062,6 +2062,13 @@ out_free2:
 		r = 0;
 		break;
 	}
+	case KVM_SET_ENTITLEMENT: {
+		r = kvm_arch_vcpu_ioctl_set_entitlement(vcpu, arg);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}

