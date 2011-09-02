Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab1IBAzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:55:25 -0400
Received: from claw.goop.org ([74.207.240.146]:43148 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab1IBAzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:55:22 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/13] x86/ticketlock: collapse a layer of functions
Date: Thu,  1 Sep 2011 17:54:55 -0700
Message-Id: <860046dfb09b88e19854366ca1fc29b027b2fd27.1314922370.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Now that the paravirtualization layer doesn't exist at the spinlock
level any more, we can collapse the __ticket_ functions into the arch_
functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |   35 +++++------------------------------
 1 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index f5d9236..c1d9617 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -81,7 +81,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __t
  * save some instructions and make the code more elegant. There really isn't
  * much between them in performance though, especially as locks are out of line.
  */
-static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
+static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 {
 	register struct __raw_tickets inc = { .tail = 1 };
 
@@ -101,7 +101,7 @@ static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
 out:	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
+static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	arch_spinlock_t old, new;
 
@@ -133,7 +133,7 @@ static __always_inline void __ticket_unlock_release(arch_spinlock_t *lock)
 }
 #endif
 
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
+static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__ticket_t next = lock->tickets.head + 1;
 
@@ -141,46 +141,21 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
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
1.7.6

