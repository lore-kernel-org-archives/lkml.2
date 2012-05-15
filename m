Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab2EOQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:26:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab2EOQ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:26:23 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=huzqtivG31QA:10 a=5SG0PmZfjMsA:10 a=AJWcLwqtiKGz1wIxxmYA:9 a=PUjeQqilurYA:10 a=mxPFySlORhQNwflBtCUA:9 a=1GGQG-N9BVCwGqgkc-wA:7 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337099180.14207.321.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 15 May 2012 12:26:20 -0400
In-Reply-To: <1337090625.14207.304.camel@gandalf.stny.rr.com>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
Content-Type: multipart/mixed; boundary="=-vSY4GtLXS2ilbwo+h0lb"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vSY4GtLXS2ilbwo+h0lb
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

On Tue, 2012-05-15 at 10:03 -0400, Steven Rostedt wrote:

> I'll see if I can get some numbers to see how this fixes the issues with
> multi threads on big boxes.
> 

I couldn't get access to the big box, so I wrote my own test. The
attached program is what I used. It creates 400 threads and allocates a
memory range (with mmap) of 10 gigs. Then it runs all 400 threads, where
each is fighting to read this new memory. Causing lots of page faults.

I tested on a 4 CPU box with 3.4.0-rc7-rt6:

Without the patch:

map=10737418240
time = 11302617 usecs
map=10737418240
time = 11229341 usecs
map=10737418240
time = 11171463 usecs
map=10737418240
time = 11435549 usecs
map=10737418240
time = 11299086 usecs


With the patch:

map=10737418240
time = 6493796 usecs
map=10737418240
time = 6726186 usecs
map=10737418240
time = 3978194 usecs
map=10737418240
time = 6796688 usecs


So it went from roughly 11 secs to 6 secs (even had one 4sec run). This
shows that it sped up the fault access by almost half.


-- Steve


--=-vSY4GtLXS2ilbwo+h0lb
Content-Disposition: attachment; filename="faultme.c"
Content-Type: text/x-csrc; name="faultme.c"; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

/*
 * Copyright 2012, Steven Rostedt
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdarg.h>
#include <sched.h>
#include <pthread.h>
#include <signal.h>
#include <time.h>
#include <sys/time.h>
#include <sys/mman.h>

#define THREADS 400
//#define MEM (4096ULL*400)
#define MEM (10ULL*4096*1024*1024/4)

#define nano2sec(nan) (nan / 1000000000ULL)
#define nano2ms(nan) (nan / 1000000ULL)
#define nano2usec(nan) (nan / 1000ULL)
#define usec2nano(sec) (sec * 1000ULL)
#define ms2nano(ms) (ms * 1000000ULL)
#define sec2nano(sec) (sec * 1000000000ULL)
#define sec2usec(sec) (sec * 1000000ULL)

static char *data;

static pthread_barrier_t start_barrier;
static pthread_barrier_t stop_barrier;

static void perr(char *fmt, ...)
{
	char buffer[BUFSIZ];
	va_list ap;

	va_start(ap, fmt);
	vsnprintf(buffer, BUFSIZ, fmt, ap);
	va_end(ap);

	perror(buffer);
	fflush(stderr);
	exit(-1);
}

void *func(void *dat)
{
	unsigned long id = (unsigned long)dat;
	static char x;
	unsigned long i;

	pthread_barrier_wait(&start_barrier);

	for (i = id * 4096; i < MEM; i += 4096 * THREADS) {
		x = data[i];
	}

	pthread_barrier_wait(&stop_barrier);

	return NULL;
}

static unsigned long long get_time(void)
{
	struct timeval tv;
	unsigned long long time;

	gettimeofday(&tv, NULL);

	time = sec2usec(tv.tv_sec);
	time += tv.tv_usec;

	return time;
}

void run_test(int threads)
{
	pthread_t t[threads];
	unsigned long long start, end;
	unsigned long i;

	for (i=0; i < threads; i++) {
		if (pthread_create(&t[i], NULL, func, (void *)i)) {
			perror("pthread_creat");
			exit(-1);
		}
	}

	start = get_time();
	pthread_barrier_wait(&start_barrier);
	pthread_barrier_wait(&stop_barrier);
	end = get_time();

	printf("time = %lld usecs\n", end - start);

	 for (i=0; i < threads; i++) {
		 pthread_join(t[i], NULL);
	 }
}

int main (int argc, char **argv)
{
	int threads = THREADS;
	int ret;

	ret = pthread_barrier_init(&start_barrier, NULL, threads + 1);
	if (ret < 0)
		perr("pthread_barrier_init");

	ret = pthread_barrier_init(&stop_barrier, NULL, threads + 1);
	if (ret < 0)
		perr("pthread_barrier_init");

	printf("map=%lld\n", MEM);
	data = mmap(NULL, MEM, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
	if (data == MAP_FAILED)
		perr("mmap");

	run_test(threads);
	
	exit(0);
	
	return 0;
}

--=-vSY4GtLXS2ilbwo+h0lb--

