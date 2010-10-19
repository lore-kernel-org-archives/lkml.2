Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab0JSL3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:29:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43096 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758322Ab0JSL3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:29:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+YZDVGLyiYGI9XaVjJPJ0bbBgqIee314irZ/yh2z
	dyfDU/zhA2FkaA
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1287479765.9920.9.camel@marge.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net>
Content-Type: multipart/mixed; boundary="=-liVcIHkLu2ZeYthwi8b0"
Date: Tue, 19 Oct 2010 13:29:17 +0200
Message-Id: <1287487757.24189.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-liVcIHkLu2ZeYthwi8b0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

It was suggested that I show a bit more info.

On Tue, 2010-10-19 at 11:16 +0200, Mike Galbraith wrote:

> A 100% hog overhead measurement proggy pinned to the same CPU as a make -j10
> 
> pert/s:      229 >5484.43us:       41 min:  0.15 max:12069.42 avg:2193.81 sum/s:502382us overhead:50.24%
> pert/s:      222 >5652.28us:       43 min:  0.46 max:12077.31 avg:2248.56 sum/s:499181us overhead:49.92%
> pert/s:      211 >5809.38us:       43 min:  0.16 max:12064.78 avg:2381.70 sum/s:502538us overhead:50.25%
> pert/s:      223 >6147.92us:       43 min:  0.15 max:16107.46 avg:2282.17 sum/s:508925us overhead:50.49%
> pert/s:      218 >6252.64us:       43 min:  0.16 max:12066.13 avg:2324.11 sum/s:506656us overhead:50.27%

The same load without per tty task groups.

pert/s:       31 >40475.37us:        3 min:  0.37 max:48103.60 avg:29573.74 sum/s:916786us overhead:90.24%
pert/s:       23 >41237.70us:       12 min:  0.36 max:56010.39 avg:40187.01 sum/s:924301us overhead:91.99%
pert/s:       24 >42150.22us:       12 min:  8.86 max:61265.91 avg:39459.91 sum/s:947038us overhead:92.20%
pert/s:       26 >42344.91us:       11 min:  3.83 max:52029.60 avg:36164.70 sum/s:940282us overhead:91.12%
pert/s:       24 >44262.90us:       14 min:  5.05 max:82735.15 avg:40314.33 sum/s:967544us overhead:92.22%
                                                      ^^^^^usecs   ^^^^^usecs                       ^^the competition got

Average service latency is an order of magnitude better with tty_sched.
(Imagine that pert is Xorg or whatnot instead)

Using Mathieu Desnoyers' wakeup-latency testcase (attached):

With taskset -c 3 make -j 10 running..

taskset -c 3 ./wakeup-latency& sleep 30;killall wakeup-latency

without:
maximum latency: 42963.2 µs
average latency: 9077.0 µs
missed timer events: 0

with:
maximum latency: 4160.7 µs
average latency: 149.4 µs
missed timer events: 0

Patch makes a big difference in desktop feel under hefty load here.

	-Mike

--=-liVcIHkLu2ZeYthwi8b0
Content-Disposition: attachment; filename="wakeup-latency.c"
Content-Type: text/x-csrc; name="wakeup-latency.c"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

/*

    Test application to test wakeup latency under different kinds of
    conditions and scheduling systems.

    Copyright (C) 2008 Nokia Corporation.
    Copyright (C) 2008 Jussi Laako <jussi@sonarnerd.net>

    Contact: Jussi Laako <jussi.laako@nokia.com>
             Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

    Compile with:
    gcc -lm -lrt -o wakeup-latency wakeup-latency.c
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <time.h>
#include <math.h>
#include <sched.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#define WL_CLOCK_ID	CLOCK_MONOTONIC
/*#define WL_CLOCK_ID	CLOCK_REALTIME*/
#define WL_INTERVAL	10			/* in milliseconds */
#define WL_DELTA	0.01			/* same as above, in seconds */
#define WL_REPORT	0.005			/* report threshold */
#define WL_BLOCKSIZE	480
#define WL_WORKCOUNT	2


