Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab0EFETl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 00:19:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44534 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0EFETk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 00:19:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NaSfDnCZz1OGu3S+JyVRWVqQS3/R/LJ0yln5S3BXwfnIISoU+A/IuFbP3MNyrSe5Bb
         WsC42MWW20EMaGC1kdnMoEJJAu/jg8kCITlOXLiUmxzFflq64nfXtBYZaSqN9VZJ30Dq
         DEo6ENsMnLnJ87IgEKZBj8VSAJBbpiLMV5I9w=
From: Changli Gao <xiaosuo@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Takashi Iwai <tiwai@suse.de>,
       David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] epoll: use wrapper functions
Date: Thu,  6 May 2010 09:57:34 +0800
Message-Id: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use wrapper functions.

epoll should not touch flags in wait_queue_t. This patch introduces a new
function add_wait_queue_head_exclusive_locked(), for the users, who use
wait queue as a LIFO queue.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/eventpoll.c       |    5 ++---
 include/linux/wait.h |   15 +++++++++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bd056a5..8137f6e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1140,8 +1140,7 @@ retry:
 		 * ep_poll_callback() when events will become available.
 		 */
 		init_waitqueue_entry(&wait, current);
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue(&ep->wq, &wait);
+		add_wait_queue_head_exclusive_locked(&ep->wq, &wait);
 
 		for (;;) {
 			/*
@@ -1161,7 +1160,7 @@ retry:
 			jtimeout = schedule_timeout(jtimeout);
 			spin_lock_irqsave(&ep->lock, flags);
 		}
-		__remove_wait_queue(&ep->wq, &wait);
+		remove_wait_queue_locked(&ep->wq, &wait);
 
 		set_current_state(TASK_RUNNING);
 	}
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a48e16b..de2566d 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -407,17 +407,28 @@ do {									\
  * Must be called with the spinlock in the wait_queue_head_t held.
  */
 static inline void add_wait_queue_exclusive_locked(wait_queue_head_t *q,
-						   wait_queue_t * wait)
+						   wait_queue_t *wait)
 {
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	__add_wait_queue_tail(q,  wait);
 }
 
 /*
+ * Must be called with the spinlock in the wait_queue_head_t held, and
+ * q must be for exclusive wait only.
+ */
+static inline void add_wait_queue_head_exclusive_locked(wait_queue_head_t *q,
+							wait_queue_t *wait)
+{
+	wait->flags |= WQ_FLAG_EXCLUSIVE;
+	__add_wait_queue(q,  wait);
+}
+
+/*
  * Must be called with the spinlock in the wait_queue_head_t held.
  */
 static inline void remove_wait_queue_locked(wait_queue_head_t *q,
-					    wait_queue_t * wait)
+					    wait_queue_t *wait)
 {
 	__remove_wait_queue(q,  wait);
 }
