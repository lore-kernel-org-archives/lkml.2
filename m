Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1IVNme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:42:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:43166 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751374Ab1IVNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:42:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/jRidZiYXjki9EOsv/riotYnYPTlk6yzQr5+JVZI
	G13UisGVjAEGAS
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, mingo <mingo@redhat.com>
In-Reply-To: <1316693391.31429.12.camel@twins>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins>
	 <1316600230.6628.6.camel@marge.simson.net> <1316685640.31429.2.camel@twins>
	 <1316692534.6284.46.camel@marge.simson.net>
	 <1316693391.31429.12.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 15:42:23 +0200
Message-ID: <1316698943.6348.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 14:09 +0200, Peter Zijlstra wrote:
> On Thu, 2011-09-22 at 13:55 +0200, Mike Galbraith wrote:
> > On Thu, 2011-09-22 at 12:00 +0200, Peter Zijlstra wrote:
> > 
> > > OK, this one seems to be better.. But its quite vile, not sure I
> > > actually like it anymore.
> > 
> > Well, seemed to work, but I see there's a v3 now.
> 
> Yeah, just posted it for completeness, not sure its actually going
> anywhere since its slower than the current code (although its hard to
> say with the results changing from reboot to reboot), and its still
> quite ugly..

Hm. Stracing this proglet will soon leave it stuck forever unless the
timer is left running.  Virgin rt14 does the same though...

strace ./jitter -c 3 -p 99 -f 1000 -t 10 -r

