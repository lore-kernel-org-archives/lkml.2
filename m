Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab0GQAtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 20:49:33 -0400
Received: from claw.goop.org ([74.207.240.146]:40913 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759563Ab0GQAs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 20:48:57 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Wed, 14 Jul 2010 16:30:01 -0700
Subject: [PATCH RFC 08/12] x86/ticketlock: collapse a layer of functions
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>
Message-Id: <20100717004855.C6416A3C4D@abulafia.goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the paravirtualization layer doesn't exist at the spinlock
level any more, we can collapse the __ticket_ functions into the arch_
functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |   35 +++++------------------------------
 1 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 06815f3..a79dfee 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -110,7 +110,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __t
 		____ticket_unlock_kick(lock, next);
 }
 
-static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
+static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 {
 	register struct __raw_tickets inc;
 
@@ -130,7 +130,7 @@ static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
+static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	union {
 		struct __raw_tickets tickets;
@@ -150,53 +150,28 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 	return ret;
 }
 
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
+static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__ticket_t next = lock->tickets.head + 1;
 	__ticket_unlock_release(lock);
 	__ticket_unlock_kick(lock, next);
 }
 
-static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
 	return !!(tmp.tail ^ tmp.head);
 }
 
-static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
+static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
 	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
 }
-
-static inline int arch_spin_is_locked(arch_spinlock_t *lock)
-{
-	return __ticket_spin_is_locked(lock);
-}
-
-static inline int arch_spin_is_contended(arch_spinlock_t *lock)
-{
-	return __ticket_spin_is_contended(lock);
-}
 #define arch_spin_is_contended	arch_spin_is_contended
 
-static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
-{
-	__ticket_spin_lock(lock);
-}
-
-static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
-{
-	return __ticket_spin_trylock(lock);
-}
-
-static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
-{
-	__ticket_spin_unlock(lock);
-}
-
 static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 						  unsigned long flags)
 {
-- 
1.7.1.1


