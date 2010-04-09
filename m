Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0DITVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:21:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23110 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab0DITVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:21:43 -0400
Date: Fri, 09 Apr 2010 21:21:17 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 0/7] The FunctionFS composite function
To: linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Davide Libenzi <davidel@xmailserver.org>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <cover.1270835924.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,


*Changes from Previous Version*

This is the second version of the FunctionFS patchset.

1. A new wait_event_interruptible_locked() macro (in 6 variants) has
   been added and used in the f_fs.c instead of an open-coding it.
   This, again, was suggested by Greg.

   As a side effect of the above, also a patch for fs/timerfd.c is
   provided that uses the new facility (hence I'm ccing it to fsdevel
   and timerfd folks as well).

2. The __init/__exit tags from various USB related files have been
   removed instead of using __usb_* tags that can be switched.  This
   was requested by Greg.

3. A bug in f_fs.c in has been fixed (the one I've spotted and
   announced earlier on the list).  Also there were some other tiny
   changes to f_fs.c.

4. The testusb.c now looks for usbfs in both /dev/bus/usb and
   /proc/bus/usb.  It was suggested by Heikki Krogerus that some
   distributions don't provide usbfs in /proc.  Also -A argument has
   been added to let user supply the path.

Chosen differences as a diff are included at the end of the mail.


*Prologue*

Patches that follow implement the FunctionFS composite function that
is a conversion of GadgetFS to use the composite framework.  Possible
uses are:

1. what Peter Korsgaard has described[1]:

> I could certainly imagine doing something like that, E.G. reuse the
> existing g_serial functionality while implementing E.G. a HID device
> though gadgetfs.

2. or what Rupesh Gujare has described[2]:

> In my requirement, I want to have Media Transfer Protocol (MTP)
> (which uses user level usb driver (usb.c) & gadgetfs) along with
> modem functionality(f_acm.c).
>
> Currently either of them ie. f_acm (as part of composite driver
> along with ums) or gadgetfs (as independent module) can be loaded,
> which allows only one active USB function at a time.
>
> If gadgetfs can be made as a composite function then I can have both
> functionality at same time.


*The Patches*

The first patch creates a new wait_event_interruptible_locked()
interface for waiting on events.  While holding the wait queue's lock.
Refer to the commit message for usage.

The second patch makes use of the new interface in fs/timerfd.c file
replacing some 20 lines by a single macro call.

Next three patches implement the FunctionFS and a composite gadget
that uses FunctionFS and Ethernet function (with the later function
optionally disabled via Kconfig).

The last three patches provide a testing code for the FunctionFS.
My original intend was to provide those just for anyone who'd like to
test the code and not to include them in the Linux source tree but if
that seems appropriate then why not?


*How FunctionFS works*

(Copied from second patch commit message.)

>From kernel point of view it is just a composite function with some
unique behaviour.  It may be added to an USB configuration only after
the user space driver has registered by writing descriptors and
strings (the user space program has to provide the same information
that kernel level composite functions provide when they are added to
the configuration).

This in particular means that the composite initialisation functions
may not be in init section (ie. may not use the __init tag) hence the
first and fourth patch in the series.


>From user space point of view it is a file system which when
mounted provide an "ep0" file.  User space driver need to
write descriptors and strings to that file.  It does not need
to worry about endpoints, interfaces or strings numbers but
simply provide descriptors such as if the function was the
only one (endpoints and strings numbers starting from one and
interface numbers starting from core).  The FunctionFS changes
numbers of those as needed also handling situation when
numbers differ in different configurations.

When descriptors and strings are written "ep#" files appear
(one for each declared endpoint) which handle communication on
a single endpoint.  Again, FunctionFS takes care of the real
numbers and changing of the configuration (which means that
"ep1" file may be really mapped to (say) endpoint 3 (and when
configuration changes to (say) endpoint 2)).  "ep0" is used
for receiving events and handling setup requests.

When all files are closed the function disables itself.


*Testing*

The fifth patch implement a simple source/sink FunctionFS driver based
on similar driver for GadgetFS by David Brownell[3].  It registers
a dual-speed function with a single IN and single OUT endpoints.

