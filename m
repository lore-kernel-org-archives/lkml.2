Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab2JQCZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:25:12 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47803 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab2JQCZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:25:07 -0400
Subject: [PATCH RFC V2 5/5] Add an ioctl to communicate the consign limit to
 the host.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com,
        anthony@codemonkey.ws
Date: Tue, 16 Oct 2012 21:24:50 -0500
Message-ID: <20121017022449.16949.20925.stgit@lambeau>
In-Reply-To: <20121017022249.16949.2775.stgit@lambeau>
References: <20121017022249.16949.2775.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101702-5490-0000-0000-0000024C68B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an ioctl to communicate the consign limit to the host.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |    6 ++++++
 include/linux/kvm.h      |    2 ++
 include/linux/kvm_host.h |    2 ++
 virt/kvm/kvm_main.c      |    7 +++++++
 4 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 469e748..5a4b8db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5928,6 +5928,12 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
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
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2ce09aa..6b211fb 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -904,6 +904,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
 /* VM is being stopped by host */
 #define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xad)
+/* Set the consignment limit which will be used to separete steal time */
+#define KVM_SET_ENTITLEMENT	  _IOW(KVMIO, 0xae, unsigned long)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8a59e0a..9a0a791 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -538,6 +538,8 @@ void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_ioctl_set_entitlement(struct kvm_vcpu *vcpu,
+					long entitlement);
 
 void kvm_free_physmem(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d617f69..ccf0aec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1936,6 +1936,13 @@ out_free2:
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

