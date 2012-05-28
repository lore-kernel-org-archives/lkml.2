Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2E1D4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:56:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51800 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903Ab2E1D24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:28:56 -0400
Message-Id: <20120528031203.152711779@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, Michael Ellerman <michael@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 002/117] KVM: Ensure all vcpus are consistent with in-kernel irqchip settings
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 3e515705a1f46beb1c942bb8043c16f8ac7b1e9e)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/ia64/kvm/kvm-ia64.c |    5 +++++
 arch/x86/kvm/x86.c       |    8 ++++++++
 include/linux/kvm_host.h |    7 +++++++
 virt/kvm/kvm_main.c      |    4 ++++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 43f4c92..7073185 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1169,6 +1169,11 @@ out:
 
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
index e04cae1..4fc5323 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3579,6 +3579,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -EEXIST;
 		if (kvm->arch.vpic)
 			goto create_irqchip_unlock;
+		r = -EINVAL;
+		if (atomic_read(&kvm->online_vcpus))
+			goto create_irqchip_unlock;
 		r = -ENOMEM;
 		vpic = kvm_create_pic(kvm);
 		if (vpic) {
@@ -6486,6 +6489,11 @@ void kvm_arch_check_processor_compat(void *rtn)
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
index 35410ef..6136821 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -744,6 +744,13 @@ static inline bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
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
index 9ffac2e..ec747dc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1667,6 +1667,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto vcpu_destroy;
 
 	mutex_lock(&kvm->lock);
+	if (!kvm_vcpu_compatible(vcpu)) {
+		r = -EINVAL;
+		goto unlock_vcpu_destroy;
+	}
 	if (atomic_read(&kvm->online_vcpus) == KVM_MAX_VCPUS) {
 		r = -EINVAL;
 		goto unlock_vcpu_destroy;


