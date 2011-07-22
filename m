Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1GVT6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:58:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:38215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab1GVT6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:58:19 -0400
Date: Fri, 22 Jul 2011 19:58:12 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-847c73e8042e565a2cc4934c84103ab82e0eac42@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <ce03e48f4b70a2a31accf32c8b41b781674e57c3.1308878118.git.jeremy.fitzhardinge@citrix.com>
References: <ce03e48f4b70a2a31accf32c8b41b781674e57c3.1308878118.git.jeremy.fitzhardinge@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86: Add xadd helper macro
Git-Commit-ID: 847c73e8042e565a2cc4934c84103ab82e0eac42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jul 2011 19:58:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  847c73e8042e565a2cc4934c84103ab82e0eac42
Gitweb:     http://git.kernel.org/tip/847c73e8042e565a2cc4934c84103ab82e0eac42
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Thu, 23 Jun 2011 18:19:19 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 22 Jul 2011 11:18:58 -0700

x86: Add xadd helper macro

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/ce03e48f4b70a2a31accf32c8b41b781674e57c3.1308878118.git.jeremy.fitzhardinge@citrix.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
