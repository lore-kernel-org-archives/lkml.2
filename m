Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0IPWQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:16:54 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:51812 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab0IPWQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:16:50 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexander Shishkin <virtuoso@slind.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/7] notify userspace about time changes
Date: Fri, 17 Sep 2010 01:10:43 +0300
Message-Id: <1284675049-23479-2-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain userspace applications (like "clock" desktop applets or cron) might
want to be notified when some other application changes the system time. It
might also be important for an application to be able to distinguish between
its own and somebody else's time changes.

This patch implements a notification interface via eventfd mechanism. Proccess
wishing to be notified about time changes should create an eventfd and pass it
to time_change_notify() syscall along with notification options.
After that, any calls to settimeofday()/stime()/adjtimex() made by other
processes will be signalled to this eventfd. Credits for suggesting the eventfd
mechanism for this purpose go to Kirill Shutemov.

This patch adds the syscall to asm-generic/unistd.h.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
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
 Documentation/time-change-notify-example.c |   64 ++++++++++
 include/asm-generic/unistd.h               |    4 +-
 include/linux/syscalls.h                   |    1 +
 include/linux/time.h                       |   20 +++
 init/Kconfig                               |    7 +
 kernel/Makefile                            |    1 +
 kernel/sys_ni.c                            |    3 +
 kernel/sysctl.c                            |   11 ++
 kernel/time.c                              |   11 ++-
 kernel/time_notify.c                       |  183 ++++++++++++++++++++++++++++
 10 files changed, 302 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/time-change-notify-example.c
 create mode 100644 kernel/time_notify.c

diff --git a/Documentation/time-change-notify-example.c b/Documentation/time-change-notify-example.c
new file mode 100644
index 0000000..e8e4f4d
--- /dev/null
+++ b/Documentation/time-change-notify-example.c
@@ -0,0 +1,64 @@
+/*
+ * Simple program to catch system time changes
+ *
+ * written by Alexander Shishkin <virtuoso@slind.org>
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <sys/eventfd.h>
+#include <sys/syscall.h>
+#include <errno.h>
+#include <unistd.h>
+#include <poll.h>
+
+#ifndef SYS_time_change_notify
+# include "asm/unistd.h"
+# ifdef __NR_time_change_notify
+#  define SYS_time_change_notify __NR_time_change_notify
+# else
+#  error Cannot figure out time_change_notify syscall number.
+# endif
+#endif
+
+static int time_change_notify(int fd, unsigned int flags)
+{
+	return syscall(SYS_time_change_notify, fd, flags);
+}
+
+int main(int argc, char **argv)
+{
+	struct pollfd fds = { .events = POLLIN };
+
+	fds.fd = eventfd(0, 0);
+	if (fds.fd < 0) {
+		perror("eventfd");
+		return EXIT_FAILURE;
+	}
+
+	/* subscribe to all events from all sources */
+	if (time_change_notify(fds.fd, 0xf)) {
+		perror("time_change_notify");
+		return EXIT_FAILURE;
+	}
+
+	while (poll(&fds, 1, -1) > 0) {
+		eventfd_t data;
+		ssize_t r;
+
+		r = read(fds.fd, &data, sizeof data);
+		if (r == -1) {
+			if (errno == EINTR)
+				continue;
+
+			break;
+		}
+
+		printf("system time has changed %llu times\n", data);
+	}
+
+	puts("Done polling system time changes.\n");
+
+	return EXIT_SUCCESS;
+}
+
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index b969770..c8372db 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -646,9 +646,11 @@ __SYSCALL(__NR_prlimit64, sys_prlimit64)
 __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 #define __NR_fanotify_mark 263
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
+#define __NR_time_change_notify 264
+__SYSCALL(__NR_time_change_notify, sys_time_change_notify)
 
 #undef __NR_syscalls
-#define __NR_syscalls 264
+#define __NR_syscalls 265
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e6319d1..789f92e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -819,6 +819,7 @@ asmlinkage long sys_fanotify_init(unsigned int flags, unsigned int event_f_flags
 asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
 				  u64 mask, int fd,
 				  const char  __user *pathname);
