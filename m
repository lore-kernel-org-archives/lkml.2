Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2A0XZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:25:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56937 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2A0XZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:25:23 -0500
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        wad@chromium.org, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, indan@nul.nu, mcgrathr@chromium.org
Subject: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
Date: Fri, 27 Jan 2012 17:24:40 -0600
Message-Id: <1327706681-11959-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327706681-11959-1-git-send-email-wad@chromium.org>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This patch depends on luto@mit.edu's no_new_privs patch:
 https://lkml.org/lkml/2012/1/12/446
]

This patch adds support for seccomp mode 2.  This mode enables dynamic
enforcement of system call filtering policy in the kernel as specified
by a userland task.  The policy is expressed in terms of a Berkeley
Packet Filter program, as is used for userland-exposed socket filtering.
Instead of network data, the BPF program is evaluated over struct
seccomp_filter_data at the time of the system call.

A filter program may be installed by a userland task by calling
  prctl(PR_ATTACH_SECCOMP_FILTER, &fprog);
where fprog is of type struct sock_fprog.

If the first filter program allows subsequent prctl(2) calls, then
additional filter programs may be attached.  All attached programs
must be evaluated before a system call will be allowed to proceed.

To avoid CONFIG_COMPAT related landmines, once a filter program is
installed using specific is_compat_task() value, it is not allowed to
make system calls using the alternate entry point.

Filter programs will be inherited across fork/clone and execve.
However, if the task attaching the filter is unprivileged
(!CAP_SYS_ADMIN) the no_new_privs bit will be set on the task.  This
ensures that unprivileged tasks cannot attach filters that affect
privileged tasks (e.g., setuid binary).

There are a number of benefits to this approach. A few of which are
as follows:
- BPF has been exposed to userland for a long time.
- Userland already knows its ABI: system call numbers and desired
  arguments
- No time-of-check-time-of-use vulnerable data accesses are possible.
- system call arguments are loaded on demand only to minimize copying
  required for system call number-only policy decisions.

This patch includes its own BPF evaluator, but relies on the
net/core/filter.c BPF checking code.  It is possible to share
evaluators, but the performance sensitive nature of the network
filtering path makes it an iterative optimization which (I think :) can
be tackled separately via separate patchsets. (And at some point sharing
BPF JIT code!)

 v5: - uses syscall_get_arguments
       (indan@nul.nu,oleg@redhat.com, mcgrathr@chromium.org)
     - uses union-based arg storage with hi/lo struct to
       handle endianness.  Compromises between the two alternate
       proposals to minimize extra arg shuffling and account for
       endianness assuming userspace uses offsetof().
       (mcgrathr@chromium.org, indan@nul.nu)
     - update Kconfig description
     - add include/seccomp_filter.h and add its installation
     - (naive) on-demand syscall argument loading
     - drop seccomp_t (eparis@redhat.com)
     - adds proper compat prctl call copying
 v4: - adjusted prctl to make room for PR_[SG]ET_NO_NEW_PRIVS
     - now uses current->no_new_privs
         (luto@mit.edu,torvalds@linux-foundation.com)
     - assign names to seccomp modes (rdunlap@xenotime.net)
     - fix style issues (rdunlap@xenotime.net)
     - reworded Kconfig entry (rdunlap@xenotime.net)
 v3: - macros to inline (oleg@redhat.com)
     - init_task behavior fixed (oleg@redhat.com)
     - drop creator entry and extra NULL check (oleg@redhat.com)
     - alloc returns -EINVAL on bad sizing (serge.hallyn@canonical.com)
     - adds tentative use of "always_unprivileged" as per
       torvalds@linux-foundation.org and luto@mit.edu
 v2: - (patch 2 only)

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/Kbuild           |    1 +
 include/linux/prctl.h          |    3 +
 include/linux/seccomp.h        |   63 ++++
 include/linux/seccomp_filter.h |   79 +++++
 kernel/Makefile                |    1 +
 kernel/fork.c                  |    4 +
 kernel/seccomp.c               |   10 +-
 kernel/seccomp_filter.c        |  620 ++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c                   |    4 +
 security/Kconfig               |   20 ++
 10 files changed, 804 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/seccomp_filter.h
 create mode 100644 kernel/seccomp_filter.c

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index c94e717..5659454 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -330,6 +330,7 @@ header-y += scc.h
 header-y += sched.h
 header-y += screen_info.h
 header-y += sdla.h
