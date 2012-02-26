Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2BZUxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 15:53:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42917 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab2BZUxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 15:53:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [RFC][PATCH 4/7] Input / PM: Add ioctl to block suspend while event queue is not empty
Date: Sun, 26 Feb 2012 21:57:18 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201202070200.55505.rjw@sisk.pl> <201202220034.58836.rjw@sisk.pl> <20120224051649.GB7666@count0.beaverton.ibm.com>
In-Reply-To: <20120224051649.GB7666@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202262157.18496.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 24, 2012, Matt Helsley wrote:
> On Wed, Feb 22, 2012 at 12:34:58AM +0100, Rafael J. Wysocki wrote:
> > From: Arve Hjønnevåg <arve@android.com>
> > 
> > Add a new ioctl, EVIOCSWAKEUPSRC, to attach a wakeup source object to
> > an evdev client event queue, such that it will be active whenever the
> > queue is not empty.  Then, all events in the queue will be regarded
> > as wakeup events in progress and pm_get_wakeup_count() will block (or
> > return false if woken up by a signal) until they are removed from the
> > queue.  In consequence, if the checking of wakeup events is enabled
> > (e.g. throught the /sys/power/wakeup_count interface), the system
> > won't be able to go into a sleep state until the queue is empty.
> > 
> > This allows user space processes to handle situations in which they
> > want to do a select() on an evdev descriptor, so they go to sleep
> > until there are some events to read from the device's queue, and then
> > they don't want the system to go into a sleep state until all the
> > events are read (presumably for further processing).  Of course, if
> > they don't want the system to go into a sleep state _after_ all the
> > events have been read from the queue, they have to use a separate
> > mechanism that will prevent the system from doing that and it has
> > to be activated before reading the first event (that also may be the
> > last one).
> 
> I haven't seen this idea mentioned before but I must admit I haven't
> been following this thread too closely so apologies (and don't bother
> rehashing) if it has:
> 
> Could you just add this to epoll so that any fd userspace chooses would be
> capable of doing this without introducing potentially ecclectic ioctl
> interfaces?
> 
> struct epoll_event ev;
> 
> epfd = epoll_create1(EPOLL_STAY_AWAKE_SET);
> ev.data.ptr = foo;
> epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);
> 
> Which could be useful because you can put one epollfd in another's epoll
> set. Or maybe as an EPOLLKEEPAWAKE flag in the event struct sort of like
> EPOLLET:
> 
> epfd = epoll_create1(0);
> ev.events = EPOLLIN|EPOLLKEEPAWAKE;
> epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);

Do you mean something like the patch below, or something different?

Rafael

