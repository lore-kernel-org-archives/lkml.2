Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab0ESPWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:22:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0ESPWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:22:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274135154-24082-11-git-send-email-walken@google.com>
References: <1274135154-24082-11-git-send-email-walken@google.com> <1274135154-24082-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 10/10] Use down_read_critical() for /sys/<pid>/exe and /sys/<pid>/maps files
Date: Wed, 19 May 2010 16:21:32 +0100
Message-ID: <31783.1274282492@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> This helps in the following situation:
> - Thread A takes a page fault while reading or writing memory.
>   do_page_fault() acquires the mmap_sem for read and blocks on disk
>   (either reading the page from file, or hitting swap) for a long time.
> - Thread B does an mmap call and blocks trying to acquire the mmap_sem
>   for write
> - Thread C is a monitoring process trying to read every /proc/pid/maps
>   in the system. This requires acquiring the mmap_sem for read. Thread C
>   blocks behind B, waiting for A to release the rwsem.  If thread C
>   could be allowed to run in parallel with A, it would probably get done
>   long before thread A's disk access completes, thus not actually slowing
>   down thread B.
> 
> Test results with down_read_critical_test (10 seconds):

That seems to work.  I have some rwsem benchmarks for you using my
synchronisation primitive test (see attached).  I run it like so:

	insmod /tmp/synchro-test.ko rd=10 wr=2 dg=1 do_sched=1

with 10 readers, 2 writers and a downgrader on the same rwsem, and permitting
scheduling between attempts to grab and release the semaphore.  The test runs
for 5 seconds on a box that isn't doing anything else, and has had almost
everything that might normally be running (including syslog) disabled or
removed.

Without your patches:

      THREADS       S INTVL             LOCKS TAKEN AND RELEASED
-------------------   /LOAD -------------------------------------------------
MTX SEM RD  WR  DG          MTX TAKEN SEM TAKEN RD TAKEN  WR TAKEN  DG TAKEN
=== === === === === = ===== ========= ========= ========= ========= =========
  0   0  10   2   1 s   2/2         0         0   2087911    590464    194394
  0   0  10   2   1 s   2/2         0         0   2030497    591511    196851
  0   0  10   2   1 s   2/2         0         0   2078523    605317    199645

With your patches

  0   0  10   2   1 s   2/2         0         0   2054720    605691    198472
  0   0  10   2   1 s   2/2         0         0   2051376    597976    196962
  0   0  10   2   1 s   2/2         0         0   2011909    595706    197482

So there doesn't seem to be much in the way of degradation.  In fact, there
seems to have been more degradation somewhere in the general kernel since I
played with version 1 of your patches a week ago.  At that time, the vanilla
kernel gave this without your patches applied:

  0   0  10   2   1 s   2/2         0         0   2217200    636227    210255
  0   0  10   2   1 s   2/2         0         0   2217903    629175    212926
  0   0  10   2   1 s   2/2         0         0   2224136    647912    212506

Feel free to have a play.

BTW, the code also works on FRV in NOMMU mode (which uses the spinlock-based
rwsem version).


However...  I'm not certain that giving a process that's accessing
/proc/pid/maps priority over a second process that may be trying to do mmap or
page fault or something internally is a good idea.

It would be useful if you made clearer what you're actually measuring from
/proc/pid/maps...

David
---
/* synchro-test.c: run some threads to test the synchronisation primitives
 *
 * Copyright (C) 2005, 2006 Red Hat, Inc. All Rights Reserved.
 * Written by David Howells (dhowells@redhat.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version
 * 2 of the License, or (at your option) any later version.
 *
 * The module should be run as something like:
 *
 *	insmod synchro-test.ko rd=2 wr=2
 *	insmod synchro-test.ko mx=1
 *	insmod synchro-test.ko sm=2 ism=1
 *	insmod synchro-test.ko sm=2 ism=2
 *
 * See Documentation/synchro-test.txt for more information.
 */

#include <linux/module.h>
#include <linux/poll.h>
#include <linux/moduleparam.h>
#include <linux/sched.h>
#include <linux/stat.h>
#include <linux/init.h>
#include <asm/atomic.h>
#include <linux/personality.h>
#include <linux/smp_lock.h>
#include <linux/delay.h>
#include <linux/timer.h>
#include <linux/completion.h>
#include <linux/mutex.h>

#define MAX_THREADS 64

/*
 * Turn on self-validation if we do a one-shot boot-time test:
 */
#ifndef MODULE
# define VALIDATE_OPERATORS
#endif

