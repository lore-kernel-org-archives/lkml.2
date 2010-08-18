Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0HRN6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:58:32 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:32419 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0HRN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:58:30 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: lkml@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RFCv2] notify userspace about time changes
Date: Wed, 18 Aug 2010 16:55:39 +0300
Message-Id: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.rc1.1.gb2842
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
 - updated against 2.6.36-rc1,
 - added notification/filtering options,
 - added Documentation/ABI/sysfs-kernel-time-notify interface description.

Certain userspace applications (like "clock" desktop applets or cron) might
want to be notified when some other application changes the system time. It
might also be important for an application to be able to distinguish between
its own and somebody else's time changes.

This patch implements a notification interface via eventfd mechanism. Proccess
wishing to be notified about time changes should create an eventfd and echo
its file descriptor along with notification options to /sys/kernel/time_notify.
After that, any calls to settimeofday()/stime()/adjtimex() made by other
processes will be signalled to this eventfd. Credits for suggesting the eventfd
mechanism for this purpose go to Kirill Shutemov.

So far, this implementation can only filter out notifications caused by
time change calls made by the process that wrote the eventfd descriptor to
sysfs, but not its children which (might) have inherited the eventfd. It
is so far not clear to me whether this is bad and more confusing than
excluding such children as well.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Kirill A. Shutemov <kirill@shutemov.name>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <johnstul@us.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Jon Hunter <jon-hunter@ti.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: David Howells <dhowells@redhat.com>
CC: Avi Kivity <avi@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: John Kacur <jkacur@redhat.com>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Chris Friesen <chris.friesen@genband.com>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
---
 Documentation/ABI/testing/sysfs-kernel-time-notify |   39 ++++
 include/linux/time.h                               |   11 ++
 init/Kconfig                                       |    8 +
 kernel/Makefile                                    |    1 +
 kernel/time.c                                      |   11 +-
 kernel/time_notify.c                               |  184 ++++++++++++++++++++
 6 files changed, 252 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-time-notify
 create mode 100644 kernel/time_notify.c

diff --git a/Documentation/ABI/testing/sysfs-kernel-time-notify b/Documentation/ABI/testing/sysfs-kernel-time-notify
new file mode 100644
index 0000000..fe5c960
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-time-notify
@@ -0,0 +1,39 @@
+What:		/sys/kernel/time_notify
+Date:		August 2010
+Contact:	Alexander Shishkin <virtuoso@slind.org>
+Description:
+		This file is used by processes which want to receive
+		notifications about system time changes, to communicate their
+		eventfd descriptor number along with the type of event they
+		wish to subscribe to and filtering options. Every time one of
+		the processes in the system succeeds in doing a settimeofday()
+		or adjtimex(), this eventfd will be signalled.
+		This file is not readable. Upon write, this is the format
+		accepted by the kernel:
+		<fd> <want-others> <want-own> <want-set> <want-adj>
+		where
+		- <fd> is the file descriptor of the eventfd that the process
+		will listen to for time change events;
+		- <want-others> is 0 or 1 depending on whether the process wants
+		to be notified about other processes' time changes;
+		- <want-own> -- likewise, for process' own time changes;
+		- <want-set> is 0 or 1 depending on whether the process wants
+		to be notified about settimeofday()/stime() system calls;
+		- <want-adj> -- likewise, for adjtimex() system call.
+
+		A simple snippet of C code illustrates the usage pattern:
+
+		     efd = eventfd(0, 0);
+		     fd = open("/sys/kernel/time_notify", O_WRONLY);
+		     fdprintf(fd, "%d 1 0 1 1", efd);
+		     close(fd);
+
+		     fds[0].fd = efd;
+		     fds[0].events = POLLIN;
+		     while (poll(fds, 1, -1) > 0) {
+		           uint64_t n;
+
+			   read(efd, &n, 8);
+			   printf("time has been modified %d time(s)\n", n);
+		     }
+
diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..72b6060 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -252,6 +252,17 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
+
+/* time change events */
+#define TIME_EVENT_SET 0
+#define TIME_EVENT_ADJ 1
+
+#ifdef CONFIG_TIME_NOTIFY
+void time_notify_all(int type);
+#else
+#define time_notify_all(x) do {} while (0)
+#endif
+
 #endif /* __KERNEL__ */
 
 #define NFDBITS			__NFDBITS
diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..aa4d890 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -980,6 +980,14 @@ config PERF_USE_VMALLOC
 	help
 	  See tools/perf/design.txt for details
 
+config TIME_NOTIFY
+	bool
+	default y
+	depends on EVENTFD
+	help
+	  Enable time change notification events to userspace via
+	  eventfd.
+
 menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
diff --git a/kernel/Makefile b/kernel/Makefile
index 0b72d1a..ac53c67 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_TIME_NOTIFY) += time_notify.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/time.c b/kernel/time.c
index ba9b338..b4155b8 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -92,7 +92,9 @@ SYSCALL_DEFINE1(stime, time_t __user *, tptr)
 	if (err)
 		return err;
 
-	do_settimeofday(&tv);
+	err = do_settimeofday(&tv);
+	if (!err)
+		time_notify_all(TIME_EVENT_SET);
 	return 0;
 }
 
@@ -177,7 +179,10 @@ int do_sys_settimeofday(struct timespec *tv, struct timezone *tz)
 		/* SMP safe, again the code in arch/foo/time.c should
 		 * globally block out interrupts when it runs.
 		 */
-		return do_settimeofday(tv);
+		error = do_settimeofday(tv);
+		if (!error)
+			time_notify_all(TIME_EVENT_SET);
+		return error;
 	}
 	return 0;
 }
