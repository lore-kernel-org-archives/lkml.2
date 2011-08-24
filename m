Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1HXR5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:57:13 -0400
Received: from claw.goop.org ([74.207.240.146]:52874 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1HXRxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:53:19 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/18] x86: add xadd helper macro
Date: Wed, 24 Aug 2011 10:53:01 -0700
Message-Id: <41c1484d36a94613f86f33e15219d5fcd14b2343.1314207974.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Add a common xadd implementation.

This has the side effect of generating a bad instruction if you try to
use it on a 64-bit value on a 32-bit system - but don't do that.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index a460fa0..b771cdb 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -1,5 +1,37 @@
+#ifndef ASM_X86_CMPXCHG_H
+#define ASM_X86_CMPXCHG_H
+
 #ifdef CONFIG_X86_32
 # include "cmpxchg_32.h"
 #else
 # include "cmpxchg_64.h"
 #endif
+
+
+#define xadd(ptr, inc)							\
+	do {								\
+		switch (sizeof(*(ptr))) {				\
+		case 1:							\
+			asm volatile (LOCK_PREFIX "xaddb %b0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case 2:							\
+			asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case 4:							\
+			asm volatile (LOCK_PREFIX "xaddl %0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case 8:							\
+			asm volatile (LOCK_PREFIX "xaddq %q0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		}							\
+	} while(0)
+
+#endif	/* ASM_X86_CMPXCHG_H */
-- 
1.7.6

