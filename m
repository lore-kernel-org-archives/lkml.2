Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab1FPVlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:41:15 -0400
Received: from claw.goop.org ([74.207.240.146]:53898 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933091Ab1FPVlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:41:09 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/7] x86/ticketlock: Use C for __ticket_spin_unlock
Date: Thu, 16 Jun 2011 14:40:50 -0700
Message-Id: <79803bbbf9966c4310344ac95a3d91425724453b.1308259496.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If we don't need to use a locked inc for unlock, then implement it in C.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index f48a6e3..0170ba9 100644
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
+		asm (LOCK_PREFIX "incb %0"
+		     : "+m" (lock->tickets.head) : : "memory");
+	else
+		asm (LOCK_PREFIX "incw %0"
+		     : "+m" (lock->tickets.head) : : "memory");
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
@@ -144,15 +148,13 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 
 	return tmp;
 }
+#endif
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
-		     : "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
+	__ticket_unlock_release(lock);
+	barrier();		/* prevent reordering into locked region */
 }
-#endif
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
-- 
1.7.5.4

