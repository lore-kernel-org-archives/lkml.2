Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1LULkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:40:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33940 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1LULko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:40:44 -0500
Date: Wed, 21 Dec 2011 03:40:23 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-8zpopbny51023rdb0qq67eye@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep/waitqueues: Add better annotation
Git-Commit-ID: f07fdec50a13f134ea9608c8fb3f6408c58ef55e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:40:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f07fdec50a13f134ea9608c8fb3f6408c58ef55e
Gitweb:     http://git.kernel.org/tip/f07fdec50a13f134ea9608c8fb3f6408c58ef55e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 13 Dec 2011 13:20:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:07:39 +0100

lockdep/waitqueues: Add better annotation

 -> #2 (&tty->write_wait){-.-...}:

is a lot more informative than:

 -> #2 (key#19){-.....}:

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-8zpopbny51023rdb0qq67eye@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/wait.h |    4 ++--
 kernel/wait.c        |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 3efc9f3..a9ce45e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -77,13 +77,13 @@ struct task_struct;
 #define __WAIT_BIT_KEY_INITIALIZER(word, bit)				\
 	{ .flags = word, .bit_nr = bit, }
 
-extern void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *);
+extern void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *);
 
 #define init_waitqueue_head(q)				\
 	do {						\
 		static struct lock_class_key __key;	\
 							\
-		__init_waitqueue_head((q), &__key);	\
+		__init_waitqueue_head((q), #q, &__key);	\
 	} while (0)
 
 #ifdef CONFIG_LOCKDEP
diff --git a/kernel/wait.c b/kernel/wait.c
index 26fa779..7fdd9ea 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -10,10 +10,10 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 
-void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *key)
+void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
 {
 	spin_lock_init(&q->lock);
-	lockdep_set_class(&q->lock, key);
+	lockdep_set_class_and_name(&q->lock, key, name);
 	INIT_LIST_HEAD(&q->task_list);
 }
 
