Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2AaPfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:35:50 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:52520 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab2AaPfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:35:39 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4 V11] Add functions to check if the host has stopped the vm
Date: Tue, 31 Jan 2012 10:35:30 -0500
Message-Id: <1328024132-7687-3-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328024132-7687-1-git-send-email-emunson@mgebm.net>
References: <1328024132-7687-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a host stops or suspends a VM it will set a flag to show this.  The
watchdog will use these functions to determine if a softlockup is real, or the
result of a suspended VM.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
asm-generic changes Acked-by: Arnd Bergmann <arnd@arndb.de>
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
Changes from V6:
 Use __this_cpu_and when clearing the PVCLOCK_GUEST_STOPPED flag
Changes from V5:
 Collapse generic stubs into this patch
 check_and_clear_guest_stopped() takes no args and uses __get_cpu_var()
 Include individual definitions in ia64, s390, and powerpc

 arch/ia64/include/asm/kvm_para.h    |    5 +++++
 arch/powerpc/include/asm/kvm_para.h |    5 +++++
 arch/s390/include/asm/kvm_para.h    |    5 +++++
 arch/x86/include/asm/kvm_para.h     |    8 ++++++++
 arch/x86/kernel/kvmclock.c          |   21 +++++++++++++++++++++
 5 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_para.h b/arch/ia64/include/asm/kvm_para.h
index 1588aee..2019cb9 100644
--- a/arch/ia64/include/asm/kvm_para.h
+++ b/arch/ia64/include/asm/kvm_para.h
@@ -26,6 +26,11 @@ static inline unsigned int kvm_arch_para_features(void)
 	return 0;
 }
 
+static inline bool kvm_check_and_clear_guest_paused(void)
+{
+	return false;
+}
+
 #endif
 
 #endif
diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
index 50533f9..1f80293 100644
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@ -169,6 +169,11 @@ static inline unsigned int kvm_arch_para_features(void)
 	return r;
 }
 
+static inline bool kvm_check_and_clear_guest_paused(void)
+{
+	return false;
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* __POWERPC_KVM_PARA_H__ */
diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/kvm_para.h
index 6964db2..a988329 100644
--- a/arch/s390/include/asm/kvm_para.h
+++ b/arch/s390/include/asm/kvm_para.h
@@ -149,6 +149,11 @@ static inline unsigned int kvm_arch_para_features(void)
 	return 0;
 }
 
+static inline bool kvm_check_and_clear_guest_paused(void)
+{
+	return false;
+}
+
 #endif
 
 #endif /* __S390_KVM_PARA_H */
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 734c376..99c4bbe 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -95,6 +95,14 @@ struct kvm_vcpu_pv_apf_data {
 extern void kvmclock_init(void);
 extern int kvm_register_clock(char *txt);
 
+#ifdef CONFIG_KVM_CLOCK
+bool kvm_check_and_clear_guest_paused(void);
+#else
+static inline bool kvm_check_and_clear_guest_paused(void)
+{
+	return false;
+}
+#endif /* CONFIG_KVMCLOCK */
 
 /* This instruction is vmcall.  On non-VT architectures, it will generate a
  * trap that we will then rewrite to the appropriate instruction.
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 44842d7..bdf6423 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -22,6 +22,7 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <linux/percpu.h>
+#include <linux/hardirq.h>
 
 #include <asm/x86_init.h>
 #include <asm/reboot.h>
@@ -114,6 +115,26 @@ static void kvm_get_preset_lpj(void)
 	preset_lpj = lpj;
 }
 
+bool kvm_check_and_clear_guest_paused(void)
+{
+	bool ret = false;
+	struct pvclock_vcpu_time_info *src;
+
+	/*
+	 * per_cpu() is safe here because this function is only called from
+	 * timer functions where preemption is already disabled.
+	 */
+	WARN_ON(!in_atomic());
+	src = &__get_cpu_var(hv_clock);
+	if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
+		__this_cpu_and(hv_clock.flags, ~PVCLOCK_GUEST_STOPPED);
+		ret = true;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_check_and_clear_guest_paused);
+
 static struct clocksource kvm_clock = {
 	.name = "kvm-clock",
 	.read = kvm_clock_get_cycles,
-- 
1.7.5.4

