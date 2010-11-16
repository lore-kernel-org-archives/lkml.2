Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab0KPVI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:08:58 -0500
Received: from claw.goop.org ([74.207.240.146]:50417 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758461Ab0KPVI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:08:56 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?UTF-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/14] x86/ticketlock: make __ticket_spin_lock common
Date: Tue, 16 Nov 2010 13:08:36 -0800
Message-Id: <1d7e9cd6f8c9b818dc5647157f4ff5a257a38114.1289940821.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
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
index 1b81809..f722f96 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -67,13 +67,27 @@ static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
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
@@ -84,6 +98,7 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 out:	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
+#if (NR_CPUS < 256)
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned int tmp, new;
@@ -103,23 +118,6 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 	return tmp;
 }
 #else
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
-{
-	register struct __raw_tickets inc = { .tail = 1 };
-
-	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
-		     : "+r" (inc), "+m" (lock->tickets)
-		     : : "memory", "cc");
-
-	for (;;) {
-		if (inc.head == inc.tail)
-			goto out;
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
-	}
-out:	barrier();		/* make sure nothing creeps before the lock is taken */
-}
-
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned tmp;
-- 
1.7.2.3