The sixth and seventh patch provide a host-side testing code.  This is
what David Brownell has created a while back[4] with a simple fix to
make the tool detect the number of our source/sink interface.

Still, you will need to configure the gadget to report idProduct ==
0xa4a4 (an "echo 0xa4a4 >/sys/module/g_ffs/parameters/usb_product"
should suffice) or configure host to handle 0x0525:0xa4ac devices
using the usbtest driver.

Hence, the simplest way to run the test is to do the following:

* On target (machine that runs has the gadget) as root:
  $ echo 0xa4a4 >/sys/module/g_ffs/parameters/usb_product &&
  $ mkdir /dev/ffs &&
  $ mount -t functionfs ffs /dev/ffs &&
  $ cd /dev/ffs &&
  $ /path/to/ffs-test
* On host (as root):
  $ testusb -a

At this point I have to admit that communication on EP0 has not yet
been tested, so beware of bugs there.


*Request for Comments and Future Work*

Regarding presented version there are two aspects I'd like to discuss.

1. First of all, the current code uses similar approach GadgetFS
   used -- there is a single file ("ep0" in case of FunctionFS and
   named after the controller in case of GadgetFS) that is used to
   receive events from kernel and handle ep0 communication.

   I think it is not the best approach as it'd be simpler and cleaner
   if there were two files: one for receiving events and another for
   handling ep0 communication.

   What do you think? Should I keep the current version or change to
   code to use two files?

2. What still needs to be implemented is a mechanism allowing double
   buffering (and in effect transmission without pauses) and maybe
   single-thread user-space driver implementation.

   I'd like to ask what would be the best way to achieve this.
   GadgetFS implements asynchronous I/O -- is it still the best
   option?

3. The last thing I'd like to mention is that the FunctionFS is
   designed in such a way that with some more work it will be able
   to mount it several times so in the end a gadget could use several
   FunctionFS functions.

   The idea is that each FunctionFS instance is identified by the
   device name used when mounting.

   One can imagine a gadget that has an Ethernet, MTP and HID
   interfaces where the last two are implemented via FunctionFS.  On
   user space level it would look like this:

   $ modprobe g_foo
   $ mkdir /dev/ffs-mtp && mount -t functionfs mtp /dev/ffs-mtp
   $ ( cd /dev/ffs-mtp && mtp-daemon ) &
   $ mkdir /dev/ffs-hid && mount -t functionfs hid /dev/ffs-hid
   $ ( cd /dev/ffs-hid && hid-daemon ) &

   On kernel level the gadget would check ffs_data->dev_name to
   identify whether it's FunctionFS designed for MTP ("mtp") or HID
   ("hid").


____________________________________________________________
[1] http://article.gmane.org/gmane.linux.usb.general/23890
[2] http://article.gmane.org/gmane.linux.usb.general/23902
[3] http://www.linux-usb.org/gadget/usb.c
[4] http://www.linux-usb.org/usbtest/testusb.c


David Brownell (1):
  USB: testusb: an USB testing application

Michal Nazarewicz (7):
  wait_event_interruptible_locked() interface
  fs/timerfd.c: make use of wait_event_interruptible_locked_irq()
  USB: gadget: __init and __exit tags removed
  USB: f_fs: the FunctionFS driver
  USB: g_ffs: the FunctionFS gadget driver
  USB: ffs-test: FunctionFS testing program
  USB: testusb: testusb compatibility with FunctionFS gadget

 drivers/usb/gadget/Kconfig          |   21 +-
 drivers/usb/gadget/Makefile         |    2 +
 drivers/usb/gadget/composite.c      |   21 +-
 drivers/usb/gadget/config.c         |    4 +-
 drivers/usb/gadget/epautoconf.c     |   12 +-
 drivers/usb/gadget/f_acm.c          |   32 +-
 drivers/usb/gadget/f_ecm.c          |   33 +-
 drivers/usb/gadget/f_fs.c           | 2453 +++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 drivers/usb/gadget/f_rndis.c        |   34 +-
 drivers/usb/gadget/g_ffs.c          |  322 +++++
 drivers/usb/gadget/u_ether.c        |    4 +-
 fs/timerfd.c                        |   22 +-
 include/linux/usb/functionfs.h      |  199 +++
 include/linux/wait.h                |  231 ++++-
 kernel/sched.c                      |    1 +
 tools/usb/ffs-test.c                |  554 ++++++++
 tools/usb/testusb.c                 |  537 ++++++++
 18 files changed, 4392 insertions(+), 92 deletions(-)
 create mode 100644 drivers/usb/gadget/f_fs.c
 create mode 100644 drivers/usb/gadget/g_ffs.c
 create mode 100644 include/linux/usb/functionfs.h
 create mode 100644 tools/usb/ffs-test.c
 create mode 100644 tools/usb/testusb.c


