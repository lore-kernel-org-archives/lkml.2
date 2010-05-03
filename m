Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab0ECPy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759570Ab0ECPxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:53:55 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH v2 6/7] don't compute pvclock adjustments if we trust the tsc
Date: Mon,  3 May 2010 11:52:06 -0400
Message-Id: <1272901927-829-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1272901927-829-6-git-send-email-glommer@redhat.com>
References: <1272901927-829-1-git-send-email-glommer@redhat.com>
 <1272901927-829-2-git-send-email-glommer@redhat.com>
 <1272901927-829-3-git-send-email-glommer@redhat.com>
 <1272901927-829-4-git-send-email-glommer@redhat.com>
 <1272901927-829-5-git-send-email-glommer@redhat.com>
 <1272901927-829-6-git-send-email-glommer@redhat.com>
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
index f019f8c..6f1b878 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -21,6 +21,11 @@
  */
 #define KVM_FEATURE_CLOCKSOURCE2        3
 
+/* The last 8 bits are used to indicate how to interpret the flags field
+ * in pvclock structure. If no bits are set, all flags are ignored.
+ */
+#define KVM_FEATURE_CLOCKSOURCE_STABLE_TSC	24
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
index 59c740f..518de01 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -215,4 +215,7 @@ void __init kvmclock_init(void)
 	clocksource_register(&kvm_clock);
 	pv_info.paravirt_enabled = 1;
 	pv_info.name = "KVM";
+
+	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_TSC))
+		pvclock_set_flags(PVCLOCK_STABLE_TSC);
 }
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 3dff5fa..0d4fe0c 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -135,6 +135,10 @@ cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 		barrier();
 	} while (version != src->version);
 
+	if ((valid_flags & PVCLOCK_STABLE_TSC) &&
+		(shadow.flags & PVCLOCK_STABLE_TSC))
+		return ret;
+
 	/*
 	 * Assumption here is that last_value, a global accumulator, always goes
 	 * forward. If we are less than that, we should not be much smaller.
-- 
1.6.2.2

