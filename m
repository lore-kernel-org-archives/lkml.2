Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526Ab1JaUI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 16:08:29 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:47651 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab1JaUHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 16:07:35 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mingo@redhat.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 6/6 V2] Add age out of guest paused flag
Date: Mon, 31 Oct 2011 16:07:30 -0400
Message-Id: <1320091650-24682-7-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
References: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KVM_GUEST_PAUSED flag will prevent a guest from compaining about a soft
lockup but it can mask real soft lockups if the flag isn't cleared when it is
no longer relevant.  This patch adds a kvm ioctl that the hypervisor will use
when it resumes a guest to start a timer for aging out the flag.  The time out
will be specified by the hypervisor in the ioctl call.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
Cahnges from V1:
 Add host functions for flag management to arch/x86/kvm/x86.c instead of
kvmclock.c

 arch/x86/include/asm/pvclock.h |    2 ++
 arch/x86/kvm/x86.c             |   32 ++++++++++++++++++++++++++++++++
 include/linux/kvm.h            |    2 ++
 include/linux/kvm_host.h       |    2 ++
 4 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index 9312814..e8460b9 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -18,6 +18,8 @@ void kvm_set_host_stopped(struct kvm_vcpu *vcpu);
 
 bool kvm_check_and_clear_host_stopped(int cpu);
 
+void kvm_clear_guest_paused(struct kvm_vcpu *vcpu, unsigned int length);
+
 /*
  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
  * yielding a 64-bit result.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 592ac3b..fb0132a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -46,6 +46,7 @@
 #include <linux/hash.h>
 #include <linux/pci.h>
 #include <trace/events/kvm.h>
+#include <linux/timer.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -3300,6 +3301,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		kvm_set_host_stopped(vcpu);
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
@@ -6133,6 +6143,28 @@ void kvm_set_host_stopped(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_set_host_stopped);
 
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