static int nummx;
static int numsm, seminit = 4;
static int numrd, numwr, numdg;
static int elapse = 5, load = 2, do_sched, interval = 2;
static int verbose = 0;

MODULE_AUTHOR("David Howells");
MODULE_DESCRIPTION("Synchronisation primitive test demo");
MODULE_LICENSE("GPL");

module_param_named(v, verbose, int, 0);
MODULE_PARM_DESC(verbose, "Verbosity");

module_param_named(mx, nummx, int, 0);
MODULE_PARM_DESC(nummx, "Number of mutex threads");

module_param_named(sm, numsm, int, 0);
MODULE_PARM_DESC(numsm, "Number of semaphore threads");

module_param_named(ism, seminit, int, 0);
MODULE_PARM_DESC(seminit, "Initial semaphore value");

module_param_named(rd, numrd, int, 0);
MODULE_PARM_DESC(numrd, "Number of reader threads");

module_param_named(wr, numwr, int, 0);
MODULE_PARM_DESC(numwr, "Number of writer threads");

module_param_named(dg, numdg, int, 0);
MODULE_PARM_DESC(numdg, "Number of downgrader threads");

module_param(elapse, int, 0);
MODULE_PARM_DESC(elapse, "Number of seconds to run for");

module_param(load, int, 0);
MODULE_PARM_DESC(load, "Length of load in uS");

module_param(interval, int, 0);
MODULE_PARM_DESC(interval, "Length of interval in uS before re-getting lock");

module_param(do_sched, int, 0);
MODULE_PARM_DESC(do_sched, "True if each thread should schedule regularly");

/* the semaphores under test */
static struct mutex ____cacheline_aligned mutex;
static struct semaphore ____cacheline_aligned sem;
static struct rw_semaphore ____cacheline_aligned rwsem;

static atomic_t ____cacheline_aligned do_stuff		= ATOMIC_INIT(0);

#ifdef VALIDATE_OPERATORS
static atomic_t ____cacheline_aligned mutexes		= ATOMIC_INIT(0);
static atomic_t ____cacheline_aligned semaphores	= ATOMIC_INIT(0);
static atomic_t ____cacheline_aligned readers		= ATOMIC_INIT(0);
static atomic_t ____cacheline_aligned writers		= ATOMIC_INIT(0);
#endif

static unsigned int ____cacheline_aligned mutexes_taken		[MAX_THREADS];
static unsigned int ____cacheline_aligned semaphores_taken	[MAX_THREADS];
static unsigned int ____cacheline_aligned reads_taken		[MAX_THREADS];
static unsigned int ____cacheline_aligned writes_taken		[MAX_THREADS];
static unsigned int ____cacheline_aligned downgrades_taken	[MAX_THREADS];

static struct completion ____cacheline_aligned mx_comp[MAX_THREADS];
static struct completion ____cacheline_aligned sm_comp[MAX_THREADS];
static struct completion ____cacheline_aligned rd_comp[MAX_THREADS];
static struct completion ____cacheline_aligned wr_comp[MAX_THREADS];
static struct completion ____cacheline_aligned dg_comp[MAX_THREADS];

static struct timer_list ____cacheline_aligned timer;

#define ACCOUNT(var, N) var##_taken[N]++;

#ifdef VALIDATE_OPERATORS
#define TRACK(var, dir) atomic_##dir(&(var))

