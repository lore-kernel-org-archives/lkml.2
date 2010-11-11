Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0KKTag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:30:36 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:38915 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab0KKTab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:30:31 -0500
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCHv6 1/7] notify userspace about time changes
Date: Thu, 11 Nov 2010 21:29:56 +0200
Message-Id: <1289503802-22444-2-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain userspace applications (like "clock" desktop applets or cron) might
want to be notified when some other application changes the system time.
There are several known to me reasons for this:
 - avoiding periodic wakeups to poll time changes;
 - changing system timekeeping policy for system-wide time management
   programs;
 - keeping guest applications/operating systems running in emulators
   up to date.

This patch implements a notification interface via eventfd mechanism. Proccess
wishing to be notified about time changes should create an eventfd and pass it
to time_change_notify() syscall. After that, any calls to settimeofday()/
stime()/adjtimex() made by other processes will be signalled to this eventfd.
Credits for suggesting the eventfd mechanism for this purpose go to Kirill
Shutemov.

This patch adds the syscall to asm-generic/unistd.h and a simple usage
example.

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
 Documentation/time-change-notify-example.c |   65 +++++++++++
 include/asm-generic/unistd.h               |    4 +-
 include/linux/syscalls.h                   |    2 +
 include/linux/time.h                       |   13 +++
 kernel/sys_ni.c                            |    3 +
 kernel/time/Kconfig                        |    7 ++
 kernel/time/Makefile                       |    1 +
 kernel/time/notify.c                       |  163 ++++++++++++++++++++++++++++
 kernel/time/ntp.c                          |    3 +
 kernel/time/timekeeping.c                  |    3 +
 10 files changed, 263 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/time-change-notify-example.c
 create mode 100644 kernel/time/notify.c

diff --git a/Documentation/time-change-notify-example.c b/Documentation/time-change-notify-example.c
new file mode 100644
index 0000000..b90c605
--- /dev/null
+++ b/Documentation/time-change-notify-example.c
@@ -0,0 +1,65 @@
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
+#include <time.h>
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
+static int time_change_notify(clockid_t clockid, int fd, unsigned int flags)
+{
+	return syscall(SYS_time_change_notify, clockid, fd, flags);
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
+	if (time_change_notify(CLOCK_REALTIME, fds.fd, 0)) {
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
index cacc27a..6b77576 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -820,6 +820,8 @@ asmlinkage long sys_fanotify_init(unsigned int flags, unsigned int event_f_flags
 asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
 				  u64 mask, int fd,
 				  const char  __user *pathname);
+asmlinkage long sys_time_change_notify(clockid_t clockid, int fd,
+				       unsigned int flags);
 
 int kernel_execve(const char *filename, const char *const argv[], const char *const envp[]);
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..76b9710 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -252,6 +252,19 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
+
+/* time change events types */
+enum {
+	TIME_EVENT_SET = 0,
+	TIME_EVENT_ADJ,
+};
+
+#ifdef CONFIG_TIME_NOTIFY
+void time_notify_all(clockid_t clockid, int type);
+#else
+static inline void time_notify_all(clockid_t clockid, int type) {}
+#endif
+
 #endif /* __KERNEL__ */
 
 #define NFDBITS			__NFDBITS
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index c782fe9..48533f6 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -186,3 +186,6 @@ cond_syscall(sys_perf_event_open);
 /* fanotify! */
 cond_syscall(sys_fanotify_init);
 cond_syscall(sys_fanotify_mark);
+
+/* time change notification */
+cond_syscall(sys_time_change_notify);
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index f06a8a3..71de686 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -27,3 +27,10 @@ config GENERIC_CLOCKEVENTS_BUILD
 	default y
 	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
 
+config TIME_NOTIFY
+	bool "System time changes notification for userspace"
+	depends on EVENTFD
+	help
+	  Enable time change notification events to userspace via
+	  eventfd.
+
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index ee26662..2db9d25 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
+obj-$(CONFIG_TIME_NOTIFY)			+= notify.o
diff --git a/kernel/time/notify.c b/kernel/time/notify.c
new file mode 100644
index 0000000..f6e9bd8
--- /dev/null
+++ b/kernel/time/notify.c
@@ -0,0 +1,163 @@
+/*
+ * linux/kernel/time/notify.c
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
+/*
+ * A process can "subscribe" to receive a notification via eventfd that
+ * some other process has called stime/settimeofday/adjtimex.
+ */
+struct time_event {
+	struct eventfd_ctx	*eventfd;
+	clockid_t		clockid;
+	unsigned int		type;
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
+	__u64 cnt;
+
+	eventfd_ctx_remove_wait_queue(evt->eventfd, &evt->wq, &cnt);
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
+SYSCALL_DEFINE3(time_change_notify, clockid_t, clockid, int, fd, unsigned int,
+		type)
+{
+	struct time_event *evt;
+	struct file *file;
+	int ret;
+
+	/*
+	 * for now only accept CLOCK_REALTIME clockid; in future CLOCK_RTC
+	 * will make use of this interface as well; with dynamic clockids
+	 * it may find even more users
+	 */
+	if ((type != TIME_EVENT_SET && type != TIME_EVENT_ADJ) ||
+	    clockid != CLOCK_REALTIME)
+		return -EINVAL;
+
+	evt = kmalloc(sizeof(*evt), GFP_KERNEL);
+	if (!evt)
+		return -ENOMEM;
+
+	evt->type = type;
+	evt->clockid = clockid;
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
+	if (file->f_op->poll(file, &evt->pt) & POLLHUP) {
+		ret = 0;
+		goto out_ctxput;
+	}
+
+	spin_lock(&event_lock);
+	list_add(&evt->list, &event_list);
+	spin_unlock(&event_lock);
+
+	fput(file);
+
+	return 0;
+
+out_ctxput:
+	eventfd_ctx_put(evt->eventfd);
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
+void time_notify_all(clockid_t clockid, int type)
+{
+	struct list_head *tmp;
+
+	spin_lock(&event_lock);
+	list_for_each(tmp, &event_list) {
+		struct time_event *e = container_of(tmp, struct time_event,
+						    list);
+
+		if (e->type != type || e->clockid != clockid)
+			continue;
+
+		eventfd_signal(e->eventfd, 1);
+	}
+	spin_unlock(&event_lock);
+}
+
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index d232189..9022068 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -541,6 +541,9 @@ int do_adjtimex(struct timex *txc)
 
 	notify_cmos_timer();
 
+	if (txc->modes)
+		time_notify_all(CLOCK_REALTIME, TIME_EVENT_ADJ);
+
 	return result;
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 49010d8..f9517e2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -335,6 +335,9 @@ int do_settimeofday(struct timespec *tv)
 	/* signal hrtimers about time change */
 	clock_was_set();
 
+	/* signal time_change_notify() listeners */
+	time_notify_all(CLOCK_REALTIME, TIME_EVENT_SET);
+
 	return 0;
 }
 
-- 
1.7.2.1.45.gb66c2

