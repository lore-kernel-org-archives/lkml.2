Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785Ab1FWRpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:45:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:35608 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933824Ab1FWRij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Robin Holt <holt@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 229/247] epoll: convert max_user_watches to long
Date: Thu, 23 Jun 2011 13:34:57 -0400
Message-Id: <1308850515-15242-170-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 52bd19f7691b2ea6433aef0ef94c08c57efd7e79 upstream.

On a 16TB machine, max_user_watches has an integer overflow.  Convert it
to use a long and handle the associated fallout.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/eventpoll.c        |   20 ++++++++++++--------
 include/linux/sched.h |    2 +-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a8dfe21..85c5a9f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -227,7 +227,7 @@ struct ep_send_events_data {
  * Configuration options available inside /proc/sys/fs/epoll/
  */
 /* Maximum number of epoll watched descriptors, per user */
-static int max_user_watches __read_mostly;
+static long max_user_watches __read_mostly;
 
 /*
  * This mutex is used to serialize ep_free() and eventpoll_release_file().
@@ -253,16 +253,18 @@ static struct kmem_cache *pwq_cache __read_mostly;
 
 #include <linux/sysctl.h>
 
-static int zero;
+static long zero;
+static long long_max = LONG_MAX;
 
 ctl_table epoll_table[] = {
 	{
 		.procname	= "max_user_watches",
 		.data		= &max_user_watches,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(max_user_watches),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 		.extra1		= &zero,
+		.extra2		= &long_max,
 	},
 	{ }
 };
@@ -574,7 +576,7 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	/* At this point it is safe to free the eventpoll item */
 	kmem_cache_free(epi_cache, epi);
 
-	atomic_dec(&ep->user->epoll_watches);
+	atomic_long_dec(&ep->user->epoll_watches);
 
 	return 0;
 }
@@ -910,11 +912,12 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 {
 	int error, revents, pwake = 0;
 	unsigned long flags;
+	long user_watches;
 	struct epitem *epi;
 	struct ep_pqueue epq;
 
-	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
-		     max_user_watches))
+	user_watches = atomic_long_read(&ep->user->epoll_watches);
+	if (unlikely(user_watches >= max_user_watches))
 		return -ENOSPC;
 	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
 		return -ENOMEM;
@@ -978,7 +981,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	spin_unlock_irqrestore(&ep->lock, flags);
 
-	atomic_inc(&ep->user->epoll_watches);
+	atomic_long_inc(&ep->user->epoll_watches);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -1512,6 +1515,7 @@ static int __init eventpoll_init(void)
 	 */
 	max_user_watches = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) /
 		EP_ITEM_COST;
+	BUG_ON(max_user_watches < 0);
 
 	/*
 	 * Initialize the structure used to perform epoll file descriptor
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 03e34c5..c66e0af 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -672,7 +672,7 @@ struct user_struct {
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
 #ifdef CONFIG_EPOLL
-	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
+	atomic_long_t epoll_watches; /* The number of file descriptors currently watched */
 #endif
 #ifdef CONFIG_POSIX_MQUEUE
 	/* protected by mq_lock	*/
-- 
1.7.4.4