+header-y += seccomp_filter.h
 header-y += securebits.h
 header-y += selinux_netlink.h
 header-y += sem.h
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 7ddc7f1..b8c4beb 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -114,4 +114,7 @@
 # define PR_SET_MM_START_BRK		6
 # define PR_SET_MM_BRK			7
 
+/* Set process seccomp filters */
+#define PR_ATTACH_SECCOMP_FILTER	37
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 171ab66..3992bb6 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -5,10 +5,29 @@
 #ifdef CONFIG_SECCOMP
 
 #include <linux/thread_info.h>
+#include <linux/types.h>
 #include <asm/seccomp.h>
 
+/* Valid values of seccomp_struct.mode */
+#define SECCOMP_MODE_DISABLED	0 /* seccomp is not in use. */
+#define SECCOMP_MODE_STRICT	1 /* uses hard-coded seccomp.c rules. */
+#define SECCOMP_MODE_FILTER	2 /* system call access determined by filter. */
+
+struct seccomp_filter;
+/**
+ * struct seccomp_struct - the state of a seccomp'ed process
+ *
+ * @mode:  indicates one of the valid values above for controlled
+ *         system calls available to a process.
+ * @filter: Metadata for filter if using CONFIG_SECCOMP_FILTER.
+ *          @filter must only be accessed from the context of current as there
+ *          is no guard.
+ */
 struct seccomp_struct {
 	int mode;
+#ifdef CONFIG_SECCOMP_FILTER
+	struct seccomp_filter *filter;
+#endif
 };
 
 extern void __secure_computing(int);
@@ -51,4 +70,48 @@ static inline int seccomp_mode(struct seccomp_struct *s)
 
 #endif /* CONFIG_SECCOMP */
 
+#ifdef CONFIG_SECCOMP_FILTER
+
+
+extern long prctl_attach_seccomp_filter(char __user *);
+
+extern struct seccomp_filter *get_seccomp_filter(struct seccomp_filter *);
+extern void put_seccomp_filter(struct seccomp_filter *);
+
+extern int seccomp_test_filters(int);
+extern void seccomp_filter_log_failure(int);
+extern void seccomp_struct_fork(struct seccomp_struct *child,
+				const struct seccomp_struct *parent);
+
+static inline void seccomp_struct_init_task(struct seccomp_struct *seccomp)
+{
+	seccomp->mode = SECCOMP_MODE_DISABLED;
+	seccomp->filter = NULL;
+}
+
+/* No locking is needed here because the task_struct will
+ * have no parallel consumers.
+ */
+static inline void seccomp_struct_free_task(struct seccomp_struct *seccomp)
+{
+	put_seccomp_filter(seccomp->filter);
+	seccomp->filter = NULL;
+}
+
+#else  /* CONFIG_SECCOMP_FILTER */
+
+#include <linux/errno.h>
+
+struct seccomp_filter { };
+/* Macros consume the unused dereference by the caller. */
+#define seccomp_struct_init_task(_seccomp) do { } while (0);
+#define seccomp_struct_fork(_tsk, _orig) do { } while (0);
+#define seccomp_struct_free_task(_seccomp) do { } while (0);
+
+static inline long prctl_attach_seccomp_filter(char __user *a2)
+{
+	return -ENOSYS;
+}
+
+#endif  /* CONFIG_SECCOMP_FILTER */
 #endif /* _LINUX_SECCOMP_H */
