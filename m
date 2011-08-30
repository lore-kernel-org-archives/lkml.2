Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1H3F0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:26:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:49010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab1H3F0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:26:53 -0400
Date: Tue, 30 Aug 2011 05:26:23 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-2994488fe5bb721de1ded53af1a2fc41f47f6ddc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, ticketlock: Convert __ticket_spin_lock to use xadd()
Git-Commit-ID: 2994488fe5bb721de1ded53af1a2fc41f47f6ddc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:26:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2994488fe5bb721de1ded53af1a2fc41f47f6ddc
Gitweb:     http://git.kernel.org/tip/2994488fe5bb721de1ded53af1a2fc41f47f6ddc
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Tue, 13 Jul 2010 14:07:45 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 13:46:07 -0700

x86, ticketlock: Convert __ticket_spin_lock to use xadd()

Convert the two variants of __ticket_spin_lock() to use xadd(), which
has the effect of making them identical, so remove the duplicate function.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h |   35 +++++------------------------------
 1 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 5240cde..b69e0b4 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -54,26 +54,22 @@
  * save some instructions and make the code more elegant. There really isn't
  * much between them in performance though, especially as locks are out of line.
  */
-#if (NR_CPUS < 256)
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	register union {
-		struct __raw_tickets tickets;
-		unsigned short slock;
-	} inc = { .slock = 1 << TICKET_SHIFT };
+	register struct __raw_tickets inc = { .tail = 1 };
 
-	asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
-		      : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
+	inc = xadd(&lock->tickets, inc);
 
 	for (;;) {
-		if (inc.tickets.head == inc.tickets.tail)
+		if (inc.head == inc.tail)
 			break;
 		cpu_relax();
-		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
+		inc.head = ACCESS_ONCE(lock->tickets.head);
 	}
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
+#if (NR_CPUS < 256)
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned int tmp, new;
@@ -101,27 +97,6 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 		     : "memory", "cc");
 }
 #else
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
-{
-	unsigned inc = 1 << TICKET_SHIFT;
-	__ticket_t tmp;
-
-	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
-		     : "+r" (inc), "+m" (lock->slock)
-		     : : "memory", "cc");
-
-	tmp = inc;
-	inc >>= TICKET_SHIFT;
-
-	for (;;) {
-		if ((__ticket_t)inc == tmp)
-			break;
-		cpu_relax();
-		tmp = ACCESS_ONCE(lock->tickets.head);
-	}
-	barrier();		/* make sure nothing creeps before the lock is taken */
-}
-
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned tmp;
