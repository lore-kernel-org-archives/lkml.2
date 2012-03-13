Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140Ab2CMAe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:34:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:48738 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965104Ab2CMAYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 168/196] x86: pvclock: Move scale_delta into common header
Date: Mon, 12 Mar 2012 20:21:21 -0400
Message-Id: <1331598109-31424-123-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Amsden <zamsden@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 347bb4448c2155eb2310923ccaa4be5677649003 upstream.

The scale_delta function for shift / multiply with 31-bit
precision moves to a common header so it can be used by both
kernel and kvm module.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/pvclock.h |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pvclock.c      |    3 ++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index daaacab..982aa32 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -12,4 +12,42 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct timespec *ts);
 void pvclock_resume(void);
 
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
index b12fe8d..929047c 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -74,7 +74,8 @@ static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
 static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
 {
 	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
-	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
+	return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
+				   shadow->tsc_shift);
 }
 
 /*
-- 
1.7.9.3

