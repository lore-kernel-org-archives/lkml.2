Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2BUXg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:36:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab2BUXfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:35:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 4/7] Input / PM: Add ioctl to block suspend while event queue is not empty
Date: Wed, 22 Feb 2012 00:34:58 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201202070200.55505.rjw@sisk.pl> <201202220031.46219.rjw@sisk.pl>
In-Reply-To: <201202220031.46219.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202220034.58836.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Add a new ioctl, EVIOCSWAKEUPSRC, to attach a wakeup source object to
an evdev client event queue, such that it will be active whenever the
queue is not empty.  Then, all events in the queue will be regarded
as wakeup events in progress and pm_get_wakeup_count() will block (or
return false if woken up by a signal) until they are removed from the
queue.  In consequence, if the checking of wakeup events is enabled
(e.g. throught the /sys/power/wakeup_count interface), the system
won't be able to go into a sleep state until the queue is empty.

This allows user space processes to handle situations in which they
want to do a select() on an evdev descriptor, so they go to sleep
until there are some events to read from the device's queue, and then
they don't want the system to go into a sleep state until all the
events are read (presumably for further processing).  Of course, if
they don't want the system to go into a sleep state _after_ all the
events have been read from the queue, they have to use a separate
mechanism that will prevent the system from doing that and it has
to be activated before reading the first event (that also may be the
last one).

[rjw: Removed unnecessary checks, changed the names of the new ioctls
 and the names of the functions that add/remove wakeup source objects
 to/from evdev clients, modified the changelog.]

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/input/evdev.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/input.h |    3 ++
 2 files changed, 58 insertions(+)

Index: linux/drivers/input/evdev.c
===================================================================
--- linux.orig/drivers/input/evdev.c
+++ linux/drivers/input/evdev.c
@@ -43,6 +43,7 @@ struct evdev_client {
 	unsigned int tail;
 	unsigned int packet_head; /* [future] position of the first element of next packet */
 	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
+	struct wakeup_source *wakeup_source;
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
@@ -75,10 +76,12 @@ static void evdev_pass_event(struct evde
 		client->buffer[client->tail].value = 0;
 
 		client->packet_head = client->tail;
+		__pm_relax(client->wakeup_source);
 	}
 
 	if (event->type == EV_SYN && event->code == SYN_REPORT) {
 		client->packet_head = client->head;
+		__pm_stay_awake(client->wakeup_source);
 		kill_fasync(&client->fasync, SIGIO, POLL_IN);
 	}
 
@@ -255,6 +258,8 @@ static int evdev_release(struct inode *i
 	mutex_unlock(&evdev->mutex);
 
 	evdev_detach_client(evdev, client);
+	wakeup_source_unregister(client->wakeup_source);
+
 	kfree(client);
 
 	evdev_close_device(evdev);
@@ -373,6 +378,8 @@ static int evdev_fetch_next_event(struct
 	if (have_event) {
 		*event = client->buffer[client->tail++];
 		client->tail &= client->bufsize - 1;
+		if (client->packet_head == client->tail)
+			__pm_relax(client->wakeup_source);
 	}
 
 	spin_unlock_irq(&client->buffer_lock);
@@ -623,6 +630,45 @@ static int evdev_handle_set_keycode_v2(s
 	return input_set_keycode(dev, &ke);
 }
 
+static int evdev_attach_wakeup_source(struct evdev *evdev,
+				      struct evdev_client *client)
+{
+	struct wakeup_source *ws;
+	char name[28];
+
+	if (client->wakeup_source)
+		return 0;
+
+	snprintf(name, sizeof(name), "%s-%d",
+		 dev_name(&evdev->dev), task_tgid_vnr(current));
+
+	ws = wakeup_source_register(name);
+	if (!ws)
+		return -ENOMEM;
+
+	spin_lock_irq(&client->buffer_lock);
+	client->wakeup_source = ws;
+	if (client->packet_head != client->tail)
+		__pm_stay_awake(client->wakeup_source);
+	spin_unlock_irq(&client->buffer_lock);
+	return 0;
+}
+
+static int evdev_detach_wakeup_source(struct evdev *evdev,
+				      struct evdev_client *client)
+{
+	struct wakeup_source *ws;
+
+	spin_lock_irq(&client->buffer_lock);
+	ws = client->wakeup_source;
+	client->wakeup_source = NULL;
+	spin_unlock_irq(&client->buffer_lock);
+
+	wakeup_source_unregister(ws);
+
+	return 0;
+}
+
 static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			   void __user *p, int compat_mode)
 {
@@ -696,6 +742,15 @@ static long evdev_do_ioctl(struct file *
 
 	case EVIOCSKEYCODE_V2:
 		return evdev_handle_set_keycode_v2(dev, p);
+
+	case EVIOCGWAKEUPSRC:
+		return put_user(!!client->wakeup_source, ip);
+
+	case EVIOCSWAKEUPSRC:
+		if (p)
+			return evdev_attach_wakeup_source(evdev, client);
+		else
+			return evdev_detach_wakeup_source(evdev, client);
 	}
 
 	size = _IOC_SIZE(cmd);
Index: linux/include/linux/input.h
===================================================================
--- linux.orig/include/linux/input.h
+++ linux/include/linux/input.h
@@ -129,6 +129,9 @@ struct input_keymap_entry {
 
 #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
 
+#define EVIOCGWAKEUPSRC	_IOR('E', 0x91, int)	/* Check if wakeup handling is enabled */
+#define EVIOCSWAKEUPSRC	_IOW('E', 0x91, int)	/* Enable/disable wakeup handling */
+
 /*
  * Device properties and quirks
  */

