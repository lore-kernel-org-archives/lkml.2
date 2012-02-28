Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab2B1F7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 00:59:01 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:52579 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2B1F7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 00:59:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arve@android.com designates 10.229.69.30 as permitted sender) smtp.mail=arve@android.com
MIME-Version: 1.0
In-Reply-To: <201202262157.18496.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201202220034.58836.rjw@sisk.pl>
	<20120224051649.GB7666@count0.beaverton.ibm.com>
	<201202262157.18496.rjw@sisk.pl>
Date: Mon, 27 Feb 2012 21:58:59 -0800
Message-ID: <CAMP5XgfJ5tYgAEx_57vS70R8brHf4v=5U4VX5Ribt2e3fBdbfA@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/7] Input / PM: Add ioctl to block suspend while
 event queue is not empty
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, jeffbrown@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 12:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, February 24, 2012, Matt Helsley wrote:
>> On Wed, Feb 22, 2012 at 12:34:58AM +0100, Rafael J. Wysocki wrote:
>> > From: Arve Hjønnevåg <arve@android.com>
>> >
>> > Add a new ioctl, EVIOCSWAKEUPSRC, to attach a wakeup source object to
>> > an evdev client event queue, such that it will be active whenever the
>> > queue is not empty.  Then, all events in the queue will be regarded
>> > as wakeup events in progress and pm_get_wakeup_count() will block (or
>> > return false if woken up by a signal) until they are removed from the
>> > queue.  In consequence, if the checking of wakeup events is enabled
>> > (e.g. throught the /sys/power/wakeup_count interface), the system
>> > won't be able to go into a sleep state until the queue is empty.
>> >
>> > This allows user space processes to handle situations in which they
>> > want to do a select() on an evdev descriptor, so they go to sleep
>> > until there are some events to read from the device's queue, and then
>> > they don't want the system to go into a sleep state until all the
>> > events are read (presumably for further processing).  Of course, if
>> > they don't want the system to go into a sleep state _after_ all the
>> > events have been read from the queue, they have to use a separate
>> > mechanism that will prevent the system from doing that and it has
>> > to be activated before reading the first event (that also may be the
>> > last one).
>>
>> I haven't seen this idea mentioned before but I must admit I haven't
>> been following this thread too closely so apologies (and don't bother
>> rehashing) if it has:
>>
>> Could you just add this to epoll so that any fd userspace chooses would be
>> capable of doing this without introducing potentially ecclectic ioctl
>> interfaces?
>>
>> struct epoll_event ev;
>>
>> epfd = epoll_create1(EPOLL_STAY_AWAKE_SET);
>> ev.data.ptr = foo;
>> epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);
>>
>> Which could be useful because you can put one epollfd in another's epoll
>> set. Or maybe as an EPOLLKEEPAWAKE flag in the event struct sort of like
>> EPOLLET:
>>
>> epfd = epoll_create1(0);
>> ev.events = EPOLLIN|EPOLLKEEPAWAKE;
>> epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);
>
> Do you mean something like the patch below, or something different?
>
> Rafael
>
> ---

I don't think it is useful to tie an evdev implementation to epoll
that way. You just replaced the ioctl with a new control function.

The code below tries to implement the same flag without modifying
evdev at all. The behavior of this is different as it will keep the
device awake until user-space calls epoll_wait again. I also used an
extra wakeup source to handle the function that runs without the
spin_lock held which means that non-wakeup files in same epoll list
could abort suspend.

-- 
Arve Hjønnevåg

----
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f9cfd16..45af494 100644
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
@@ -79,7 +80,7 @@
  */

 /* Epoll private bits inside the event mask */
-#define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET)
+#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET)

 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
@@ -146,6 +147,9 @@ struct epitem {
 	/* List header used to link this item to the "struct file" items list */
 	struct list_head fllink;

+	/* wakeup_source used when EPOLLWAKEUP is set */
+	struct wakeup_source *ws;
+
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
 };
@@ -186,6 +190,9 @@ struct eventpoll {
 	 */
 	struct epitem *ovflist;

+	/* wakeup_source used when ep_scan_ready_list is running */
+	struct wakeup_source *ws;
+
 	/* The user that created the eventpoll descriptor */
 	struct user_struct *user;
 };
@@ -492,6 +499,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * in a lockless way.
 	 */
 	spin_lock_irqsave(&ep->lock, flags);
