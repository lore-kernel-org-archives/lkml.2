Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0J0TJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:09:26 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39266 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab0J0TJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:09:24 -0400
Message-Id: <20101027190921.059806977@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Wed, 27 Oct 2010 14:09:15 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [Patch] Convert max_user_watches to long.
References: <20101027190914.146006767@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=max_user_watches_overflow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 16TB machine, max_user_watches has an integer overflow.  Convert it
to use a long and handle the associated fallout.


Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>

---

 fs/eventpoll.c        |   20 ++++++++++++--------
 include/linux/sched.h |    2 +-
 2 files changed, 13 insertions(+), 9 deletions(-)

Index: pv1010933/fs/eventpoll.c
===================================================================
--- pv1010933.orig/fs/eventpoll.c	2010-10-27 14:04:44.000000000 -0500
+++ pv1010933/fs/eventpoll.c	2010-10-27 14:07:50.211457551 -0500
@@ -220,7 +220,7 @@ struct ep_send_events_data {
  * Configuration options available inside /proc/sys/fs/epoll/
  */
 /* Maximum number of epoll watched descriptors, per user */
-static int max_user_watches __read_mostly;
+static long max_user_watches __read_mostly;
 
 /*
  * This mutex is used to serialize ep_free() and eventpoll_release_file().
@@ -243,16 +243,18 @@ static struct kmem_cache *pwq_cache __re
 
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
@@ -564,7 +566,7 @@ static int ep_remove(struct eventpoll *e
 	/* At this point it is safe to free the eventpoll item */
 	kmem_cache_free(epi_cache, epi);
 
-	atomic_dec(&ep->user->epoll_watches);
+	atomic_long_dec(&ep->user->epoll_watches);
 
 	return 0;
 }
@@ -900,11 +902,12 @@ static int ep_insert(struct eventpoll *e
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
@@ -968,7 +971,7 @@ static int ep_insert(struct eventpoll *e
 
 	spin_unlock_irqrestore(&ep->lock, flags);
 
-	atomic_inc(&ep->user->epoll_watches);
+	atomic_long_inc(&ep->user->epoll_watches);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -1422,6 +1425,7 @@ static int __init eventpoll_init(void)
 	 */
 	max_user_watches = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) /
 		EP_ITEM_COST;
+	BUG_ON(max_user_watches < 0);
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
Index: pv1010933/include/linux/sched.h
===================================================================
--- pv1010933.orig/include/linux/sched.h	2010-10-27 14:04:44.000000000 -0500
+++ pv1010933/include/linux/sched.h	2010-10-27 14:04:47.119415143 -0500
@@ -666,7 +666,7 @@ struct user_struct {
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
 #ifdef CONFIG_EPOLL
-	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
+	atomic_long_t epoll_watches; /* The number of file descriptors currently watched */
 #endif
 #ifdef CONFIG_POSIX_MQUEUE
 	/* protected by mq_lock	*/

