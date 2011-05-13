Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab1EMXZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:25:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:51437 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758272Ab1EMXZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:25:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,366,1301900400"; 
   d="scan'208";a="642512843"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: libc-alpha@sourceware.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] Add a sysconf syscall
Date: Fri, 13 May 2011 16:24:18 -0700
Message-Id: <1305329059-2017-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

During testing we found some cases where a library wants to know
the number of CPUs for internal tuning, and calls sysconf for that.
glibc then reads /proc/stat which is very slow and scales poorly,
when the program is executed often.

For example sleepycat DB has this problem.

This patch adds a sysconf system call to avoid this problem.
This adds very little code to the kernel, but gives a large speedup.

It is intended to be called from glibc.

It is not a 100% POSIX sysconf -- some values in there are only
known to the C library, but supplies all values usefully
known to the kernel.

In some cases it is more accurate than glibc can do because it doesn't
have to guess. So when some value changes in the kernel it can
return the current value.
---
 include/linux/sysconf.h |   23 ++++++++++++++
 kernel/Makefile         |    2 +-
 kernel/sysconf.c        |   77 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/sysconf.h
 create mode 100644 kernel/sysconf.c

diff --git a/include/linux/sysconf.h b/include/linux/sysconf.h
new file mode 100644
index 0000000..6d64ef7
--- /dev/null
+++ b/include/linux/sysconf.h
@@ -0,0 +1,23 @@
+#ifndef _LINUX_SYSCONF_H
+#define _LINUX_SYSCONF 1
+
+/* 
+ * Subset of the glibc values for the entries the kernel implements. 
+ */
+
+#define _SC_ARG_MAX		0
+#define _SC_CHILD_MAX		1
+#define _SC_CLK_TCK		2
+#define _SC_NGROUPS_MAX		3
+#define _SC_OPEN_MAX		4
+#define _SC_PAGESIZE		30
+#define _SC_SEM_NSEMS_MAX	32
+#define _SC_SIGQUEUE_MAX	34
+#define _SC_UIO_MAXIOV		60
+#define _SC_NPROCESSORS_CONF	83
+#define _SC_NPROCESSORS_ONLN	84
+#define _SC_PHYS_PAGES		85
+#define _SC_AVPHYS_PAGES	86
+#define _SC_SYMLOOP_MAX		173
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 85cbfb3..6ef66ca 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o jump_label.o
+	    async.o range.o jump_label.o sysconf.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
diff --git a/kernel/sysconf.c b/kernel/sysconf.c
new file mode 100644
index 0000000..f41db10
--- /dev/null
+++ b/kernel/sysconf.c
@@ -0,0 +1,77 @@
+#include <linux/syscalls.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/swap.h>
+#include <linux/sched.h>
+#include <linux/limits.h>
+#include <linux/sysconf.h>
+#include <linux/ipc_namespace.h>
+
+/* Do lockless because we only read a single number */
+static long rlimit_or(int rlim, long max)
+{
+	unsigned long cur = ACCESS_ONCE(current->signal->rlim[rlim].rlim_cur);
+
+	return cur == RLIM_INFINITY ? max : cur;
+}
+
+/* 
+ * POSIX sysconf subset. Some programs need this in relatively fast paths
+ * and /proc is too slow for them.
+ *
+ * Note this is only a subset of the values supported by POSIX.
+ * We assume the C library handles the others.
+ */
+SYSCALL_DEFINE1(sysconf, int, name)
+{
+	switch (name) {
+	case _SC_ARG_MAX:
+		return rlimit_or(RLIMIT_STACK, ARG_MAX*ARG_MAX_FACTOR) / 
+				ARG_MAX_FACTOR;
+
+	case _SC_CHILD_MAX:
+		return rlimit_or(RLIMIT_NPROC, max_threads);
+
+	case _SC_CLK_TCK:
+		return HZ;
+
+	case _SC_SEM_NSEMS_MAX:
+		return current->nsproxy->ipc_ns->sem_ctls[1];
+
+	case _SC_OPEN_MAX:
+		return rlimit_or(RLIMIT_NOFILE, sysctl_nr_open);
+
+	case _SC_SIGQUEUE_MAX:
+		/* or fallback based on memory? */
+		return rlimit_or(RLIMIT_SIGPENDING, INT_MAX);
+
+	case _SC_UIO_MAXIOV:
+		return UIO_MAXIOV;
+		
+	case _SC_PAGESIZE:
+		return PAGE_SIZE;
+
+	case _SC_SYMLOOP_MAX:
+		return SYMLOOP_MAX;
+		
+	case _SC_PHYS_PAGES:
+		return totalram_pages;
+
+	case _SC_AVPHYS_PAGES:
+		return nr_free_pages();
+
+	case _SC_NPROCESSORS_CONF:
+		return num_possible_cpus();
+
+	case _SC_NPROCESSORS_ONLN:
+		return num_online_cpus();
+
+	case _SC_NGROUPS_MAX:
+		return NGROUPS_MAX;
+       
+	default:
+		return -EINVAL;
+	}
+}
+
-- 
1.7.4.4

