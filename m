Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1ASUhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:37:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab1ASUhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:37:10 -0500
Subject: Re: [PATCH] fsnotify: Do not always merge overflow events
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Wed, 19 Jan 2011 15:37:01 -0500
In-Reply-To: <20101126113958.GB11676@lsanfilippo.unix.rd.tt.avira.com>
References: <20101126113958.GB11676@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295469422.21577.33.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 12:39 +0100, Lino Sanfilippo wrote:

> With this patch we only merge an overflow event if the last event in the
> queue is also an overflow event.

I liked the idea, but not the patch.  It left some dead return_event
code, but more importantly I'd rather keep the generic code generic if
we could.  I merged this patch instead which pushes the handling out to
fanotify_merge, so if some listener wants other complex behavior they
can handle it.

What do you think?

>From 8c33f8e252ac94bf4714fa3133163857463ab9ea Mon Sep 17 00:00:00 2001
From: Eric Paris <eparis@redhat.com>
Date: Wed, 19 Jan 2011 15:25:53 -0500
Subject: [PATCH] fanotify: Do not always merge overflow events

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

Now a listener could see that the queue has been overflowed 2 times.  With the
recent implementation it would only know that the queue has been overflowed at
least one time.

Based-on-patch-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/fanotify/fanotify.c    |   15 +++++++++++++++
 fs/notify/notification.c         |    2 +-
 include/linux/fsnotify_backend.h |    2 ++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c2ba86a..0adb80f 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -30,6 +30,19 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 	return false;
 }
 
+/* special merging for q_overflow, only merge with the last event */
+static struct fsnotify_event *fanotify_merge_q_overflow(struct list_head *list)
+{
+	struct fsnotify_event_holder *last;
+
+	last = list_entry(list->prev, struct fsnotify_event_holder, event_list);
+	if (last->event == q_overflow_event) {
+		fsnotify_get_event(q_overflow_event);
+		return q_overflow_event;
+	}
+	return NULL;
+}
+
 /* and the list better be locked by something too! */
 static struct fsnotify_event *fanotify_merge(struct list_head *list,
 					     struct fsnotify_event *event)
@@ -40,6 +53,8 @@ static struct fsnotify_event *fanotify_merge(struct list_head *list,
 
 	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
 
+	if (event == q_overflow_event)
+		return fanotify_merge_q_overflow(list);
 
 	list_for_each_entry_reverse(test_holder, list, event_list) {
 		if (should_merge(test_holder->event, event)) {
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index f39260f..e69573e 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -56,7 +56,7 @@ static struct kmem_cache *fsnotify_event_holder_cachep;
  * it is needed.  It's refcnt is set 1 at kernel init time and will never
  * get set to 0 so it will never get 'freed'
  */
-static struct fsnotify_event *q_overflow_event;
+struct fsnotify_event *q_overflow_event;
 static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
 
 /**
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 6a3c660..dbcbcae 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -364,6 +364,8 @@ extern struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *op
 /* drop reference on a group from fsnotify_alloc_group */
 extern void fsnotify_put_group(struct fsnotify_group *group);
 
+/* special event used to indicate the queue is full */
+extern struct fsnotify_event *q_overflow_event;
 /* take a reference to an event */
 extern void fsnotify_get_event(struct fsnotify_event *event);
 extern void fsnotify_put_event(struct fsnotify_event *event);
-- 
1.7.1