#define CHECK(var, cond, val)						\
do {									\
	int x = atomic_read(&(var));					\
	if (unlikely(!(x cond (val))))					\
		printk("check [%s %s %d, == %d] failed in %s\n",	\
		       #var, #cond, (val), x, __func__);		\
} while (0)

#else
#define TRACK(var, dir)		do {} while(0)
#define CHECK(var, cond, val)	do {} while(0)
#endif

static inline void do_mutex_lock(unsigned int N)
{
	mutex_lock(&mutex);

	ACCOUNT(mutexes, N);
	TRACK(mutexes, inc);
	CHECK(mutexes, ==, 1);
}

static inline void do_mutex_unlock(unsigned int N)
{
	CHECK(mutexes, ==, 1);
	TRACK(mutexes, dec);

	mutex_unlock(&mutex);
}

static inline void do_down(unsigned int N)
{
	CHECK(mutexes, <, seminit);

	down(&sem);

	ACCOUNT(semaphores, N);
	TRACK(semaphores, inc);
}

static inline void do_up(unsigned int N)
{
	CHECK(semaphores, >, 0);
	TRACK(semaphores, dec);

	up(&sem);
}

static inline void do_down_read(unsigned int N)
{
	down_read(&rwsem);

	ACCOUNT(reads, N);
	TRACK(readers, inc);
	CHECK(readers, >, 0);
	CHECK(writers, ==, 0);
}

static inline void do_up_read(unsigned int N)
{
	CHECK(readers, >, 0);
	CHECK(writers, ==, 0);
	TRACK(readers, dec);

	up_read(&rwsem);
}

static inline void do_down_write(unsigned int N)
{
	down_write(&rwsem);

	ACCOUNT(writes, N);
	TRACK(writers, inc);
	CHECK(writers, ==, 1);
	CHECK(readers, ==, 0);
}

static inline void do_up_write(unsigned int N)
{
	CHECK(writers, ==, 1);
	CHECK(readers, ==, 0);
	TRACK(writers, dec);

	up_write(&rwsem);
}

static inline void do_downgrade_write(unsigned int N)
{
	CHECK(writers, ==, 1);
	CHECK(readers, ==, 0);
	TRACK(writers, dec);
	TRACK(readers, inc);

	downgrade_write(&rwsem);

	ACCOUNT(downgrades, N);
}

static inline void sched(void)
{
	if (do_sched)
		schedule();
}

static int mutexer(void *arg)
{
	unsigned int N = (unsigned long) arg;

	daemonize("Mutex%u", N);
	set_user_nice(current, 19);

	while (atomic_read(&do_stuff)) {
		do_mutex_lock(N);
		if (load)
			udelay(load);
		do_mutex_unlock(N);
		sched();
		if (interval)
			udelay(interval);
	}

	if (verbose >= 2)
		printk("%s: done\n", current->comm);
	complete_and_exit(&mx_comp[N], 0);
}

static int semaphorer(void *arg)
{
	unsigned int N = (unsigned long) arg;

	daemonize("Sem%u", N);
	set_user_nice(current, 19);

	while (atomic_read(&do_stuff)) {
		do_down(N);
		if (load)
			udelay(load);
		do_up(N);
		sched();
		if (interval)
			udelay(interval);
	}

	if (verbose >= 2)
		printk("%s: done\n", current->comm);
	complete_and_exit(&sm_comp[N], 0);
}

static int reader(void *arg)
{
	unsigned int N = (unsigned long) arg;

	daemonize("Read%u", N);
	set_user_nice(current, 19);

	while (atomic_read(&do_stuff)) {
		do_down_read(N);
#ifdef LOAD_TEST
		if (load)
			udelay(load);
#endif
		do_up_read(N);
		sched();
		if (interval)
			udelay(interval);
	}

	if (verbose >= 2)
		printk("%s: done\n", current->comm);
	complete_and_exit(&rd_comp[N], 0);
}

static int writer(void *arg)
{
	unsigned int N = (unsigned long) arg;

	daemonize("Write%u", N);
	set_user_nice(current, 19);

	while (atomic_read(&do_stuff)) {
		do_down_write(N);
#ifdef LOAD_TEST
		if (load)
			udelay(load);
#endif
		do_up_write(N);
		sched();
		if (interval)
			udelay(interval);
	}

	if (verbose >= 2)
		printk("%s: done\n", current->comm);
	complete_and_exit(&wr_comp[N], 0);
}

static int downgrader(void *arg)
{
	unsigned int N = (unsigned long) arg;

	daemonize("Down%u", N);
	set_user_nice(current, 19);

	while (atomic_read(&do_stuff)) {
		do_down_write(N);
#ifdef LOAD_TEST
		if (load)
			udelay(load);
#endif
		do_downgrade_write(N);
#ifdef LOAD_TEST
		if (load)
			udelay(load);
#endif
		do_up_read(N);
		sched();
		if (interval)
			udelay(interval);
	}

	if (verbose >= 2)
		printk("%s: done\n", current->comm);
	complete_and_exit(&dg_comp[N], 0);
}

static void stop_test(unsigned long dummy)
{
	atomic_set(&do_stuff, 0);
}

static unsigned int total(const char *what, unsigned int counts[], int num)
{
	unsigned int tot = 0, max = 0, min = UINT_MAX, zeros = 0, cnt;
	int loop;

	for (loop = 0; loop < num; loop++) {
		cnt = counts[loop];

		if (cnt == 0) {
			zeros++;
			min = 0;
			continue;
		}

		tot += cnt;
		if (tot > max)
			max = tot;
		if (tot < min)
			min = tot;
	}

	if (verbose && tot > 0) {
		printk("%s:", what);

		for (loop = 0; loop < num; loop++) {
			cnt = counts[loop];

			if (cnt == 0)
				printk(" zzz");
			else
				printk(" %d%%", cnt * 100 / tot);
		}

		printk("\n");
	}

	return tot;
}

/*****************************************************************************/
/*
 *
 */
static int __init do_tests(void)
{
	unsigned long loop;
	unsigned int mutex_total, sem_total, rd_total, wr_total, dg_total;

	if (nummx < 0 || nummx > MAX_THREADS ||
	    numsm < 0 || numsm > MAX_THREADS ||
	    numrd < 0 || numrd > MAX_THREADS ||
	    numwr < 0 || numwr > MAX_THREADS ||
	    numdg < 0 || numdg > MAX_THREADS ||
	    seminit < 1 ||
	    elapse < 1 ||
	    load < 0 || load > 999 ||
	    interval < 0 || interval > 999
	    ) {
		printk("Parameter out of range\n");
		return -ERANGE;
	}

	if ((nummx | numsm | numrd | numwr | numdg) == 0) {
		int num = num_online_cpus();

		if (num > MAX_THREADS)
			num = MAX_THREADS;
		nummx = numsm = numrd = numwr = numdg = num;

		load = 1;
		interval = 1;
		do_sched = 1;
		printk("No parameters - using defaults.\n");
	}

	if (verbose)
		printk("\nStarting synchronisation primitive tests...\n");

	mutex_init(&mutex);
	sema_init(&sem, seminit);
	init_rwsem(&rwsem);
	atomic_set(&do_stuff, 1);

	/* kick off all the children */
	for (loop = 0; loop < MAX_THREADS; loop++) {
		if (loop < nummx) {
			init_completion(&mx_comp[loop]);
			kernel_thread(mutexer, (void *) loop, 0);
		}

		if (loop < numsm) {
			init_completion(&sm_comp[loop]);
			kernel_thread(semaphorer, (void *) loop, 0);
		}

		if (loop < numrd) {
			init_completion(&rd_comp[loop]);
			kernel_thread(reader, (void *) loop, 0);
		}

		if (loop < numwr) {
			init_completion(&wr_comp[loop]);
			kernel_thread(writer, (void *) loop, 0);
		}

		if (loop < numdg) {
			init_completion(&dg_comp[loop]);
			kernel_thread(downgrader, (void *) loop, 0);
		}
	}

	/* set a stop timer */
	init_timer(&timer);
	timer.function = stop_test;
	timer.expires = jiffies + elapse * HZ;
	add_timer(&timer);

	/* now wait until it's all done */
	for (loop = 0; loop < nummx; loop++)
		wait_for_completion(&mx_comp[loop]);

	for (loop = 0; loop < numsm; loop++)
		wait_for_completion(&sm_comp[loop]);

	for (loop = 0; loop < numrd; loop++)
		wait_for_completion(&rd_comp[loop]);

	for (loop = 0; loop < numwr; loop++)
		wait_for_completion(&wr_comp[loop]);

	for (loop = 0; loop < numdg; loop++)
		wait_for_completion(&dg_comp[loop]);

	atomic_set(&do_stuff, 0);
	del_timer(&timer);

	if (mutex_is_locked(&mutex))
		printk(KERN_ERR "Mutex is still locked!\n");

	/* count up */
	mutex_total	= total("MTX", mutexes_taken, nummx);
	sem_total	= total("SEM", semaphores_taken, numsm);
	rd_total	= total("RD ", reads_taken, numrd);
	wr_total	= total("WR ", writes_taken, numwr);
	dg_total	= total("DG ", downgrades_taken, numdg);

	/* print the results */
	if (verbose) {
		printk("mutexes taken: %u\n", mutex_total);
		printk("semaphores taken: %u\n", sem_total);
		printk("reads taken: %u\n", rd_total);
		printk("writes taken: %u\n", wr_total);
		printk("downgrades taken: %u\n", dg_total);
	}
	else {
		char buf[30];

		sprintf(buf, "%d/%d", interval, load);

		printk("%3d %3d %3d %3d %3d %c %5s %9u %9u %9u %9u %9u\n",
		       nummx, numsm, numrd, numwr, numdg,
		       do_sched ? 's' : '-',
		       buf,
		       mutex_total,
		       sem_total,
		       rd_total,
		       wr_total,
		       dg_total);
	}

	/* tell insmod to discard the module */
	if (verbose)
		printk("Tests complete\n");
	return -ENOANO;

} /* end do_tests() */

module_init(do_tests);

