Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab1KDQ4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:56:04 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:35659 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932814Ab1KDQzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:55:18 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6 V3] Add age out of guest paused flag
Date: Fri,  4 Nov 2011 12:55:12 -0400
Message-Id: <1320425712-5312-7-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320425712-5312-1-git-send-email-emunson@mgebm.net>
References: <1320425712-5312-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KVM_GUEST_PAUSED flag will prevent a guest from compaining about a soft
lockup but it can mask real soft lockups if the flag isn't cleared when it is
no longer relevant.  This patch adds a kvm ioctl that the hypervisor will use
when it resumes a guest to start a timer for aging out the flag.  The time out
will be specified by the hypervisor in the ioctl call.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: arnd@arndb.de
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: jeremy.fitzhardinge@citrix.com
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from V2:
 Move function definition to kvm_host.h

 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   32 ++++++++++++++++++++++++++++++++
 include/linux/kvm.h             |    2 ++
 include/linux/kvm_host.h        |    2 ++
 4 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index beb94c6..5cec925 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -673,6 +673,7 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int kvm_set_guest_paused(struct kvm_vcpu *vcpu);
+void kvm_clear_guest_paused(struct kvm_vcpu *vcpu, unsigned int length);
 
 extern bool tdp_enabled;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0127617..ca2187b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -46,6 +46,7 @@
 #include <linux/hash.h>
 #include <linux/pci.h>
 #include <trace/events/kvm.h>
+#include <linux/timer.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -3299,6 +3300,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_set_guest_paused(vcpu);
 		break;
 	}
+	case KVM_CLEAR_GUEST_PAUSED: {
+		unsigned int length;
+		r = -EFAULT;
+		if (copy_from_user(&length, argp, sizeof length))
+			goto out;
+		r = 0;
+		kvm_clear_guest_paused(vcpu, length);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -6137,6 +6147,28 @@ int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_set_guest_paused);
 
+static void kvm_timer_clear_guest_paused(unsigned long vcpu_addr)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)vcpu_addr;
+	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
+	src->flags = src->flags & (~PVCLOCK_GUEST_STOPPED);
+}
+
+/*
+ * Host has resumed the guest, we need to clear the guest paused flag so we
+ * don't mask any real soft lockups.
+ */
+void kvm_clear_guest_paused(struct kvm_vcpu *vcpu, unsigned int length)
+{
+	if (!timer_pending(&vcpu->flag_timer))
+		setup_timer(&vcpu->flag_timer,
+			    kvm_timer_clear_guest_paused,
+			    (unsigned long)vcpu);
+	mod_timer(&vcpu->flag_timer,
+		  jiffies + (length * HZ));
+}
+EXPORT_SYMBOL_GPL(kvm_clear_guest_paused);
+
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 87cab0d..bd9724c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -765,6 +765,8 @@ struct kvm_clock_data {
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
 /* VM is being stopped by host */
 #define KVM_GUEST_PAUSED	  _IO(KVMIO,   0xaa)
+/* Start the timer to clear the paused flag */
+#define KVM_CLEAR_GUEST_PAUSED	  _IO(KVMIO,   0xab)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d526231..043af4d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 #include <linux/ratelimit.h>
+#include <linux/timer.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -154,6 +155,7 @@ struct kvm_vcpu {
 #endif
 
 	struct kvm_vcpu_arch arch;
+	struct timer_list flag_timer;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
-- 
1.7.5.4

