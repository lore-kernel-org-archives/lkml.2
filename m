Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0EGIzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:55:40 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:46438 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0EGIzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QpD18psPwLIZZxvN8I33Gs1C+DLUN8NNF1LrvTOV704Jn3mX4GIjn7rTI0/PL64kxP
         Nqz2/tZaQgoZRYewYASJH1IKBZCoeaHaVz+72/yRwIFFEMxRrTxxAVu+O6IeFxzW9Hht
         qE4c/6eepTgWC+rjITR6ULOuAIrKE+famTEGo=
From: Changli Gao <xiaosuo@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH v2] wait: use wrapper functions
Date: Fri,  7 May 2010 14:33:26 +0800
Message-Id: <1273214006-2979-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use wrapper functions

epoll should not touch flags in wait_queue_t. This patch introduces a new
function __add_wait_queue_excl(), for the users, who use wait queue as a
LIFO queue.

__add_wait_queue_tail_excl() is introduced too instead of
add_wait_queue_exclusive_locked(). remove_wait_queue_locked() is removed, as
it is a duplicate of __remove_wait_queue(), disliked by users, and with less
users.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/eventpoll.c       |    3 +--
 include/linux/wait.h |   35 +++++++++++++++--------------------
 kernel/cgroup.c      |    2 +-
 kernel/sched.c       |    3 +--
 4 files changed, 18 insertions(+), 25 deletions(-)
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bd056a5..a6ba470 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1140,8 +1140,7 @@ retry:
 		 * ep_poll_callback() when events will become available.
 		 */
 		init_waitqueue_entry(&wait, current);
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue(&ep->wq, &wait);
+		__add_wait_queue_excl(&ep->wq, &wait);
 
 		for (;;) {
 			/*
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a48e16b..4db4147 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -127,12 +127,26 @@ static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
 /*
  * Used for wake-one threads:
  */
+static inline void __add_wait_queue_excl(wait_queue_head_t *q,
+					      wait_queue_t *wait)
+{
+	wait->flags |= WQ_FLAG_EXCLUSIVE;
+	__add_wait_queue(q, wait);
+}
+
 static inline void __add_wait_queue_tail(wait_queue_head_t *head,
-						wait_queue_t *new)
+					 wait_queue_t *new)
 {
 	list_add_tail(&new->task_list, &head->task_list);
 }
 
+static inline void __add_wait_queue_tail_excl(wait_queue_head_t *q,
+					      wait_queue_t *wait)
+{
+	wait->flags |= WQ_FLAG_EXCLUSIVE;
+	__add_wait_queue_tail(q, wait);
+}
+
 static inline void __remove_wait_queue(wait_queue_head_t *head,
 							wait_queue_t *old)
 {
@@ -404,25 +418,6 @@ do {									\
 })
 
 /*
- * Must be called with the spinlock in the wait_queue_head_t held.
- */
-static inline void add_wait_queue_exclusive_locked(wait_queue_head_t *q,
-						   wait_queue_t * wait)
-{
-	wait->flags |= WQ_FLAG_EXCLUSIVE;
-	__add_wait_queue_tail(q,  wait);
-}
-
-/*
- * Must be called with the spinlock in the wait_queue_head_t held.
- */
-static inline void remove_wait_queue_locked(wait_queue_head_t *q,
-					    wait_queue_t * wait)
-{
-	__remove_wait_queue(q,  wait);
-}
-
-/*
  * These are the old interfaces to sleep waiting for an event.
  * They are racy.  DO NOT use them, use the wait_event* interfaces above.
  * We plan to remove these interfaces.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2769e1..4a07d05 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3010,7 +3010,7 @@ static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 	unsigned long flags = (unsigned long)key;
 
 	if (flags & POLLHUP) {
-		remove_wait_queue_locked(event->wqh, &event->wait);
+		__remove_wait_queue(event->wqh, &event->wait);
 		spin_lock(&cgrp->event_list_lock);
 		list_del(&event->list);
 		spin_unlock(&cgrp->event_list_lock);
diff --git a/kernel/sched.c b/kernel/sched.c
index 6af210a..c5c998d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4039,8 +4039,7 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 	if (!x->done) {
 		DECLARE_WAITQUEUE(wait, current);
 
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue_tail(&x->wait, &wait);
+		__add_wait_queue_tail_excl(&x->wait, &wait);
 		do {
 			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