+asmlinkage long sys_time_change_notify(int fd, unsigned int flags);
 
 int kernel_execve(const char *filename, const char *const argv[], const char *const envp[]);
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..d66045e 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -252,6 +252,26 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
+
+/* time change events */
+#define TIME_EVENT_SET 0
+#define TIME_EVENT_ADJ 1
+
+#define TIME_CHANGE_NOTIFY_OTHERS	BIT(0)
+#define TIME_CHANGE_NOTIFY_OWN		BIT(1)
+#define TIME_CHANGE_NOTIFY_SET		BIT(2)
+#define TIME_CHANGE_NOTIFY_ADJUST	BIT(3)
+
+#define TIME_CHANGE_NOTIFY_MAX_USERS	1024
+
+#ifdef CONFIG_TIME_NOTIFY
+extern unsigned int time_change_notify_max_users;
+
+void time_notify_all(int type);
+#else
+static inline void time_notify_all(int type) {}
+#endif
+
 #endif /* __KERNEL__ */
 
 #define NFDBITS			__NFDBITS
diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..504a51a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -980,6 +980,13 @@ config PERF_USE_VMALLOC
 	help
 	  See tools/perf/design.txt for details
 
+config TIME_NOTIFY
+	bool "System time changes notification for userspace"
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
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index bad369e..bb27e93 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -185,3 +185,6 @@ cond_syscall(sys_perf_event_open);
 /* fanotify! */
 cond_syscall(sys_fanotify_init);
 cond_syscall(sys_fanotify_mark);
+
+/* time change notification */
+cond_syscall(sys_time_change_notify);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f88552c..9e7d7a9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1441,6 +1441,17 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= proc_doulongvec_minmax,
 	},
 #endif /* CONFIG_AIO */
+#ifdef CONFIG_TIME_NOTIFY
+	{
+		.procname	= "time-change-notify-max-users",
+		.data		= &time_change_notify_max_users,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &ten_thousand,
+	},
+#endif
 #ifdef CONFIG_INOTIFY_USER
 	{
 		.procname	= "inotify",
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
index 0000000..1e57eb4
--- /dev/null
+++ b/kernel/time_notify.c
@@ -0,0 +1,183 @@
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
+#include <linux/syscalls.h>
+#include <linux/slab.h>
+#include <linux/eventfd.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/poll.h>
+#include <linux/err.h>
+
+/* sysctl tunable to limit the number of users */
+unsigned int time_change_notify_max_users = TIME_CHANGE_NOTIFY_MAX_USERS;
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
+static int nevents;
+static DEFINE_SPINLOCK(event_lock);
+
+/*
+ * Do the necessary cleanup when the eventfd is being closed
+ */
+static void time_event_remove(struct work_struct *work)
+{
+	struct time_event *evt = container_of(work, struct time_event, remove);
+
+	BUG_ON(nevents <= 0);
+
+	kfree(evt);
+	nevents--;
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
+ * time_change_notify() registers a given eventfd to receive time change
+ * notifications
+ */
+SYSCALL_DEFINE2(time_change_notify, int, fd, unsigned int, flags)
+{
+	int ret;
+	struct file *file;
+	struct time_event *evt;
+
+	evt = kmalloc(sizeof(*evt), GFP_KERNEL);
+	if (!evt)
+		return -ENOMEM;
+
+	evt->want_others = !!(flags & TIME_CHANGE_NOTIFY_OTHERS);
+	evt->want_own = !!(flags & TIME_CHANGE_NOTIFY_OWN);
+	evt->want_set = !!(flags & TIME_CHANGE_NOTIFY_SET);
+	evt->want_adj = !!(flags & TIME_CHANGE_NOTIFY_ADJUST);
+
+	file = eventfd_fget(fd);
+	if (IS_ERR(file)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	evt->eventfd = eventfd_ctx_fileget(file);
+	if (IS_ERR(evt->eventfd)) {
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
+	evt->watcher = current;
+
+	spin_lock(&event_lock);
+	if (nevents == time_change_notify_max_users) {
+		spin_unlock(&event_lock);
+		ret = -EBUSY;
+		goto out_fput;
+	}
+
+	nevents++;
+	list_add(&evt->list, &event_list);
+	spin_unlock(&event_lock);
+
+	if (file->f_op->poll(file, &evt->pt) & POLLHUP) {
+		ret = 0;
+		goto out_fput;
+	}
+
+	fput(file);
+
+	return 0;
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
+static int time_notify_init(void)
+{
+	return 0;
+}
+
+core_initcall(time_notify_init);
-- 
1.7.2.1.45.gb66c2

