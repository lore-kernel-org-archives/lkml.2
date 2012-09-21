Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2IUIH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:07:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51958 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2IUIHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:07:50 -0400
Date: Fri, 21 Sep 2012 01:07:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [PATCH v2 0/3] input: Dynamic Minor Numbers
Message-ID: <20120921080745.GA2053@core.coreip.homeip.net>
References: <1348163523-2062-1-git-send-email-dh.herrmann@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348163523-2062-1-git-send-email-dh.herrmann@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Sep 20, 2012 at 07:52:00PM +0200, David Herrmann wrote:
> Hi
> 
> This is version 2 of the Dynamic Minor Numbers support for input devices.
> Version 1 can be found here:
>   http://thread.gmane.org/gmane.linux.kernel.input/26842
> 
> For historical reasons, each input-handler (like evdev, joydev etc.) gets 32
> minor numbers assigned statically. That means, if we have more than 32 input
> devices, then there will not be any /dev/input/eventX device that user-space can
> use to access the device.
> While 32 devices were enough for a long time, multi-seat machines currently
> cannot create more than 8 seats due to this restriction (assuming 3 devices per
> seat plus some static devices).
> 
> This patchset allows input-handlers to allocate dynamic minor numbers if they
> run out of static numbers. Patch #1 adds the infrastructure to the input core,
> patch #2 makes sure we allow enough devices so we actually have room for dynamic
> minor numbers and patch #3 converts evdev to use it.
> 
> Unused static minors numbers are never used for the dynamic minor numbers pool.
> So existing user-space does not break. But old user-space (not using udev) will
> not be able to use the new devices.

Thank you very much for working on this, unfortunately your patch extends the
existing infrastructure handling of character devices in input core,
which is quite rigid and sub-optimal.

For a while now I wanted to stop input core from pre-creating character
devices and multiplexing file operations and instead push more chardev
handling tasks into individual input handlers and make they more
independent from input core. So while I won't be taking your patch as is
it was a great motivator to finally do something about current
limitation and I would appreciate if you could take a look at the patch
below and see if you have any issues with it.

The main difference from your patch:

- switch to cdev infrastructure and creating only devices that actually
  exist - this simplifies handling of opening non-existing devices as
  there won't be any;
- use IDR/IDA framework for tracking minors;
- mousedev and joydev also use dynamic minors.

Thanks!

-- 
Dmitry


Input: extend the number of event (and other) devices

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Extend the amount of character devices, such as eventX, mouseX and jsX,
from a hard limit of 32 per input handler to about 1024 shared across
all handlers.

To be compatible with legacy installations input handlers will start
creating char devices with minors in their legacy range, however once
legacy range is exhausted they will start allocating minors from the
dynamic range 256-1024.

Because input handlers now do the majority of character devices handling
and not register their file operations with input core format of
/proc/bus/input/handlers was changed: "Minor=X" line was taken out.
With dynamic minors is does not make much sense anyway and nobody was
ever using it.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

 drivers/input/evdev.c    |   99 +++++++-------------
 drivers/input/input.c    |  114 +++++++++++------------
 drivers/input/joydev.c   |   88 ++++++------------
 drivers/input/mousedev.c |  224 ++++++++++++++++++++++++----------------------
 include/linux/input.h    |    9 +-
 5 files changed, 237 insertions(+), 297 deletions(-)


diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 6c58bff..0bc4507 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -23,11 +23,11 @@
 #include <linux/input/mt.h>
 #include <linux/major.h>
 #include <linux/device.h>
