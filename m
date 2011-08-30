Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1H3F0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:26:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:48965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab1H3F0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:26:10 -0400
Date: Tue, 30 Aug 2011 05:25:21 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-84eb950db13ca40a0572ce9957e14723500943d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, ticketlock: Clean up types and accessors
Git-Commit-ID: 84eb950db13ca40a0572ce9957e14723500943d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:26:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84eb950db13ca40a0572ce9957e14723500943d6
Gitweb:     http://git.kernel.org/tip/84eb950db13ca40a0572ce9957e14723500943d6
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Fri, 2 Jul 2010 23:26:36 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 13:45:19 -0700

x86, ticketlock: Clean up types and accessors

A few cleanups to the way spinlocks are defined and accessed:
 - define __ticket_t which is the size of a spinlock ticket (ie, enough
   bits to hold all the cpus)
 - Define struct arch_spinlock as a union containing plain slock and
   the head and tail tickets
 - Use head and tail to implement some of the spinlock predicates.
 - Make all ticket variables unsigned.
 - Use TICKET_SHIFT to form constants

Most of this will be used in later patches.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h       |   24 ++++++++++--------------
 arch/x86/include/asm/spinlock_types.h |   20 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index ee67edf..ea2a04f 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -55,11 +55,9 @@
  * much between them in performance though, especially as locks are out of line.
  */
 #if (NR_CPUS < 256)
-#define TICKET_SHIFT 8
-
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	short inc = 0x0100;
+	unsigned short inc = 1 << TICKET_SHIFT;
 
 	asm volatile (
 		LOCK_PREFIX "xaddw %w0, %1\n"
@@ -78,7 +76,7 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
-	int tmp, new;
+	unsigned int tmp, new;
 
 	asm volatile("movzwl %2, %0\n\t"
 		     "cmpb %h0,%b0\n\t"
@@ -103,12 +101,10 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 		     : "memory", "cc");
 }
 #else
-#define TICKET_SHIFT 16
-
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	int inc = 0x00010000;
-	int tmp;
+	unsigned inc = 1 << TICKET_SHIFT;
+	unsigned tmp;
 
 	asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
 		     "movzwl %w0, %2\n\t"
@@ -128,8 +124,8 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
-	int tmp;
-	int new;
+	unsigned tmp;
+	unsigned new;
 
 	asm volatile("movl %2,%0\n\t"
 		     "movl %0,%1\n\t"
@@ -159,16 +155,16 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
-	int tmp = ACCESS_ONCE(lock->slock);
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & ((1 << TICKET_SHIFT) - 1));
+	return !!(tmp.tail ^ tmp.head);
 }
 
 static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 {
-	int tmp = ACCESS_ONCE(lock->slock);
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
+	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
 }
 
 #ifndef CONFIG_PARAVIRT_SPINLOCKS
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 7c7a486..1c51bd2 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -5,11 +5,27 @@
 # error "please don't include this file directly"
 #endif
 
+#include <linux/types.h>
+
+#if (CONFIG_NR_CPUS < 256)
+typedef u8  __ticket_t;
+#else
+typedef u16 __ticket_t;
+#endif
+
+#define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
+#define TICKET_MASK	((__ticket_t)((1 << TICKET_SHIFT) - 1))
+
 typedef struct arch_spinlock {
-	unsigned int slock;
+	union {
+		unsigned int slock;
+		struct __raw_tickets {
+			__ticket_t head, tail;
+		} tickets;
+	};
 } arch_spinlock_t;
 
-#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ { .slock = 0 } }
 
 #include <asm/rwlock.h>
 
