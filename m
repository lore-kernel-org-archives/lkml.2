Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1GVT5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:57:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1GVT5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:57:32 -0400
Date: Fri, 22 Jul 2011 19:57:25 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-65bd26616b53c5dfab162f18c34ec57ddb682a00@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <11b6893703912054024bdb60251ed944f31cbafe.1308878118.git.jeremy.fitzhardinge@citrix.com>
References: <11b6893703912054024bdb60251ed944f31cbafe.1308878118.git.jeremy.fitzhardinge@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, ticketlock: Make __ticket_spin_lock common
Git-Commit-ID: 65bd26616b53c5dfab162f18c34ec57ddb682a00
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jul 2011 19:57:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65bd26616b53c5dfab162f18c34ec57ddb682a00
Gitweb:     http://git.kernel.org/tip/65bd26616b53c5dfab162f18c34ec57ddb682a00
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Thu, 23 Jun 2011 18:19:17 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 22 Jul 2011 11:18:44 -0700

x86, ticketlock: Make __ticket_spin_lock common

Aside from the particular form of the xadd instruction, they're identical.
So factor out the xadd and use common code for the rest.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/11b6893703912054024bdb60251ed944f31cbafe.1308878118.git.jeremy.fitzhardinge@citrix.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h |   42 ++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 078319e..a0e26c8 100644
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
