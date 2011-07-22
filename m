Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1GVT5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:57:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:38159 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1GVT5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:57:07 -0400
Date: Fri, 22 Jul 2011 19:57:01 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-dc126c03ca25de516eaa8e575a98b81382d6d4b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <9eea42d16aabc7624488eb62213a763dbbacef38.1308878118.git.jeremy.fitzhardinge@citrix.com>
References: <9eea42d16aabc7624488eb62213a763dbbacef38.1308878118.git.jeremy.fitzhardinge@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, ticketlock: Make large and small ticket versions of spin_lock the same
Git-Commit-ID: dc126c03ca25de516eaa8e575a98b81382d6d4b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jul 2011 19:57:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc126c03ca25de516eaa8e575a98b81382d6d4b4
Gitweb:     http://git.kernel.org/tip/dc126c03ca25de516eaa8e575a98b81382d6d4b4
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Thu, 23 Jun 2011 18:19:16 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 22 Jul 2011 11:18:37 -0700

x86, ticketlock: Make large and small ticket versions of spin_lock the same

Make the bulk of __ticket_spin_lock look identical for large and small
number of cpus.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/9eea42d16aabc7624488eb62213a763dbbacef38.1308878118.git.jeremy.fitzhardinge@citrix.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index f8d51dc..078319e 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -70,19 +70,16 @@ static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
 #if (NR_CPUS < 256)
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	register union {
-		struct __raw_tickets tickets;
-		unsigned short slock;
-	} inc = { .slock = 1 << TICKET_SHIFT };
+	register struct __raw_tickets inc = { .tail = 1 };
 
 	asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
-		      : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
+		      : "+r" (inc), "+m" (lock->tickets) : : "memory", "cc");
 
 	for (;;) {
-		if (inc.tickets.head == inc.tickets.tail)
+		if (inc.head == inc.tail)
 			goto out;
 		cpu_relax();
-		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
+		inc.head = ACCESS_ONCE(lock->tickets.head);
 	}
 out:	barrier();		/* make sure nothing creeps before the lock is taken */
 }
@@ -108,21 +105,17 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 #else
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	unsigned inc = 1 << TICKET_SHIFT;
-	__ticket_t tmp;
+	register struct __raw_tickets inc = { .tail = 1 };
 
 	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
-		     : "+r" (inc), "+m" (lock->slock)
+		     : "+r" (inc), "+m" (lock->tickets)
 		     : : "memory", "cc");
 
-	tmp = inc;
-	inc >>= TICKET_SHIFT;
-
 	for (;;) {
-		if ((__ticket_t)inc == tmp)
+		if (inc.head == inc.tail)
 			goto out;
 		cpu_relax();
-		tmp = ACCESS_ONCE(lock->tickets.head);
+		inc.head = ACCESS_ONCE(lock->tickets.head);
 	}
 out:	barrier();		/* make sure nothing creeps before the lock is taken */
 }