+#include <linux/cdev.h>
 #include "input-compat.h"
 
 struct evdev {
 	int open;
-	int minor;
 	struct input_handle handle;
 	wait_queue_head_t wait;
 	struct evdev_client __rcu *grab;
@@ -35,6 +35,7 @@ struct evdev {
 	spinlock_t client_lock; /* protects client_list */
 	struct mutex mutex;
 	struct device dev;
+	struct cdev cdev;
 	bool exist;
 };
 
@@ -51,9 +52,6 @@ struct evdev_client {
 	struct input_event buffer[];
 };
 
-static struct evdev *evdev_table[EVDEV_MINORS];
-static DEFINE_MUTEX(evdev_table_mutex);
-
 static void evdev_pass_event(struct evdev_client *client,
 			     struct input_event *event,
 			     ktime_t mono, ktime_t real)
@@ -285,35 +283,16 @@ static unsigned int evdev_compute_buffer_size(struct input_dev *dev)
 
 static int evdev_open(struct inode *inode, struct file *file)
 {
-	struct evdev *evdev;
+	struct evdev *evdev = container_of(inode->i_cdev, struct evdev, cdev);
+	unsigned int bufsize = evdev_compute_buffer_size(evdev->handle.dev);
 	struct evdev_client *client;
-	int i = iminor(inode) - EVDEV_MINOR_BASE;
-	unsigned int bufsize;
 	int error;
 
-	if (i >= EVDEV_MINORS)
-		return -ENODEV;
-
-	error = mutex_lock_interruptible(&evdev_table_mutex);
-	if (error)
-		return error;
-	evdev = evdev_table[i];
-	if (evdev)
-		get_device(&evdev->dev);
-	mutex_unlock(&evdev_table_mutex);
-
-	if (!evdev)
-		return -ENODEV;
-
-	bufsize = evdev_compute_buffer_size(evdev->handle.dev);
-
 	client = kzalloc(sizeof(struct evdev_client) +
 				bufsize * sizeof(struct input_event),
 			 GFP_KERNEL);
-	if (!client) {
-		error = -ENOMEM;
-		goto err_put_evdev;
-	}
+	if (!client)
+		return -ENOMEM;
 
 	client->bufsize = bufsize;
 	spin_lock_init(&client->buffer_lock);
@@ -327,13 +306,12 @@ static int evdev_open(struct inode *inode, struct file *file)
 	file->private_data = client;
 	nonseekable_open(inode, file);
 
+	get_device(&evdev->dev);
 	return 0;
 
  err_free_client:
 	evdev_detach_client(evdev, client);
 	kfree(client);
- err_put_evdev:
-	put_device(&evdev->dev);
 	return error;
 }
 
@@ -915,26 +893,6 @@ static const struct file_operations evdev_fops = {
 	.llseek		= no_llseek,
 };
 
-static int evdev_install_chrdev(struct evdev *evdev)
-{
-	/*
-	 * No need to do any locking here as calls to connect and
-	 * disconnect are serialized by the input core
-	 */
-	evdev_table[evdev->minor] = evdev;
-	return 0;
-}
-
-static void evdev_remove_chrdev(struct evdev *evdev)
-{
-	/*
-	 * Lock evdev table to prevent race with evdev_open()
-	 */
-	mutex_lock(&evdev_table_mutex);
-	evdev_table[evdev->minor] = NULL;
-	mutex_unlock(&evdev_table_mutex);
-}
-
 /*
  * Mark device non-existent. This disables writes, ioctls and
  * prevents new users from opening the device. Already posted
@@ -953,7 +911,8 @@ static void evdev_cleanup(struct evdev *evdev)
 
 	evdev_mark_dead(evdev);
 	evdev_hangup(evdev);
-	evdev_remove_chrdev(evdev);
+
+	cdev_del(&evdev->cdev);
 
 	/* evdev is marked dead so no one else accesses evdev->open */
 	if (evdev->open) {
@@ -964,43 +923,47 @@ static void evdev_cleanup(struct evdev *evdev)
 
 /*
  * Create new evdev device. Note that input core serializes calls
- * to connect and disconnect so we don't need to lock evdev_table here.
+ * to connect and disconnect.
  */
 static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 			 const struct input_device_id *id)
 {
 	struct evdev *evdev;
 	int minor;
+	int dev_no;
 	int error;
 
-	for (minor = 0; minor < EVDEV_MINORS; minor++)
-		if (!evdev_table[minor])
-			break;
-
-	if (minor == EVDEV_MINORS) {
-		pr_err("no more free evdev devices\n");
-		return -ENFILE;
+	minor = input_get_new_minor(EVDEV_MINOR_BASE, 8 /*EVDEV_MINORS*/, true);
+	if (minor < 0) {
+		error = minor;
+		pr_err("failed to reserve new minor: %d\n", error);
+		return error;
 	}
 
 	evdev = kzalloc(sizeof(struct evdev), GFP_KERNEL);
-	if (!evdev)
-		return -ENOMEM;
+	if (!evdev) {
+		error = -ENOMEM;
+		goto err_free_minor;
+	}
 
 	INIT_LIST_HEAD(&evdev->client_list);
 	spin_lock_init(&evdev->client_lock);
 	mutex_init(&evdev->mutex);
 	init_waitqueue_head(&evdev->wait);
-
-	dev_set_name(&evdev->dev, "event%d", minor);
 	evdev->exist = true;
-	evdev->minor = minor;
+
+	dev_no = minor;
+	/* Normalize device number if it falls into legacy range */
+	if (dev_no < EVDEV_MINOR_BASE + EVDEV_MINORS)
+		dev_no -= EVDEV_MINOR_BASE;
+	dev_set_name(&evdev->dev, "event%d", dev_no);
 
 	evdev->handle.dev = input_get_device(dev);
 	evdev->handle.name = dev_name(&evdev->dev);
 	evdev->handle.handler = handler;
 	evdev->handle.private = evdev;
 
-	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
+	evdev->dev.devt = MKDEV(INPUT_MAJOR, minor);
 	evdev->dev.class = &input_class;
 	evdev->dev.parent = &dev->dev;
 	evdev->dev.release = evdev_free;
@@ -1010,7 +973,8 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	if (error)
 		goto err_free_evdev;
 
-	error = evdev_install_chrdev(evdev);
+	cdev_init(&evdev->cdev, &evdev_fops);
+	error = cdev_add(&evdev->cdev, evdev->dev.devt, 1);
 	if (error)
 		goto err_unregister_handle;
 
@@ -1026,6 +990,8 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	input_unregister_handle(&evdev->handle);
  err_free_evdev:
 	put_device(&evdev->dev);
+ err_free_minor:
+	input_free_minor(minor);
 	return error;
 }
 
@@ -1035,6 +1001,7 @@ static void evdev_disconnect(struct input_handle *handle)
 
 	device_del(&evdev->dev);
 	evdev_cleanup(evdev);
+	input_free_minor(MINOR(evdev->dev.devt));
 	input_unregister_handle(handle);
 	put_device(&evdev->dev);
 }
@@ -1050,8 +1017,6 @@ static struct input_handler evdev_handler = {
 	.event		= evdev_event,
 	.connect	= evdev_connect,
 	.disconnect	= evdev_disconnect,
-	.fops		= &evdev_fops,
-	.minor		= EVDEV_MINOR_BASE,
 	.name		= "evdev",
 	.id_table	= evdev_ids,
 };
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 768e46b..1869cf1 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -14,6 +14,7 @@
 
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/idr.h>
 #include <linux/input/mt.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -32,7 +33,9 @@ MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
 MODULE_DESCRIPTION("Input core");
 MODULE_LICENSE("GPL");
 
-#define INPUT_DEVICES	256
+#define INPUT_MAX_CHAR_DEVICES		1024
+#define INPUT_FIRST_DYNAMIC_DEV		256
+static DEFINE_IDA(input_ida);
 
 static LIST_HEAD(input_dev_list);
 static LIST_HEAD(input_handler_list);
@@ -45,8 +48,6 @@ static LIST_HEAD(input_handler_list);
  */
 static DEFINE_MUTEX(input_mutex);
 
-static struct input_handler *input_table[8];
-
 static inline int is_event_supported(unsigned int code,
 				     unsigned long *bm, unsigned int max)
 {
@@ -1144,8 +1145,6 @@ static int input_handlers_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "N: Number=%u Name=%s", state->pos, handler->name);
 	if (handler->filter)
 		seq_puts(seq, " (filter)");
-	if (handler->fops)
-		seq_printf(seq, " Minor=%d", handler->minor);
 	seq_putc(seq, '\n');
 
 	return 0;
@@ -1932,22 +1931,14 @@ EXPORT_SYMBOL(input_unregister_device);
 int input_register_handler(struct input_handler *handler)
 {
 	struct input_dev *dev;
-	int retval;
+	int error;
 
-	retval = mutex_lock_interruptible(&input_mutex);
-	if (retval)
-		return retval;
+	error = mutex_lock_interruptible(&input_mutex);
+	if (error)
+		return error;
 
 	INIT_LIST_HEAD(&handler->h_list);
 
-	if (handler->fops != NULL) {
-		if (input_table[handler->minor >> 5]) {
-			retval = -EBUSY;
-			goto out;
-		}
-		input_table[handler->minor >> 5] = handler;
-	}
-
 	list_add_tail(&handler->node, &input_handler_list);
 
 	list_for_each_entry(dev, &input_dev_list, node)
@@ -1955,9 +1946,8 @@ int input_register_handler(struct input_handler *handler)
 
 	input_wakeup_procfs_readers();
 
- out:
 	mutex_unlock(&input_mutex);
-	return retval;
+	return 0;
 }
 EXPORT_SYMBOL(input_register_handler);
 
@@ -1980,9 +1970,6 @@ void input_unregister_handler(struct input_handler *handler)
 
 	list_del_init(&handler->node);
 
-	if (handler->fops != NULL)
-		input_table[handler->minor >> 5] = NULL;
-
 	input_wakeup_procfs_readers();
 
 	mutex_unlock(&input_mutex);
@@ -2099,51 +2086,52 @@ void input_unregister_handle(struct input_handle *handle)
 }
 EXPORT_SYMBOL(input_unregister_handle);
 