*Diff with Previous Version*

diff --git a/include/linux/wait.h b/include/linux/wait.h
see first patch

diff --git a/fs/timerfd.c b/fs/timerfd.c
see second patch

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
diff --git a/drivers/usb/gadget/config.c b/drivers/usb/gadget/config.c
diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
basically: sed -e s/__usb_\(init\|exit\|init_or_exit\_/__cold/ \
               -e s/__usb_initdata//

diff --git a/drivers/usb/gadget/usb-init-exit.h b/drivers/usb/gadget/usb-init-exit.h
deleted file mode 100644

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -336,7 +336,7 @@ ffs_sb_create_file(struct super_block *sb, const char *name, void *data,
 static int ffs_mutex_lock(struct mutex *mutex, unsigned nonblock)
 	__attribute__((warn_unused_result, nonnull));
 static char *ffs_prepare_buffer(const char * __user buf, size_t len)
-	__attribute__((warn_unused_result));
+	__attribute__((warn_unused_result, nonnull));
 
 
 /* Control file aka ep0 *****************************************************/
@@ -533,34 +533,6 @@ done_spin:
 
 
 
-static int __ffs_ep0_read_wait_for_events(struct ffs_data *ffs)
-{
-	/* We are holding ffs->ev.waitq.lock */
-
-	DEFINE_WAIT(wait);
-	int ret = 0;
-
-	wait.flags |= WQ_FLAG_EXCLUSIVE;
-	__add_wait_queue_tail(&ffs->ev.waitq, &wait);
-
-	do {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (signal_pending(current)) {
-			ret = -ERESTARTSYS;
-			break;
-		}
-
-		spin_unlock_irq(&ffs->ev.waitq.lock);
-		schedule();
-		spin_lock_irq(&ffs->ev.waitq.lock);
-	} while (!ffs->ev.count);
-
-	__remove_wait_queue(&ffs->ev.waitq, &wait);
-	__set_current_state(TASK_RUNNING);
-
-	return ret;
-}
-
 static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 				     size_t n)
 {
@@ -580,7 +552,13 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 		}
 	} while (++i < n);
 
-	ffs->ev.count = 0;
+	if (n < ffs->ev.count) {
+		ffs->ev.count -= n;
+		memmove(ffs->ev.types, ffs->ev.types + n,
+			ffs->ev.count * sizeof *ffs->ev.types);
+	} else {
+		ffs->ev.count = 0;
+	}
 
 	spin_unlock_irq(&ffs->ev.waitq.lock);
 	mutex_unlock(&ffs->mutex);
@@ -594,8 +572,8 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 			    size_t len, loff_t *ptr)
 {
 	struct ffs_data *ffs = file->private_data;
+	char *data = NULL;
 	size_t n;
-	char *data;
 	int ret;
 
 	ENTER();
@@ -638,8 +616,7 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 			break;
 		}
 
