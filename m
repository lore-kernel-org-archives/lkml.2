Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab2CFBEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:04:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44809 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab2CFBEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:04:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arve@android.com designates 10.68.234.166 as permitted sender) smtp.mail=arve@android.com
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, jeffbrown@android.com,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 1/2] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready
Date: Mon,  5 Mar 2012 17:04:31 -0800
Message-Id: <1330995872-4491-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <201203042356.17846.rjw@sisk.pl>
References: <201203042356.17846.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
wakeup_source will be active to prevent suspend. This can be used to
handle wakeup events from a driver that support poll, e.g. input, if
that driver wakes up the waitqueue passed to epoll before allowing
suspend.

The current implementation uses an extra wakeup_source when
ep_scan_ready_list runs. This can cause problems if a single thread
is polling on wakeup events and frequent non-wakeup events (events
usually arrive during thread freezing) using the same epoll file.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 fs/eventpoll.c            |   71 +++++++++++++++++++++++++++++++++++++++++++--
 include/linux/eventpoll.h |    6 ++++
 2 files changed, 74 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index aabdfc3..6263ac6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -33,6 +33,7 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/anon_inodes.h>
+#include <linux/device.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/io.h>
@@ -88,7 +89,7 @@
  */
 
 /* Epoll private bits inside the event mask */
-#define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET)
+#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET)
 
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
@@ -155,6 +156,9 @@ struct epitem {
 	/* List header used to link this item to the "struct file" items list */
 	struct list_head fllink;
 
+	/* wakeup_source used when EPOLLWAKEUP is set */
+	struct wakeup_source *ws;
+
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
 };
@@ -195,6 +199,9 @@ struct eventpoll {
 	 */
 	struct epitem *ovflist;
 
+	/* wakeup_source used when ep_scan_ready_list is running */
+	struct wakeup_source *ws;
+
 	/* The user that created the eventpoll descriptor */
 	struct user_struct *user;
 
@@ -524,6 +531,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * in a lockless way.
 	 */
 	spin_lock_irqsave(&ep->lock, flags);
+	__pm_stay_awake(ep->ws);
 	list_splice_init(&ep->rdllist, &txlist);
 	ep->ovflist = NULL;
 	spin_unlock_irqrestore(&ep->lock, flags);
@@ -547,8 +555,10 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 		 * queued into ->ovflist but the "txlist" might already
 		 * contain them, and the list_splice() below takes care of them.
 		 */
-		if (!ep_is_linked(&epi->rdllink))
+		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
+			__pm_stay_awake(epi->ws);
+		}
 	}
 	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
@@ -561,6 +571,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * Quickly re-inject items left on "txlist".
 	 */
 	list_splice(&txlist, &ep->rdllist);
+	__pm_relax(ep->ws);
 
 	if (!list_empty(&ep->rdllist)) {
 		/*
@@ -615,6 +626,9 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);
 
+	if (epi->ws)
+		wakeup_source_unregister(epi->ws);
+
 	/* At this point it is safe to free the eventpoll item */
 	kmem_cache_free(epi_cache, epi);
 
@@ -665,6 +679,8 @@ static void ep_free(struct eventpoll *ep)
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
 	free_uid(ep->user);
+	if (ep->ws)
+		wakeup_source_unregister(ep->ws);
 	kfree(ep);
 }
 
@@ -693,6 +709,7 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			 * callback, but it's not actually ready, as far as
 			 * caller requested events goes. We can remove it here.
 			 */
+			__pm_relax(epi->ws);
 			list_del_init(&epi->rdllink);
 		}
 	}
@@ -877,8 +894,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	}
 
 	/* If this file is already in the ready list we exit soon */
-	if (!ep_is_linked(&epi->rdllink))
+	if (!ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
+		__pm_stay_awake(epi->ws);
+	}
 
 	/*
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
@@ -1034,6 +1053,30 @@ static int reverse_path_check(void)
 	return error;
 }
 
+static int ep_create_wakeup_source(struct epitem *epi)
+{
+	const char *name;
+
+	if (!epi->ep->ws) {
+		epi->ep->ws = wakeup_source_register("eventpoll");
+		if (!epi->ep->ws)
+			return -ENOMEM;
+	}
+
+	name = epi->ffd.file->f_path.dentry->d_name.name;
+	epi->ws = wakeup_source_register(name);
+	if (!epi->ws)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void ep_destroy_wakeup_source(struct epitem *epi)
+{
+	wakeup_source_unregister(epi->ws);
+	epi->ws = NULL;
+}
+
 /*
  * Must be called with "mtx" held.
  */
@@ -1061,6 +1104,13 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	epi->event = *event;
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
+	if (epi->event.events & EPOLLWAKEUP) {
+		error = ep_create_wakeup_source(epi);
+		if (error)
+			goto error_create_wakeup_source;
+	} else {
+		epi->ws = NULL;
+	}
 
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
@@ -1106,6 +1156,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	/* If the file is already "ready" we drop it inside the ready list */
 	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
+		__pm_stay_awake(epi->ws);
 
 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
@@ -1146,6 +1197,10 @@ error_unregister:
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);
 
+	if (epi->ws)
+		wakeup_source_unregister(epi->ws);
+
+error_create_wakeup_source:
 	kmem_cache_free(epi_cache, epi);
 
 	return error;
@@ -1167,6 +1222,12 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 */
 	epi->event.events = event->events;
 	epi->event.data = event->data; /* protected by mtx */
+	if (epi->event.events & EPOLLWAKEUP) {
+		if (!epi->ws)
+			ep_create_wakeup_source(epi);
+	} else if (epi->ws) {
+		ep_destroy_wakeup_source(epi);
+	}
 
 	/*
 	 * Get current event bits. We can safely use the file* here because
@@ -1182,6 +1243,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
+			__pm_stay_awake(epi->ws);
 
 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
@@ -1217,6 +1279,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	     !list_empty(head) && eventcnt < esed->maxevents;) {
 		epi = list_first_entry(head, struct epitem, rdllink);
 
+		__pm_relax(epi->ws);
 		list_del_init(&epi->rdllink);
 
 		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
@@ -1232,6 +1295,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
 				list_add(&epi->rdllink, head);
+				__pm_stay_awake(epi->ws);
 				return eventcnt ? eventcnt : -EFAULT;
 			}
 			eventcnt++;
@@ -1251,6 +1315,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 				 * poll callback will queue them in ep->ovflist.
 				 */
 				list_add_tail(&epi->rdllink, &ep->rdllist);
+				__pm_stay_awake(epi->ws);
 			}
 		}
 	}
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 657ab55..520a57c 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -26,6 +26,12 @@
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
 
+/*
+ * Request the handling of system wakeup events so as to prevent automatic
+ * system suspends from happening while those events are being processed.
+ */
+#define EPOLLWAKEUP (1 << 29)
+
 /* Set the One Shot behaviour for the target file descriptor */
 #define EPOLLONESHOT (1 << 30)
 
-- 
1.7.7.3

