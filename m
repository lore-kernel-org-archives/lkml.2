Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3AHWdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:33:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab3AHWdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:33:33 -0500
Date: Tue, 8 Jan 2013 17:32:41 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: [PATCH 2/5] x86,smp: proportional backoff for ticket spinlocks
Message-ID: <20130108173241.3e1b1d2d@annuminas.surriel.com>
In-Reply-To: <20130108172632.1126898a@annuminas.surriel.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86,smp: proportional backoff for ticket spinlocks

Simple fixed value proportional backoff for ticket spinlocks.
By pounding on the cacheline with the spin lock less often,
bus traffic is reduced. In cases of a data structure with
embedded spinlock, the lock holder has a better chance of
making progress.

If we are next in line behind the current holder of the
lock, we do a fast spin, so as not to waste any time when
the lock is released.

The number 50 is likely to be wrong for many setups, and
this patch is mostly to illustrate the concept of proportional
backup. The next patch automatically tunes the delay value.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/x86/kernel/smp.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 20da354..aa743e9 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -117,11 +117,28 @@ static bool smp_no_nmi_ipi = false;
  */
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
+	__ticket_t head = inc.head, ticket = inc.tail;
+	__ticket_t waiters_ahead;
+	unsigned loops;
+
 	for (;;) {
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
+		waiters_ahead = ticket - head - 1;
+		/*
+		 * We are next after the current lock holder. Check often
+		 * to avoid wasting time when the lock is released.
+		 */
+		if (!waiters_ahead) {
+			do {
+				cpu_relax();
+			} while (ACCESS_ONCE(lock->tickets.head) != ticket);
+			break;
+		}
+		loops = 50 * waiters_ahead;
+		while (loops--)
+			cpu_relax();
 
-		if (inc.head == inc.tail)
+		head = ACCESS_ONCE(lock->tickets.head);
+		if (head == ticket)
 			break;
 	}
 }

