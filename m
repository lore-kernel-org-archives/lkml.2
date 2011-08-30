Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1H3F0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:26:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:48976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1H3F0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:26:23 -0400
Date: Tue, 30 Aug 2011 05:25:53 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-c576a3ea905c25d50339503e0e5c7fef724e0147@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, ticketlock: Convert spin loop to C
Git-Commit-ID: c576a3ea905c25d50339503e0e5c7fef724e0147
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:26:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c576a3ea905c25d50339503e0e5c7fef724e0147
Gitweb:     http://git.kernel.org/tip/c576a3ea905c25d50339503e0e5c7fef724e0147
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Sat, 3 Jul 2010 01:06:04 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 13:45:43 -0700

x86, ticketlock: Convert spin loop to C

The inner loop of __ticket_spin_lock isn't doing anything very special,
so reimplement it in C.

For the 8 bit ticket lock variant, we use a register union to get direct
access to the lower and upper bytes in the tickets, but unfortunately gcc
won't generate a direct comparison between the two halves of the register,
so the generated asm isn't quite as pretty as the hand-coded version.
However benchmarking shows that this is actually a small improvement in
runtime performance on some benchmarks, and never a slowdown.

We also need to make sure there's a barrier at the end of the lock loop
to make sure that the compiler doesn't move any instructions from within
the locked region into the region where we don't yet own the lock.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h |   58 +++++++++++++++++++-------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index ea2a04f..5240cde 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -57,21 +57,21 @@
 #if (NR_CPUS < 256)
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	unsigned short inc = 1 << TICKET_SHIFT;
-
-	asm volatile (
-		LOCK_PREFIX "xaddw %w0, %1\n"
-		"1:\t"
-		"cmpb %h0, %b0\n\t"
-		"je 2f\n\t"
-		"rep ; nop\n\t"
-		"movb %1, %b0\n\t"
-		/* don't need lfence here, because loads are in-order */
-		"jmp 1b\n"
-		"2:"
-		: "+Q" (inc), "+m" (lock->slock)
-		:
-		: "memory", "cc");
+	register union {
+		struct __raw_tickets tickets;
+		unsigned short slock;
+	} inc = { .slock = 1 << TICKET_SHIFT };
+
+	asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
+		      : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
+
+	for (;;) {
+		if (inc.tickets.head == inc.tickets.tail)
+			break;
+		cpu_relax();
+		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
+	}
+	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
@@ -104,22 +104,22 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned inc = 1 << TICKET_SHIFT;
-	unsigned tmp;
+	__ticket_t tmp;
 
-	asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
-		     "movzwl %w0, %2\n\t"
-		     "shrl $16, %0\n\t"
-		     "1:\t"
-		     "cmpl %0, %2\n\t"
-		     "je 2f\n\t"
-		     "rep ; nop\n\t"
-		     "movzwl %1, %2\n\t"
-		     /* don't need lfence here, because loads are in-order */
-		     "jmp 1b\n"
-		     "2:"
-		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
-		     :
-		     : "memory", "cc");
+	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
+		     : "+r" (inc), "+m" (lock->slock)
+		     : : "memory", "cc");
+
+	tmp = inc;
+	inc >>= TICKET_SHIFT;
+
+	for (;;) {
+		if ((__ticket_t)inc == tmp)
+			break;
+		cpu_relax();
+		tmp = ACCESS_ONCE(lock->tickets.head);
+	}
+	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
