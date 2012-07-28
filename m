Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2G1QmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 12:42:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab2G1QmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 12:42:07 -0400
Date: Sat, 28 Jul 2012 12:41:55 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, lwoodman@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>, kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH 2/3] Introduce percpu rw semaphores
In-Reply-To: <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <20120628111541.GB17515@quack.suse.cz> <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
 <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce percpu rw semaphores

When many CPUs are locking a rw semaphore for read concurrently, cache
line bouncing occurs. When a CPU acquires rw semaphore for read, the
CPU writes to the cache line holding the semaphore. Consequently, the
cache line is being moved between CPUs and this slows down semaphore
acquisition.

This patch introduces new percpu rw semaphores. They are functionally
identical to existing rw semaphores, but locking the percpu rw semaphore
for read is faster and locking for write is slower.

The percpu rw semaphore is implemented as a percpu array of rw
semaphores, each semaphore for one CPU. When some thread needs to lock
the semaphore for read, only semaphore on the current CPU is locked for
read. When some thread needs to lock the semaphore for write, semaphores
for all CPUs are locked for write. This avoids cache line bouncing.

Note that the thread that is locking percpu rw semaphore may be
rescheduled, it doesn't cause bug, but cache line bouncing occurs in
this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/percpu-rwsem.h |   77 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

Index: linux-3.5-fast/include/linux/percpu-rwsem.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.5-fast/include/linux/percpu-rwsem.h	2012-07-28 18:41:05.000000000 +0200
@@ -0,0 +1,77 @@
+#ifndef _LINUX_PERCPU_RWSEM_H
+#define _LINUX_PERCPU_RWSEM_H
+
+#include <linux/rwsem.h>
+#include <linux/percpu.h>
+
+#ifndef CONFIG_SMP
+
+#define percpu_rw_semaphore	rw_semaphore
+#define percpu_rwsem_ptr	int
+#define percpu_down_read(x)	(down_read(x), 0)
+#define percpu_up_read(x, y)	up_read(x)
+#define percpu_down_write	down_write
+#define percpu_up_write		up_write
+#define percpu_init_rwsem(x)	(({init_rwsem(x);}), 0)
+#define percpu_free_rwsem(x)	do { } while (0)
+
+#else
+
+struct percpu_rw_semaphore {
+	struct rw_semaphore __percpu *s;
+};
+
+typedef struct rw_semaphore *percpu_rwsem_ptr;
+
+static inline percpu_rwsem_ptr percpu_down_read(struct percpu_rw_semaphore *sem)
+{
+	struct rw_semaphore *s = __this_cpu_ptr(sem->s);
+	down_read(s);
+	return s;
+}
+
+static inline void percpu_up_read(struct percpu_rw_semaphore *sem, percpu_rwsem_ptr s)
+{
+	up_read(s);
+}
+
+static inline void percpu_down_write(struct percpu_rw_semaphore *sem)
+{
+	int cpu;
+	for_each_possible_cpu(cpu) {
+		struct rw_semaphore *s = per_cpu_ptr(sem->s, cpu);
+		down_write(s);
+	}
+}
+
+static inline void percpu_up_write(struct percpu_rw_semaphore *sem)
+{
+	int cpu;
+	for_each_possible_cpu(cpu) {
+		struct rw_semaphore *s = per_cpu_ptr(sem->s, cpu);
+		up_write(s);
+	}
+}
+
+static inline int percpu_init_rwsem(struct percpu_rw_semaphore *sem)
+{
+	int cpu;
+	sem->s = alloc_percpu(struct rw_semaphore);
+	if (unlikely(!sem->s))
+		return -ENOMEM;
+	for_each_possible_cpu(cpu) {
+		struct rw_semaphore *s = per_cpu_ptr(sem->s, cpu);
+		init_rwsem(s);
+	}
+	return 0;
+}
+
+static inline void percpu_free_rwsem(struct percpu_rw_semaphore *sem)
+{
+	free_percpu(sem->s);
+	sem->s = NULL;		/* catch use after free bugs */
+}
+
+#endif
+
+#endif
