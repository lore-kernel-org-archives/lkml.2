Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab1FXBU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:20:58 -0400
Received: from claw.goop.org ([74.207.240.146]:41619 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760176Ab1FXBT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:19:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 7/8] x86: add xadd helper macro
Date: Thu, 23 Jun 2011 18:19:19 -0700
Message-Id: <ce03e48f4b70a2a31accf32c8b41b781674e57c3.1308878118.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <05552e1c97739f589cb76c20b5a6565ccd506636.1308878118.git.jeremy.fitzhardinge@citrix.com>
References: <05552e1c97739f589cb76c20b5a6565ccd506636.1308878118.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg_32.h |   21 +++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_64.h |   26 ++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 284a6e8..30f0318 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -280,4 +280,25 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 
 #endif
 
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
+		}							\
+	} while(0)
+
 #endif /* _ASM_X86_CMPXCHG_32_H */
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 423ae58..62da1ff 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -151,4 +151,30 @@ extern void __cmpxchg_wrong_size(void);
 	cmpxchg_local((ptr), (o), (n));					\
 })
 
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
 #endif /* _ASM_X86_CMPXCHG_64_H */
-- 
1.7.5.4

