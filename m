Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1JYT0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:26:30 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:57229 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752551Ab1JYT0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:26:23 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mingo@redhat.com, x86@kernel.org, hpa@zytor.com, mtosatti@redhat.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 3/6] Add ioctl for KVM_GUEST_STOPPED
Date: Tue, 25 Oct 2011 15:26:16 -0400
Message-Id: <1319570779-8907-4-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
References: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a flag that will tell the guest it was suspended, create an
interface for that communication using a KVM ioctl.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 arch/x86/include/asm/pvclock.h |    3 +++
 arch/x86/kernel/kvmclock.c     |   12 ++++++++++++
 arch/x86/kvm/x86.c             |    5 +++++
 include/linux/kvm.h            |    2 ++
 4 files changed, 22 insertions(+), 0 deletions(-)

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
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 8ddcfaf..f4fff3d 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -22,6 +22,7 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <linux/percpu.h>
+#include <linux/kvm_host.h>
 
 #include <asm/x86_init.h>
 #include <asm/reboot.h>
@@ -113,6 +114,17 @@ static void kvm_get_preset_lpj(void)
 	preset_lpj = lpj;
 }
 
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
 bool kvm_check_and_clear_host_stopped(int cpu)
 {
 	bool ret = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 84a28ea..16e029e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3264,6 +3264,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		goto out;
 	}
+	case KVM_PAUSE_GUEST: {
+		r = 0;
+		kvm_set_host_stopped(vcpu);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index aace6b8..a2697be 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -759,6 +759,8 @@ struct kvm_clock_data {
 #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
 /* Available with KVM_CAP_RMA */
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
+/* VM is being stopped by host */
+#define KVM_PAUSE_GUEST		  _IO(KVMIO,   0xaa)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
-- 
1.7.5.4

