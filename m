Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab0EKSba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:31:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:49089 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab0EKSb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:31:28 -0400
Date: Tue, 11 May 2010 18:30:41 GMT
From: tip-bot for Changli Gao <xiaosuo@gmail.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       hpa@zytor.com, mingo@redhat.com, lizf@cn.fujitsu.com,
       a.p.zijlstra@chello.nl, viro@zeniv.linux.org.uk, xiaosuo@gmail.com,
       menage@google.com, davidel@xmailserver.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, xiaosuo@gmail.com,
       viro@zeniv.linux.org.uk, menage@google.com, davidel@xmailserver.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1273214006-2979-1-git-send-email-xiaosuo@gmail.com>
References: <1273214006-2979-1-git-send-email-xiaosuo@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, wait: Use wrapper functions
Message-ID: <tip-a93d2f1744206827ccf416e2cdc5018aa503314e@git.kernel.org>
Git-Commit-ID: a93d2f1744206827ccf416e2cdc5018aa503314e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 May 2010 18:30:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a93d2f1744206827ccf416e2cdc5018aa503314e
Gitweb:     http://git.kernel.org/tip/a93d2f1744206827ccf416e2cdc5018aa503314e
Author:     Changli Gao <xiaosuo@gmail.com>
AuthorDate: Fri, 7 May 2010 14:33:26 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 May 2010 17:43:58 +0200

sched, wait: Use wrapper functions

epoll should not touch flags in wait_queue_t. This patch introduces a new
function __add_wait_queue_exclusive(), for the users, who use wait queue as a
LIFO queue.

__add_wait_queue_tail_exclusive() is introduced too instead of
add_wait_queue_exclusive_locked(). remove_wait_queue_locked() is removed, as
it is a duplicate of __remove_wait_queue(), disliked by users, and with less
users.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: <containers@lists.linux-foundation.org>
LKML-Reference: <1273214006-2979-1-git-send-email-xiaosuo@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/eventpoll.c       |    3 +--
 include/linux/wait.h |   35 +++++++++++++++--------------------
 kernel/cgroup.c      |    2 +-
 kernel/sched.c       |    3 +--
 4 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bd056a5..3817149 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1140,8 +1140,7 @@ retry:
 		 * ep_poll_callback() when events will become available.
 		 */
 		init_waitqueue_entry(&wait, current);
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue(&ep->wq, &wait);
+		__add_wait_queue_exclusive(&ep->wq, &wait);
 
 		for (;;) {
 			/*
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a48e16b..76d96d0 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -127,12 +127,26 @@ static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
 /*
  * Used for wake-one threads:
  */
+static inline void __add_wait_queue_exclusive(wait_queue_head_t *q,
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
 
+static inline void __add_wait_queue_tail_exclusive(wait_queue_head_t *q,
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
index 39aa9c7..b531d79 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3983,8 +3983,7 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 	if (!x->done) {
 		DECLARE_WAITQUEUE(wait, current);
 
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue_tail(&x->wait, &wait);
+		__add_wait_queue_tail_exclusive(&x->wait, &wait);
 		do {
 			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
