Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2EAFeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 01:34:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42329 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab2EAFd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 01:33:59 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready
Date: Mon, 30 Apr 2012 22:33:48 -0700
Message-Id: <1335850428-30883-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com>
References: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com>
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

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/eventpoll.c             |   90 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/capability.h |    5 ++-
 include/linux/eventpoll.h  |   12 ++++++
 3 files changed, 103 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 739b098..1abed50 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -33,6 +33,7 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/anon_inodes.h>
+#include <linux/device.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/mman.h>
@@ -87,7 +88,7 @@
  */
 
 /* Epoll private bits inside the event mask */
-#define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET)
+#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET)
 
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
@@ -154,6 +155,9 @@ struct epitem {
 	/* List header used to link this item to the "struct file" items list */
 	struct list_head fllink;
 
+	/* wakeup_source used when EPOLLWAKEUP is set */
+	struct wakeup_source *ws;
+
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
 };
@@ -194,6 +198,9 @@ struct eventpoll {
 	 */
 	struct epitem *ovflist;
 
+	/* wakeup_source used when ep_scan_ready_list is running */
+	struct wakeup_source *ws;
+
 	/* The user that created the eventpoll descriptor */
 	struct user_struct *user;
 
@@ -588,8 +595,10 @@ static int ep_scan_ready_list(struct eventpoll *ep,
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
@@ -602,6 +611,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * Quickly re-inject items left on "txlist".
 	 */
 	list_splice(&txlist, &ep->rdllist);
+	__pm_relax(ep->ws);
 
 	if (!list_empty(&ep->rdllist)) {
 		/*
@@ -656,6 +666,8 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);
 
+	wakeup_source_unregister(epi->ws);
+
 	/* At this point it is safe to free the eventpoll item */
 	kmem_cache_free(epi_cache, epi);
 
@@ -706,6 +718,7 @@ static void ep_free(struct eventpoll *ep)
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
 	free_uid(ep->user);
+	wakeup_source_unregister(ep->ws);
 	kfree(ep);
 }
 
@@ -737,6 +750,7 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			 * callback, but it's not actually ready, as far as
 			 * caller requested events goes. We can remove it here.
 			 */
+			__pm_relax(epi->ws);
 			list_del_init(&epi->rdllink);
 		}
 	}
@@ -927,13 +941,23 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 		if (epi->next == EP_UNACTIVE_PTR) {
 			epi->next = ep->ovflist;
 			ep->ovflist = epi;
+			if (epi->ws) {
+				/*
+				 * Activate ep->ws since epi->ws may get
+				 * deactivated at any time.
+				 */
+				__pm_stay_awake(ep->ws);
+			}
+
 		}
 		goto out_unlock;
 	}
 
 	/* If this file is already in the ready list we exit soon */
-	if (!ep_is_linked(&epi->rdllink))
+	if (!ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
+		__pm_stay_awake(epi->ws);
+	}
 
 	/*
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
@@ -1091,6 +1115,30 @@ static int reverse_path_check(void)
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
@@ -1118,6 +1166,13 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
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
@@ -1164,6 +1219,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	/* If the file is already "ready" we drop it inside the ready list */
 	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
+		__pm_stay_awake(epi->ws);
 
 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
@@ -1204,6 +1260,9 @@ error_unregister:
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);
 
+	wakeup_source_unregister(epi->ws);
+
+error_create_wakeup_source:
 	kmem_cache_free(epi_cache, epi);
 
 	return error;
@@ -1229,6 +1288,12 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	epi->event.events = event->events;
 	pt._key = event->events;
 	epi->event.data = event->data; /* protected by mtx */
+	if (epi->event.events & EPOLLWAKEUP) {
+		if (!epi->ws)
+			ep_create_wakeup_source(epi);
+	} else if (epi->ws) {
+		ep_destroy_wakeup_source(epi);
+	}
 
 	/*
 	 * Get current event bits. We can safely use the file* here because
@@ -1244,6 +1309,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
+			__pm_stay_awake(epi->ws);
 
 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
@@ -1282,6 +1348,18 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	     !list_empty(head) && eventcnt < esed->maxevents;) {
 		epi = list_first_entry(head, struct epitem, rdllink);
 
+		/*
+		 * Activate ep->ws before deactivating epi->ws to prevent
+		 * triggering auto-suspend here (in case we reactive epi->ws
+		 * below).
+		 *
+		 * This could be rearranged to delay the deactivation of epi->ws
+		 * instead, but then epi->ws would temporarily be out of sync
+		 * with ep_is_linked().
+		 */
+		if (epi->ws && epi->ws->active)
+			__pm_stay_awake(ep->ws);
+		__pm_relax(epi->ws);
 		list_del_init(&epi->rdllink);
 
 		pt._key = epi->event.events;
@@ -1298,6 +1376,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
 				list_add(&epi->rdllink, head);
+				__pm_stay_awake(epi->ws);
 				return eventcnt ? eventcnt : -EFAULT;
 			}
 			eventcnt++;
@@ -1317,6 +1396,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 				 * poll callback will queue them in ep->ovflist.
 				 */
 				list_add_tail(&epi->rdllink, &ep->rdllist);
+				__pm_stay_awake(epi->ws);
 			}
 		}
 	}
@@ -1629,6 +1709,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	if (!tfile->f_op || !tfile->f_op->poll)
 		goto error_tgt_fput;
 
+	/* Check if EPOLLWAKEUP is allowed */
+	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_EPOLLWAKEUP))
+		goto error_tgt_fput;
+
 	/*
 	 * We have to check that the file structure underneath the file descriptor
 	 * the user passed to us _is_ an eventpoll file. And also we do not permit
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 12d52de..222974a 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -360,8 +360,11 @@ struct cpu_vfs_cap_data {
 
 #define CAP_WAKE_ALARM            35
 
+/* Allow preventing automatic system suspends while epoll events are pending */
 
-#define CAP_LAST_CAP         CAP_WAKE_ALARM
+#define CAP_EPOLLWAKEUP      36
+
+#define CAP_LAST_CAP         CAP_EPOLLWAKEUP
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 657ab55..5b591fb 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -26,6 +26,18 @@
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
 
+/*
+ * Request the handling of system wakeup events so as to prevent automatic
+ * system suspends from happening while those events are being processed.
+ *
+ * Assuming neither EPOLLET nor EPOLLONESHOT is set, automatic system suspends
+ * will not be re-allowed until epoll_wait is called again after consuming the
+ * wakeup event(s).
+ *
+ * Requires CAP_EPOLLWAKEUP
+ */
+#define EPOLLWAKEUP (1 << 29)
+
 /* Set the One Shot behaviour for the target file descriptor */
 #define EPOLLONESHOT (1 << 30)
 
-- 
1.7.7.3

