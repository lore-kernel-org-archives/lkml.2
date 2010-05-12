Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0ELDYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:24:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52622 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab0ELDYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:24:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ZL/DRDdIYKmICgwuuOJxlWBMkznFwSyGs51jBQBwQidczZOPkfbcCHLYJvTOCFMqP
	sTx6HeVKQMlTUzZfOikHw==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 04/12] rwsem: consistently use adjustment variable
Date: Tue, 11 May 2010 20:20:54 -0700
Message-Id: <1273634462-2672-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup: previous change introduced an adjustment variable used in
waking writers; the code to wake readers can be made nicer by making
use of that same variable.

Reducing variable count should hopefully help both humans and compilers
looking at this function :)

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 0fb6e38..92c8f8e 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -52,7 +52,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long oldcount, woken, loop, adjustment;
+	signed long oldcount, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
@@ -96,9 +96,9 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	 *   readers before waking any processes up
 	 */
  readers_only:
-	woken = 0;
+	loop = 0;
 	do {
-		woken++;
+		loop++;
 
 		if (waiter->list.next == &sem->wait_list)
 			break;
@@ -108,14 +108,13 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 
 	} while (waiter->flags & RWSEM_WAITING_FOR_READ);
 
-	loop = woken;
-	woken *= RWSEM_ACTIVE_READ_BIAS;
+	adjustment = loop * RWSEM_ACTIVE_READ_BIAS;
 	if (waiter->flags & RWSEM_WAITING_FOR_READ)
 		/* hit end of list above */
-		woken -= RWSEM_WAITING_BIAS;
+		adjustment -= RWSEM_WAITING_BIAS;
 
  retry_readers:
-	oldcount = rwsem_atomic_update(woken, sem) - woken;
+	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
 	if (!downgrading && (oldcount & RWSEM_ACTIVE_MASK))
 		/* Someone grabbed the sem already */
 		goto undo_readers;
@@ -144,7 +143,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	goto retry_writer;
 
  undo_readers:
-	if (rwsem_atomic_update(-woken, sem) & RWSEM_ACTIVE_MASK)
+	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
 	goto retry_readers;
 }
-- 
1.7.0.1

