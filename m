Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3ABWjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:39:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3ABWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:39:52 -0500
Date: Wed, 2 Jan 2013 14:39:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/2] extend synchro-test module to test spinlocks too
Message-Id: <20130102143950.26df393d.akpm@linux-foundation.org>
In-Reply-To: <1356922034-25165-1-git-send-email-walken@google.com>
References: <1356922034-25165-1-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2012 18:47:12 -0800
Michel Lespinasse <walken@google.com> wrote:

> I'm not sure whats' the back story with synchro-test though - they seem
> to have been stuck in andrew's tree for a very long time now. Is there
> any reason delaying their inclusion or is it just that nobody's been
> pushing for them ?

iirc, we decided that synchro-test wasn't valuable/important enough to
put into mainline.  So it has been living in -mm for, umm, seven years.

Let's revisit that decision.  What do you think is the case for inclusion?

Here it is.  It will need a full re-review.



From: David Howells <dhowells@redhat.com>
Subject: mutex subsystem, synchro-test module

The attached patch adds a module for testing and benchmarking mutexes,
semaphores and R/W semaphores.

Using it is simple:

	insmod synchro-test.ko <args>

It will exit with error ENOANO after running the tests and printing the
results to the kernel console log.

The available arguments are:

 (*) mx=N

	Start up to N mutex thrashing threads, where N is at most 20. All will
	try and thrash the same mutex.

 (*) sm=N

	Start up to N counting semaphore thrashing threads, where N is at most
	20. All will try and thrash the same semaphore.

 (*) ism=M

	Initialise the counting semaphore with M, where M is any positive
	integer greater than zero. The default is 4.

 (*) rd=N
 (*) wr=O
 (*) dg=P

	Start up to N reader thrashing threads, O writer thrashing threads and
	P downgrader thrashing threads, where N, O and P are at most 20
	apiece. All will try and thrash the same read/write semaphore.

 (*) elapse=N

	Run the tests for N seconds. The default is 5.

 (*) load=N

	Each thread delays for N uS whilst holding the lock. The dfault is 0.

 (*) interval=N

	Each thread delays for N uS whilst not holding the lock. The default
	is 0.

 (*) do_sched=1

	Each thread will call schedule if required after each iteration.

 (*) v=1

	Print more verbose information, including a thread iteration
	distribution list.

The module should be enabled by turning on CONFIG_DEBUG_SYNCHRO_TEST to "m".

[randy.dunlap@oracle.com: fix build errors, add <sched.h> header file]
[akpm@linux-foundation.org: remove smp_lock.h inclusion]
[viro@ZenIV.linux.org.uk: kill daemonize() calls]
[rdunlap@xenotime.net: fix printk format warrnings]
[walken@google.com: add spinlock test]
[walken@google.com: document default load and interval values]
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/synchro-test.txt |   59 +++
 kernel/Makefile                |    1 
 kernel/synchro-test.c          |  586 +++++++++++++++++++++++++++++++
 lib/Kconfig.debug              |   14 
 4 files changed, 660 insertions(+)