-static int input_open_file(struct inode *inode, struct file *file)
+/**
+ * input_get_new_minor - allocates a new input minor number
+ * @legacy_base: beginning or the legacy range to be searched
+ * @legacy_num: size of legacy range
+ * @allow_dynamic: whether we can also take ID from the dynamic range
+ *
+ * This function allocates a new device minor for from input major namespace.
+ * Caller can request legacy minor by specifying @legacy_base and @legacy_num
+ * parameters and whether ID can be allocated from dynamic range if there are
+ * no free IDs in legacy range.
+ */
+int input_get_new_minor(int legacy_base, unsigned int legacy_num,
+			bool allow_dynamic)
 {
-	struct input_handler *handler;
-	const struct file_operations *old_fops, *new_fops = NULL;
-	int err;
-
-	err = mutex_lock_interruptible(&input_mutex);
-	if (err)
-		return err;
-
-	/* No load-on-demand here? */
-	handler = input_table[iminor(inode) >> 5];
-	if (handler)
-		new_fops = fops_get(handler->fops);
-
-	mutex_unlock(&input_mutex);
-
 	/*
-	 * That's _really_ odd. Usually NULL ->open means "nothing special",
-	 * not "no device". Oh, well...
+	 * This function should be called from input handler's ->connect()
+	 * methods, which are serialized with input_mutex, so no additional
+	 * locking is needed here.
 	 */
-	if (!new_fops || !new_fops->open) {
-		fops_put(new_fops);
-		err = -ENODEV;
-		goto out;
+	if (legacy_base >= 0) {
+		int minor = ida_simple_get(&input_ida,
+					   legacy_base,
+					   legacy_base + legacy_num,
+					   GFP_KERNEL);
+		if (minor >= 0 || !allow_dynamic)
+			return minor;
 	}
 
-	old_fops = file->f_op;
-	file->f_op = new_fops;
-
-	err = new_fops->open(inode, file);
-	if (err) {
-		fops_put(file->f_op);
-		file->f_op = fops_get(old_fops);
-	}
-	fops_put(old_fops);
-out:
-	return err;
+	return ida_simple_get(&input_ida,
+			      INPUT_FIRST_DYNAMIC_DEV, INPUT_MAX_CHAR_DEVICES,
+			      GFP_KERNEL);
 }
+EXPORT_SYMBOL(input_get_new_minor);
 
-static const struct file_operations input_fops = {
-	.owner = THIS_MODULE,
-	.open = input_open_file,
-	.llseek = noop_llseek,
-};
+/**
+ * input_free_minor - release previously allocated minor
+ * @minor: minor to be released
+ *
+ * This function releases previously allocated input minor so that it can be
+ * reused later.
+ */
+void input_free_minor(unsigned int minor)
+{
+	ida_simple_remove(&input_ida, minor);
+}
+EXPORT_SYMBOL(input_free_minor);
 
 static int __init input_init(void)
 {
@@ -2159,7 +2147,8 @@ static int __init input_init(void)
 	if (err)
 		goto fail1;
 
-	err = register_chrdev(INPUT_MAJOR, "input", &input_fops);
+	err = register_chrdev_region(MKDEV(INPUT_MAJOR, 0),
+				     INPUT_MAX_CHAR_DEVICES, "input");
 	if (err) {
 		pr_err("unable to register char major %d", INPUT_MAJOR);
 		goto fail2;
@@ -2175,7 +2164,8 @@ static int __init input_init(void)
 static void __exit input_exit(void)
 {
 	input_proc_exit();
-	unregister_chrdev(INPUT_MAJOR, "input");
+	unregister_chrdev_region(MKDEV(INPUT_MAJOR, 0),
+				 INPUT_MAX_CHAR_DEVICES);
 	class_unregister(&input_class);
 }
 
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index f0909ed..c82f76f 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -27,6 +27,7 @@
 #include <linux/poll.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/cdev.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Joystick device interfaces");
@@ -39,13 +40,13 @@ MODULE_LICENSE("GPL");
 
 struct joydev {
 	int open;
-	int minor;
 	struct input_handle handle;
 	wait_queue_head_t wait;
 	struct list_head client_list;
 	spinlock_t client_lock; /* protects client_list */
 	struct mutex mutex;
 	struct device dev;
+	struct cdev cdev;
 	bool exist;
 
 	struct js_corr corr[ABS_CNT];
@@ -70,9 +71,6 @@ struct joydev_client {
 	struct list_head node;
 };
 
-static struct joydev *joydev_table[JOYDEV_MINORS];
-static DEFINE_MUTEX(joydev_table_mutex);
-
 static int joydev_correct(int value, struct js_corr *corr)
 {
 	switch (corr->type) {
@@ -252,30 +250,14 @@ static int joydev_release(struct inode *inode, struct file *file)
 
 static int joydev_open(struct inode *inode, struct file *file)
 {
+	struct joydev *joydev =
+			container_of(inode->i_cdev, struct joydev, cdev);
 	struct joydev_client *client;
-	struct joydev *joydev;
-	int i = iminor(inode) - JOYDEV_MINOR_BASE;
 	int error;
 
-	if (i >= JOYDEV_MINORS)
-		return -ENODEV;
-
-	error = mutex_lock_interruptible(&joydev_table_mutex);
-	if (error)
-		return error;
-	joydev = joydev_table[i];
-	if (joydev)
-		get_device(&joydev->dev);
-	mutex_unlock(&joydev_table_mutex);
-
-	if (!joydev)
-		return -ENODEV;
-
 	client = kzalloc(sizeof(struct joydev_client), GFP_KERNEL);
-	if (!client) {
-		error = -ENOMEM;
-		goto err_put_joydev;
-	}
+	if (!client)
+		return -ENOMEM;
 
 	spin_lock_init(&client->buffer_lock);
 	client->joydev = joydev;
@@ -288,13 +270,12 @@ static int joydev_open(struct inode *inode, struct file *file)
 	file->private_data = client;
 	nonseekable_open(inode, file);
 
+	get_device(&joydev->dev);
 	return 0;
 
  err_free_client:
 	joydev_detach_client(joydev, client);
 	kfree(client);
- err_put_joydev:
-	put_device(&joydev->dev);
 	return error;
 }
 
@@ -747,19 +728,6 @@ static const struct file_operations joydev_fops = {
 	.llseek		= no_llseek,
 };
 
-static int joydev_install_chrdev(struct joydev *joydev)
-{
-	joydev_table[joydev->minor] = joydev;
-	return 0;
-}
-
-static void joydev_remove_chrdev(struct joydev *joydev)
-{
-	mutex_lock(&joydev_table_mutex);
-	joydev_table[joydev->minor] = NULL;
-	mutex_unlock(&joydev_table_mutex);
-}
-
 /*
  * Mark device non-existent. This disables writes, ioctls and
  * prevents new users from opening the device. Already posted
@@ -778,7 +746,8 @@ static void joydev_cleanup(struct joydev *joydev)
 
 	joydev_mark_dead(joydev);
 	joydev_hangup(joydev);
-	joydev_remove_chrdev(joydev);
+
+	cdev_del(&joydev->cdev);
 
 	/* joydev is marked dead so no one else accesses joydev->open */
 	if (joydev->open)
@@ -803,30 +772,33 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 			  const struct input_device_id *id)
 {
 	struct joydev *joydev;
-	int i, j, t, minor;
+	int i, j, t, minor, dev_no;
 	int error;
 
-	for (minor = 0; minor < JOYDEV_MINORS; minor++)
-		if (!joydev_table[minor])
-			break;
-
-	if (minor == JOYDEV_MINORS) {
-		pr_err("no more free joydev devices\n");
-		return -ENFILE;
+	minor = input_get_new_minor(JOYDEV_MINOR_BASE, JOYDEV_MINORS, true);
+	if (minor < 0) {
+		error = minor;
+		pr_err("failed to reserve new minor: %d\n", error);
+		return error;
 	}
 
 	joydev = kzalloc(sizeof(struct joydev), GFP_KERNEL);
-	if (!joydev)
-		return -ENOMEM;
+	if (!joydev) {
+		error = -ENOMEM;
+		goto err_free_minor;
+	}
 
 	INIT_LIST_HEAD(&joydev->client_list);
 	spin_lock_init(&joydev->client_lock);
 	mutex_init(&joydev->mutex);
 	init_waitqueue_head(&joydev->wait);
-
-	dev_set_name(&joydev->dev, "js%d", minor);
 	joydev->exist = true;
-	joydev->minor = minor;
+
+	dev_no = minor;
+	/* Normalize device number if it falls into legacy range */
+	if (dev_no < JOYDEV_MINOR_BASE + JOYDEV_MINORS)
+		dev_no -= JOYDEV_MINOR_BASE;
+	dev_set_name(&joydev->dev, "js%d", dev_no);
 
 	joydev->handle.dev = input_get_device(dev);
 	joydev->handle.name = dev_name(&joydev->dev);
@@ -880,7 +852,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 		}
 	}
 
-	joydev->dev.devt = MKDEV(INPUT_MAJOR, JOYDEV_MINOR_BASE + minor);
+	joydev->dev.devt = MKDEV(INPUT_MAJOR, minor);
 	joydev->dev.class = &input_class;
 	joydev->dev.parent = &dev->dev;
 	joydev->dev.release = joydev_free;
@@ -890,7 +862,8 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 	if (error)
 		goto err_free_joydev;
 
-	error = joydev_install_chrdev(joydev);
+	cdev_init(&joydev->cdev, &joydev_fops);
+	error = cdev_add(&joydev->cdev, joydev->dev.devt, 1);
 	if (error)
 		goto err_unregister_handle;
 
@@ -906,6 +879,8 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 	input_unregister_handle(&joydev->handle);
  err_free_joydev:
 	put_device(&joydev->dev);
+ err_free_minor:
+	input_free_minor(minor);
 	return error;
 }
 
@@ -915,6 +890,7 @@ static void joydev_disconnect(struct input_handle *handle)
 
 	device_del(&joydev->dev);
 	joydev_cleanup(joydev);
+	input_free_minor(MINOR(joydev->dev.devt));
 	input_unregister_handle(handle);
 	put_device(&joydev->dev);
 }
@@ -966,8 +942,6 @@ static struct input_handler joydev_handler = {
 	.match		= joydev_match,
 	.connect	= joydev_connect,
 	.disconnect	= joydev_disconnect,
-	.fops		= &joydev_fops,
-	.minor		= JOYDEV_MINOR_BASE,
 	.name		= "joydev",
 	.id_table	= joydev_ids,
 };
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 964e43d..7fd9d91 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -24,10 +24,8 @@
 #include <linux/random.h>
 #include <linux/major.h>
 #include <linux/device.h>
+#include <linux/cdev.h>
 #include <linux/kernel.h>
-#ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
-#include <linux/miscdevice.h>
-#endif
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Mouse (ExplorerPS/2) device interfaces");
@@ -61,17 +59,18 @@ struct mousedev_hw_data {
 
 struct mousedev {
 	int open;
-	int minor;
 	struct input_handle handle;
 	wait_queue_head_t wait;
 	struct list_head client_list;
 	spinlock_t client_lock; /* protects client_list */
 	struct mutex mutex;
 	struct device dev;
+	struct cdev cdev;
 	bool exist;
+	bool is_mixdev;
 
 	struct list_head mixdev_node;
-	int mixdev_open;
+	bool mixdev_open;
 
 	struct mousedev_hw_data packet;
 	unsigned int pkt_count;
@@ -114,10 +113,6 @@ struct mousedev_client {
 static unsigned char mousedev_imps_seq[] = { 0xf3, 200, 0xf3, 100, 0xf3, 80 };
 static unsigned char mousedev_imex_seq[] = { 0xf3, 200, 0xf3, 200, 0xf3, 80 };
 
-static struct input_handler mousedev_handler;
-
-static struct mousedev *mousedev_table[MOUSEDEV_MINORS];
-static DEFINE_MUTEX(mousedev_table_mutex);
 static struct mousedev *mousedev_mix;
 static LIST_HEAD(mousedev_mix_list);
 
@@ -433,7 +428,7 @@ static int mousedev_open_device(struct mousedev *mousedev)
 	if (retval)
 		return retval;
 
-	if (mousedev->minor == MOUSEDEV_MIX)
+	if (mousedev->is_mixdev)
 		mixdev_open_devices();
 	else if (!mousedev->exist)
 		retval = -ENODEV;
@@ -451,7 +446,7 @@ static void mousedev_close_device(struct mousedev *mousedev)
 {
 	mutex_lock(&mousedev->mutex);
 
-	if (mousedev->minor == MOUSEDEV_MIX)
+	if (mousedev->is_mixdev)
 		mixdev_close_devices();
 	else if (mousedev->exist && !--mousedev->open)
 		input_close_device(&mousedev->handle);
@@ -476,7 +471,7 @@ static void mixdev_open_devices(void)
 			if (mousedev_open_device(mousedev))
 				continue;
 
-			mousedev->mixdev_open = 1;
+			mousedev->mixdev_open = true;
 		}
 	}
 }
@@ -495,7 +490,7 @@ static void mixdev_close_devices(void)
 
 	list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
 		if (mousedev->mixdev_open) {
-			mousedev->mixdev_open = 0;
+			mousedev->mixdev_open = false;
 			mousedev_close_device(mousedev);
 		}
 	}
@@ -538,35 +533,17 @@ static int mousedev_open(struct inode *inode, struct file *file)
 	struct mousedev_client *client;
 	struct mousedev *mousedev;
 	int error;
-	int i;
 
 #ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
 	if (imajor(inode) == MISC_MAJOR)
-		i = MOUSEDEV_MIX;
+		mousedev = mousedev_mix;
 	else
 #endif
-		i = iminor(inode) - MOUSEDEV_MINOR_BASE;
-
-	if (i >= MOUSEDEV_MINORS)
-		return -ENODEV;
-
-	error = mutex_lock_interruptible(&mousedev_table_mutex);
-	if (error)
-		return error;
-
-	mousedev = mousedev_table[i];
-	if (mousedev)
-		get_device(&mousedev->dev);
-	mutex_unlock(&mousedev_table_mutex);
-
-	if (!mousedev)
-		return -ENODEV;
+		mousedev = container_of(inode->i_cdev, struct mousedev, cdev);
 
 	client = kzalloc(sizeof(struct mousedev_client), GFP_KERNEL);
-	if (!client) {
-		error = -ENOMEM;
-		goto err_put_mousedev;
-	}
+	if (!client)
+		return -ENOMEM;
 
 	spin_lock_init(&client->packet_lock);
 	client->pos_x = xres / 2;
@@ -579,13 +556,14 @@ static int mousedev_open(struct inode *inode, struct file *file)
 		goto err_free_client;
 
 	file->private_data = client;
+	nonseekable_open(inode, file);
+
+	get_device(&mousedev->dev);
 	return 0;
 
  err_free_client:
 	mousedev_detach_client(mousedev, client);
 	kfree(client);
- err_put_mousedev:
-	put_device(&mousedev->dev);
 	return error;
 }
 
@@ -785,29 +763,16 @@ static unsigned int mousedev_poll(struct file *file, poll_table *wait)
 }
 
 static const struct file_operations mousedev_fops = {
-	.owner =	THIS_MODULE,
-	.read =		mousedev_read,
-	.write =	mousedev_write,
-	.poll =		mousedev_poll,
-	.open =		mousedev_open,
-	.release =	mousedev_release,
-	.fasync =	mousedev_fasync,
-	.llseek = noop_llseek,
+	.owner		= THIS_MODULE,
+	.read		= mousedev_read,
+	.write		= mousedev_write,
+	.poll		= mousedev_poll,
+	.open		= mousedev_open,
+	.release	= mousedev_release,
+	.fasync		= mousedev_fasync,
+	.llseek		= noop_llseek,
 };
 
-static int mousedev_install_chrdev(struct mousedev *mousedev)
-{
-	mousedev_table[mousedev->minor] = mousedev;
-	return 0;
-}
-
-static void mousedev_remove_chrdev(struct mousedev *mousedev)
-{
-	mutex_lock(&mousedev_table_mutex);
-	mousedev_table[mousedev->minor] = NULL;
-	mutex_unlock(&mousedev_table_mutex);
-}
-
 /*
  * Mark device non-existent. This disables writes, ioctls and
  * prevents new users from opening the device. Already posted
@@ -842,24 +807,50 @@ static void mousedev_cleanup(struct mousedev *mousedev)
 
 	mousedev_mark_dead(mousedev);
 	mousedev_hangup(mousedev);
-	mousedev_remove_chrdev(mousedev);
+
+	cdev_del(&mousedev->cdev);
 
 	/* mousedev is marked dead so no one else accesses mousedev->open */
 	if (mousedev->open)
 		input_close_device(handle);
 }
 
