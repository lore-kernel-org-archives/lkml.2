Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3ABAKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 19:10:45 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43769 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab3ABAKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 19:10:43 -0500
Date: Tue, 1 Jan 2013 16:10:38 -0800
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, Tom Herbert <therbert@google.com>
Subject: [PATCH 2/2] x86,smp: proportional backoff for ticket spinlocks
Message-ID: <20130102001038.GC13678@google.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20130102000653.GA13678@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102000653.GA13678@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple fixed value proportional backoff for ticket spinlocks.
By pounding on the cacheline with the spin lock less often,
bus traffic is reduced. In cases of a data structure with
embedded spinlock, the lock holder has a better chance of
making progress.

Note that when a thread notices that it's at the head of the line for
acquiring the spinlock, this thread has already touched the spinlock's
cacheline and now holds it in shared state. At this point, extra reads
to the cache line are local to the processor and do not generate any
extra coherency traffic, until another thread (probably the spinlock
owner) writes to it. When that write occurs, the writing thread will
get exclusive access to the cacheline first, and then the waiting
thread will ask to get its shared access again. It is expected that in
many cases, the writing thread will release the spinlock before the
waiting thread gets its shared access back. For these reasons, it
seems unproductive for the head waiter to throttle its accesses;
however we do want to throttle the other waiter threads so that they
don't generate any extra coherency traffic until they can acquire the
spinlock, or at least reach the head position among waiters.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 arch/x86/include/asm/spinlock.h |    2 ++
 arch/x86/kernel/smp.c           |   33 +++++++++++++++++++++++++++------
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 19e8a36b3b83..b49ae57a62c8 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -34,6 +34,8 @@
 # define UNLOCK_LOCK_PREFIX
 #endif
 
+extern unsigned int __read_mostly spinlock_delay;
+
 extern void ticket_spin_lock_wait(arch_spinlock_t *, struct __raw_tickets);
 
 /*
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 20da35427bd5..eb2c49c6cc08 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <linux/debugfs.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -111,20 +112,40 @@
 
 static atomic_t stopping_cpu = ATOMIC_INIT(-1);
 static bool smp_no_nmi_ipi = false;
+unsigned int __read_mostly spinlock_delay = 1;
 
 /*
  * Wait on a congested ticket spinlock.
  */
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
-	for (;;) {
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
+	__ticket_t head = inc.head, ticket = inc.tail;
+	__ticket_t waiters_ahead;
+	unsigned delay;
+	do {
+		waiters_ahead = ticket - head - 1;
+		if (!waiters_ahead) {
+			do
+				cpu_relax();
+			while (ACCESS_ONCE(lock->tickets.head) != ticket);
+			return;
+		}
+		delay = waiters_ahead * spinlock_delay;
+		do
+			cpu_relax();
+		while (delay--);
+		head = ACCESS_ONCE(lock->tickets.head);
+	} while (head != ticket);
+}
 
-		if (inc.head == inc.tail)
-			break;
-	}
+#ifdef CONFIG_DEBUG_FS
+static __init int spinlock_delay_init_debug(void)
+{
+	debugfs_create_u32("spinlock_delay", 0644, NULL, &spinlock_delay);
+	return 0;
 }
+late_initcall(spinlock_delay_init_debug);
+#endif
 
 /*
  * this function sends a 'reschedule' IPI to another CPU.
-- 
1.7.7.3
