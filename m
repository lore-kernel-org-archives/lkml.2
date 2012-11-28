Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2K1Tvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:51:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38784 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab2K1Tu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:50:57 -0500
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of no CPUID
Date: Wed, 28 Nov 2012 11:50:30 -0800
Message-Id: <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Simplify the implementation of sync_core() for the case where we may
not have the CPUID instruction available.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 9a4ee46..b381df7 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -673,17 +673,24 @@ static inline void sync_core(void)
 	int tmp;
 
 #ifdef CONFIG_M486
-	if (boot_cpu_data.x86 < 5)
-		/* There is no speculative execution.
-		 * jmp is a barrier to prefetching. */
-		asm volatile("jmp 1f\n1:\n" ::: "memory");
-	else
+	/*
+	 * Do a CPUID if available, otherwise do a jump.  The jump
+	 * can conveniently enough be the jump around CPUID.
+	 */
+	asm volatile("cmpl %2,%1\n\t"
+		     "jl 1f\n\t"
+		     "cpuid\n"
+		     "1:"
+		     : "=a" (tmp)
+		     : "rm" (boot_cpu_data.cpuid_level), "ri" (0), "0" (1)
+		     : "ebx", "ecx", "edx", "memory");
+#else
+	/* cpuid is a barrier to speculative execution.
+	 * Prefetched instructions are automatically
+	 * invalidated when modified. */
+	asm volatile("cpuid" : "=a" (tmp) : "0" (1)
+		     : "ebx", "ecx", "edx", "memory");
 #endif
-		/* cpuid is a barrier to speculative execution.
-		 * Prefetched instructions are automatically
-		 * invalidated when modified. */
-		asm volatile("cpuid" : "=a" (tmp) : "0" (1)
-			     : "ebx", "ecx", "edx", "memory");
 }
 
 static inline void __monitor(const void *eax, unsigned long ecx,
-- 
1.7.11.7

