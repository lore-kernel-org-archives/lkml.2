Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2JRIaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:30:19 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:10471
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602Ab2JRIaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:30:16 -0400
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPV:NLI;H:oce-exbhcs03a.oce.net;RD:smtp02.oce.com;EFVD:NLI
X-SpamScore: 17
X-BigFish: VS17(zzzz1ce5h1202h1d1ah1cabh1d2ahzz8275bhz2ei87h668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441hff4m129fs1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Ivo Sieben <meltedpianoman@gmail.com>
To: <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
CC: <linux-serial@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH-v2] sched: Prevent wakeup to enter critical section needlessly
Date: Thu, 18 Oct 2012 10:30:05 +0200
Message-ID: <1350549005-18309-1-git-send-email-meltedpianoman@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121010140249.GX16230@one.firstfloor.org>
References: <20121010140249.GX16230@one.firstfloor.org>
X-OriginalArrivalTime: 18 Oct 2012 08:30:07.0798 (UTC) FILETIME=[C7DC1560:01CDAD0A]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: oce.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the waitqueue task list to be non empty before entering the critical
section. This prevents locking the spin lock needlessly in case the queue
was empty, and therefor also prevent scheduling overhead on a PREEMPT_RT
system.

Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
---

 v2:
 - We don't need the "careful" list empty, a normal list empty is sufficient:
   if you miss an update it was just as it happened a little later.
 - Because of memory ordering problems we can observe an unupdated list
   administration. This can cause an wait_event-like code to miss an event.
   Adding a memory barrier befor checking the list to be empty will guarantee we
   evaluate a 100% updated list adminsitration.

 kernel/sched/core.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..168a9b2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3090,9 +3090,22 @@ void __wake_up(wait_queue_head_t *q, unsigned int mode,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, 0, key);
-	spin_unlock_irqrestore(&q->lock, flags);
+	/*
+	 * We check for list emptiness outside the lock. This prevents the wake
+	 * up to enter the critical section needlessly when the task list is
+	 * empty.
+	 *
+	 * Placed a full memory barrier before checking list emptiness to make
+	 * 100% sure this function sees an up-to-date list administration.
+	 * Note that other code that manipulates the list uses a spin_lock and
+	 * therefore doesn't need additional memory barriers.
+	 */
+	smp_mb();
+	if (!list_empty(&q->task_list)) {
+		spin_lock_irqsave(&q->lock, flags);
+		__wake_up_common(q, mode, nr_exclusive, 0, key);
+		spin_unlock_irqrestore(&q->lock, flags);
+	}
 }
 EXPORT_SYMBOL(__wake_up);
 
-- 
1.7.9.5