typedef struct _ctx_t
{
	timer_t tid;
	unsigned count;
	unsigned overruns;
	double prevtime;
	double maxlat;
	double avglat;
	int dowork;
} ctx_t;


static int workcount = WL_WORKCOUNT;
static float x[4 + 1] = { 0 };
static float y[4] = { 0 };
static float wrk[WL_BLOCKSIZE];

static int tracefd;

static void usertrace(char *str)
{
	write(tracefd, str, strlen(str));
}

static inline double time_as_double (void)
{
	double restime;
	struct timespec ts = { 0 };  /* zero result in case of failure */

	clock_gettime(WL_CLOCK_ID, &ts);

	restime = (double) ts.tv_sec;
	restime += (double) ts.tv_nsec * 1.0e-9;

	return restime;
}


static void flt (float *data, int count)
{
	int i;
	float by;
	float ay;
	float yn;
	static const float a[] = {
		1.0F,
		2.000399874F,
		1.777661733F,
		0.7472161963F,
		0.1247940929F
	};
	static const float b[] = {
		0.3531294936F,
		1.412517974F,
		2.118776961F,
		1.412517974F,
		0.3531294936F
	};

	while (count)
	{
		for (i = 1; i <= 4; i++)
			x[i - 1] = x[i];
		x[4] = *data;
		by = 0;
		for (i = 0; i <= 4; i++)
			by += b[i] * x[4 - i];
		ay = 0;
		for (i = 1; i <= 4; i++)
			ay += a[i] * y[4 - i];
		yn = by - ay;
		for (i = 1; i < 4; i++)
			y[i - 1] = y[i];
		y[4 - 1] = yn;
		*data++ = yn;
		count--;
	}
}


static void sig_cb (int signo)
{
	/* no-op */
}


static void event_cb (sigval_t sval)
{
	int i, w;
	int or;
	int rnd;
	float s;
	float rms;
	double curtime;
	double delta;
	double lat;
	ctx_t *lctx = (ctx_t *) sval.sival_ptr;
	char buf[256];

	curtime = time_as_double();
	or = timer_getoverrun(lctx->tid);
	if (or > 0)
	{
		snprintf(buf, 256, "overruns: %i", or);
		usertrace(buf);
		printf("%s\n", buf);
		lctx->overruns += or;
	}
	delta = curtime - lctx->prevtime;
	if (delta > WL_DELTA)
	{
		lat = delta - WL_DELTA;
		/* display only the ones exceeding the threshold */
		if (lat > WL_REPORT) {
			snprintf(buf, 256, "late by: %.1f µs", lat * 1.0e6);
			usertrace(buf);
			printf("%s\n", buf);
		}
		if (lat > lctx->maxlat)
			lctx->maxlat = lat;
		lctx->avglat += lat;
		lctx->count++;
	}
	lctx->prevtime = curtime;
	if (lctx->dowork)
	{
		for (w = 0; w < workcount; w++)
		{
			s = 1.0F / (float) (RAND_MAX / 2);
			for (i = 0; i < WL_BLOCKSIZE; i++)
			{
				rnd = rand() - (RAND_MAX >> 1);
				wrk[i] = (float) rnd * s;
			}
			flt(wrk, WL_BLOCKSIZE);
			rms = 0.0F;
			for (i = 0; i < WL_BLOCKSIZE; i++)
				rms += wrk[i];
			rms = sqrtf(rms / (float) WL_BLOCKSIZE);
		}
	}
}


static int set_scheduling (int schedpol)
{
	struct sched_param schedparm = { 0 };

	printf("min priority: %i, max priority: %i\n",
		sched_get_priority_min(schedpol),
		sched_get_priority_max(schedpol));
	if (schedpol == SCHED_FIFO || schedpol == SCHED_RR)
		schedparm.sched_priority = sched_get_priority_min(schedpol);
	else
		schedparm.sched_priority = sched_get_priority_max(schedpol);
	if (sched_setscheduler(0, schedpol, &schedparm))
	{
		perror("sched_setscheduler()");
		return -1;
	}
	return 0;
}


