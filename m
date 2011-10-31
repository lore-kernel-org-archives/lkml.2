Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518Ab1JaUHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 16:07:40 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:47636 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1JaUHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 16:07:33 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mingo@redhat.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 3/6 V2] Add ioctl for KVM_GUEST_STOPPED
Date: Mon, 31 Oct 2011 16:07:27 -0400
Message-Id: <1320091650-24682-4-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
References: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a flag that will tell the guest it was suspended, create an
interface for that communication using a KVM ioctl.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
Changes from V1:
 Add kvm_set_host_stopped to arch/x86/jvm/x86.c instead of kvmclock.c
 Rename KVM_PAUSE_GUEST to KVM_GUEST_PAUSED

 arch/x86/include/asm/pvclock.h |    3 +++
 arch/x86/kvm/x86.c             |   16 ++++++++++++++++
 include/linux/kvm.h            |    2 ++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index 7d3ba41..9312814 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -3,6 +3,7 @@
 
 #include <linux/clocksource.h>
 #include <asm/pvclock-abi.h>
+#include <linux/kvm_host.h>
 
 /* some helper functions for xen and kvm pv clock sources */
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
@@ -13,6 +14,8 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct timespec *ts);
 void pvclock_resume(void);
 
+void kvm_set_host_stopped(struct kvm_vcpu *vcpu);
+
 bool kvm_check_and_clear_host_stopped(int cpu);
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c38efd7..592ac3b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3295,6 +3295,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		goto out;
 	}
+	case KVM_GUEST_PAUSED: {
+		r = 0;
+		kvm_set_host_stopped(vcpu);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -6117,6 +6122,17 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason,
 }
 EXPORT_SYMBOL_GPL(kvm_task_switch);
 
+/*
+ * kvm_set_host_stopped() indicates to the guest kernel that it has been
+ * stopped by the hypervisor.  This function will be called from the host only.
+ */
+void kvm_set_host_stopped(struct kvm_vcpu *vcpu)
+{
+	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
+	src->flags |= PVCLOCK_GUEST_STOPPED;
+}
+EXPORT_SYMBOL_GPL(kvm_set_host_stopped);
+
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f47fcd3..87cab0d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -763,6 +763,8 @@ struct kvm_clock_data {
 #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
 /* Available with KVM_CAP_RMA */
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
+/* VM is being stopped by host */
+#define KVM_GUEST_PAUSED	  _IO(KVMIO,   0xaa)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
-- 
1.7.5.4

