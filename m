Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0KCPAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:00:53 -0400
Received: from claw.goop.org ([74.207.240.146]:35143 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab0KCPAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:00:48 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/20] x86/ticketlock: clean up types and accessors
Date: Wed,  3 Nov 2010 10:59:42 -0400
Message-Id: <742be99eb6d64784dbc3e446d22df78b7a55fc0c.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

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
---
 arch/x86/include/asm/spinlock.h       |   24 ++++++++++--------------
 arch/x86/include/asm/spinlock_types.h |   20 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 3089f70..d6d5784 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -56,11 +56,9 @@
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
@@ -79,7 +77,7 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
-	int tmp, new;
+	unsigned int tmp, new;
 
 	asm volatile("movzwl %2, %0\n\t"
 		     "cmpb %h0,%b0\n\t"
@@ -104,12 +102,10 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
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
@@ -129,8 +125,8 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
-	int tmp;
-	int new;
+	unsigned tmp;
+	unsigned new;
 
 	asm volatile("movl %2,%0\n\t"
 		     "movl %0,%1\n\t"
@@ -160,16 +156,16 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 
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
index dcb48b2..4582640 100644
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
+#define TICKET_MASK	((1 << TICKET_SHIFT) - 1)
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
 
 typedef struct {
 	unsigned int lock;
-- 
1.7.2.3