static int create_source (ctx_t *ctx, int schedpol)
{
	int res = 0;
	struct sigevent sev = { 0 };
	struct sched_param schedparm = { 0 };
	pthread_attr_t tattr;

	pthread_attr_init(&tattr);
	if (pthread_attr_setinheritsched(&tattr, PTHREAD_INHERIT_SCHED))
	{
		pthread_attr_setinheritsched(&tattr, PTHREAD_EXPLICIT_SCHED);
		pthread_attr_setschedpolicy(&tattr, schedpol);
		if (schedpol == SCHED_FIFO || schedpol == SCHED_RR)
			schedparm.sched_priority =
				sched_get_priority_min(schedpol);
		else
			schedparm.sched_priority =
				sched_get_priority_max(schedpol);
		pthread_attr_setschedparam(&tattr, &schedparm);
	}

	sev.sigev_notify = SIGEV_THREAD;
	sev.sigev_signo = SIGRTMIN;
	sev.sigev_value.sival_ptr = ctx;
	sev.sigev_notify_function = event_cb;
	sev.sigev_notify_attributes = &tattr;
	if (timer_create(WL_CLOCK_ID, &sev, &ctx->tid))
	{
		perror("timer_create()");
		res = -1;
	}

	pthread_attr_destroy(&tattr);

	return res;
}


static int set_timer (ctx_t *ctx)
{
	struct itimerspec ts;

	ts.it_interval.tv_sec = 0;
	ts.it_interval.tv_nsec = WL_INTERVAL * 1000000;
	ts.it_value.tv_sec = 0;
	ts.it_value.tv_nsec = WL_INTERVAL * 1000000;
	ctx->prevtime = time_as_double();
	if (timer_settime(ctx->tid, 0, &ts, NULL))
	{
		perror("timer_settime()");
		return -1;
	}
	return 0;
}


int main (int argc, char *argv[])
{
	int i;
	int w;
	int schedpol = 0;
	int sig;
	int ret = 0;
	sigset_t ss;
	ctx_t ctx = { 0 };

	tracefd = open("/debugfs/ltt/write_event", O_WRONLY);

	signal(SIGINT, sig_cb);
	signal(SIGTERM, sig_cb);
	srand(time(NULL));
	for (i = 1; i < argc; i++)
	{
		if (strcmp(argv[i], "--use-mm") == 0)
			schedpol = 6;
		else if (strcmp(argv[i], "--use-fifo") == 0)
			schedpol = SCHED_FIFO;
		else if (strcmp(argv[i], "--use-rr") == 0)
			schedpol = SCHED_RR;
		else if (strcmp(argv[i], "--do-work") == 0)
		{
			ctx.dowork = 1;
			if (i + 1 < argc)
			{
				w = atoi(argv[i + 1]);
				if (w > 0)
				{
					workcount = w;
					i++;
				}
			}
			printf("work count: %i\n", workcount);
		}
		else
		{
			printf("unknown option: %s\n", argv[i]);
			printf(
				"usage: %s [--use-mm|--use-fifo|--use-rr][--do-work [n]]\n",
				argv[0]);
			ret = 1;
			goto end;
		}
	}

	if (set_scheduling(schedpol)) {
		ret = 1;
		goto end;
	}

	if (create_source(&ctx, schedpol)) {
		ret = 1;
		goto end;
	}

	if (!set_timer(&ctx))
	{
		sigemptyset(&ss);
		sigaddset(&ss, SIGINT);
		sigaddset(&ss, SIGTERM);
		sigwait(&ss, &sig);
	}

	printf("\nmaximum latency: %.1f µs\n", ctx.maxlat * 1.0e6);
	printf("average latency: %.1f µs\n",
		ctx.avglat / (double) ctx.count * 1.0e6);
	printf("missed timer events: %u\n", ctx.overruns);

	timer_delete(ctx.tid);
end:
	close(tracefd);

	return ret;
}


--=-liVcIHkLu2ZeYthwi8b0--

