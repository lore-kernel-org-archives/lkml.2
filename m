Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0HBFcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 01:32:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41065 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0HBFcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 01:32:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZYhSfju8T3eC+QTgu/mibNwaIe3gstVGgSkcWOB8UWNirDoOe6i2rdcnykNntWoNVA
         IdzVVLWipN0hvbuS4idjcx4g/bnRZM0JDZQcP/uKaRVlozU8rpL7Qn3TQsEXtqGxUjtM
         cy2CSlLNXw+AzvHdFKoM78RQnjmZCM4qKhNho=
Message-ID: <4C565845.30307@gmail.com>
Date: Mon, 02 Aug 2010 13:31:49 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] New EPOLL flag: EPOLLHEAD
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch introduces to new epoll flag EPOLLHEAD. Using this flag, the trigged events will be insert at head of ready events linked list, so they likely can be processed earlier in user space. In fact, this is the most simplest events priority, is it right?

BTW: I did not subscribe linux-fsdevel mail list, so please also send reply to my gmail, thanks!

Signed-off-by: Li Yu <raise.sail@gmail.com>
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 3817149..ddd1500 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -72,7 +72,7 @@
  */
 
 /* Epoll private bits inside the event mask */
-#define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET)
+#define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET | EPOLLHEAD)
 
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
@@ -281,6 +281,15 @@ static inline int ep_is_linked(struct list_head *p)
 	return !list_empty(p);
 }
 
+/* The events with EPOLLHEAD can be detected first by user space. */
+static inline void ep_event_ready(struct eventpoll *ep, struct epitem *epi)
+{
+	if (epi->event.events & EPOLLHEAD)
+		list_add(&epi->rdllink, &ep->rdllist);
+	else
+		list_add_tail(&epi->rdllink, &ep->rdllist);
+}
+
 /* Get the "struct epitem" from a wait queue pointer */
 static inline struct epitem *ep_item_from_wait(wait_queue_t *p)
 {
@@ -494,7 +503,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 		 * contain them, and the list_splice() below takes care of them.
 		 */
 		if (!ep_is_linked(&epi->rdllink))
-			list_add_tail(&epi->rdllink, &ep->rdllist);
+			ep_event_ready(ep, epi);
 	}
 	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
@@ -829,7 +838,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 
 	/* If this file is already in the ready list we exit soon */
 	if (!ep_is_linked(&epi->rdllink))
-		list_add_tail(&epi->rdllink, &ep->rdllist);
+		ep_event_ready(ep, epi);
 
 	/*
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
@@ -957,7 +966,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	/* If the file is already "ready" we drop it inside the ready list */
 	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
-		list_add_tail(&epi->rdllink, &ep->rdllist);
+		ep_event_ready(ep, epi);
 
 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
@@ -1025,7 +1034,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	if (revents & event->events) {
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
-			list_add_tail(&epi->rdllink, &ep->rdllist);
+			ep_event_ready(ep, epi);
 
 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
@@ -1094,7 +1103,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 				 * ep_scan_ready_list() holding "mtx" and the
 				 * poll callback will queue them in ep->ovflist.
 				 */
-				list_add_tail(&epi->rdllink, &ep->rdllist);
+				ep_event_ready(ep, epi);
 			}
 		}
 	}
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index f6856a5..b7658e1 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -26,6 +26,9 @@
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
 
+/* When target file descriptor is ready, insert it into head of ready list */
+#define EPOLLHEAD (1 << 29)
+
 /* Set the One Shot behaviour for the target file descriptor */
 #define EPOLLONESHOT (1 << 30)
 
