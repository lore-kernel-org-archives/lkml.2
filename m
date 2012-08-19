Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab2HSDD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:03:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:44069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab2HSC5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415454"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 46/74] x86, lto: Disable fancy hweight optimizations for LTO
Date: Sat, 18 Aug 2012 19:56:42 -0700
Message-Id: <1345345030-22211-47-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The fancy x86 hweight uses different compiler options for the
hweight file. This does not work with LTO. Just disable the optimization
with LTO

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig                    |    5 +++--
 arch/x86/include/asm/arch_hweight.h |    9 +++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..9382b09 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -224,8 +224,9 @@ config X86_32_LAZY_GS
 
 config ARCH_HWEIGHT_CFLAGS
 	string
-	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
-	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
+	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32 && !LTO
+	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64 && !LTO
+	default "" if LTO
 
 config ARCH_CPU_PROBE_RELEASE
 	def_bool y
diff --git a/arch/x86/include/asm/arch_hweight.h b/arch/x86/include/asm/arch_hweight.h
index 9686c3d..ca80549 100644
--- a/arch/x86/include/asm/arch_hweight.h
+++ b/arch/x86/include/asm/arch_hweight.h
@@ -25,9 +25,14 @@ static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res = 0;
 
+#ifdef CONFIG_LTO
+	res  = __sw_hweight32(w);
+#else
+
 	asm (ALTERNATIVE("call __sw_hweight32", POPCNT32, X86_FEATURE_POPCNT)
 		     : "="REG_OUT (res)
 		     : REG_IN (w));
+#endif
 
 	return res;
 }
@@ -46,6 +51,9 @@ static inline unsigned long __arch_hweight64(__u64 w)
 {
 	unsigned long res = 0;
 
+#ifdef CONFIG_LTO
+	res = __sw_hweight64(w);
+#else
 #ifdef CONFIG_X86_32
 	return  __arch_hweight32((u32)w) +
 		__arch_hweight32((u32)(w >> 32));
@@ -54,6 +62,7 @@ static inline unsigned long __arch_hweight64(__u64 w)
 		     : "="REG_OUT (res)
 		     : REG_IN (w));
 #endif /* CONFIG_X86_32 */
+#endif
 
 	return res;
 }
-- 
1.7.7.6

