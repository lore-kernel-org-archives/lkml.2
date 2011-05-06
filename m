Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab1EFA0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:26:22 -0400
Received: from kroah.org ([198.145.64.141]:37423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab1EFA0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:19 2011
Message-Id: <20110506002219.104537530@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:22:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [141/143] x86: pvclock: Move scale_delta into common header
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Zachary Amsden <zamsden@redhat.com>

(cherry-picked from commit 347bb4448c2155eb2310923ccaa4be5677649003)

The scale_delta function for shift / multiply with 31-bit
precision moves to a common header so it can be used by both
kernel and kvm module.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

BugLink: http://bugs.launchpad.net/bugs/714335

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/pvclock.h |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pvclock.c      |    3 ++-
 2 files changed, 40 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -12,4 +12,42 @@ void pvclock_read_wallclock(struct pvclo
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
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -74,7 +74,8 @@ static inline u64 scale_delta(u64 delta,
 static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
 {
 	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
-	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
+	return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
+				   shadow->tsc_shift);
 }
 
 /*


