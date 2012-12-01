Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab2LAAm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:42:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2LAAm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:42:27 -0500
Date: Fri, 30 Nov 2012 16:41:56 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-45c39fb0cc20d24da08d5bb159f57d191098104d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@alien8.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@alien8.de
In-Reply-To: <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/nuke386] x86, cleanups: Simplify sync_core()
  in the case of no CPUID
Git-Commit-ID: 45c39fb0cc20d24da08d5bb159f57d191098104d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:42:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45c39fb0cc20d24da08d5bb159f57d191098104d
Gitweb:     http://git.kernel.org/tip/45c39fb0cc20d24da08d5bb159f57d191098104d
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Nov 2012 11:50:30 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Nov 2012 13:25:39 -0800

x86, cleanups: Simplify sync_core() in the case of no CPUID

Simplify the implementation of sync_core() for the case where we may
not have the CPUID instruction available.

[ v2: stylistic cleanup of the #else clause per suggestion by Borislav
  Petkov. ]

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1354132230-21854-9-git-send-email-hpa@linux.intel.com
Cc: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/processor.h | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 9a4ee46..b0d3e73 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -673,17 +673,28 @@ static inline void sync_core(void)
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
+	/*
+	 * CPUID is a barrier to speculative execution.
+	 * Prefetched instructions are automatically
+	 * invalidated when modified.
+	 */
+	asm volatile("cpuid"
+		     : "=a" (tmp)
+		     : "0" (1)
+		     : "ebx", "ecx", "edx", "memory");
 #endif
-		/* cpuid is a barrier to speculative execution.
-		 * Prefetched instructions are automatically
-		 * invalidated when modified. */
-		asm volatile("cpuid" : "=a" (tmp) : "0" (1)
-			     : "ebx", "ecx", "edx", "memory");
 }
 
 static inline void __monitor(const void *eax, unsigned long ecx,
