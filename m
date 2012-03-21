Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030863Ab2CUKXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:23:19 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45386 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030800Ab2CUKXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:23:17 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Date: Wed, 21 Mar 2012 15:51:18 +0530
Message-Id: <20120321102118.473.20986.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V6 3/11]  x86/ticketlock: collapse a layer of functions
x-cbid: 12032110-2674-0000-0000-000003C7FA91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Now that the paravirtualization layer doesn't exist at the spinlock
level any more, we can collapse the __ticket_ functions into the arch_
functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/include/asm/spinlock.h |   35 +++++------------------------------
 1 files changed, 5 insertions(+), 30 deletions(-)
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 7e66b85..f6442f4 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -79,7 +79,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
  * in the high part, because a wide xadd increment of the low part would carry
  * up and contaminate the high part.
  */
-static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
+static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 {
 	register struct __raw_tickets inc = { .tail = 1 };
 
@@ -99,7 +99,7 @@ static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
 out:	barrier();	/* make sure nothing creeps before the lock is taken */
 }
 
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
+static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	arch_spinlock_t old, new;
 
@@ -113,7 +113,7 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
 }
 
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
+static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__ticket_t next = lock->tickets.head + 1;
 
@@ -121,46 +121,21 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
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

