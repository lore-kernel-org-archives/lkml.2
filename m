Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1HXRxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:53:22 -0400
Received: from claw.goop.org ([74.207.240.146]:52874 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab1HXRxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:53:18 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/18] x86/ticketlock: Use C for __ticket_spin_unlock
Date: Wed, 24 Aug 2011 10:52:57 -0700
Message-Id: <39551c1e0ae3e4963ad9ac119edf78dbd25a32d9.1314207974.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If we don't need to use a locked inc for unlock, then implement it in C.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index f48a6e3..61feeb5 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -33,9 +33,21 @@
  * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
  * (PPro errata 66, 92)
  */
-# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
+static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
+{
+	if (sizeof(lock->tickets.head) == sizeof(u8))
+		asm volatile (LOCK_PREFIX "incb %0"
+			      : "+m" (lock->tickets.head) : : "memory");
+	else
+		asm volatile (LOCK_PREFIX "incw %0"
+			      : "+m" (lock->tickets.head) : : "memory");
+
+}
 #else
-# define UNLOCK_LOCK_PREFIX
+static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
+{
+	lock->tickets.head++;
+}
 #endif
 
 /*
@@ -93,14 +105,6 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 
 	return tmp;
 }
-
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
-{
-	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
-		     : "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
-}
 #else
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
@@ -144,15 +148,14 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 
 	return tmp;
 }
+#endif
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
-		     : "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
+	barrier();		/* prevent reordering out of locked region */
+	__ticket_unlock_release(lock);
+	barrier();		/* prevent reordering into locked region */
 }
-#endif
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
-- 
1.7.6

