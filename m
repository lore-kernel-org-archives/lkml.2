Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0HTIOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:14:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab0HTIIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:37 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 15/35] Move scale_delta into common header
Date: Thu, 19 Aug 2010 22:07:29 -1000
Message-Id: <1282291669-25709-16-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scale_delta function for shift / multiply with 31-bit
precision moves to a common header so it can be used by both
kernel and kvm module.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/pvclock.h |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pvclock.c      |    3 ++-
 2 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index cd02f32..7f7e577 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -12,4 +12,42 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
 
+/*
+ * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
+ * yielding a 64-bit result.
+ */
+static inline u64 pvclock_scale_delta(u64 delta, u32 mul_frac, int shift)
+{
+	u64 product;
+#ifdef __i386__
+	u32 tmp1, tmp2;
+#endif
+
+	if (shift < 0)
+		delta >>= -shift;
+	else
+		delta <<= shift;
+
+#ifdef __i386__
+	__asm__ (
+		"mul  %5       ; "
+		"mov  %4,%%eax ; "
+		"mov  %%edx,%4 ; "
+		"mul  %5       ; "
+		"xor  %5,%5    ; "
+		"add  %4,%%eax ; "
+		"adc  %5,%%edx ; "
+		: "=A" (product), "=r" (tmp1), "=r" (tmp2)
+		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
+#elif defined(__x86_64__)
+	__asm__ (
+		"mul %%rdx ; shrd $32,%%rdx,%%rax"
+		: "=a" (product) : "0" (delta), "d" ((u64)mul_frac) );
+#else
+#error implement me!
+#endif
+
+	return product;
+}
+
 #endif /* _ASM_X86_PVCLOCK_H */
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 239427c..bab3b9e 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -82,7 +82,8 @@ static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
 static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
 {
 	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
-	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
+	return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
+				   shadow->tsc_shift);
 }
 
 /*
-- 
1.7.1

