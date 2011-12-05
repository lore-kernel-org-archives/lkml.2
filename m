Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1LEUUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:20:43 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:34685 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501Ab1LEUTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:19:09 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5 V5] Add ioctl for KVMCLOCK_GUEST_STOPPED
Date: Mon,  5 Dec 2011 15:19:02 -0500
Message-Id: <1323116344-17911-4-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a flag that will tell the guest it was suspended, create an
interface for that communication using a KVM ioctl.

Signed-off-by: Eric B Munson <emunson@mgebm.net>

Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: arnd@arndb.de
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: jeremy.fitzhardinge@citrix.com
Cc: levinsasha928@gmail.com
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from V4:
 Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
 Add new ioctl description to api.txt

 Documentation/virtual/kvm/api.txt |   12 ++++++++++++
 arch/x86/include/asm/kvm_host.h   |    2 ++
 arch/x86/kvm/x86.c                |   20 ++++++++++++++++++++
 include/linux/kvm.h               |    2 ++
 4 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 7945b0b..0f7dd99 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1450,6 +1450,18 @@ is supported; 2 if the processor requires all virtual machines to have
 an RMA, or 1 if the processor can use an RMA but doesn't require it,
 because it supports the Virtual RMA (VRMA) facility.
 
+4.64 KVMCLOCK_GUEST_PAUSED
+
+Capability: basic
+Architechtures: Any that implement pvclocks (currently x86 only)
+Type: vcpu ioctl
+Parameters: None
+Returns: 0 on success, -1 on error
+
+This signals to the host kernel that the specified guest is being paused by
+userspace.  The host will set a flag in the pvclock structure that is checked
+from the soft lockup watchdog.
+
 5. The kvm_run structure
 
 Application code obtains a pointer to the kvm_run structure by
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4973f4..beb94c6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -672,6 +672,8 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 		  gpa_t addr, unsigned long *ret);
 u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
 
+int kvm_set_guest_paused(struct kvm_vcpu *vcpu);
+
 extern bool tdp_enabled;
 
 u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c38efd7..1dab5fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3295,6 +3295,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		goto out;
 	}
+	case KVMCLOCK_GUEST_PAUSED: {
+		r = kvm_set_guest_paused(vcpu);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -6117,6 +6121,22 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason,
 }
 EXPORT_SYMBOL_GPL(kvm_task_switch);
 
+/*
+ * kvm_set_guest_paused() indicates to the guest kernel that it has been
+ * stopped by the hypervisor.  This function will be called from the host only.
+ * EINVAL is returned when the host attempts to set the flag for a guest that
+ * does not support pv clocks.
+ */
+int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
+{
+	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
+	if (!vcpu->arch.time_page)
+		return -EINVAL;
+	src->flags |= PVCLOCK_GUEST_STOPPED;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_set_guest_paused);
+
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c3892fc..1d1ddef 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -762,6 +762,8 @@ struct kvm_clock_data {
 #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
 /* Available with KVM_CAP_RMA */
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
+/* VM is being stopped by host */
+#define KVMCLOCK_GUEST_PAUSED	  _IO(KVMIO,   0xaa)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
-- 
1.7.5.4