+static int mousedev_reserve_minor(bool mixdev)
+{
+	int minor;
+
+	if (mixdev) {
+		minor = input_get_new_minor(MOUSEDEV_MIX, 1, false);
+		if (minor < 0)
+			pr_err("failed to reserve mixdev minor: %d\n", minor);
+	} else {
+		minor = input_get_new_minor(MOUSEDEV_MINOR_BASE,
+					    MOUSEDEV_MINORS, true);
+		if (minor < 0)
+			pr_err("failed to reserve new minor: %d\n", minor);
+	}
+
+	return minor;
+}
+
 static struct mousedev *mousedev_create(struct input_dev *dev,
 					struct input_handler *handler,
-					int minor)
+					bool mixdev)
 {
 	struct mousedev *mousedev;
+	int minor;
 	int error;
 
+	minor = mousedev_reserve_minor(mixdev);
+	if (minor < 0) {
+		error = minor;
+		goto err_out;
+	}
+
 	mousedev = kzalloc(sizeof(struct mousedev), GFP_KERNEL);
 	if (!mousedev) {
 		error = -ENOMEM;
-		goto err_out;
+		goto err_free_minor;
 	}
 
 	INIT_LIST_HEAD(&mousedev->client_list);
@@ -867,16 +858,21 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 	spin_lock_init(&mousedev->client_lock);
 	mutex_init(&mousedev->mutex);
 	lockdep_set_subclass(&mousedev->mutex,
-			     minor == MOUSEDEV_MIX ? SINGLE_DEPTH_NESTING : 0);
+			     mixdev ? SINGLE_DEPTH_NESTING : 0);
 	init_waitqueue_head(&mousedev->wait);
 
