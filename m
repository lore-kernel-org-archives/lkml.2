Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356Ab2JAXkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:40:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34975 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458Ab2JAW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:32 -0400
Message-Id: <20121001225159.521191640@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Ellerman <michael@ellerman.id.au>, Avi Kivity <avi@redhat.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 045/180] KVM: Ensure all vcpus are consistent with in-kernel irqchip settings
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

commit 3e515705a1f46beb1c942bb8043c16f8ac7b1e9e upstream

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
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/ia64/kvm/kvm-ia64.c |    5 +++++
 arch/x86/kvm/x86.c       |    8 ++++++++
 include/linux/kvm_host.h |    7 +++++++
 virt/kvm/kvm_main.c      |    4 ++++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 2eb6365..416122b 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1185,6 +1185,11 @@ out:
 
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
index 5908461..271fddf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2280,6 +2280,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -EEXIST;
 		if (kvm->arch.vpic)
 			goto create_irqchip_unlock;
+		r = -EINVAL;
+		if (atomic_read(&kvm->online_vcpus))
+			goto create_irqchip_unlock;
 		r = -ENOMEM;
 		vpic = kvm_create_pic(kvm);
 		if (vpic) {
@@ -5027,6 +5030,11 @@ void kvm_arch_check_processor_compat(void *rtn)
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
index c728a50..8bfed57 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -556,5 +556,12 @@ static inline bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
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
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 311ec18..82b6fdc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1857,6 +1857,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		return r;
 
 	mutex_lock(&kvm->lock);
+	if (!kvm_vcpu_compatible(vcpu)) {
+		r = -EINVAL;
+		goto vcpu_destroy;
+	}
 	if (atomic_read(&kvm->online_vcpus) == KVM_MAX_VCPUS) {
 		r = -EINVAL;
 		goto vcpu_destroy;
-- 
1.7.2.1.45.g54fbc



