Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0KCPBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:01:25 -0400
Received: from claw.goop.org ([74.207.240.146]:41972 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab0KCPBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:01:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/20] x86/ticketlock: make __ticket_spin_lock common
Date: Wed,  3 Nov 2010 10:59:46 -0400
Message-Id: <2080b3702fad2a4ec3647efe2cfef19140da8086.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Aside from the particular form of the xadd instruction, they're identical.
So factor out the xadd and use common code for the rest.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |   42 ++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 7586d7a..4f9fa24 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -69,13 +69,27 @@ static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
  * save some instructions and make the code more elegant. There really isn't
  * much between them in performance though, especially as locks are out of line.
  */
-#if (NR_CPUS < 256)
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
+static __always_inline struct __raw_tickets __ticket_spin_claim(struct arch_spinlock *lock)
 {
-	register struct __raw_tickets inc = { .tail = 1 };
+	register struct __raw_tickets tickets = { .tail = 1 };
+
+	if (sizeof(lock->tickets.head) == sizeof(u8))
+		asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
+			      : "+r" (tickets), "+m" (lock->tickets)
+			      : : "memory", "cc");
+	else
+		asm volatile (LOCK_PREFIX "xaddl %0, %1\n"
+			     : "+r" (tickets), "+m" (lock->tickets)
+			     : : "memory", "cc");
 
-	asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
-		      : "+r" (inc), "+m" (lock->tickets) : : "memory", "cc");
+	return tickets;
+}
+
+static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
+{
+	register struct __raw_tickets inc;
+
+	inc = __ticket_spin_claim(lock);
 
 	for (;;) {
 		if (inc.head == inc.tail)
@@ -86,6 +100,7 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
+#if (NR_CPUS < 256)
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned int tmp, new;
@@ -105,23 +120,6 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 	return tmp;
 }
 #else
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
-{
-	register struct __raw_tickets inc = { .tickets.tail = 1 };
-
-	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
-		     : "+r" (inc), "+m" (lock->tickets)
-		     : : "memory", "cc");
-
-	for (;;) {
-		if (inc.head == inc.tail)
-			return;
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
-	}
-	barrier();		/* make sure nothing creeps before the lock is taken */
-}
-
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned tmp;
-- 
1.7.2.3