+	__pm_stay_awake(ep->ws);
 	list_splice_init(&ep->rdllist, &txlist);
 	ep->ovflist = NULL;
 	spin_unlock_irqrestore(&ep->lock, flags);
@@ -515,9 +523,12 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 		 * queued into ->ovflist but the "txlist" might already
 		 * contain them, and the list_splice() below takes care of them.
 		 */
-		if (!ep_is_linked(&epi->rdllink))
+		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
+			__pm_stay_awake(epi->ws);
+		}
 	}
+
 	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
 	 * releasing the lock, events will be queued in the normal way inside
@@ -529,6 +540,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * Quickly re-inject items left on "txlist".
 	 */
 	list_splice(&txlist, &ep->rdllist);
+	__pm_relax(ep->ws);

 	if (!list_empty(&ep->rdllist)) {
 		/*
@@ -583,6 +595,9 @@ static int ep_remove(struct eventpoll *ep, struct
epitem *epi)
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);

+	if (epi->ws)
+		wakeup_source_unregister(epi->ws);
+
 	/* At this point it is safe to free the eventpoll item */
 	kmem_cache_free(epi_cache, epi);

@@ -633,6 +648,8 @@ static void ep_free(struct eventpoll *ep)
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
 	free_uid(ep->user);
+	if (ep->ws)
+		wakeup_source_unregister(ep->ws);
 	kfree(ep);
 }

@@ -661,6 +678,7 @@ static int ep_read_events_proc(struct eventpoll
*ep, struct list_head *head,
 			 * callback, but it's not actually ready, as far as
 			 * caller requested events goes. We can remove it here.
 			 */
+			__pm_relax(epi->ws);
 			list_del_init(&epi->rdllink);
 		}
 	}
@@ -851,8 +869,10 @@ static int ep_poll_callback(wait_queue_t *wait,
unsigned mode, int sync, void *k
 	}

 	/* If this file is already in the ready list we exit soon */
-	if (!ep_is_linked(&epi->rdllink))
+	if (!ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
+		__pm_stay_awake(epi->ws);
+	}

 	/*
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
@@ -915,6 +935,30 @@ static void ep_rbtree_insert(struct eventpoll
*ep, struct epitem *epi)
 	rb_insert_color(&epi->rbn, &ep->rbr);
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
@@ -942,6 +986,13 @@ static int ep_insert(struct eventpoll *ep, struct
epoll_event *event,
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
@@ -982,6 +1033,7 @@ static int ep_insert(struct eventpoll *ep, struct
epoll_event *event,
 	/* If the file is already "ready" we drop it inside the ready list */
 	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
+		__pm_stay_awake(epi->ws);

 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
@@ -1014,6 +1066,10 @@ error_unregister:
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);

+	if (epi->ws)
+		wakeup_source_unregister(epi->ws);
+
+error_create_wakeup_source:
 	kmem_cache_free(epi_cache, epi);

 	return error;
@@ -1035,6 +1091,12 @@ static int ep_modify(struct eventpoll *ep,
struct epitem *epi, struct epoll_even
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
@@ -1050,6 +1112,7 @@ static int ep_modify(struct eventpoll *ep,
struct epitem *epi, struct epoll_even
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
+			__pm_stay_awake(epi->ws);

 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
@@ -1085,6 +1148,7 @@ static int ep_send_events_proc(struct eventpoll
*ep, struct list_head *head,
 	     !list_empty(head) && eventcnt < esed->maxevents;) {
 		epi = list_first_entry(head, struct epitem, rdllink);

+		__pm_relax(epi->ws);
 		list_del_init(&epi->rdllink);

 		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
@@ -1100,6 +1164,7 @@ static int ep_send_events_proc(struct eventpoll
*ep, struct list_head *head,
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
 				list_add(&epi->rdllink, head);
+				__pm_stay_awake(epi->ws);
 				return eventcnt ? eventcnt : -EFAULT;
 			}
 			eventcnt++;
@@ -1119,6 +1184,7 @@ static int ep_send_events_proc(struct eventpoll
*ep, struct list_head *head,
 				 * poll callback will queue them in ep->ovflist.
 				 */
 				list_add_tail(&epi->rdllink, &ep->rdllist);
+				__pm_stay_awake(epi->ws);
 			}
 		}
 	}
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index f362733..cd156ff 100644
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
