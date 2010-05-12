Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0ELBG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:06:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:46986 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab0ELBGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:06:55 -0400
Date: Wed, 12 May 2010 01:06:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
In-Reply-To: <1273135546-29690-2-git-send-email-avi@redhat.com>
References: <1273135546-29690-2-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: Add new static_cpu_has() function using alternatives
Message-ID: <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>
Git-Commit-ID: a3c8acd04376d604370dcb6cd2143c9c14078a50
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 May 2010 01:06:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3c8acd04376d604370dcb6cd2143c9c14078a50
Gitweb:     http://git.kernel.org/tip/a3c8acd04376d604370dcb6cd2143c9c14078a50
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 11 May 2010 17:47:07 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 11 May 2010 17:47:07 -0700

x86: Add new static_cpu_has() function using alternatives

For CPU-feature-specific code that touches performance-critical paths,
introduce a static patching version of [boot_]cpu_has().  This is run
at alternatives time and is therefore not appropriate for most
initialization code, but on the other hand initialization code is
generally not performance critical.

On gcc 4.5+ this uses the new "asm goto" feature.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1273135546-29690-2-git-send-email-avi@redhat.com>
---
 arch/x86/include/asm/cpufeature.h |   57 +++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0cd82d0..9b11a5c 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -175,6 +175,7 @@
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
+#include <asm/asm.h>
 #include <linux/bitops.h>
 
 extern const char * const x86_cap_flags[NCAPINTS*32];
@@ -283,6 +284,62 @@ extern const char * const x86_power_flags[32];
 
 #endif /* CONFIG_X86_64 */
 
+/*
+ * Static testing of CPU features.  Used the same as boot_cpu_has().
+ * These are only valid after alternatives have run, but will statically
+ * patch the target code for additional performance.
+ *
+ */
+static __always_inline __pure bool __static_cpu_has(u8 bit)
+{
+#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
+		asm goto("1: jmp %l[t_no]\n"
+			 "2:\n"
+			 ".section .altinstructions,\"a\"\n"
+			 _ASM_ALIGN "\n"
+			 _ASM_PTR "1b\n"
+			 _ASM_PTR "0\n" 	/* no replacement */
+			 " .byte %P0\n"		/* feature bit */
+			 " .byte 2b - 1b\n"	/* source len */
+			 " .byte 0\n"		/* replacement len */
+			 " .byte 0xff + 0 - (2b-1b)\n"	/* padding */
+			 ".previous\n"
+			 : : "i" (bit) : : t_no);
+		return true;
+	t_no:
+		return false;
+#else
+		u8 flag;
+		/* Open-coded due to __stringify() in ALTERNATIVE() */
+		asm volatile("1: movb $0,%0\n"
+			     "2:\n"
+			     ".section .altinstructions,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b\n"
+			     _ASM_PTR "3f\n"
+			     " .byte %P1\n"		/* feature bit */
+			     " .byte 2b - 1b\n"		/* source len */
+			     " .byte 4f - 3f\n"		/* replacement len */
+			     " .byte 0xff + (4f-3f) - (2b-1b)\n" /* padding */
+			     ".previous\n"
+			     ".section .altinstr_replacement,\"ax\"\n"
+			     "3: movb $1,%0\n"
+			     "4:\n"
+			     ".previous\n"
+			     : "=qm" (flag) : "i" (bit));
+		return flag;
+#endif
+}
+
+#define static_cpu_has(bit)					\
+(								\
+	__builtin_constant_p(boot_cpu_has(bit)) ?		\
+		boot_cpu_has(bit) :				\
+	(__builtin_constant_p(bit) && !((bit) & ~0xff)) ?	\
+		__static_cpu_has(bit) :				\
+		boot_cpu_has(bit)				\
+)
+
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 
 #endif /* _ASM_X86_CPUFEATURE_H */
