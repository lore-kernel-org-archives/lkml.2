Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab0HHWqJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 18:46:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60066 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab0HHWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 18:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HAMdKMevuS/4eRxhM6kxDqdFWGut2jQpyJuyZYopNRNxruJY9VYYC2fJ8kDgVevryD
         vBApZenPxghb7s5Ca0zX70lh1b/fftq9MufjtO3LkWYS7rVyDpUeJRIcJDIBOG0nqXRi
         qoAG0YmHyraVSdWuAhNgMZcBpJIfDqG6OKzUY=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH] hrtimer: make epoll_wait() use the hrtimer range feature
Date: Sun,  8 Aug 2010 17:45:32 -0500
Message-Id: <1281307532-3235-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This make epoll use hrtimers for the timeout value which prevents
epoll_wait() from timing out up to a millisecond early.

This mirrors the behavior of select() and poll().

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 fs/eventpoll.c       |   35 +++++++++++++++++++----------------
 fs/select.c          |    2 +-
 include/linux/poll.h |    2 ++
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 3817149..728f56c 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -77,9 +77,6 @@
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
 
-/* Maximum msec timeout value storeable in a long int */
-#define EP_MAX_MSTIMEO min(1000ULL * MAX_SCHEDULE_TIMEOUT / HZ, (LONG_MAX - 999ULL) / HZ)
-
 #define EP_MAX_EVENTS (INT_MAX / sizeof(struct epoll_event))
 
 #define EP_UNACTIVE_PTR ((void *) -1L)
@@ -1116,18 +1113,22 @@ static int ep_send_events(struct eventpoll *ep,
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res, eavail;
+	int res, eavail, timed_out = 0;
 	unsigned long flags;
-	long jtimeout;
+	long slack;
 	wait_queue_t wait;
-
-	/*
-	 * Calculate the timeout by checking for the "infinite" value (-1)
-	 * and the overflow condition. The passed timeout is in milliseconds,
-	 * that why (t * HZ) / 1000.
-	 */
-	jtimeout = (timeout < 0 || timeout >= EP_MAX_MSTIMEO) ?
-		MAX_SCHEDULE_TIMEOUT : (timeout * HZ + 999) / 1000;
+	struct timespec end_time;
+	ktime_t expires, *to = NULL;
+
+	if (timeout > 0) {
+		ktime_get_ts(&end_time);
+		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
+		slack = estimate_accuracy(&end_time);
+		to = &expires;
+		*to = timespec_to_ktime(end_time);
+	} else if (timeout == 0) {
+		timed_out = 1;
+	}
 
 retry:
 	spin_lock_irqsave(&ep->lock, flags);
@@ -1149,7 +1150,7 @@ retry:
 			 * to TASK_INTERRUPTIBLE before doing the checks.
 			 */
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (!list_empty(&ep->rdllist) || !jtimeout)
+			if (!list_empty(&ep->rdllist) || timed_out)
 				break;
 			if (signal_pending(current)) {
 				res = -EINTR;
@@ -1157,7 +1158,9 @@ retry:
 			}
 
 			spin_unlock_irqrestore(&ep->lock, flags);
-			jtimeout = schedule_timeout(jtimeout);
+			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+				timed_out = 1;
+
 			spin_lock_irqsave(&ep->lock, flags);
 		}
 		__remove_wait_queue(&ep->wq, &wait);
@@ -1175,7 +1178,7 @@ retry:
 	 * more luck.
 	 */
 	if (!res && eavail &&
-	    !(res = ep_send_events(ep, events, maxevents)) && jtimeout)
+	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
 		goto retry;
 
 	return res;
diff --git a/fs/select.c b/fs/select.c
index 500a669..003cb77 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -67,7 +67,7 @@ static long __estimate_accuracy(struct timespec *tv)
 	return slack;
 }
 
-static long estimate_accuracy(struct timespec *tv)
+long estimate_accuracy(struct timespec *tv)
 {
 	unsigned long ret;
 	struct timespec now;
diff --git a/include/linux/poll.h b/include/linux/poll.h
index 600cc1f..52be81f 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -73,6 +73,8 @@ extern void poll_initwait(struct poll_wqueues *pwq);
 extern void poll_freewait(struct poll_wqueues *pwq);
 extern int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
 				 ktime_t *expires, unsigned long slack);
+extern long estimate_accuracy(struct timespec *tv);
+
 
 static inline int poll_schedule(struct poll_wqueues *pwq, int state)
 {
-- 
1.7.2.1

