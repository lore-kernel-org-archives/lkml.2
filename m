Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2HOTtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:36394 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2HOTtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Avi Kivity <avi@redhat.com>, Michael Ellerman <michael@ellerman.id.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 016/165] KVM: Ensure all vcpus are consistent with in-kernel irqchip settings
Date: Wed, 15 Aug 2012 15:46:00 -0400
Message-ID: <1345060109-9187-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3e515705a1f46beb1c942bb8043c16f8ac7b1e9e upstream.

If some vcpus are created before KVM_CREATE_IRQCHIP, then
irqchip_in_kernel() and vcpu->arch.apic will be inconsistent, leading
to potential NULL pointer dereferences.

Fix by:
- ensuring that no vcpus are installed when KVM_CREATE_IRQCHIP is called
- ensuring that a vcpu has an apic if it is installed after KVM_CREATE_IRQCHIP

This is somewhat long winded because vcpu->arch.apic is created without
kvm->lock held.

Based on earlier patch by Michael Ellerman.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/ia64/kvm/kvm-ia64.c | 5 +++++
 arch/x86/kvm/x86.c       | 8 ++++++++
 include/linux/kvm_host.h | 7 +++++++
 virt/kvm/kvm_main.c      | 4 ++++
 4 files changed, 24 insertions(+)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 7f3c0a2..2b7adad 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1179,6 +1179,11 @@ out:
 
 #define PALE_RESET_ENTRY    0x80000000ffffffb0UL
 
+bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu)
+{
+	return irqchip_in_kernel(vcpu->kcm) == (vcpu->arch.apic != NULL);
+}
+
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu *v;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ced130..c1e586d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2764,6 +2764,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -EEXIST;
 		if (kvm->arch.vpic)
 			goto create_irqchip_unlock;
+		r = -EINVAL;
+		if (atomic_read(&kvm->online_vcpus))
+			goto create_irqchip_unlock;
 		r = -ENOMEM;
 		vpic = kvm_create_pic(kvm);
 		if (vpic) {
@@ -5586,6 +5589,11 @@ void kvm_arch_check_processor_compat(void *rtn)
 	kvm_x86_ops->check_processor_compatibility(rtn);
 }
 
+bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu)
+{
+	return irqchip_in_kernel(vcpu->kvm) == (vcpu->arch.apic != NULL);
+}
+
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 169d077..94cb72c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -599,6 +599,13 @@ static inline bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->bsp_vcpu_id == vcpu->vcpu_id;
 }
+
+bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu);
+
+#else
+
+static inline bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu) { return true; }
+
 #endif
 
 #ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c82ae24..559af38 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1322,6 +1322,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		return r;
 
 	mutex_lock(&kvm->lock);
+	if (!kvm_vcpu_compatible(vcpu)) {
+		r = -EINVAL;
+		goto unlock_vcpu_destroy;
+	}
 	if (atomic_read(&kvm->online_vcpus) == KVM_MAX_VCPUS) {
 		r = -EINVAL;
 		goto vcpu_destroy;
-- 
1.7.12.rc2