diff --git a/include/linux/seccomp_filter.h b/include/linux/seccomp_filter.h
new file mode 100644
index 0000000..3ecd641
--- /dev/null
+++ b/include/linux/seccomp_filter.h
@@ -0,0 +1,79 @@
+/*
+ * Secomp-based system call filtering data structures and definitions.
+ *
+ * Copyright (C) 2012 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ */
+
+#ifndef __LINUX_SECCOMP_FILTER_H__
+#define __LINUX_SECCOMP_FILTER_H__
+
+#include <asm/byteorder.h>
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/*
+ *	Keep the contents of this file similar to linux/filter.h:
+ *	  struct sock_filter and sock_fprog and versions.
+ *	Custom naming exists solely if divergence is ever needed.
+ */
+
+/*
+ * Current version of the filter code architecture.
+ */
+#define SECCOMP_BPF_MAJOR_VERSION 1
+#define SECCOMP_BPF_MINOR_VERSION 1
+
+struct seccomp_filter_block {	/* Filter block */
+	__u16	code;   /* Actual filter code */
+	__u8	jt;	/* Jump true */
+	__u8	jf;	/* Jump false */
+	__u32	k;      /* Generic multiuse field */
+};
+
+struct seccomp_fprog {	/* Required for SO_ATTACH_FILTER. */
+	unsigned short		len;	/* Number of filter blocks */
+	struct seccomp_filter_block __user *filter;
+};
+
+/* Ensure the u32 ordering is consistent with platform byte order. */
+#if defined(__LITTLE_ENDIAN)
+#define SECCOMP_ENDIAN_SWAP(x, y) x, y
+#elif defined(__BIG_ENDIAN)
+#define SECCOMP_ENDIAN_SWAP(x, y) y, x
+#else
+#error edit for your odd arch byteorder.
+#endif
+
+/* System call argument layout for the filter data. */
+union seccomp_filter_arg {
+	struct {
+		__u32 SECCOMP_ENDIAN_SWAP(lo32, hi32);
+	};
+	__u64 u64;
+};
+
+/*
+ *	Expected data the BPF program will execute over.
+ *	Endianness will be arch specific, but the values will be
+ *	swapped, as above, to allow for consistent BPF programs.
+ */
+struct seccomp_filter_data {
+	int syscall_nr;
+	__u32 __reserved;
+	union seccomp_filter_arg args[6];
+};
+
+#undef SECCOMP_ENDIAN_SWAP
+
+/*
+ * Defined valid return values for the BPF program.
+ */
+#define SECCOMP_BPF_ALLOW	0xFFFFFFFF
+#define SECCOMP_BPF_DENY	0
+
+#endif /* __LINUX_SECCOMP_FILTER_H__ */
diff --git a/kernel/Makefile b/kernel/Makefile
index 2d9de86..fd81bac 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
+obj-$(CONFIG_SECCOMP_FILTER) += seccomp_filter.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
diff --git a/kernel/fork.c b/kernel/fork.c
index 051f090..f312edb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -34,6 +34,7 @@
 #include <linux/cgroup.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
+#include <linux/seccomp.h>
 #include <linux/swap.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
@@ -169,6 +170,7 @@ void free_task(struct task_struct *tsk)
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
+	seccomp_struct_free_task(&tsk->seccomp);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -1093,6 +1095,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	ftrace_graph_init_task(p);
+	seccomp_struct_init_task(&p->seccomp);
 
 	rt_mutex_init_task(p);
 
@@ -1376,6 +1379,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	perf_event_fork(p);
+	seccomp_struct_fork(&p->seccomp, &current->seccomp);
 
 	trace_task_newtask(p, clone_flags);
 
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index e8d76c5..a045dd4 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -37,7 +37,7 @@ void __secure_computing(int this_syscall)
 	int * syscall;
 
 	switch (mode) {
-	case 1:
+	case SECCOMP_MODE_STRICT:
 		syscall = mode1_syscalls;
 #ifdef CONFIG_COMPAT
 		if (is_compat_task())
@@ -48,6 +48,14 @@ void __secure_computing(int this_syscall)
 				return;
 		} while (*++syscall);
 		break;
+#ifdef CONFIG_SECCOMP_FILTER
+	case SECCOMP_MODE_FILTER:
+		if (seccomp_test_filters(this_syscall) == 0)
+			return;
+
+		seccomp_filter_log_failure(this_syscall);
+		break;
+#endif
 	default:
 		BUG();
 	}