rt_sigtimedwait([], NULL, NULL, 8)      = 64
timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={1316698141, 166759038}}, NULL) = 0
rt_sigtimedwait([], NULL, NULL, 8)      = 64
timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={1316698141, 167822701}}, NULL) = 0
rt_sigtimedwait([], NULL, NULL, 8)      = 64
timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={1316698141, 168887375}}, NULL) = 0
--- SIGRT_32 (Real-time signal 30) @ 0 (0) ---
rt_sigreturn(0x40)                      = 0
rt_sigtimedwait([], NULL, NULL, 8^C <unfinished ...>

#define _GNU_SOURCE

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <values.h>
#include <sched.h>
#include <signal.h>
#include <time.h>
#include <cpuset.h>
#include <getopt.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/mman.h>

/* compile with gcc -O  jitter.c  -o jitter -lrt -lm */

#define NSEC_PER_SEC 1000000000ULL
#define USEC_PER_SEC 1000000ULL
#define NSEC_PER_USEC 1000ULL


int frequency = 1000;
int period;
int tolerance = 5;
int delay = 1;
int samples = 1000;
int cpu;
int priority = 1;
int reset_timer;

double *deltas;
double *deviants;

sigset_t mysigset;

char *usage = "Usage: -c <cpu> -d <delay> -f <freq(Hz)> -p <prio> -t <tolerance(us)>\n";

void parse_options(int argc, char **argv)
{
	int ch;
	extern char *optarg;
	extern int optind;

	while ((ch = getopt(argc, argv, "c:d:f:p:rt:")) != EOF) {
		switch (ch) {
			case 'c':
				if (sscanf(optarg, "%d", &cpu) != 1 ||
						cpu < 0) {
					fprintf(stderr,"Invalid cpu.\n");
					exit(EXIT_FAILURE);
		 		}
			break;
			case 'd':
				if (sscanf(optarg, "%d", &delay) != 1 ||
						delay <= 0) {
					fprintf(stderr,"Invalid delay.\n");
					exit(EXIT_FAILURE);
		 		}
			break;
			case 'f':
				if (sscanf(optarg, "%d", &frequency) != 1 ||
						frequency <= 0) {
					fprintf(stderr,"Invalid frequency.\n");
					exit(EXIT_FAILURE);
		 		}
			break;
			case 'r':
				reset_timer = 1;
			break;
			case 'p':
				if (sscanf(optarg, "%d", &priority) != 1 ||
						priority < 1 || priority > 99) {
					fprintf(stderr,"Invalid priority.\n");
					exit(EXIT_FAILURE);
		 		}
			break;
			case 't':
				if (sscanf(optarg, "%d", &tolerance) != 1 ||
						tolerance < 0) {
					fprintf(stderr,"Invalid tolerance.\n");
					exit(EXIT_FAILURE);
		 		}
			break;
			default:
				fprintf(stderr, "%s", usage);
				exit(EXIT_FAILURE);
			break;
		}
	}

	samples = frequency * delay;
	period = NSEC_PER_SEC / frequency;
}

long delta(struct timespec *now, struct timespec *then)
{
	long delta = now->tv_sec * NSEC_PER_SEC + now->tv_nsec;

	delta -= then->tv_sec * NSEC_PER_SEC + then->tv_nsec; 

	return delta;
}

void signal_handler(int signo)
{
}

void init_timer(timer_t *timer_id)
{
	struct sigaction sa;
	struct sigevent se;

	memset(&sa, 0, sizeof(sa));
	sa.sa_flags = SA_RESTART|SA_SIGINFO;
	sa.sa_handler = signal_handler;
	sigemptyset(&sa.sa_mask);
	sigaddset(&sa.sa_mask, SIGCHLD);

	memset(&se, 0, sizeof(se));
	se.sigev_notify = SIGEV_SIGNAL;
	se.sigev_signo = SIGRTMAX;
	se.sigev_value.sival_int = 0;

	if (sigaction(SIGRTMAX, &sa, 0) < 0) {
		perror("sigaction");
		exit(EXIT_FAILURE);
	}

	if (timer_create(CLOCK_REALTIME, &se, timer_id) < 0) {
		perror("timer_create");
		exit(EXIT_FAILURE);
	}

	sigemptyset(&mysigset);
	sigaddset(&mysigset,SIGRTMAX);
}

void set_timer(timer_t timer_id, int period, struct timespec *target)
{
	struct itimerspec ts;
	struct timespec now;

	clock_gettime(CLOCK_REALTIME, target);

	if (period) {
		target->tv_nsec += period;

		if (target->tv_nsec >= NSEC_PER_SEC) {
			target->tv_sec++;
			target->tv_nsec -= NSEC_PER_SEC;
		}
	
		ts.it_value = *target;
		ts.it_interval.tv_sec = 0;
		ts.it_interval.tv_nsec = reset_timer ? 0 : period;
	} else
		memset(&ts, 0, sizeof(struct itimerspec));

	if (timer_settime(timer_id, TIMER_ABSTIME, &ts, NULL) < 0) {
		perror("timer_settime");
		exit (EXIT_FAILURE);
	}
}

void print_stats(void)
{
	struct sched_param sp;
	double min = MAXDOUBLE, max = MINDOUBLE;
	double sum = 0.0, delta, mean, sd;
	double tol = (double)tolerance;
	int i, deviant = 0;

	sp.sched_priority = 0;
	if (sched_setscheduler(0, SCHED_OTHER, &sp) == -1) {
		perror("sched_setscheduler");
		exit(EXIT_FAILURE);
	}

	for (i = 0; i < samples; i++) {
		deltas[i] /= (double)NSEC_PER_USEC;
		if (deltas[i] < min)
			min = deltas[i];
		if (deltas[i] > max)
			max = deltas[i];
		if (abs((int)deltas[i]) > tol) {
			deviants[deviant] = deltas[i];
			deviant++;
		}
		sum += deltas[i];
	}
	mean = sum / (double)samples;

	/* calculate standard deviation */
	sum = 0.0;
	for (i = 0; i < samples; i++) {
		delta = deltas[i] - mean;
		sum += delta*delta;
	}
	sum /= (double)samples;
	sd = sqrt(sum);

	printf("jitter:%7.2f\tmin: %9.2f max: %9.2f mean: %9.2f stddev: %7.2f\n",
		max - min, min, max, mean, sd);

	if (!deviant)
		goto out;

	min = MAXDOUBLE;
	max = MINDOUBLE;
	sum = 0.0;

	for (i = 0; i < deviant; i++) {
		if (deviants[i] < min)
			min = deviants[i];
		if (deviants[i] > max)
			max = deviants[i];
		sum += deviants[i];
	}
	mean = sum / (double)deviant;

	/* calculate standard deviation */
	sum = 0.0;
	for (i = 0; i < deviant; i++) {
		delta = deviants[i] - mean;
		sum += delta*delta;
	}
	sum /= (double)deviant;
	sd = sqrt(sum);
	printf("%d > %d us hits\tmin: %9.2f max: %9.2f mean: %9.2f stddev: %7.2f\n\n",
		deviant, tolerance, min, max, mean, sd);

out:
	fflush(stdout);
	sp.sched_priority = priority;
	if (sched_setscheduler(0, SCHED_FIFO, &sp) == -1) {
		perror("sched_setscheduler");
		exit(EXIT_FAILURE);
	}
}


int quit;

void exit_handler(int signo)
{
	quit = 1;
}

int main(int argc, char **argv)
{
	timer_t timer_id;
	struct sched_param sp;
	cpu_set_t cpuset;
	struct timespec now, then;
	int i = 0, sig = 0;

	parse_options(argc, argv);
	signal(SIGINT, exit_handler);
	signal(SIGTERM, exit_handler);

	if (mlockall(MCL_CURRENT|MCL_FUTURE) < 0) {
		perror("mlockall");
		exit(EXIT_FAILURE);
	}

	if (!(deltas = malloc(samples * sizeof(double)))) {
		perror("malloc deltas");
		exit(EXIT_FAILURE);
	} else if (!(deviants = malloc(samples * sizeof(double)))) {
		perror("malloc deviants");
		exit(EXIT_FAILURE);
	}

	CPU_ZERO(&cpuset);
	CPU_SET(cpu, &cpuset);

	if (sched_setaffinity(0, sizeof(cpuset), &cpuset) == -1) {
		perror("setaffinity");
		exit(EXIT_FAILURE);
	}

	sp.sched_priority = priority;
	if (sched_setscheduler(0, SCHED_FIFO, &sp) == -1) {
		perror("sched_setscheduler");
		exit(EXIT_FAILURE);
	}

	printf("CPU%d priority: %d timer freq: %d Hz tolerance: %d usecs, stats interval: %d %s\n\n",
		cpu, sp.sched_priority, frequency, tolerance,  delay, "secs");

	init_timer(&timer_id);
	set_timer(timer_id, period, &then);

	while (!quit && reset_timer) {
		sigwait(&mysigset,&sig);
		set_timer(timer_id, 0, &now);
		deltas[i] = (double)delta(&now, &then);

		if (i++ >= samples) {
			print_stats();
			i = 0;
		}

		set_timer(timer_id, period, &then);
	}

	clock_gettime(CLOCK_REALTIME, &then);

	while (!quit && !reset_timer) {
		sigwait(&mysigset,&sig);
		clock_gettime(CLOCK_REALTIME, &now);
		deltas[i] = (double)delta(&now, &then) - period;

		if (i++ >= samples) {
			set_timer(timer_id, 0, &then);
			print_stats();
			i = 0;
			set_timer(timer_id, period, &then);
		}

		clock_gettime(CLOCK_REALTIME, &then);
	}

	set_timer(timer_id, 0, &now);

	exit(EXIT_SUCCESS);
}


