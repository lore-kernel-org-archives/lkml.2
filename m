Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab1IADJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:09:57 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43293 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab1IADJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:09:56 -0400
Date: Wed, 31 Aug 2011 23:07:18 -0400 (EDT)
Message-Id: <20110831.230718.2029810906806382170.davem@davemloft.net>
To: peterz@infradead.org
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: process time < thread time?
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 31 Aug 2011 20:07:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If someone who understands our thread/process time implementation can
look into this, I'd appreciate it.

Attached below is a watered-down version of rt/tst-cpuclock2.c from
GLIBC.  Just build it with "gcc -o test test.c -lpthread -lrt" or
similar.

Run it several times, and you will see cases where the main thread
will measure a process clock difference before and after the nanosleep
which is smaller than the cpu-burner thread's individual thread clock
difference.  This doesn't make any sense since the cpu-burner thread
is part of the top-level process's thread group.

I've reproduced this on both x86-64 and sparc64 (using both 32-bit and
64-bit binaries).

For example:

[davem@boricha build-x86_64-linux]$ ./test
process: before(0.001221967) after(0.498624371) diff(497402404)
thread:  before(0.000081692) after(0.498316431) diff(498234739)
self:    before(0.001223521) after(0.001240219) diff(16698)
[davem@boricha build-x86_64-linux]$ 

The diff of 'process' should always be >= the diff of 'thread'.

I make sure to wrap the 'thread' clock measurements the most tightly
around the nanosleep() call, and that the 'process' clock measurements
are the outer-most ones.

I suspect this might be some kind of artifact of how the partial
runqueue ->clock and ->clock_task updates work?  Maybe some weird
interaction with ->skip_clock_update?

Or is this some known issue?

Thanks!

--------------------
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <pthread.h>

static pthread_barrier_t barrier;

static void *chew_cpu(void *arg)
{
	pthread_barrier_wait(&barrier);
	while (1)
		__asm__ __volatile__("" : : : "memory");
	return NULL;
}

int main(void)
{
	clockid_t process_clock, my_thread_clock, th_clock;
	struct timespec process_before, process_after;
	struct timespec me_before, me_after;
	struct timespec th_before, th_after;
	struct timespec sleeptime;
	unsigned long diff;
	pthread_t th;
	int err;

	err = clock_getcpuclockid(0, &process_clock);
	if (err)
		return 1;

	err = pthread_getcpuclockid(pthread_self(), &my_thread_clock);
	if (err)
		return 1;

	pthread_barrier_init(&barrier, NULL, 2);
	err = pthread_create(&th, NULL, chew_cpu, NULL);
	if (err)
		return 1;

	err = pthread_getcpuclockid(th, &th_clock);
	if (err)
		return 1;

	pthread_barrier_wait(&barrier);

	err = clock_gettime(process_clock, &process_before);
	if (err)
		return 1;

	err = clock_gettime(my_thread_clock, &me_before);
	if (err)
		return 1;

	err = clock_gettime(th_clock, &th_before);
	if (err)
		return 1;

	sleeptime.tv_sec = 0;
	sleeptime.tv_nsec = 500000000;
	nanosleep(&sleeptime, NULL);

	err = clock_gettime(th_clock, &th_after);
	if (err)
		return 1;

	err = clock_gettime(my_thread_clock, &me_after);
	if (err)
		return 1;

	err = clock_gettime(process_clock, &process_after);
	if (err)
		return 1;

	diff = process_after.tv_nsec - process_before.tv_nsec;
	printf("process: before(%lu.%.9lu) after(%lu.%.9lu) diff(%lu)\n",
	       process_before.tv_sec, process_before.tv_nsec,
	       process_after.tv_sec, process_after.tv_nsec, diff);
	diff = th_after.tv_nsec - th_before.tv_nsec;
	printf("thread:  before(%lu.%.9lu) after(%lu.%.9lu) diff(%lu)\n",
	       th_before.tv_sec, th_before.tv_nsec,
	       th_after.tv_sec, th_after.tv_nsec, diff);
	diff = me_after.tv_nsec - me_before.tv_nsec;
	printf("self:    before(%lu.%.9lu) after(%lu.%.9lu) diff(%lu)\n",
	       me_before.tv_sec, me_before.tv_nsec,
	       me_after.tv_sec, me_after.tv_nsec, diff);

	return 0;
}
