Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2LUXwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:52:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2LUXwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:52:05 -0500
Date: Fri, 21 Dec 2012 18:50:38 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 1/3] x86,smp: move waiting on contended lock out of line
Message-ID: <20121221185038.43e8246c@annuminas.surriel.com>
In-Reply-To: <20121221184940.103c31ad@annuminas.surriel.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86,smp: move waiting on contended ticket lock out of line

Moving the wait loop for congested loops to its own function allows
us to add things to that wait loop, without growing the size of the
kernel text appreciably.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/spinlock.h |   13 +++++++------
 arch/x86/kernel/smp.c           |   14 ++++++++++++++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 33692ea..2a45eb0 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -34,6 +34,8 @@
 # define UNLOCK_LOCK_PREFIX
 #endif
 
+extern void ticket_spin_lock_wait(arch_spinlock_t *, struct __raw_tickets);
+
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -53,12 +55,11 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 
 	inc = xadd(&lock->tickets, inc);
 
-	for (;;) {
-		if (inc.head == inc.tail)
-			break;
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
-	}
+	if (inc.head == inc.tail)
+		goto out;
+
+	ticket_spin_lock_wait(lock, inc);
+ out:
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..20da354 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -113,6 +113,20 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
 static bool smp_no_nmi_ipi = false;
 
 /*
+ * Wait on a congested ticket spinlock.
+ */
+void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
+{
+	for (;;) {
+		cpu_relax();
+		inc.head = ACCESS_ONCE(lock->tickets.head);
+
+		if (inc.head == inc.tail)
+			break;
+	}
+}
+
+/*
  * this function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
  * anything. Worst case is that we lose a reschedule ...
