Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2C1N5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:57:55 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:33537 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752788Ab2C1N5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:57:53 -0400
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Hagen Paul Pfeifer <hagen@jauu.net>
Subject: [PATCH Resend] epoll: add EPOLLEXCLUSIVE support
Date: Wed, 28 Mar 2012 15:57:40 +0200
Message-Id: <1332943060-18374-1-git-send-email-hagen@jauu.net>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

High performance server sometimes create one listening socket (e.g. port
80), create a epoll file descriptor and add the socket. Afterwards
create SC_NPROCESSORS_ONLN threads and wait for events. This often
result in a thundering herd problem because all CPUs are scheduled.

This patch add an additional flag to epoll_ctl(2) called EPOLLEXCLUSIVE.
If a descriptor is added with this flag only one CPU is scheduled in.

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
---
Dave rejected the patch and said not network specific. Because there
is no epoll maintainer this time directly.

 fs/eventpoll.c            |    7 +++++--
 include/linux/eventpoll.h |    3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 629e9ed..16d787f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -88,7 +88,7 @@
  */
 
 /* Epoll private bits inside the event mask */
-#define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET)
+#define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET | EPOLLEXCLUSIVE)
 
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
@@ -969,7 +969,10 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		pwq->whead = whead;
 		pwq->base = epi;
-		add_wait_queue(whead, &pwq->wait);
+		if (unlikely(epi->event.events & EPOLLEXCLUSIVE))
+			add_wait_queue_exclusive(whead, &pwq->wait);
+		else
+			add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
 	} else {
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 657ab55..d334389 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -26,6 +26,9 @@
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
 
+/* Set Exclusive wake up behaviour for the target file descriptor */
+#define EPOLLEXCLUSIVE (1 << 29)
+
 /* Set the One Shot behaviour for the target file descriptor */
 #define EPOLLONESHOT (1 << 30)
 
-- 
1.7.9.1

