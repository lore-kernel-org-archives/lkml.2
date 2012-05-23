Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962Ab2EWVo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:44:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51227 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2EWVoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:44:24 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Subject: [PATCH 02/15] math128, x86_64: Implement {mul,add}_u128 in 64bit asm
Date: Wed, 23 May 2012 23:42:42 +0200
Message-Id: <1337809375-24295-3-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Enable __int128 usage when available, if not, provide asm versions of
mul_u64_u64 and add_u128.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-67zk6v8agsi8m7k1bdcd0srw@git.kernel.org
---
 arch/x86/include/asm/Kbuild    |    1 -
 arch/x86/include/asm/math128.h |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/math128.h

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 86441b9..f9c0d3b 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -26,4 +26,3 @@ header-y += vsyscall.h
 genhdr-y += unistd_32.h
 genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
-generic-y += math128.h
diff --git a/arch/x86/include/asm/math128.h b/arch/x86/include/asm/math128.h
new file mode 100644
index 0000000..c0e2a6c
--- /dev/null
+++ b/arch/x86/include/asm/math128.h
@@ -0,0 +1,39 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#ifdef CONFIG_X86_64
+
+#ifdef __SIZEOF_INT128__
+#define ARCH_HAS_INT128
+#endif
+
+#ifndef ARCH_HAS_INT128
+
+static inline u128 mul_u64_u64(u64 a, u64 b)
+{
+       u128 res;
+
+       asm("mulq %2"
+               : "=a" (res.lo), "=d" (res.hi)
+               :  "rm" (b), "0" (a));
+
+       return res;
+}
+#define mul_u64_u64 mul_u64_u64
+
+static inline u128 add_u128(u128 a, u128 b)
+{
+       u128 res;
+
+       asm("addq %2,%0;\n"
+           "adcq %3,%1;\n"
+               : "=rm" (res.lo), "=rm" (res.hi)
+               : "r" (b.lo), "r" (b.hi), "0" (a.lo), "1" (a.hi));
+
+       return res;
+}
+#define add_u128 add_u128
+
+#endif /* ARCH_HAS_INT128 */
+#endif /* CONFIG_X86_64 */
+#endif /* _ASM_MATH128_H */
-- 
1.7.9.5

