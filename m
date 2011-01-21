Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab1AUOot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:44:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47657 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753420Ab1AUOor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:44:47 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18jUWtWti0jKa3FTpvKUeMPYE1WM4lsIfYJnz5lfw
	ZrwH4yvA/2jyDi
Date: Fri, 21 Jan 2011 15:41:31 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fsnotify: Do not always merge overflow events
Message-ID: <20110121144131.GA15375@lsanfilippo.unix.rd.tt.avira.com>
References: <20101126113958.GB11676@lsanfilippo.unix.rd.tt.avira.com> <1295469422.21577.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295469422.21577.33.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 03:37:01PM -0500, Eric Paris wrote:
> On Fri, 2010-11-26 at 12:39 +0100, Lino Sanfilippo wrote:
> 
> > With this patch we only merge an overflow event if the last event in the
> > queue is also an overflow event.
> 
> I liked the idea, but not the patch.  It left some dead return_event
> code, but more importantly I'd rather keep the generic code generic if
> we could.  I merged this patch instead which pushes the handling out to
> fanotify_merge, so if some listener wants other complex behavior they
> can handle it.
> 
> What do you think?

I think keeping it generic and up to the listener is a very good idea. 
But what we also have to consider then is how overflow events are handled if _no_ merge() 
function is defined by a listener:
Right now, since o-events are not merged in that case, a new o-event is put in the 
queue everytime the queue is found full, possibly increasing the queue more and more. 
So we could end up with a queue that is permanently overflowed only because its 
filled with countless overflow events :|.
I dont think that this is a good default behaviour.

My suggestion is to do both, keep generic and offer a default merge() function - 
which does nothing but merge overflow events in a sane way. 
So listeners could decide whether they want to keep the default behaviour, 
reuse it in their own implementation or completely replace it with their own 
implementation. 

In the example below the implementation from fanotify_merge_q_overflow() is used as 
a generic (default) merge() function: 


diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c2ba86a..87925c0 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -40,6 +40,8 @@ static struct fsnotify_event *fanotify_merge(struct list_head *list,
 
 	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
 
+	if (event == q_overflow_event)
+		return fsnotify_generic_merge(list, event);
 
 	list_for_each_entry_reverse(test_holder, list, event_list) {
 		if (should_merge(test_holder->event, event)) {
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index f39260f..8e66252 100644
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
@@ -132,6 +132,22 @@ struct fsnotify_event_private_data *fsnotify_remove_priv_from_event(struct fsnot
 	return priv;
 }
 
+/* generic merging for q_overflow, only merge with the last event */
+struct fsnotify_event *fsnotify_generic_merge(struct list_head *list,
+					      struct fsnotify_event *event)
+{
+	struct fsnotify_event_holder *last;
+
+	if (event != q_overflow_event)
+		return NULL;
+	last = list_entry(list->prev, struct fsnotify_event_holder, event_list);
+	if (last->event == q_overflow_event) {
+		fsnotify_get_event(q_overflow_event);
+		return q_overflow_event;
+	}
+	return NULL;
+}
+
 /*
  * Add an event to the group notification queue.  The group can later pull this
  * event off the queue to deal with.  If the event is successfully added to the
@@ -145,9 +161,14 @@ struct fsnotify_event *fsnotify_add_notify_event(struct fsnotify_group *group, s
 	struct fsnotify_event *return_event = NULL;
 	struct fsnotify_event_holder *holder = NULL;
 	struct list_head *list = &group->notification_list;
+	struct fsnotify_event *(* merge_event) (struct list_head *,
+						struct fsnotify_event *)
+		= fsnotify_generic_merge;
 
 	pr_debug("%s: group=%p event=%p priv=%p\n", __func__, group, event, priv);
 
+	if (merge) /* use merge() function provided by listener */
+		merge_event = merge;
 	/*
 	 * There is one fsnotify_event_holder embedded inside each fsnotify_event.
 	 * Check if we expect to be able to use that holder.  If not alloc a new
@@ -179,10 +200,10 @@ alloc_holder:
 		priv = NULL;
 	}
 
-	if (!list_empty(list) && merge) {
+	if (!list_empty(list)) {
 		struct fsnotify_event *tmp;
 
-		tmp = merge(list, event);
+		tmp = merge_event(list, event);
 		if (tmp) {
 			mutex_unlock(&group->notification_mutex);
 
@@ -210,7 +231,6 @@ alloc_holder:
 			fsnotify_put_event(return_event);
 			return_event = NULL;
 		}
-
 		goto alloc_holder;
 	}
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 6a3c660..e3d1b78 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -364,6 +364,11 @@ extern struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *op
 /* drop reference on a group from fsnotify_alloc_group */
 extern void fsnotify_put_group(struct fsnotify_group *group);
 
+/* special event used to indicate the queue is full */
+extern struct fsnotify_event *q_overflow_event;
+/* generic merging */
+extern struct fsnotify_event *fsnotify_generic_merge(struct list_head *list,
+						     struct fsnotify_event *event);
 /* take a reference to an event */
 extern void fsnotify_get_event(struct fsnotify_event *event);
 extern void fsnotify_put_event(struct fsnotify_event *event);