@@ -215,6 +220,8 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
 	if(copy_from_user(&txc, txc_p, sizeof(struct timex)))
 		return -EFAULT;
 	ret = do_adjtimex(&txc);
+	if (!ret)
+		time_notify_all(TIME_EVENT_ADJ);
 	return copy_to_user(txc_p, &txc, sizeof(struct timex)) ? -EFAULT : ret;
 }
 
diff --git a/kernel/time_notify.c b/kernel/time_notify.c
new file mode 100644
index 0000000..21c1bea
--- /dev/null
+++ b/kernel/time_notify.c
@@ -0,0 +1,184 @@
+/*
+ * linux/kernel/time_notify.c
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Alexander Shishkin
+ *
+ * This file implements an interface to communicate time changes to userspace.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/eventfd.h>
+#include <linux/kobject.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/poll.h>
+#include <linux/err.h>
+
+/*
+ * A process can "subscribe" to receive a notification via eventfd that
+ * some other process has called stime/settimeofday/adjtimex.
+ */
+struct time_event {
+	struct eventfd_ctx	*eventfd;
+	struct task_struct	*watcher;
+	unsigned int		want_others:1;
+	unsigned int		want_own:1;
+	unsigned int		want_set:1;
+	unsigned int		want_adj:1;
+	struct work_struct	remove;
+	wait_queue_t		wq;
+	wait_queue_head_t	*wqh;
+	poll_table		pt;
+	struct list_head	list;
+};
+
+static LIST_HEAD(event_list);
+static DEFINE_SPINLOCK(event_lock);
+
+/*
+ * Do the necessary cleanup when the eventfd is being closed
+ */
+static void time_event_remove(struct work_struct *work)
+{
+	struct time_event *evt = container_of(work, struct time_event, remove);
+
+	kfree(evt);
+}
+
+static int time_event_wakeup(wait_queue_t *wq, unsigned int mode, int sync,
+			     void *key)
+{
+	struct time_event *evt = container_of(wq, struct time_event, wq);
+	unsigned long flags = (unsigned long)key;
+
+	if (flags & POLLHUP) {
+		__remove_wait_queue(evt->wqh, &evt->wq);
+		spin_lock(&event_lock);
+		list_del(&evt->list);
+		spin_unlock(&event_lock);
+
+		schedule_work(&evt->remove);
+	}
+
+	return 0;
+}
+
+static void time_event_ptable_queue_proc(struct file *file,
+					 wait_queue_head_t *wqh, poll_table *pt)
+{
+	struct time_event *evt = container_of(pt, struct time_event, pt);
+
+	evt->wqh = wqh;
+	add_wait_queue(wqh, &evt->wq);
+}
+
+/*
+ * Process wishing to be notified about time changes should write its
+ * eventfd's descriptor to /sys/kernel/time_notify. This eventfd will
+ * then be signalled about any time changes made by any process *but*
+ * this one.
+ */
+static int time_notify_store(struct kobject *kobj, struct kobj_attribute *attr,
+			     const char *buf, size_t n)
+{
+	int ret;
+	unsigned int fd;
+	unsigned int want_others, want_own, want_set, want_adj;
+	struct file *file;
+	struct time_event *evt;
+
+	evt = kmalloc(sizeof(*evt), GFP_KERNEL);
+	if (!evt)
+		return -ENOMEM;
+
+	ret = sscanf(buf, "%u %u %u %u %u", &fd, &want_others, &want_own,
+		     &want_set, &want_adj);
+	if (ret < 4) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	evt->want_others = !!want_others;
+	evt->want_own = !!want_own;
+	evt->want_set = !!want_set;
+	evt->want_adj = !!want_adj;
+
+	file = eventfd_fget(fd);
+	if (IS_ERR(file)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	evt->eventfd = eventfd_ctx_fileget(file);
+	if (!evt->eventfd) {
+		ret = PTR_ERR(evt->eventfd);
+		goto out_fput;
+	}
+
+	INIT_LIST_HEAD(&evt->list);
+	INIT_WORK(&evt->remove, time_event_remove);
+
+	init_waitqueue_func_entry(&evt->wq, time_event_wakeup);
+	init_poll_funcptr(&evt->pt, time_event_ptable_queue_proc);
+
+	if (file->f_op->poll(file, &evt->pt) & POLLHUP) {
+		ret = 0;
+		goto out_fput;
+	}
+
+	evt->watcher = current;
+
+	spin_lock(&event_lock);
+	list_add(&event_list, &evt->list);
+	spin_unlock(&event_lock);
+
+	fput(file);
+
+	return n;
+
+out_fput:
+	fput(file);
+
+out_free:
+	kfree(evt);
+
+	return ret;
+}
+
+void time_notify_all(int type)
+{
+	struct list_head *tmp;
+
+	spin_lock(&event_lock);
+	list_for_each(tmp, &event_list) {
+		struct time_event *e = container_of(tmp, struct time_event,
+						    list);
+
+		if (type == TIME_EVENT_SET && !e->want_set)
+			continue;
+		else if (type == TIME_EVENT_ADJ && !e->want_adj)
+			continue;
+
+		if (e->watcher == current && !e->want_own)
+			continue;
+		else if (e->watcher != current && !e->want_others)
+			continue;
+
+		eventfd_signal(e->eventfd, 1);
+	}
+	spin_unlock(&event_lock);
+}
+
+static struct kobj_attribute time_notify_attr =
+	__ATTR(time_notify, S_IWUGO, NULL, time_notify_store);
+
+static int time_notify_init(void)
+{
+	return sysfs_create_file(kernel_kobj, &time_notify_attr.attr);
+}
+
+core_initcall(time_notify_init);
-- 
1.7.1

