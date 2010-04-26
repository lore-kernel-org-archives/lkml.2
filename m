Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0DZRuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:50:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab0DZRun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:50:43 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH 6/6] don't compute pvclock adjustments if we trust the tsc
Date: Mon, 26 Apr 2010 13:46:28 -0400
Message-Id: <1272303988-21929-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1272303988-21929-6-git-send-email-glommer@redhat.com>
References: <1272303988-21929-1-git-send-email-glommer@redhat.com>
 <1272303988-21929-2-git-send-email-glommer@redhat.com>
 <1272303988-21929-3-git-send-email-glommer@redhat.com>
 <1272303988-21929-4-git-send-email-glommer@redhat.com>
 <1272303988-21929-5-git-send-email-glommer@redhat.com>
 <1272303988-21929-6-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the HV told us we can fully trust the TSC, skip any
correction

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/include/asm/kvm_para.h    |    5 +++++
 arch/x86/include/asm/pvclock-abi.h |    1 +
 arch/x86/kernel/kvmclock.c         |    3 +++
 arch/x86/kernel/pvclock.c          |    4 ++++
 4 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index f019f8c..615ebb1 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -21,6 +21,11 @@
  */
 #define KVM_FEATURE_CLOCKSOURCE2        3
 
+/* The last 8 bits are used to indicate how to interpret the flags field
+ * in pvclock structure. If no bits are set, all flags are ignored.
+ */
+#define KVM_FEATURE_CLOCKSOURCE_STABLE_TSC	0xf8
+
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
 
diff --git a/arch/x86/include/asm/pvclock-abi.h b/arch/x86/include/asm/pvclock-abi.h
index ec5c41a..b123bd7 100644
--- a/arch/x86/include/asm/pvclock-abi.h
+++ b/arch/x86/include/asm/pvclock-abi.h
@@ -39,5 +39,6 @@ struct pvclock_wall_clock {
 	u32   nsec;
 } __attribute__((__packed__));
 
+#define PVCLOCK_STABLE_TSC	(1 << 0)
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_PVCLOCK_ABI_H */
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index f2f6aee..aca2d3c 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -218,4 +218,7 @@ void __init kvmclock_init(void)
 	clocksource_register(&kvm_clock);
 	pv_info.paravirt_enabled = 1;
 	pv_info.name = "KVM";
+
+	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_TSC))
+		pvclock_valid_flags(PVCLOCK_STABLE_TSC);
 }
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 6cf6dec..43ae8d5 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -135,6 +135,10 @@ cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 		barrier();
 	} while (version != src->version);
 
+	if ((valid_flags & PVCLOCK_STABLE_TSC) &&
+		(shadow->flags & PVCLOCK_STABLE_TSC))
+		return ret;
+
 	/*
 	 * Assumption here is that last_value, a global accumulator, always goes
 	 * forward. If we are less than that, we should not be much smaller.
-- 
1.6.2.2

