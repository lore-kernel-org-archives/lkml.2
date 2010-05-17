Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab0EQW3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:29:17 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25641 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0EQW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:27:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=epSzqwtbdju9vKptHERwJqE+HGT2sg6Mu3qXe7VfEYkbVtob5hnJWO952LybEM5iY
	REOtnwg/WPnLKEgb9Cysg==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 08/10] rwsem: down_read_critical infrastructure support
Date: Mon, 17 May 2010 15:25:52 -0700
Message-Id: <1274135154-24082-9-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274135154-24082-1-git-send-email-walken@google.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rwsem_down_read_unfair_failed() function in the non-generic rwsem
library code, similar to  rwsem_down_read_failed() except that blocked
threads are placed at the head of the queue.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index d8764e0..b3fe179 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -34,6 +34,7 @@ struct rwsem_waiter {
 	unsigned int flags;
 #define RWSEM_WAITING_FOR_READ	0x00000001
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
+#define RWSEM_UNFAIR            0x00000004
 };
 
 /* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
@@ -187,7 +188,11 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 
 	if (list_empty(&sem->wait_list))
 		adjustment += RWSEM_WAITING_BIAS;
-	list_add_tail(&waiter.list, &sem->wait_list);
+
+	if (flags & RWSEM_UNFAIR)
+		list_add(&waiter.list, &sem->wait_list);
+	else
+		list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
@@ -229,6 +234,21 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 					-RWSEM_ACTIVE_READ_BIAS);
 }
 
+#ifdef __HAVE_DOWN_READ_UNFAIR
+
+/*
+ * wait for the read lock to be granted - skip waiting threads
+ */
+asmregparm struct rw_semaphore __sched *
+rwsem_down_read_unfair_failed(struct rw_semaphore *sem)
+{
+	return rwsem_down_failed_common(sem,
+					RWSEM_WAITING_FOR_READ | RWSEM_UNFAIR,
+					-RWSEM_ACTIVE_READ_BIAS);
+}
+
+#endif
+
 /*
  * wait for the write lock to be granted
  */
-- 
1.7.0.1

