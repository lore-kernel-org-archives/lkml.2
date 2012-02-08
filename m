Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2BHPJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:09:17 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:56113 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab2BHPHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:07:50 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 V13] Add ioctl for KVM_KVMCLOCK_CTRL
Date: Wed,  8 Feb 2012 10:07:45 -0500
Message-Id: <1328713666-11424-4-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328713666-11424-1-git-send-email-emunson@mgebm.net>
References: <1328713666-11424-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a flag that will tell the guest it was suspended, create an
interface for that communication using a KVM ioctl.

Signed-off-by: Eric B Munson <emunson@mgebm.net>

Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from V12:
 Rename KVM_CAP and KVM ioctl
Changes from V11:
 Correct typo in api.txt
 Add kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu) call to kvm_set_guest_paused()
Changes from V10:
 Return the ioctl to per vcpu instead of per vm
Changes from V9:
 Use kvm_for_each_vcpu to iterate online vcpu's
Changes from V8:
 Make KVM_GUEST_PAUSED a per vm ioctl instead of per vcpu
Changes from V7:
 Define KVM_CAP_GUEST_PAUSED and support check
 Call mark_page_dirty () after setting PVCLOCK_GUEST_STOPPED
Changes from V4:
 Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
 Add new ioctl description to api.txt

 Documentation/virtual/kvm/api.txt |   13 +++++++++++++
 arch/x86/kvm/x86.c                |   22 ++++++++++++++++++++++
 include/linux/kvm.h               |    3 +++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 5b03eee..c6f3ac7 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1482,6 +1482,19 @@ following algorithm:
 Some guests configure the LINT1 NMI input to cause a panic, aiding in
 debugging.
 
+4.65 KVM_KVMCLOCK_CTRL
+
+Capability: KVM_CAP_KVMCLOCK_CTRL
+Architectures: Any that implement pvclocks (currently x86 only)
+Type: vcpu ioctl
+Parameters: None
+Returns: 0 on success, -1 on error
+
+This signals to the host kernel that the specified guest is being paused by
+userspace.  The host will set a flag in the pvclock structure that is checked
+from the soft lockup watchdog.  This ioctl can be called during pause or
+unpause.
+
 5. The kvm_run structure
 
 Application code obtains a pointer to the kvm_run structure by
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23c93fe..1895e4a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2050,6 +2050,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
 	case KVM_CAP_GET_TSC_KHZ:
+	case KVM_CAP_KVMCLOCK_CTRL:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2493,6 +2494,23 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+/*
+ * kvm_set_guest_paused() indicates to the guest kernel that it has been
+ * stopped by the hypervisor.  This function will be called from the host only.
+ * EINVAL is returned when the host attempts to set the flag for a guest that
+ * does not support pv clocks.
+ */
+static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
+{
+	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
+	if (!vcpu->arch.time_page)
+		return -EINVAL;
+	src->flags |= PVCLOCK_GUEST_STOPPED;
+	mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
+	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+	return 0;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -2782,6 +2800,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		goto out;
 	}
+	case KVM_KVMCLOCK_CTRL: {
+		r = kvm_set_guest_paused(vcpu);
+		goto out;
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c3892fc..27d5c46 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -557,6 +557,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_MAX_VCPUS 66       /* returns max vcpus per vm */
 #define KVM_CAP_PPC_PAPR 68
 #define KVM_CAP_S390_GMAP 71
+#define KVM_CAP_KVMCLOCK_CTRL 72
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -762,6 +763,8 @@ struct kvm_clock_data {
 #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
 /* Available with KVM_CAP_RMA */
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
+/* VM is being stopped by host */
+#define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xaa)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
-- 
1.7.5.4

