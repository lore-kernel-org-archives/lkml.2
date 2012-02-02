Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2BBK2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:28:41 -0500
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4469 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2BBK2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:28:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv7 PATCH 1/4] eventpoll: set key to the correct events mask.
Date: Thu,  2 Feb 2012 11:26:54 +0100
Message-Id: <a92b9a00741769f3c38a54d3a6799509f9089452.1328176079.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
References: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

The eventpoll implementation always left the key field at ~0 instead of
using the requested events mask.

This was changed so the key field now contains the actual events that
should be polled for as set by the caller.

This information is needed by drivers that need to e.g. start DMA if the
caller wants to poll for incoming data as opposed to, say, exceptions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 fs/eventpoll.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index aabdfc3..ca47608 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -682,9 +682,12 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			       void *priv)
 {
 	struct epitem *epi, *tmp;
+	poll_table pt;
 
+	init_poll_funcptr(&pt, NULL);
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		if (epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		if (epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 		    epi->event.events)
 			return POLLIN | POLLRDNORM;
 		else {
@@ -1065,6 +1068,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
+	epq.pt.key = event->events;
 
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
@@ -1159,6 +1163,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 {
 	int pwake = 0;
 	unsigned int revents;
+	poll_table pt;
+
+	init_poll_funcptr(&pt, NULL);
 
 	/*
 	 * Set the new event interest mask before calling f_op->poll();
@@ -1166,13 +1173,14 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * f_op->poll() call and the new event set registering.
 	 */
 	epi->event.events = event->events;
+	pt.key = event->events;
 	epi->event.data = event->data; /* protected by mtx */
 
 	/*
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
+	revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1207,6 +1215,9 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	unsigned int revents;
 	struct epitem *epi;
 	struct epoll_event __user *uevent;
+	poll_table pt;
+
+	init_poll_funcptr(&pt, NULL);
 
 	/*
 	 * We can loop without lock because we are passed a task private list.
@@ -1219,7 +1230,8 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 
 		list_del_init(&epi->rdllink);
 
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 			epi->event.events;
 
 		/*
-- 
1.7.8.3

