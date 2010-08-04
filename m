Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab0HDMva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:51:30 -0400
Received: from smtp.nokia.com ([192.100.105.134]:57554 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab0HDMv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:51:27 -0400
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
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] notify userspace about time changes
Date: Wed,  4 Aug 2010 15:48:28 +0300
Message-Id: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.rc1.1.gb2842
X-OriginalArrivalTime: 04 Aug 2010 12:49:24.0513 (UTC) FILETIME=[776FE910:01CB33D3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain userspace applications (like "clock" desktop applets or ntpd) might
want to be notified when some other application changes the system time. It
might also be important for an application to be able to distinguish between
its own and somebody else's time changes.

This patch implements a notification interface via eventfd mechanism. Proccess
wishing to be notified about time changes should create an eventfd and echo
its file descriptor to /sys/kernel/time_notify. After that, any calls to
settimeofday()/stime()/adjtimex() made by other processes will be signalled
to this eventfd. Credits for suggesting the eventfd mechanism for this
purpose go te Kirill Shutemov.

So far, this implementation can only filter out notifications caused by
time change calls made by the process that wrote the eventfd descriptor to
sysfs, but not its children which (might) have inherited the eventfd. It
is so far not clear to me whether this is bad and more confusing than
excluding such children as well.

Similar mechanism can also be used for signalling other (all?) system calls
made by certain (all?) processes without resorting to ptrace (which won't
help if you don't know what processes you'd like to look after), given
proper permission checks etc.

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
CC: linux-kernel@vger.kernel.org
---
 include/linux/time.h |    7 ++
 init/Kconfig         |    7 ++
 kernel/Makefile      |    1 +
 kernel/time.c        |   11 +++-
 kernel/time_notify.c |  158 ++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 182 insertions(+), 2 deletions(-)
 create mode 100644 kernel/time_notify.c

diff --git a/include/linux/time.h b/include/linux/time.h
index ea3559f..9fca62b 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -237,6 +237,13 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
+
+#ifdef CONFIG_TIME_NOTIFY
+void time_notify_all(void);
+#else
+#define time_notify_all() do {} while (0)
+#endif
+
 #endif /* __KERNEL__ */
 
 #define NFDBITS			__NFDBITS
diff --git a/init/Kconfig b/init/Kconfig
index 5cff9a9..f7271f8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -976,6 +976,13 @@ config PERF_USE_VMALLOC
 	help
 	  See tools/perf/design.txt for details
 
+config TIME_NOTIFY
+	bool
+	depends on EVENTFD
+	help
+	  Enable time change notification events to userspace via
+	  eventfd.
+
 menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
diff --git a/kernel/Makefile b/kernel/Makefile
index 057472f..7a25ee4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_TIME_NOTIFY) += time_notify.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/time.c b/kernel/time.c
index 848b1c2..74d355e 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -92,7 +92,9 @@ SYSCALL_DEFINE1(stime, time_t __user *, tptr)
 	if (err)
 		return err;
 
-	do_settimeofday(&tv);
+	err = do_settimeofday(&tv);
+	if (!err)
+		time_notify_all();
 	return 0;
 }
 
@@ -177,7 +179,10 @@ int do_sys_settimeofday(struct timespec *tv, struct timezone *tz)
 		/* SMP safe, again the code in arch/foo/time.c should
 		 * globally block out interrupts when it runs.
 		 */
-		return do_settimeofday(tv);
+		error = do_settimeofday(tv);
+		if (!error)
+			time_notify_all();
+		return error;
 	}
 	return 0;
 }
@@ -215,6 +220,8 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
 	if(copy_from_user(&txc, txc_p, sizeof(struct timex)))
 		return -EFAULT;
 	ret = do_adjtimex(&txc);
+	if (!ret)
+		time_notify_all();
 	return copy_to_user(txc_p, &txc, sizeof(struct timex)) ? -EFAULT : ret;
 }
 
diff --git a/kernel/time_notify.c b/kernel/time_notify.c
new file mode 100644
index 0000000..c674f25
--- /dev/null
+++ b/kernel/time_notify.c
@@ -0,0 +1,158 @@
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
+		remove_wait_queue_locked(evt->wqh, &evt->wq);
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
+	int ret = n;
+	unsigned int fd;
+	struct file *file;
+	struct time_event *evt;
+
+	evt = kmalloc(sizeof(*evt), GFP_KERNEL);
+	if (!evt)
+		return -ENOMEM;
+
+	fd = strict_strtoul(buf, NULL, 10);
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
+	return ret;
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
+void time_notify_all(void)
+{
+	struct list_head *tmp;
+
+	spin_lock(&event_lock);
+	list_for_each(tmp, &event_list) {
+		struct time_event *e = container_of(tmp, struct time_event,
+						    list);
+
+		if (e->watcher != current)
+			eventfd_signal(e->eventfd, 1);
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