-	if (minor == MOUSEDEV_MIX)
+	if (mixdev) {
 		dev_set_name(&mousedev->dev, "mice");
-	else
-		dev_set_name(&mousedev->dev, "mouse%d", minor);
+	} else {
+		int dev_no = minor;
+		/* Normalize device number if it falls into legacy range */
+		if (dev_no < MOUSEDEV_MINOR_BASE + MOUSEDEV_MINORS)
+			dev_no -= MOUSEDEV_MINOR_BASE;
+		dev_set_name(&mousedev->dev, "mouse%d", dev_no);
+	}
 
-	mousedev->minor = minor;
 	mousedev->exist = true;
+	mousedev->is_mixdev = mixdev;
 	mousedev->handle.dev = input_get_device(dev);
 	mousedev->handle.name = dev_name(&mousedev->dev);
 	mousedev->handle.handler = handler;
@@ -885,17 +881,18 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 	mousedev->dev.class = &input_class;
 	if (dev)
 		mousedev->dev.parent = &dev->dev;
-	mousedev->dev.devt = MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + minor);
+	mousedev->dev.devt = MKDEV(INPUT_MAJOR, minor);
 	mousedev->dev.release = mousedev_free;
 	device_initialize(&mousedev->dev);
 
-	if (minor != MOUSEDEV_MIX) {
+	if (!mixdev) {
 		error = input_register_handle(&mousedev->handle);
 		if (error)
 			goto err_free_mousedev;
 	}
 
-	error = mousedev_install_chrdev(mousedev);
+	cdev_init(&mousedev->cdev, &mousedev_fops);
+	error = cdev_add(&mousedev->cdev, mousedev->dev.devt, 1);
 	if (error)
 		goto err_unregister_handle;
 
@@ -908,10 +905,12 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
  err_cleanup_mousedev:
 	mousedev_cleanup(mousedev);
  err_unregister_handle:
-	if (minor != MOUSEDEV_MIX)
+	if (!mixdev)
 		input_unregister_handle(&mousedev->handle);
  err_free_mousedev:
 	put_device(&mousedev->dev);
+ err_free_minor:
+	input_free_minor(minor);
  err_out:
 	return ERR_PTR(error);
 }