diff -puN /dev/null Documentation/synchro-test.txt
--- /dev/null
+++ a/Documentation/synchro-test.txt
@@ -0,0 +1,59 @@
+The synchro-test.ko module can be used for testing and benchmarking mutexes,
+semaphores and R/W semaphores.
+
+The module is compiled by setting CONFIG_DEBUG_SYNCHRO_TEST to "m" when
+configuring the kernel.
+
+Using it is simple:
+
+	insmod synchro-test.ko <args>
+
+It will exit with error ENOANO after running the tests and printing the
+results to the kernel console log.
+
+The available arguments are:
+
+ (*) mx=N
+
+	Start up to N mutex thrashing threads, where N is at most 20. All will
+	try and thrash the same mutex.
+
+ (*) sm=N
+
+	Start up to N counting semaphore thrashing threads, where N is at most
+	20. All will try and thrash the same semaphore.
+
+ (*) ism=M
+
+	Initialise the counting semaphore with M, where M is any positive
+	integer greater than zero. The default is 4.
+
+ (*) rd=N
+ (*) wr=O
+ (*) dg=P
+
+	Start up to N reader thrashing threads, O writer thrashing threads and
+	P downgrader thrashing threads, where N, O and P are at most 20
+	apiece. All will try and thrash the same read/write semaphore.
+
+ (*) elapse=N
+
+	Run the tests for N seconds. The default is 5.
+
+ (*) load=N
+
+	Each thread delays for N uS whilst holding the lock. The default is 2.
+
+ (*) interval=N
+
+	Each thread delays for N uS whilst not holding the lock. The default
+	is 2.
+
+ (*) do_sched=1
+
+	Each thread will call schedule if required after each iteration.
+
+ (*) v=1
+
+	Print more verbose information, including a thread iteration
+	distribution list.
diff -puN kernel/Makefile~mutex-subsystem-synchro-test-module kernel/Makefile
--- a/kernel/Makefile~mutex-subsystem-synchro-test-module
+++ a/kernel/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
+obj-$(CONFIG_DEBUG_SYNCHRO_TEST) += synchro-test.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 obj-$(CONFIG_SMP) += stop_machine.o
diff -puN /dev/null kernel/synchro-test.c
--- /dev/null
+++ a/kernel/synchro-test.c
@@ -0,0 +1,586 @@
+/* synchro-test.c: run some threads to test the synchronisation primitives
+ *
+ * Copyright (C) 2005, 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * The module should be run as something like:
+ *
+ *	insmod synchro-test.ko rd=2 wr=2
+ *	insmod synchro-test.ko mx=1
+ *	insmod synchro-test.ko sm=2 ism=1
+ *	insmod synchro-test.ko sm=2 ism=2
+ *
+ * See Documentation/synchro-test.txt for more information.
+ */
+
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/moduleparam.h>
+#include <linux/sched.h>
+#include <linux/stat.h>
+#include <linux/init.h>
+#include <asm/atomic.h>
+#include <linux/personality.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/completion.h>
+#include <linux/mutex.h>
+#include <linux/kthread.h>
+
+#define MAX_THREADS 64
+
+/*
+ * Turn on self-validation if we do a one-shot boot-time test:
+ */
+#ifndef MODULE
+# define VALIDATE_OPERATORS
+#endif
+
+static int numsp;
+static int nummx;
+static int numsm, seminit = 4;
+static int numrd, numwr, numdg;
+static int elapse = 5, load = 2, do_sched, interval = 2;
+static int verbose = 0;
+
+MODULE_AUTHOR("David Howells");
+MODULE_DESCRIPTION("Synchronisation primitive test demo");
+MODULE_LICENSE("GPL");
+
+module_param_named(v, verbose, int, 0);
+MODULE_PARM_DESC(verbose, "Verbosity");
+
+module_param_named(sp, numsp, int, 0);
+MODULE_PARM_DESC(numsp, "Number of spinlock threads");
+
+module_param_named(mx, nummx, int, 0);
+MODULE_PARM_DESC(nummx, "Number of mutex threads");
+
+module_param_named(sm, numsm, int, 0);
+MODULE_PARM_DESC(numsm, "Number of semaphore threads");
+
+module_param_named(ism, seminit, int, 0);
+MODULE_PARM_DESC(seminit, "Initial semaphore value");
+
+module_param_named(rd, numrd, int, 0);
+MODULE_PARM_DESC(numrd, "Number of reader threads");
+
+module_param_named(wr, numwr, int, 0);
+MODULE_PARM_DESC(numwr, "Number of writer threads");
+
+module_param_named(dg, numdg, int, 0);
+MODULE_PARM_DESC(numdg, "Number of downgrader threads");
+
+module_param(elapse, int, 0);
+MODULE_PARM_DESC(elapse, "Number of seconds to run for");
+
+module_param(load, int, 0);
+MODULE_PARM_DESC(load, "Length of load in uS");
+
+module_param(interval, int, 0);
+MODULE_PARM_DESC(interval, "Length of interval in uS before re-getting lock");
+
+module_param(do_sched, int, 0);
+MODULE_PARM_DESC(do_sched, "True if each thread should schedule regularly");
+
+/* the semaphores under test */
+static spinlock_t ____cacheline_aligned spinlock;
+static struct mutex ____cacheline_aligned mutex;
+static struct semaphore ____cacheline_aligned sem;
+static struct rw_semaphore ____cacheline_aligned rwsem;
+
+static atomic_t ____cacheline_aligned do_stuff		= ATOMIC_INIT(0);
+
+#ifdef VALIDATE_OPERATORS
+static atomic_t ____cacheline_aligned spinlocks		= ATOMIC_INIT(0);
+static atomic_t ____cacheline_aligned mutexes		= ATOMIC_INIT(0);
+static atomic_t ____cacheline_aligned semaphores	= ATOMIC_INIT(0);
+static atomic_t ____cacheline_aligned readers		= ATOMIC_INIT(0);
+static atomic_t ____cacheline_aligned writers		= ATOMIC_INIT(0);
+#endif
+
+static unsigned int ____cacheline_aligned spinlocks_taken	[MAX_THREADS];
+static unsigned int ____cacheline_aligned mutexes_taken		[MAX_THREADS];
+static unsigned int ____cacheline_aligned semaphores_taken	[MAX_THREADS];
+static unsigned int ____cacheline_aligned reads_taken		[MAX_THREADS];
+static unsigned int ____cacheline_aligned writes_taken		[MAX_THREADS];
+static unsigned int ____cacheline_aligned downgrades_taken	[MAX_THREADS];
+
+static struct completion ____cacheline_aligned sp_comp[MAX_THREADS];
+static struct completion ____cacheline_aligned mx_comp[MAX_THREADS];
+static struct completion ____cacheline_aligned sm_comp[MAX_THREADS];
+static struct completion ____cacheline_aligned rd_comp[MAX_THREADS];
+static struct completion ____cacheline_aligned wr_comp[MAX_THREADS];
+static struct completion ____cacheline_aligned dg_comp[MAX_THREADS];
+
+static struct timer_list ____cacheline_aligned timer;
+
+#define ACCOUNT(var, N) var##_taken[N]++;
+
+#ifdef VALIDATE_OPERATORS
+#define TRACK(var, dir) atomic_##dir(&(var))
+
+#define CHECK(var, cond, val)						\
+do {									\
+	int x = atomic_read(&(var));					\
+	if (unlikely(!(x cond (val))))					\
+		printk("check [%s %s %d, == %d] failed in %s\n",	\
+		       #var, #cond, (val), x, __func__);		\
+} while (0)
+
+#else
+#define TRACK(var, dir)		do {} while(0)
+#define CHECK(var, cond, val)	do {} while(0)
+#endif
+
+static inline void do_spin_lock(unsigned int N)
+{
+	spin_lock(&spinlock);
+
+	ACCOUNT(spinlocks, N);
+	TRACK(spinlocks, inc);
+	CHECK(spinlocks, ==, 1);
+}
+
+static inline void do_spin_unlock(unsigned int N)
+{
+	CHECK(spinlocks, ==, 1);
+	TRACK(spinlocks, dec);
+
+	spin_unlock(&spinlock);
+}
+
+static inline void do_mutex_lock(unsigned int N)
+{
+	mutex_lock(&mutex);
+
+	ACCOUNT(mutexes, N);
+	TRACK(mutexes, inc);
+	CHECK(mutexes, ==, 1);
+}
+
+static inline void do_mutex_unlock(unsigned int N)
+{
+	CHECK(mutexes, ==, 1);
+	TRACK(mutexes, dec);
+
+	mutex_unlock(&mutex);
+}
+
+static inline void do_down(unsigned int N)
+{
+	CHECK(mutexes, <, seminit);
+
+	down(&sem);
+
+	ACCOUNT(semaphores, N);
+	TRACK(semaphores, inc);
+}
+
+static inline void do_up(unsigned int N)
+{
+	CHECK(semaphores, >, 0);
+	TRACK(semaphores, dec);
+
+	up(&sem);
+}
+
+static inline void do_down_read(unsigned int N)
+{
+	down_read(&rwsem);
+
+	ACCOUNT(reads, N);
+	TRACK(readers, inc);
+	CHECK(readers, >, 0);
+	CHECK(writers, ==, 0);
+}
+
+static inline void do_up_read(unsigned int N)
+{
+	CHECK(readers, >, 0);
+	CHECK(writers, ==, 0);
+	TRACK(readers, dec);
+
+	up_read(&rwsem);
+}
+
+static inline void do_down_write(unsigned int N)
+{
+	down_write(&rwsem);
+
+	ACCOUNT(writes, N);
+	TRACK(writers, inc);
+	CHECK(writers, ==, 1);
+	CHECK(readers, ==, 0);
+}
+
+static inline void do_up_write(unsigned int N)
+{
+	CHECK(writers, ==, 1);
+	CHECK(readers, ==, 0);
+	TRACK(writers, dec);
+
+	up_write(&rwsem);
+}
+
+static inline void do_downgrade_write(unsigned int N)
+{
+	CHECK(writers, ==, 1);
+	CHECK(readers, ==, 0);
+	TRACK(writers, dec);
+	TRACK(readers, inc);
+
+	downgrade_write(&rwsem);
+
+	ACCOUNT(downgrades, N);
+}
+
+static inline void sched(void)
+{
+	if (do_sched)
+		schedule();
+}
+
+static int spinlocker(void *arg)
+{
+	unsigned int N = (unsigned long) arg;
+
+	set_user_nice(current, 19);
+
+	while (atomic_read(&do_stuff)) {
+		do_spin_lock(N);
+		if (load)
+			udelay(load);
+		do_spin_unlock(N);
+		sched();
+		if (interval)
+			udelay(interval);
+	}
+
+	if (verbose >= 2)
+		printk("%s: done\n", current->comm);
+	complete_and_exit(&sp_comp[N], 0);
+}
+
+static int mutexer(void *arg)
+{
+	unsigned int N = (unsigned long) arg;
+
+	set_user_nice(current, 19);
+
+	while (atomic_read(&do_stuff)) {
+		do_mutex_lock(N);
+		if (load)
+			udelay(load);
+		do_mutex_unlock(N);
+		sched();
+		if (interval)
+			udelay(interval);
+	}
+
+	if (verbose >= 2)
+		printk("%s: done\n", current->comm);
+	complete_and_exit(&mx_comp[N], 0);
+}
+
+static int semaphorer(void *arg)
+{
+	unsigned int N = (unsigned long) arg;
+
+	set_user_nice(current, 19);
+
+	while (atomic_read(&do_stuff)) {
+		do_down(N);
+		if (load)
+			udelay(load);
+		do_up(N);
+		sched();
+		if (interval)
+			udelay(interval);
+	}
+
+	if (verbose >= 2)
+		printk("%s: done\n", current->comm);
+	complete_and_exit(&sm_comp[N], 0);
+}
+
+static int reader(void *arg)
+{
+	unsigned int N = (unsigned long) arg;
+
+	set_user_nice(current, 19);
+
+	while (atomic_read(&do_stuff)) {
+		do_down_read(N);
+#ifdef LOAD_TEST
+		if (load)
+			udelay(load);
+#endif
+		do_up_read(N);
+		sched();
+		if (interval)
+			udelay(interval);
+	}
+
+	if (verbose >= 2)
+		printk("%s: done\n", current->comm);
+	complete_and_exit(&rd_comp[N], 0);
+}
+
+static int writer(void *arg)
+{
+	unsigned int N = (unsigned long) arg;
+
+	set_user_nice(current, 19);
+
+	while (atomic_read(&do_stuff)) {
+		do_down_write(N);
+#ifdef LOAD_TEST
+		if (load)
+			udelay(load);
+#endif
+		do_up_write(N);
+		sched();
+		if (interval)
+			udelay(interval);
+	}
+
+	if (verbose >= 2)
+		printk("%s: done\n", current->comm);
+	complete_and_exit(&wr_comp[N], 0);
+}
+
+static int downgrader(void *arg)
+{
+	unsigned int N = (unsigned long) arg;
+
+	set_user_nice(current, 19);
+
+	while (atomic_read(&do_stuff)) {
+		do_down_write(N);
+#ifdef LOAD_TEST
+		if (load)
+			udelay(load);
+#endif
+		do_downgrade_write(N);
+#ifdef LOAD_TEST
+		if (load)
+			udelay(load);
+#endif
+		do_up_read(N);
+		sched();
+		if (interval)
+			udelay(interval);
+	}
+
+	if (verbose >= 2)
+		printk("%s: done\n", current->comm);
+	complete_and_exit(&dg_comp[N], 0);
+}
+
+static void stop_test(unsigned long dummy)
+{
+	atomic_set(&do_stuff, 0);
+}
+
+static unsigned int total(const char *what, unsigned int counts[], int num)
+{
+	unsigned int tot = 0, max = 0, min = UINT_MAX, zeros = 0, cnt;
+	int loop;
+
+	for (loop = 0; loop < num; loop++) {
+		cnt = counts[loop];
+
+		if (cnt == 0) {
+			zeros++;
+			min = 0;
+			continue;
+		}
+
+		tot += cnt;
+		if (tot > max)
+			max = tot;
+		if (tot < min)
+			min = tot;
+	}
+
+	if (verbose && tot > 0) {
+		printk("%s:", what);
+
+		for (loop = 0; loop < num; loop++) {
+			cnt = counts[loop];
+
+			if (cnt == 0)
+				printk(" zzz");
+			else
+				printk(" %d%%", cnt * 100 / tot);
+		}
+
+		printk("\n");
+	}
+
+	return tot;
+}
+
+/*****************************************************************************/
+/*
+ *
+ */
+static int __init do_tests(void)
+{
+	unsigned long loop;
+	unsigned int spinlock_total, mutex_total, sem_total;
+	unsigned int rd_total, wr_total, dg_total;
+
+	if (numsp < 0 || numsp > MAX_THREADS ||
+	    nummx < 0 || nummx > MAX_THREADS ||
+	    numsm < 0 || numsm > MAX_THREADS ||
+	    numrd < 0 || numrd > MAX_THREADS ||
+	    numwr < 0 || numwr > MAX_THREADS ||
+	    numdg < 0 || numdg > MAX_THREADS ||
+	    seminit < 1 ||
+	    elapse < 1 ||
+	    load < 0 || load > 999 ||
+	    interval < 0 || interval > 999
+	    ) {
+		printk("Parameter out of range\n");
+		return -ERANGE;
+	}
+
+	if ((numsp | nummx | numsm | numrd | numwr | numdg) == 0) {
+		int num = num_online_cpus();
+
+		if (num > MAX_THREADS)
+			num = MAX_THREADS;
+		numsp = nummx = numsm = numrd = numwr = numdg = num;
+
+		load = 1;
+		interval = 1;
+		do_sched = 1;
+		printk("No parameters - using defaults.\n");
+	}
+
+	if (verbose)
+		printk("\nStarting synchronisation primitive tests...\n");
+
+	spin_lock_init(&spinlock);
+	mutex_init(&mutex);
+	sema_init(&sem, seminit);
+	init_rwsem(&rwsem);
+	atomic_set(&do_stuff, 1);
+
+	/* kick off all the children */
+	for (loop = 0; loop < MAX_THREADS; loop++) {
+		if (loop < numsp) {
+			init_completion(&sp_comp[loop]);
+			kthread_run(spinlocker, (void *) loop,
+				    "Spinlock%lu", loop);
+		}
+
+		if (loop < nummx) {
+			init_completion(&mx_comp[loop]);
+			kthread_run(mutexer, (void *) loop, "Mutex%lu", loop);
+		}
+
+		if (loop < numsm) {
+			init_completion(&sm_comp[loop]);
+			kthread_run(semaphorer, (void *) loop, "Sem%lu", loop);
+		}
+
+		if (loop < numrd) {
+			init_completion(&rd_comp[loop]);
+			kthread_run(reader, (void *) loop, "Read%lu", loop);
+		}
+
+		if (loop < numwr) {
+			init_completion(&wr_comp[loop]);
+			kthread_run(writer, (void *) loop, "Write%lu", loop);
+		}
+
+		if (loop < numdg) {
+			init_completion(&dg_comp[loop]);
+			kthread_run(downgrader, (void *) loop, "Down%lu", loop);
+		}
+	}
+
+	/* set a stop timer */
+	init_timer(&timer);
+	timer.function = stop_test;
+	timer.expires = jiffies + elapse * HZ;
+	add_timer(&timer);
+
+	/* now wait until it's all done */
+	for (loop = 0; loop < numsp; loop++)
+		wait_for_completion(&sp_comp[loop]);
+
+	for (loop = 0; loop < nummx; loop++)
+		wait_for_completion(&mx_comp[loop]);
+
+	for (loop = 0; loop < numsm; loop++)
+		wait_for_completion(&sm_comp[loop]);
+
+	for (loop = 0; loop < numrd; loop++)
+		wait_for_completion(&rd_comp[loop]);
+
+	for (loop = 0; loop < numwr; loop++)
+		wait_for_completion(&wr_comp[loop]);
+
+	for (loop = 0; loop < numdg; loop++)
+		wait_for_completion(&dg_comp[loop]);
+
+	atomic_set(&do_stuff, 0);
+	del_timer(&timer);
+
+	if (spin_is_locked(&spinlock))
+		printk(KERN_ERR "Spinlock is still locked!\n");
+
+	if (mutex_is_locked(&mutex))
+		printk(KERN_ERR "Mutex is still locked!\n");
+
+	/* count up */
+	spinlock_total	= total("SP ", spinlocks_taken, numsp);
+	mutex_total	= total("MTX", mutexes_taken, nummx);
+	sem_total	= total("SEM", semaphores_taken, numsm);
+	rd_total	= total("RD ", reads_taken, numrd);
+	wr_total	= total("WR ", writes_taken, numwr);
+	dg_total	= total("DG ", downgrades_taken, numdg);
+
+	/* print the results */
+	if (verbose) {
+		printk("spinlocks taken: %u\n", spinlock_total);
+		printk("mutexes taken: %u\n", mutex_total);
+		printk("semaphores taken: %u\n", sem_total);
+		printk("reads taken: %u\n", rd_total);
+		printk("writes taken: %u\n", wr_total);
+		printk("downgrades taken: %u\n", dg_total);
+	}
+	else {
+		char buf[30];
+
+		sprintf(buf, "%d/%d", interval, load);
+
+		printk("%3d %3d %3d %3d %3d %3d %c %5s %9u %9u %9u %9u %9u %9u\n",
+		       numsp, nummx, numsm, numrd, numwr, numdg,
+		       do_sched ? 's' : '-',
+		       buf,
+		       spinlock_total,
+		       mutex_total,
+		       sem_total,
+		       rd_total,
+		       wr_total,
+		       dg_total);
+	}
+
+	/* tell insmod to discard the module */
+	if (verbose)
+		printk("Tests complete\n");
+	return -ENOANO;
+
+} /* end do_tests() */
+
+module_init(do_tests);
diff -puN lib/Kconfig.debug~mutex-subsystem-synchro-test-module lib/Kconfig.debug
--- a/lib/Kconfig.debug~mutex-subsystem-synchro-test-module
+++ a/lib/Kconfig.debug
@@ -931,6 +931,20 @@ config FRAME_POINTER
 	  larger and slower, but it gives very useful debugging information
 	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
 
+config DEBUG_SYNCHRO_TEST
+	tristate "Synchronisation primitive testing module"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option provides a kernel module that can thrash the sleepable
+	  synchronisation primitives (mutexes and semaphores).
+
+	  You should say N or M here. Whilst the module can be built in, it's
+	  not recommended as it requires module parameters supplying to get it
+	  to do anything.
+
+	  See Documentation/synchro-test.txt.
+
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
 	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
_