---
 drivers/input/evdev.c     |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/eventpoll.c            |   15 +++++++++++-
 include/linux/eventpoll.h |    6 +++++
 include/linux/fs.h        |    1 
 4 files changed, 76 insertions(+), 1 deletion(-)

Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -1604,6 +1604,7 @@ struct file_operations {
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
+	void (*epoll_ctl) (struct file *, int, unsigned int);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
Index: linux/fs/eventpoll.c
===================================================================
--- linux.orig/fs/eventpoll.c
+++ linux/fs/eventpoll.c
@@ -609,6 +609,10 @@ static int ep_remove(struct eventpoll *e
 	unsigned long flags;
 	struct file *file = epi->ffd.file;
 
+	/* Notify the underlying driver that the polling has completed */
+	if (file->f_op->epoll_ctl)
+		file->f_op->epoll_ctl(file, EPOLL_CTL_DEL, epi->event.events);
+
 	/*
 	 * Removes poll wait queue hooks. We _have_ to do this without holding
 	 * the "ep->lock" otherwise a deadlock might occur. This because of the
@@ -1094,6 +1098,10 @@ static int ep_insert(struct eventpoll *e
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
 
+	/* Notify the underlying driver that we want to poll it */
+	if (tfile->f_op->epoll_ctl)
+		tfile->f_op->epoll_ctl(tfile, EPOLL_CTL_ADD, event->events);
+
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
 	 * We can safely use the file* here because its usage count has
@@ -1185,6 +1193,7 @@ error_unregister:
  */
 static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_event *event)
 {
+	struct file *file = epi->ffd.file;
 	int pwake = 0;
 	unsigned int revents;
 
@@ -1196,11 +1205,15 @@ static int ep_modify(struct eventpoll *e
 	epi->event.events = event->events;
 	epi->event.data = event->data; /* protected by mtx */
 
+	/* Notify the underlying driver of the change */
+	if (file->f_op->epoll_ctl)
+		file->f_op->epoll_ctl(file, EPOLL_CTL_MOD, event->events);
+
 	/*
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
+	revents = file->f_op->poll(file, NULL);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
Index: linux/drivers/input/evdev.c
===================================================================
--- linux.orig/drivers/input/evdev.c
+++ linux/drivers/input/evdev.c
@@ -16,6 +16,7 @@
 #define EVDEV_BUF_PACKETS	8
 
 #include <linux/poll.h>
+#include <linux/eventpoll.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -43,6 +44,7 @@ struct evdev_client {
 	unsigned int tail;
 	unsigned int packet_head; /* [future] position of the first element of next packet */
 	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
+	struct wakeup_source *wakeup_source;
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
@@ -75,10 +77,12 @@ static void evdev_pass_event(struct evde
 		client->buffer[client->tail].value = 0;
 
 		client->packet_head = client->tail;
+		__pm_relax(client->wakeup_source);
 	}
 
 	if (event->type == EV_SYN && event->code == SYN_REPORT) {
 		client->packet_head = client->head;
+		__pm_stay_awake(client->wakeup_source);
 		kill_fasync(&client->fasync, SIGIO, POLL_IN);
 	}
 
@@ -255,6 +259,8 @@ static int evdev_release(struct inode *i
 	mutex_unlock(&evdev->mutex);
 
 	evdev_detach_client(evdev, client);
+	wakeup_source_unregister(client->wakeup_source);
+
 	kfree(client);
 
 	evdev_close_device(evdev);
@@ -373,6 +379,8 @@ static int evdev_fetch_next_event(struct
 	if (have_event) {
 		*event = client->buffer[client->tail++];
 		client->tail &= client->bufsize - 1;
+		if (client->packet_head == client->tail)
+			__pm_relax(client->wakeup_source);
 	}
 
 	spin_unlock_irq(&client->buffer_lock);
@@ -433,6 +441,52 @@ static unsigned int evdev_poll(struct fi
 	return mask;
 }
 
+static void evdev_client_attach_wakeup_source(struct evdev_client *client)
+{
+	struct wakeup_source *ws;
+
+	ws = wakeup_source_register(dev_name(&client->evdev->dev));
+	spin_lock_irq(&client->buffer_lock);
+	client->wakeup_source = ws;
+	if (client->packet_head != client->tail)
+		__pm_stay_awake(client->wakeup_source);
+	spin_unlock_irq(&client->buffer_lock);
+}
+
+static void evdev_client_detach_wakeup_source(struct evdev_client *client)
+{
+	struct wakeup_source *ws;
+
+	spin_lock_irq(&client->buffer_lock);
+	ws = client->wakeup_source;
+	client->wakeup_source = NULL;
+	spin_unlock_irq(&client->buffer_lock);
+	wakeup_source_unregister(ws);
+}
+
+static void evdev_epoll_ctl(struct file *file, int op,
+				    unsigned int events)
+{
+	struct evdev_client *client = file->private_data;
+
+	switch (op) {
+	case EPOLL_CTL_ADD:
+		if ((events & EPOLLWAKEUP) && !client->wakeup_source)
+			evdev_client_attach_wakeup_source(client);
+		break;
+	case EPOLL_CTL_DEL:
+		if (events & EPOLLWAKEUP)
+			evdev_client_detach_wakeup_source(client);
+		break;
+	case EPOLL_CTL_MOD:
+		/* 'events' is the new events mask (after the change) */
+		if ((events & EPOLLWAKEUP) && !client->wakeup_source)
+			evdev_client_attach_wakeup_source(client);
+		else if (!(events & EPOLLWAKEUP))
+			evdev_client_detach_wakeup_source(client);
+	}
+}
+
 #ifdef CONFIG_COMPAT
 
 #define BITS_PER_LONG_COMPAT (sizeof(compat_long_t) * 8)
@@ -845,6 +899,7 @@ static const struct file_operations evde
 	.read		= evdev_read,
 	.write		= evdev_write,
 	.poll		= evdev_poll,
+	.epoll_ctl	= evdev_epoll_ctl,
 	.open		= evdev_open,
 	.release	= evdev_release,
 	.unlocked_ioctl	= evdev_ioctl,
Index: linux/include/linux/eventpoll.h
===================================================================
--- linux.orig/include/linux/eventpoll.h
+++ linux/include/linux/eventpoll.h
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
 
