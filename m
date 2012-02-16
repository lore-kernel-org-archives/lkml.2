Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2BPUTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:19:14 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:46036 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab2BPUTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:19:12 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 V13] Add ioctl for KVM_KVMCLOCK_CTRL
Date: Thu, 16 Feb 2012 15:19:00 -0500
Message-Id: <1329423541-11677-4-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329423541-11677-1-git-send-email-emunson@mgebm.net>
References: <1329423541-11677-1-git-send-email-emunson@mgebm.net>
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
Changes from V13:
 Expand the ioctl documentation
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

 Documentation/virtual/kvm/api.txt |   21 +++++++++++++++++++++
 arch/x86/kvm/x86.c                |   22 ++++++++++++++++++++++
 include/linux/kvm.h               |    3 +++
 3 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 59a3826..d868e80 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1628,6 +1628,27 @@ at the memory location pointed to by "addr".
 The list of registers accessible using this interface is identical to the
 list in 4.64.
 
+4.70 KVM_KVMCLOCK_CTRL
+
+Capability: KVM_CAP_KVMCLOCK_CTRL
+Architectures: Any that implement pvclocks (currently x86 only)
+Type: vcpu ioctl
+Parameters: None
+Returns: 0 on success, -1 on error
+
+This signals to the host kernel that the specified guest is being paused by
+userspace.  The host will set a flag in the pvclock structure that is checked
+from the soft lockup watchdog.  The flag is part of the pvclock structure that
+is shared between guest and host, specifically the second bit of the flags
+field of the pvclock_vcpu_time_info structure.  It will be set exclusively by
+the host and read/cleared exclusively by the guest.  The guest operation of
+checking and clearing the flag must an atomic operation so use of the function
+check_and_clear_guest_paused() is encouraged, but it could also be done with
+load-link/store-conditional.  There are two cases where the guest will clear
+the flag: when the soft lockup watchdog timer resets itself or when a soft
+lockup is detected.  This ioctl can be called any time after pausing
+the vcpu, but before it is resumed.
+
 5. The kvm_run structure
 
 Application code obtains a pointer to the kvm_run structure by
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9d99e5..7ba8213 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2143,6 +2143,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
 	case KVM_CAP_GET_TSC_KHZ:
+	case KVM_CAP_KVMCLOCK_CTRL:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2593,6 +2594,23 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
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
@@ -2869,6 +2887,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = vcpu->arch.virtual_tsc_khz;
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
index acbe429..a90db11 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -588,6 +588,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_TSC_DEADLINE_TIMER 72
 #define KVM_CAP_S390_UCONTROL 73
 #define KVM_CAP_SYNC_REGS 74
+#define KVM_CAP_KVMCLOCK_CTRL 75
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -855,6 +856,8 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_ONE_REG */
 #define KVM_GET_ONE_REG		  _IOW(KVMIO,  0xab, struct kvm_one_reg)
 #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
+/* VM is being stopped by host */
+#define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xad)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
-- 
1.7.5.4