-		if (!ffs->ev.count &&
-		    unlikely(__ffs_ep0_read_wait_for_events(ffs))) {
+		if (unlikely(wait_event_interruptible_exclusive_locked_irq(ffs->ev.waitq, ffs->ev.count))) {
 			ret = -EINTR;
 			break;
 		}
@@ -658,17 +635,18 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 
 		spin_unlock_irq(&ffs->ev.waitq.lock);
 
-		data = ffs_prepare_buffer(NULL, len);
-		if (unlikely(IS_ERR(data))) {
-			ret = PTR_ERR(data);
-			goto done_mutex;
+		if (likely(len)) {
+			data = kmalloc(len, GFP_KERNEL);
+			if (unlikely(!data)) {
+				ret = -ENOMEM;
+				goto done_mutex;
+			}
 		}
 
 		spin_lock_irq(&ffs->ev.waitq.lock);
 
 		/* See ffs_ep0_write() */
 		if (FFS_SETUP_STATE(ffs) == FFS_SETUP_CANCELED) {
-			kfree(data);
 			ret = -EIDRM;
 			break;
 		}
@@ -677,7 +655,6 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 		ret = __ffs_ep0_queue_wait(ffs, data, len);
 		if (likely(ret > 0) && unlikely(__copy_to_user(buf, data, len)))
 			ret = -EFAULT;
-		kfree(data);
 		goto done_mutex;
 
 	default:
@@ -688,6 +665,7 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 	spin_unlock_irq(&ffs->ev.waitq.lock);
 done_mutex:
 	mutex_unlock(&ffs->mutex);
+	kfree(data);
 	return ret;
 }
 
@@ -1768,7 +1746,7 @@ static int __must_check ffs_do_descs(unsigned count, char *data, unsigned len,
 				     ffs_entity_callback entity, void *priv)
 {
 	const unsigned _len = len;
-	long num = 0;
+	unsigned long num = 0;
 
 	ENTER();
 
@@ -1781,7 +1759,7 @@ static int __must_check ffs_do_descs(unsigned count, char *data, unsigned len,
 		/* Record "descriptor" entitny */
 		ret = entity(FFS_DESCRIPTOR, (u8 *)num, (void *)data, priv);
 		if (unlikely(ret < 0)) {
-			FDBG("entity DESCRIPTOR(%02x); ret = %d", num, ret);
+			FDBG("entity DESCRIPTOR(%02lx); ret = %d", num, ret);
 			return ret;
 		}
 
@@ -2461,15 +2439,13 @@ static char *ffs_prepare_buffer(const char * __user buf, size_t len)
 	if (unlikely(!data))
 		return ERR_PTR(-ENOMEM);
 
-	if (likely(buf != NULL) && unlikely(__copy_from_user(data, buf, len))) {
+	if (unlikely(__copy_from_user(data, buf, len))) {
 		kfree(data);
 		return ERR_PTR(-EFAULT);
 	}
 
-	if (likely(buf)) {
-		FVDBG("Buffer from user space:");
-		ffs_dump_mem("", data, len);
-	}
+	FVDBG("Buffer from user space:");
+	ffs_dump_mem("", data, len);
 
 	return data;
 }


diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index beaeea3..0a1a5b5 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -1,8 +1,10 @@
-/* $(CROSS_COMPILE)cc -Wall -g -lpthread -o testusb testusb.c */
+/* $(CROSS_COMPILE)cc -Wall -Wextra -g -lpthread -o testusb testusb.c */
 
 /*
  * Copyright (c) 2002 by David Brownell
- * 
+ * Copyright (c) 2010 by Samsung Electronics
+ * Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2 of the License, or (at your
@@ -25,6 +27,7 @@
 #include <pthread.h>
 #include <unistd.h>
 #include <errno.h>
+#include <limits.h>
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -236,6 +239,8 @@ static int find_testdev(const char *name, const struct stat *sb, int flag)
 	int				ifnum;
 	struct testdev			*entry;
 
+	(void)sb; /* unused */
+
 	if (flag != FTW_F)
 		return 0;
 	/* ignore /proc/bus/usb/{devices,drivers} */
@@ -339,11 +344,51 @@ restart:
 	return arg;
 }
 
+static const char *usbfs_dir_find(void)
+{
+	static char usbfs_path_0[] = "/dev/usb/devices";
+	static char usbfs_path_1[] = "/proc/bus/usb/devices";
+
+	static char *const usbfs_paths[] = {
+		usbfs_path_0, usbfs_path_1
+	};
+
+	static char *const *
+		end = usbfs_paths + sizeof usbfs_paths / sizeof *usbfs_paths;
+
+	char *const *it = usbfs_paths;
+	do {
+		int fd = open(*it, O_RDONLY);
+		close(fd);
+		if (fd >= 0) {
+			strrchr(*it, '/')[0] = '\0';
+			return *it;
+		}
+	} while (++it != end);
+
+	return NULL;
+}
+
+static int parse_num(unsigned *num, const char *str)
+{
+	unsigned long val;
+	char *end;
+
+	errno = 0;
+	val = strtoul(str, &end, 0);
+	if (errno || *end || val > UINT_MAX)
+		return -1;
+	*num = val;
+	return 0;
+}
+
 int main (int argc, char **argv)
 {
+
 	int			c;
 	struct testdev		*entry;
 	char			*device;
+	const char		*usbfs_dir = NULL;
 	int			all = 0, forever = 0, not = 0;
 	int			test = -1 /* all */;
 	struct usbtest_param	param;
@@ -365,23 +410,24 @@ int main (int argc, char **argv)
 	/* for easy use when hotplugging */
 	device = getenv ("DEVICE");
 
-	while ((c = getopt (argc, argv, "D:ac:g:hns:t:v:")) != EOF)
+	while ((c = getopt (argc, argv, "D:aA:c:g:hns:t:v:")) != EOF)
 	switch (c) {
 	case 'D':	/* device, if only one */
 		device = optarg;
 		continue;
+	case 'A':	/* use all devices with specified usbfs dir */
+		usbfs_dir = optarg;
+		/* FALL THROUGH */
 	case 'a':	/* use all devices */
-		device = 0;
+		device = NULL;
 		all = 1;
 		continue;
 	case 'c':	/* count iterations */
-		param.iterations = atoi (optarg);
-		if (param.iterations < 0)
+		if (parse_num(&param.iterations, optarg))
 			goto usage;
 		continue;
 	case 'g':	/* scatter/gather entries */
-		param.sglen = atoi (optarg);
-		if (param.sglen < 0)
+		if (parse_num(&param.sglen, optarg))
 			goto usage;
 		continue;
 	case 'l':	/* loop forever */
@@ -391,8 +437,7 @@ int main (int argc, char **argv)
 		not = 1;
 		continue;
 	case 's':	/* size of packet */
-		param.length = atoi (optarg);
-		if (param.length < 0)
+		if (parse_num(&param.length, optarg))
 			goto usage;
 		continue;
 	case 't':	/* run just one test */
@@ -401,15 +446,14 @@ int main (int argc, char **argv)
 			goto usage;
 		continue;
 	case 'v':	/* vary packet size by ... */
-		param.vary = atoi (optarg);
-		if (param.vary < 0)
+		if (parse_num(&param.vary, optarg))
 			goto usage;
 		continue;
 	case '?':
 	case 'h':
 	default:
 usage:
-		fprintf (stderr, "usage: %s [-an] [-D dev]\n"
+		fprintf (stderr, "usage: %s [-n] [-D dev | -a | -A usbfs-dir]\n"
 			"\t[-c iterations]  [-t testnum]\n"
 			"\t[-s packetsize] [-g sglen] [-v vary]\n",
 			argv [0]);
@@ -423,13 +467,17 @@ usage:
 		goto usage;
 	}
 
-	if ((c = open ("/proc/bus/usb/devices", O_RDONLY)) < 0) {
-		fputs ("usbfs files are missing\n", stderr);
-		return -1;
+	/* Find usbfs mount point */
+	if (!usbfs_dir) {
+		usbfs_dir = usbfs_dir_find();
+		if (!usbfs_dir) {
+			fputs ("usbfs files are missing\n", stderr);
+			return -1;
+		}
 	}
 
 	/* collect and list the test devices */
-	if (ftw ("/proc/bus/usb", find_testdev, 3) != 0) {
+	if (ftw (usbfs_dir, find_testdev, 3) != 0) {
 		fputs ("ftw failed; is usbfs missing?\n", stderr);
 		return -1;
 	}
