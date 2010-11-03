Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0KCPAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:00:36 -0400
Received: from claw.goop.org ([74.207.240.146]:35110 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab0KCPAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:00:33 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/20] x86/ticketlock: Use C for __ticket_spin_unlock
Date: Wed,  3 Nov 2010 10:59:44 -0400
Message-Id: <20092775a9df07a5a75820ac250194b535279d51.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
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
index 6711d36..082990a 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -33,9 +33,23 @@
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
+	barrier();
+	lock->tickets.head++;
+	barrier();
+}
 #endif
 
 /*
@@ -93,14 +107,6 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 
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
@@ -144,15 +150,12 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 
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
 }
-#endif
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
-- 
1.7.2.3

