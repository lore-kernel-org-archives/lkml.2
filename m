Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1AOTnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 14:43:47 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:40974 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1AOTnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 14:43:46 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 15 Jan 2011 11:43:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [patch 2/2] fix compiler warning and optimize the non-blocking
 path
Message-ID: <alpine.DEB.2.00.1101151137590.6884@davide-lnx1>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a comment to ep_poll(), renames labels a bit clearly, 
fixes a warning of unused variable from gcc, and optimizes the 
non-blocking path a little.



From: Shawn Bohrer <shawn.bohrer@gmail.com>
Hinted-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2011-01-15 10:50:16.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2011-01-15 11:01:33.000000000 -0800
@@ -1127,27 +1127,50 @@
 	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
 }
 
+/**
+ * ep_poll - Retrieves ready events, and delivers them to the caller supplied
+ *           event buffer.
+ *
+ * @ep: Pointer to the eventpoll context.
+ * @events: Pointer to the userspace buffer where the ready events should be
+ *          stored.
+ * @maxevents: Size (in terms of number of events) of the caller event buffer.
+ * @timeout: Maximum timeout for the ready events fetch operation, in
+ *           milliseconds. If the @timeout is zero, the function will not block,
+ *           while if the @timeout is less than zero, the function will block
+ *           until at least one event has been retrieved (or an error
+ *           occurred).
+ *
+ * Returns: Returns the number of ready events which have been fetched, or an
+ *          error code, in case of error.
+ */
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
 	int res, eavail, timed_out = 0;
 	unsigned long flags;
-	long slack;
+	long slack = 0;
 	wait_queue_t wait;
 	struct timespec end_time;
 	ktime_t expires, *to = NULL;
 
 	if (timeout > 0) {
 		ktime_get_ts(&end_time);
-		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
+		timespec_add_ns(&end_time, (u64) timeout * NSEC_PER_MSEC);
 		slack = select_estimate_accuracy(&end_time);
 		to = &expires;
 		*to = timespec_to_ktime(end_time);
 	} else if (timeout == 0) {
+		/*
+		 * Avoid the unnecessary trip to the wait queue loop, if the
+		 * caller specified a non blocking operation.
+		 */
 		timed_out = 1;
+		spin_lock_irqsave(&ep->lock, flags);
+		goto check_events;
 	}
 
-retry:
+fetch_events:
 	spin_lock_irqsave(&ep->lock, flags);
 
 	res = 0;
@@ -1184,6 +1207,7 @@
 
 		set_current_state(TASK_RUNNING);
 	}
+check_events:
 	/* Is it worth to try to dig for events ? */
 	eavail = ep_events_available(ep);
 
@@ -1196,7 +1220,7 @@
 	 */
 	if (!res && eavail &&
 	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
-		goto retry;
+		goto fetch_events;
 
 	return res;
 }