@@ -920,7 +919,8 @@ static void mousedev_destroy(struct mousedev *mousedev)
 {
 	device_del(&mousedev->dev);
 	mousedev_cleanup(mousedev);
-	if (mousedev->minor != MOUSEDEV_MIX)
+	input_free_minor(MINOR(mousedev->dev.devt));
+	if (!mousedev->is_mixdev)
 		input_unregister_handle(&mousedev->handle);
 	put_device(&mousedev->dev);
 }
@@ -938,7 +938,7 @@ static int mixdev_add_device(struct mousedev *mousedev)
 		if (retval)
 			goto out;
 
-		mousedev->mixdev_open = 1;
+		mousedev->mixdev_open = true;
 	}
 
 	get_device(&mousedev->dev);
@@ -954,7 +954,7 @@ static void mixdev_remove_device(struct mousedev *mousedev)
 	mutex_lock(&mousedev_mix->mutex);
 
 	if (mousedev->mixdev_open) {
-		mousedev->mixdev_open = 0;
+		mousedev->mixdev_open = false;
 		mousedev_close_device(mousedev);
 	}
 
@@ -969,19 +969,9 @@ static int mousedev_connect(struct input_handler *handler,
 			    const struct input_device_id *id)
 {
 	struct mousedev *mousedev;
-	int minor;
 	int error;
 
-	for (minor = 0; minor < MOUSEDEV_MINORS; minor++)
-		if (!mousedev_table[minor])
-			break;
-
-	if (minor == MOUSEDEV_MINORS) {
-		pr_err("no more free mousedev devices\n");
-		return -ENFILE;
-	}
-
-	mousedev = mousedev_create(dev, handler, minor);
+	mousedev = mousedev_create(dev, handler, false);
 	if (IS_ERR(mousedev))
 		return PTR_ERR(mousedev);
 
@@ -1054,27 +1044,59 @@ static const struct input_device_id mousedev_ids[] = {
 MODULE_DEVICE_TABLE(input, mousedev_ids);
 
 static struct input_handler mousedev_handler = {
-	.event =	mousedev_event,
-	.connect =	mousedev_connect,
-	.disconnect =	mousedev_disconnect,
-	.fops =		&mousedev_fops,
-	.minor =	MOUSEDEV_MINOR_BASE,
-	.name =		"mousedev",
-	.id_table =	mousedev_ids,
+	.event		= mousedev_event,
+	.connect	= mousedev_connect,
+	.disconnect	= mousedev_disconnect,
+	.name		= "mousedev",
+	.id_table	= mousedev_ids,
 };
 
 #ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
+#include <linux/miscdevice.h>
+
 static struct miscdevice psaux_mouse = {
-	PSMOUSE_MINOR, "psaux", &mousedev_fops
+	.minor	= PSMOUSE_MINOR,
+	.name	= "psaux",
+	.fops	= &mousedev_fops,
 };
-static int psaux_registered;
+static bool psaux_registered;
+
+static void __init mousedev_psaux_register(void)
+{
+	int error;
+
+	error = misc_register(&psaux_mouse);
+	if (error)
+		pr_warn("could not register psaux device, error: %d\n",
+			   error);
+	else
+		psaux_registered = true;
+
+}
+
+static void __exit mousedev_psaux_unregister(void)
+{
+	if (psaux_registered)
+		misc_deregister(&psaux_mouse);
+}
+
+#else
+
+static inline void mousedev_psaux_register(void)
+{
+}
+
+static inline void mousedev_psaux_unregister(void)
+{
+}
+
 #endif
 
 static int __init mousedev_init(void)
 {
 	int error;
 
-	mousedev_mix = mousedev_create(NULL, &mousedev_handler, MOUSEDEV_MIX);
+	mousedev_mix = mousedev_create(NULL, &mousedev_handler, true);
 	if (IS_ERR(mousedev_mix))
 		return PTR_ERR(mousedev_mix);
 
@@ -1084,14 +1106,7 @@ static int __init mousedev_init(void)
 		return error;
 	}
 
-#ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
-	error = misc_register(&psaux_mouse);
-	if (error)
-		pr_warn("could not register psaux device, error: %d\n",
-			   error);
-	else
-		psaux_registered = 1;
-#endif
+	mousedev_psaux_register();
 
 	pr_info("PS/2 mouse device common for all mice\n");
 
@@ -1100,10 +1115,7 @@ static int __init mousedev_init(void)
 
 static void __exit mousedev_exit(void)
 {
-#ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
-	if (psaux_registered)
-		misc_deregister(&psaux_mouse);
-#endif
+	mousedev_psaux_unregister();
 	input_unregister_handler(&mousedev_handler);
 	mousedev_destroy(mousedev_mix);
 }
diff --git a/include/linux/input.h b/include/linux/input.h
index 725dcd0..c698e7e 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1387,9 +1387,6 @@ struct input_handle;
  * @start: starts handler for given handle. This function is called by
  *	input core right after connect() method and also when a process
  *	that "grabbed" a device releases it
- * @fops: file operations this driver implements
- * @minor: beginning of range of 32 minors for devices this driver
- *	can provide
  * @name: name of the handler, to be shown in /proc/bus/input/handlers
  * @id_table: pointer to a table of input_device_ids this driver can
  *	handle
@@ -1420,8 +1417,6 @@ struct input_handler {
 	void (*disconnect)(struct input_handle *handle);
 	void (*start)(struct input_handle *handle);
 
-	const struct file_operations *fops;
-	int minor;
 	const char *name;
 
 	const struct input_device_id *id_table;
@@ -1488,6 +1483,10 @@ void input_reset_device(struct input_dev *);
 int __must_check input_register_handler(struct input_handler *);
 void input_unregister_handler(struct input_handler *);
 
+int __must_check input_get_new_minor(int legacy_base, unsigned int legacy_num,
+				     bool allow_dynamic);
+void input_free_minor(unsigned int minor);
+
 int input_handler_for_each_handle(struct input_handler *, void *data,
 				  int (*fn)(struct input_handle *, void *));
 