diff --git a/kernel/seccomp_filter.c b/kernel/seccomp_filter.c
new file mode 100644
index 0000000..e57219e
--- /dev/null
+++ b/kernel/seccomp_filter.c
@@ -0,0 +1,620 @@
+/*
+ * linux/kernel/seccomp_filter.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2012 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *
+ * Extends linux/kernel/seccomp.c to allow tasks to install system call
+ * filters using a Berkeley Packet Filter program which is executed over
+ * struct seccomp_filter_data.
+ */
+
+#include <asm/syscall.h>
+
+#include <linux/capability.h>
+#include <linux/compat.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/rculist.h>
+#include <linux/filter.h>
+#include <linux/kallsyms.h>
+#include <linux/kref.h>
+#include <linux/module.h>
+#include <linux/pid.h>
+#include <linux/prctl.h>
+#include <linux/ptrace.h>
+#include <linux/ratelimit.h>
+#include <linux/reciprocal_div.h>
+#include <linux/regset.h>
+#include <linux/seccomp.h>
+#include <linux/seccomp_filter.h>
+#include <linux/security.h>
+#include <linux/seccomp.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/user.h>
+
+
+/**
+ * struct seccomp_filter - container for seccomp BPF programs
+ *
+ * @usage: reference count to manage the object lifetime.
+ *         get/put helpers should be used when accessing an instance
+ *         outside of a lifetime-guarded section.  In general, this
+ *         is only needed for handling filters shared across tasks.
+ * @parent: pointer to the ancestor which this filter will be composed with.
+ * @insns: the BPF program instructions to evaluate
+ * @count: the number of instructions in the program.
+ *
+ * seccomp_filter objects should never be modified after being attached
+ * to a task_struct (other than @usage).
+ */
+struct seccomp_filter {
+	struct kref usage;
+	struct seccomp_filter *parent;
+	struct {
+		uint32_t compat:1;
+	} flags;
+	unsigned short count;  /* Instruction count */
+	struct sock_filter insns[0];
+};
+
+/*
+ * struct seccomp_filter_metadata - BPF data wrapper
+ * @data: data accessible to the BPF program.
+ * @has_args: indicates that the args have been lazily populated.
+ *
+ * Used by seccomp_load_pointer.
+ */
+struct seccomp_filter_metadata {
+	struct seccomp_filter_data data;
+	bool has_args;
+};
+
+static unsigned int seccomp_run_filter(void *, uint32_t,
+				       const struct sock_filter *);
+
+/**
+ * seccomp_filter_alloc - allocates a new filter object
+ * @padding: size of the insns[0] array in bytes
+ *
+ * The @padding should be a multiple of
+ * sizeof(struct sock_filter).
+ *
+ * Returns ERR_PTR on error or an allocated object.
+ */
+static struct seccomp_filter *seccomp_filter_alloc(unsigned long padding)
+{
+	struct seccomp_filter *f;
+	unsigned long bpf_blocks = padding / sizeof(struct sock_filter);
+
+	/* Drop oversized requests. */
+	if (bpf_blocks == 0 || bpf_blocks > BPF_MAXINSNS)
+		return ERR_PTR(-EINVAL);
+
+	/* Padding should always be in sock_filter increments. */
+	if (padding % sizeof(struct sock_filter))
+		return ERR_PTR(-EINVAL);
+
+	f = kzalloc(sizeof(struct seccomp_filter) + padding, GFP_KERNEL);
+	if (!f)
+		return ERR_PTR(-ENOMEM);
+	kref_init(&f->usage);
+	f->count = bpf_blocks;
+	return f;
+}
+
+/**
+ * seccomp_filter_free - frees the allocated filter.
+ * @filter: NULL or live object to be completely destructed.
+ */
+static void seccomp_filter_free(struct seccomp_filter *filter)
+{
+	if (!filter)
+		return;
+	put_seccomp_filter(filter->parent);
+	kfree(filter);
+}
+
+static void __put_seccomp_filter(struct kref *kref)
+{
+	struct seccomp_filter *orig =
+		container_of(kref, struct seccomp_filter, usage);
+	seccomp_filter_free(orig);
+}
+
+void seccomp_filter_log_failure(int syscall)
+{
+	pr_info("%s[%d]: system call %d blocked at 0x%lx\n",
+		current->comm, task_pid_nr(current), syscall,
+		KSTK_EIP(current));
+}
+
+/* put_seccomp_filter - decrements the ref count of @orig and may free. */
+void put_seccomp_filter(struct seccomp_filter *orig)
+{
+	if (!orig)
+		return;
+	kref_put(&orig->usage, __put_seccomp_filter);
+}
+
+/* get_seccomp_filter - increments the reference count of @orig. */
+struct seccomp_filter *get_seccomp_filter(struct seccomp_filter *orig)
+{
+	if (!orig)
+		return NULL;
+	kref_get(&orig->usage);
+	return orig;
+}
+
+#if BITS_PER_LONG == 32
+static inline unsigned long *seccomp_filter_data_arg(
+				struct seccomp_filter_data *data, int index)
+{
+	/* Avoid inconsistent hi contents. */
+	data->args[index].hi32 = 0;
+	return (unsigned long *) &(data->args[index].lo32);
+}
+#elif BITS_PER_LONG == 64
+static inline unsigned long *seccomp_filter_data_arg(
+				struct seccomp_filter_data *data, int index)
+{
+	return (unsigned long *) &(data->args[index].u64);
+}
+#else
+#error Unknown BITS_PER_LONG.
+#endif
+
+/**
+ * seccomp_load_pointer: checks and returns a pointer to the requested offset
+ * @buf: u8 array to index into
+ * @buflen: length of the @buf array
+ * @offset: offset to return data from
+ * @size: size of the data to retrieve at offset
+ * @unused: placeholder which net/core/filter.c uses for for temporary
+ *          storage.  Ideally, the two code paths can be merged.
+ *
+ * Returns a pointer to the BPF evaluator after checking the offset and size
+ * boundaries.
+ */
+static inline void *seccomp_load_pointer(void *data, int offset, size_t size,
+					 void *buffer)
+{
+	struct seccomp_filter_metadata *metadata = data;
+	int arg;
+	if (offset >= sizeof(metadata->data))
+		goto fail;
+	if (offset < 0)
+		goto fail;
+	if (size > sizeof(metadata->data) - offset)
+		goto fail;
+	if (metadata->has_args)
+		goto pass;
+	/* No argument data touched. */
+	if (offset + size - 1 < offsetof(struct seccomp_filter_data, args))
+		goto pass;
+	for (arg = 0; arg < ARRAY_SIZE(metadata->data.args); ++arg)
+		syscall_get_arguments(current, task_pt_regs(current), arg, 1,
+			seccomp_filter_data_arg(&metadata->data, arg));
+	metadata->has_args = true;
+pass:
+	return ((__u8 *)(&metadata->data)) + offset;
+fail:
+	return NULL;
+}
+
+/**
+ * seccomp_test_filters - tests 'current' against the given syscall
+ * @syscall: number of the system call to test
+ *
+ * Returns 0 on ok and non-zero on error/failure.
+ */
+int seccomp_test_filters(int syscall)
+{
+	int ret = -EACCES;
+	struct seccomp_filter *filter;
+	struct seccomp_filter_metadata metadata;
+
+	filter = current->seccomp.filter; /* uses task ref */
+	if (!filter)
+		goto out;
+
+	metadata.data.syscall_nr = syscall;
+	metadata.has_args = false;
+
+#ifdef CONFIG_COMPAT
+	if (filter->flags.compat != !!(is_compat_task()))
+		goto out;
+#endif
+
+	/* Only allow a system call if it is allowed in all ancestors. */
+	ret = 0;
+	for ( ; filter != NULL; filter = filter->parent) {
+		/* Allowed if return value is SECCOMP_BPF_ALLOW */
+		if (seccomp_run_filter(&metadata, sizeof(metadata.data),
+					filter->insns) != SECCOMP_BPF_ALLOW)
+			ret = -EACCES;
+	}
+out:
+	return ret;
+}
+
+/**
+ * seccomp_attach_filter: Attaches a seccomp filter to current.
+ * @fprog: BPF program to install
+ *
+ * Context: User context only. This function may sleep on allocation and
+ *          operates on current. current must be attempting a system call
+ *          when this is called (usually prctl).
+ *
+ * This function may be called repeatedly to install additional filters.
+ * Every filter successfully installed will be evaluated (in reverse order)
+ * for each system call the thread makes.
+ *
+ * Returns 0 on success or an errno on failure.
+ */
+long seccomp_attach_filter(struct sock_fprog *fprog)
+{
+	struct seccomp_filter *filter = NULL;
+	/* Note, len is a short so overflow should be impossible. */
+	unsigned long fp_size = fprog->len * sizeof(struct sock_filter);
+	long ret = -EPERM;
+
+	/* Allocate a new seccomp_filter */
+	filter = seccomp_filter_alloc(fp_size);
+	if (IS_ERR(filter)) {
+		ret = PTR_ERR(filter);
+		goto out;
+	}
+
+	/* Copy the instructions from fprog. */
+	ret = -EFAULT;
+	if (copy_from_user(filter->insns, fprog->filter, fp_size))
+		goto out;
+
+	/* Check the fprog */
+	ret = sk_chk_filter(filter->insns, filter->count);
+	if (ret)
+		goto out;
+
+	/*
+	 * If a process lacks CAP_SYS_ADMIN in its namespace, force
+	 * this process and all descendents to run with no_new_privs.
+	 * A privileged process will need to set this bit independently,
+	 * if desired.
+	 */
+	if (security_capable_noaudit(current_cred(), current_user_ns(),
+				     CAP_SYS_ADMIN) != 0)
+		current->no_new_privs = 1;
+
+	/*
+	 * If there is an existing filter, make it the parent
+	 * and reuse the existing task-based ref.
+	 */
+	filter->parent = current->seccomp.filter;
+
+#ifdef CONFIG_COMPAT
+	/* Disallow changing system calling conventions after the fact. */
+	filter->flags.compat = !!(is_compat_task());
+
+	if (filter->parent &&
+	    filter->parent->flags.compat != filter->flags.compat)
+		return -EACCES;
+#endif
+
+	/*
+	 * Double claim the new filter so we can release it below simplifying
+	 * the error paths earlier.
+	 */
+	ret = 0;
+	get_seccomp_filter(filter);
+	current->seccomp.filter = filter;
+	/* Engage seccomp if it wasn't. This doesn't use PR_SET_SECCOMP. */
+	if (current->seccomp.mode == SECCOMP_MODE_DISABLED) {
+		current->seccomp.mode = SECCOMP_MODE_FILTER;
+		set_thread_flag(TIF_SECCOMP);
+	}
+
+out:
+	put_seccomp_filter(filter);  /* for get or task, on err */
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+/* This should be kept in sync with net/compat.c which changes infrequently. */
+struct compat_sock_fprog {
+	u16 len;
+	compat_uptr_t filter;	/* struct sock_filter */
+};
+
+static long compat_attach_seccomp_filter(char __user *optval)
+{
+	struct compat_sock_fprog __user *fprog32 =
+		(struct compat_sock_fprog __user *)optval;
+	struct sock_fprog __user *kfprog =
+		compat_alloc_user_space(sizeof(struct sock_fprog));
+	compat_uptr_t ptr;
+	u16 len;
+
+	if (!access_ok(VERIFY_READ, fprog32, sizeof(*fprog32)) ||
+	    !access_ok(VERIFY_WRITE, kfprog, sizeof(struct sock_fprog)) ||
+	    __get_user(len, &fprog32->len) ||
+	    __get_user(ptr, &fprog32->filter) ||
+	    __put_user(len, &kfprog->len) ||
+	    __put_user(compat_ptr(ptr), &kfprog->filter))
+		return -EFAULT;
+
+	return seccomp_attach_filter(kfprog);
+}
+#endif
+
+long prctl_attach_seccomp_filter(char __user *user_filter)
+{
+	struct sock_fprog fprog;
+	long ret = -EINVAL;
+	ret = -EFAULT;
+	if (!user_filter)
+		goto out;
+
+#ifdef CONFIG_COMPAT
+	if (is_compat_task())
+		return compat_attach_seccomp_filter(user_filter);
+#endif
+
+	if (copy_from_user(&fprog, user_filter, sizeof(fprog)))
+		goto out;
+
+	ret = seccomp_attach_filter(&fprog);
+out:
+	return ret;
+}
+
+/**
+ * seccomp_struct_fork: manages inheritance on fork
+ * @child: forkee's seccomp_struct
+ * @parent: forker's seccomp_struct
+ *
+ * Ensures that @child inherits seccomp mode and state iff
+ * seccomp filtering is in use.
+ */
+void seccomp_struct_fork(struct seccomp_struct *child,
+			 const struct seccomp_struct *parent)
+{
+	child->mode = parent->mode;
+	if (parent->mode != SECCOMP_MODE_FILTER)
+		return;
+	child->filter = get_seccomp_filter(parent->filter);
+}
+
+/**
+ * seccomp_run_filter - evaluate BPF
+ *	@buf: opaque buffer to execute the filter over
+ *	@buflen: length of the buffer
+ *	@fentry: filter to apply
+ *
+ * Decode and apply filter instructions to the buffer.  Return length to
+ * keep, 0 for none. @buf is a seccomp_filter_metadata we are filtering,
+ * @filter is the array of filter instructions.  Because all jumps are
+ * guaranteed to be before last instruction, and last instruction
+ * guaranteed to be a RET, we dont need to check flen.
+ *
+ * See core/net/filter.c as this is nearly an exact copy.
+ * At some point, it would be nice to merge them to take advantage of
+ * optimizations (like JIT).
+ */
+static unsigned int seccomp_run_filter(void *data, uint32_t datalen,
+			  const struct sock_filter *fentry)
+{
+	const void *ptr;
+	u32 A = 0;			/* Accumulator */
+	u32 X = 0;			/* Index Register */
+	u32 mem[BPF_MEMWORDS];		/* Scratch Memory Store */
+	u32 tmp;
+	int k;
+
+	/*
+	 * Process array of filter instructions.
+	 */
+	for (;; fentry++) {
+#if defined(CONFIG_X86_32)
+#define	K (fentry->k)
+#else
+		const u32 K = fentry->k;
+#endif
+
+		switch (fentry->code) {
+		case BPF_S_ALU_ADD_X:
+			A += X;
+			continue;
+		case BPF_S_ALU_ADD_K:
+			A += K;
+			continue;
+		case BPF_S_ALU_SUB_X:
+			A -= X;
+			continue;
+		case BPF_S_ALU_SUB_K:
+			A -= K;
+			continue;
+		case BPF_S_ALU_MUL_X:
+			A *= X;
+			continue;
+		case BPF_S_ALU_MUL_K:
+			A *= K;
+			continue;
+		case BPF_S_ALU_DIV_X:
+			if (X == 0)
+				return 0;
+			A /= X;
+			continue;
+		case BPF_S_ALU_DIV_K:
+			A = reciprocal_divide(A, K);
+			continue;
+		case BPF_S_ALU_AND_X:
+			A &= X;
+			continue;
+		case BPF_S_ALU_AND_K:
+			A &= K;
+			continue;
+		case BPF_S_ALU_OR_X:
+			A |= X;
+			continue;
+		case BPF_S_ALU_OR_K:
+			A |= K;
+			continue;
+		case BPF_S_ALU_LSH_X:
+			A <<= X;
+			continue;
+		case BPF_S_ALU_LSH_K:
+			A <<= K;
+			continue;
+		case BPF_S_ALU_RSH_X:
+			A >>= X;
+			continue;
+		case BPF_S_ALU_RSH_K:
+			A >>= K;
+			continue;
+		case BPF_S_ALU_NEG:
+			A = -A;
+			continue;
+		case BPF_S_JMP_JA:
+			fentry += K;
+			continue;
+		case BPF_S_JMP_JGT_K:
+			fentry += (A > K) ? fentry->jt : fentry->jf;
+			continue;
+		case BPF_S_JMP_JGE_K:
+			fentry += (A >= K) ? fentry->jt : fentry->jf;
+			continue;
+		case BPF_S_JMP_JEQ_K:
+			fentry += (A == K) ? fentry->jt : fentry->jf;
+			continue;
+		case BPF_S_JMP_JSET_K:
+			fentry += (A & K) ? fentry->jt : fentry->jf;
+			continue;
+		case BPF_S_JMP_JGT_X:
+			fentry += (A > X) ? fentry->jt : fentry->jf;
+			continue;
+		case BPF_S_JMP_JGE_X:
+			fentry += (A >= X) ? fentry->jt : fentry->jf;
+			continue;
+		case BPF_S_JMP_JEQ_X:
+			fentry += (A == X) ? fentry->jt : fentry->jf;
+			continue;
+		case BPF_S_JMP_JSET_X:
+			fentry += (A & X) ? fentry->jt : fentry->jf;
+			continue;
+		case BPF_S_LD_W_ABS:
+			k = K;
+load_w:
+			ptr = seccomp_load_pointer(data, k, 4, &tmp);
+			if (ptr != NULL) {
+				/*
+				 * Assume load_pointer did any byte swapping.
+				 */
+				A = *(const u32 *)ptr;
+				continue;
+			}
+			return 0;
+		case BPF_S_LD_H_ABS:
+			k = K;
+load_h:
+			ptr = seccomp_load_pointer(data, k, 2, &tmp);
+			if (ptr != NULL) {
+				A = *(const u16 *)ptr;
+				continue;
+			}
+			return 0;
+		case BPF_S_LD_B_ABS:
+			k = K;
+load_b:
+			ptr = seccomp_load_pointer(data, k, 1, &tmp);
+			if (ptr != NULL) {
+				A = *(const u8 *)ptr;
+				continue;
+			}
+			return 0;
+		case BPF_S_LD_W_LEN:
+			A = datalen;
+			continue;
+		case BPF_S_LDX_W_LEN:
+			X = datalen;
+			continue;
+		case BPF_S_LD_W_IND:
+			k = X + K;
+			goto load_w;
+		case BPF_S_LD_H_IND:
+			k = X + K;
+			goto load_h;
+		case BPF_S_LD_B_IND:
+			k = X + K;
+			goto load_b;
+		case BPF_S_LDX_B_MSH:
+			ptr = seccomp_load_pointer(data, K, 1, &tmp);
+			if (ptr != NULL) {
+				X = (*(u8 *)ptr & 0xf) << 2;
+				continue;
+			}
+			return 0;
+		case BPF_S_LD_IMM:
+			A = K;
+			continue;
+		case BPF_S_LDX_IMM:
+			X = K;
+			continue;
+		case BPF_S_LD_MEM:
+			A = mem[K];
+			continue;
+		case BPF_S_LDX_MEM:
+			X = mem[K];
+			continue;
+		case BPF_S_MISC_TAX:
+			X = A;
+			continue;
+		case BPF_S_MISC_TXA:
+			A = X;
+			continue;
+		case BPF_S_RET_K:
+			return K;
+		case BPF_S_RET_A:
+			return A;
+		case BPF_S_ST:
+			mem[K] = A;
+			continue;
+		case BPF_S_STX:
+			mem[K] = X;
+			continue;
+		case BPF_S_ANC_PROTOCOL:
+		case BPF_S_ANC_PKTTYPE:
+		case BPF_S_ANC_IFINDEX:
+		case BPF_S_ANC_MARK:
+		case BPF_S_ANC_QUEUE:
+		case BPF_S_ANC_HATYPE:
+		case BPF_S_ANC_RXHASH:
+		case BPF_S_ANC_CPU:
+		case BPF_S_ANC_NLATTR:
+		case BPF_S_ANC_NLATTR_NEST:
+			continue;
+		default:
+			WARN_RATELIMIT(1, "Unknown code:%u jt:%u tf:%u k:%u\n",
+				       fentry->code, fentry->jt,
+				       fentry->jf, fentry->k);
+			return 0;
+		}
+	}
+
+	return 0;
+}
diff --git a/kernel/sys.c b/kernel/sys.c
index 4070153..8e43f70 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1901,6 +1901,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_SET_SECCOMP:
 			error = prctl_set_seccomp(arg2);
 			break;
+		case PR_ATTACH_SECCOMP_FILTER:
+			error = prctl_attach_seccomp_filter((char __user *)
+								arg2);
+			break;
 		case PR_GET_TSC:
 			error = GET_TSC_CTL(arg2);
 			break;
diff --git a/security/Kconfig b/security/Kconfig
index 51bd5a0..e1ffed8 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -84,6 +84,26 @@ config SECURITY_DMESG_RESTRICT
 
 	  If you are unsure how to answer this question, answer N.
 
+config SECCOMP_FILTER
+	bool "Enable seccomp-based system call filtering"
+	select SECCOMP
+	help
+	  This option provide support for limiting the accessibility of
+	  systems calls at a task-level using a dynamically defined policy.
+
+	  System call filtering policy is expressed by the user using
+	  a Berkeley Packet Filter program.  The program is attached using
+	  prctl(2).  For every system call the task makes, its number,
+	  arguments, and other metadata will be evaluated by the attached
+	  filter program.  The result determines if the system call may
+	  may proceed or if the task should be terminated.
+
+	  This behavior is meant to aid security-conscious software in
+	  its ability to minimize the risk of running potentially
+	  risky code.
+
+	  See Documentation/prctl/seccomp_filter.txt for more detail.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
-- 
1.7.5.4

