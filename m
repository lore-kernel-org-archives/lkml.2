Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab2IXNHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:07:37 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:48731 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab2IXNHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:07:34 -0400
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPV:NLI;H:oce-exbhcs03b.oce.net;RD:smtp02.oce.com;EFVD:NLI
X-SpamScore: 19
X-BigFish: VS19(zzzz1ce5h1202h1d1ah1cabh1d2ahzz8275bhz2ei87h668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ahff4o129fs1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Ivo Sieben <meltedpianoman@gmail.com>
To: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-serial@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH] RFC: sched: Prevent wakeup to enter critical section needlessly
Date: Mon, 24 Sep 2012 15:06:37 +0200
Message-ID: <1348491997-30898-1-git-send-email-meltedpianoman@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 24 Sep 2012 13:06:41.0328 (UTC) FILETIME=[7075D300:01CD9A55]
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

 Request for comments:
 - Does this make any sense?
 - I assume that I can safely use the list_empty_careful() function here, but is
   that correct?

 Background to this patch:
 Testing on a PREEMPT_RT system with TTY serial communication. Each time the TTY
 line discipline is dereferenced the Idle handling wait queue is woken up (see
 function put_ldisc in /drivers/tty/tty_ldisc.c)
 However line discipline idle handling is not used very often so the wait queue
 is empty most of the time. But still the wake_up() function enters the critical
 section guarded by spin locks. This causes additional scheduling overhead when
 a lower priority thread has control of that same lock.

 kernel/sched/core.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 649c9f8..6436eb8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3631,9 +3631,19 @@ void __wake_up(wait_queue_head_t *q, unsigned int mode,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, 0, key);
-	spin_unlock_irqrestore(&q->lock, flags);
+	/*
+	 * We can check for list emptiness outside the lock by using the
+	 * "careful" check that verifies both the next and prev pointers, so
+	 * that there cannot be any half-pending updates in progress.
+	 *
+	 * This prevents the wake up to enter the critical section needlessly
+	 * when the task list is empty.
+	 */
+	if (!list_empty_careful(&q->task_list)) {
+		spin_lock_irqsave(&q->lock, flags);
+		__wake_up_common(q, mode, nr_exclusive, 0, key);
+		spin_unlock_irqrestore(&q->lock, flags);
+	}
 }
 EXPORT_SYMBOL(__wake_up);
 
-- 
1.7.9.5


