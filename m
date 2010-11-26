Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0KZLl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:41:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:37294 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753638Ab0KZLlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:41:55 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1834Sw6lOU3LdAG0imAKv8HyLlBAnP9Z0Q+ceq19h
	9EiH3kbosv5p3s
Date: Fri, 26 Nov 2010 12:39:58 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fsnotify: Do not always merge overflow events
Message-ID: <20101126113958.GB11676@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we always merge an overflow event if such an event already exists
somewhere in the notification queue. This makes it hard to determine how
often the limit of the queue has actually been exceeded. But this information could
be useful as a hint that the queue is overloaded permanently.
With this patch we only merge an overflow event if the last event in the
queue is also an overflow event.

An example explains the new behaviour (PU = another event is generated and pushed
into the event queue, PO = an event is read by userspace and popped from the
queue, E = Event, O = Overflow event) for a queue with a max number of queued
events of 4 whereby 3 events are already queued.

1. E E E
   PU
2. E E E E
   PU -> queue full, generate overflow event
3. E E E E O
   PU -> queue full, last event already overflow event, so do nothing
4. E E E E O
   PO
5. E E E O
   PU -> queue full, last event already overflow event, so do nothing
6. E E E O
   PO -> queue ready to take events again
7. E E O
   PU
8. E E O E
   PU -> queue full, generate overflow event
9. E E O E O

Now a listener could see that the queue has been overflowed 2 times. With the
recent implementation it would only know that the queue has been overflowed at 
least one time.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/notification.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

 This patch applies against patch "Dont try to open a file descriptor for the overflow event"
 that was sent to lkml on Nov 24.

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index f39260f..e82dabc 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -165,21 +165,30 @@ alloc_holder:
 
 	mutex_lock(&group->notification_mutex);
 
-	if (group->q_len >= group->max_events) {
-		event = q_overflow_event;
+	if (group->q_len >= group->max_events) {	/* overflow */
+		struct fsnotify_event_holder *last;
+
+		BUG_ON(list_empty(list));
 
 		/*
 		 * we need to return the overflow event
 		 * which means we need a ref
 		 */
+		event = q_overflow_event;
 		fsnotify_get_event(event);
+		last = list_entry(list->prev, struct fsnotify_event_holder,
+				  event_list);
+		if (last->event == q_overflow_event) {
+			mutex_unlock(&group->notification_mutex);
+			if (holder)
+				fsnotify_destroy_event_holder(holder);
+			return q_overflow_event;
+		}
 		return_event = event;
 
 		/* sorry, no private data on the overflow event */
 		priv = NULL;
-	}
-
-	if (!list_empty(list) && merge) {
+	} else if (!list_empty(list) && merge) {
 		struct fsnotify_event *tmp;
 
 		tmp = merge(list, event);
-- 
1.5.6.5

