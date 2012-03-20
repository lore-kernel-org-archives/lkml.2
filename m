Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab2CTX0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:26:34 -0400
Received: from ozlabs.org ([203.10.76.45]:33429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260Ab2CTX0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:26:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo\@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: CPU Hotplug rework
In-Reply-To: <1332240151.18960.401.camel@twins>
References: <4F674649.2000300@linux.vnet.ibm.com> <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 21 Mar 2012 09:30:05 +1030
Message-ID: <874ntic1ze.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012 11:42:31 +0100, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-03-20 at 10:12 +1030, Rusty Russell wrote:
> Depends on the machine and the needs. For the regular desktop with a
> regular kernel, the stop_machine in hotplug isn't really a problem. For
> _BIG_ machines stop_machine is a problem

I tested on a PPC 64-way a few years ago, but let's get a really big
machine and re-run the tests.  Simplest is to benchmark module removal,
which uses a very trivial stop_machine call.  Old test code below, but
it'll need to be updated (module insertion no longer uses stop_machine).

> for -RT stop_machine is a problem.

If this is really about -RT, let's say so.  There's nothing *wrong* with
that, but it feels more honest.

> So if we're going to re-architect hotplug anyway, it would be very good
> to get rid of it, because I really don't see any hard reasons why we
> would need it.

Absolutely.  It was an easy way to introduce it, but it's not
fundamental.

> > Unfortunately, this doesn't seem to be the case in my testing.  The time
> > for hotplug seems to be moving all the threads around.  So how about:
> 
> Agreed, the thread creation on online is the most expensive operation.
> 
> > (1) Let's not shutdown per-cpu kthreads, just leave them there to run
> >     if the CPU comes back.
> 
> Wasn't as easy as it sounds, but should be doable.
> 
> > (2) Do something more efficient with userspace threads than migrating
> >     them one at a time.
> 
> Sadly that can't really be done. We need to pick up every task
> (userspace, but also running kernel threads) and update their state.

What if we had an "orphan" runqueue which everyone pulled from?  Then we
could grab the lock, move them all to the fake rq, then let stuff happen
normally.

Maybe that's crap, but at least we could move the migration out of the
hotplug callback somehow.

> > Otherwise, we risk doing a great deal of work and gaining nothing
> > (cleanups aside, of course).
> 
> I don't really think its possible to spend too much time cleaning up
> hotplug at this point :-)

There is that, yes :)

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org

/* measure_latency.c */
#define _GNU_SOURCE
#include <sched.h>
#include <sys/time.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <err.h>
#include <string.h>
#include "time_diff.h"

/* "Copyright 2007 <kathy.staples@au.ibm.com> IBM Corp" */
#define streq(a,b) (strcmp((a),(b)) == 0)

static uint64_t timeval_to_usecs(struct timeval convert)
{	/* this function works out the number of microseconds  */
	return (convert.tv_sec * (uint64_t)1000000 + convert.tv_usec);
}

static void *grab_file(const char *filename, unsigned long *size)
{
	unsigned int max = 16384;
	int ret, fd;
	void *buffer = malloc(max);
	if (!buffer)
		return NULL;

	if (streq(filename, "-"))
		fd = dup(STDIN_FILENO);
	else
		fd = open(filename, O_RDONLY, 0);

	if (fd < 0)
		return NULL;

	*size = 0;
	while ((ret = read(fd, buffer + *size, max - *size)) > 0) {
		*size += ret;
		if (*size == max)
			buffer = realloc(buffer, max *= 2);
	}
	if (ret < 0) {
		free(buffer);
		buffer = NULL;
	}
	close(fd);
	return buffer;
}

extern long init_module(void *, unsigned long, const char *);

/* If module is NULL, merely go through the motions. */
static void do_modprobe(int cpu, int pollfd, int secs, const char *module)
{
	struct sched_param sparam = { .sched_priority = 99 };
	cpu_set_t this_cpu;
	fd_set readfds;
	int error;
	struct timeval timeout = { .tv_sec = 5 };
	void *file;
	unsigned long len;

	if (module) {
		file = grab_file(module, &len);
		if (!file)
			err(1, "Loading file %s", module);
	}

	CPU_ZERO(&this_cpu);
	CPU_SET(cpu, &this_cpu);
	if (sched_setaffinity(getpid(), sizeof(cpu_set_t), &this_cpu) != 0)
		err(1, "Could not move modprobe to cpu %i", cpu);
	if (sched_setscheduler(getpid(), SCHED_FIFO, &sparam) != 0)
		err(1, "Could not set FIFO scheduler for modprobe");

	/* Wait for go signal. */
	FD_ZERO(&readfds);
	FD_SET(pollfd, &readfds);

	/* We can timeout. */
	if (select(pollfd + 1, &readfds, NULL, NULL, &timeout) != 1)
		exit(1);

	/* Sleep until halfway through. */
	usleep(secs * 500000);

	if (module) {
		error = init_module(file, len, "");
		if (error)
			err(1, "init_module '%s'", module);
	}
	printf("Modprobe done on cpu %i\n", cpu);
	exit(0);
}

static void measure_latency(int cpu, int secs, int writefd, int pollfd)
{
	struct timeval start_time, now, elapsed_time, previous_time, diff;
	uint64_t least, max_diff, no_of_diffs;
	cpu_set_t this_cpu;
	fd_set readfds;
	struct timeval timeout = { .tv_sec = 5 };
	char buf[1024];
	struct sched_param sparam = { .sched_priority = 50 };

	least = UINT64_MAX;
	max_diff = 0;
	no_of_diffs = 0;

	CPU_ZERO(&this_cpu);
	CPU_SET(cpu, &this_cpu);
	if (sched_setaffinity(getpid(), sizeof(cpu_set_t), &this_cpu) != 0)
		err(1, "Could not move to cpu %i", cpu);
	if (sched_setscheduler(getpid(), SCHED_FIFO, &sparam) != 0)
		err(1, "Could not set FIFO scheduler");

	/* Note that we're ready. */
	write(writefd, "", 1);

	/* Wait for go signal. */
	FD_ZERO(&readfds);
	FD_SET(pollfd, &readfds);

	/* We can timeout. */
	if (select(pollfd + 1, &readfds, NULL, NULL, &timeout) != 1)
		exit(1);

	gettimeofday(&start_time, NULL);
	previous_time = start_time;
	do {
		gettimeofday(&now, NULL); 
		/* call conv_timeval func; apply to now and previous time; calc diff */
			
		time_diff(&previous_time, &now, &diff);

		if (timeval_to_usecs(diff) > max_diff)
			max_diff = timeval_to_usecs(diff);

		if (timeval_to_usecs(diff) < least)   /* This should always return 0 */
			least = timeval_to_usecs(diff);
					
		/* Work out time to elapse since the starting time */
		time_diff(&start_time, &now, &elapsed_time);
			
		/* reset previous_time to now */
		previous_time = now; 

		no_of_diffs++;
	} while (elapsed_time.tv_sec < secs);

	sprintf(buf, "CPU %u: %llu diffs, min/avg/max = %llu/%llu/%llu\n",
		cpu, no_of_diffs,
		least,
		timeval_to_usecs(elapsed_time) / no_of_diffs,
		max_diff);

	write(STDOUT_FILENO, buf, strlen(buf));
	exit(0);
}

int main(int argc, char *argv[])
{
	int i, secs, status, tochildren[2], fromchild[2], arg;
	const char *module;

	if (argc < 3) {
		printf("Usage: %s [--modprobe=<module>] <seconds> <cpunum>...\n", argv[0]);
		exit(1);
	}

	arg = 1;
	if (strncmp(argv[arg], "--modprobe=", strlen("--modprobe=")) == 0) {
		module = argv[arg] + 11;
		arg++;
	} else
		module = NULL;

	if (pipe(tochildren) != 0 || pipe(fromchild) != 0)
		err(1, "Creating pipes");

	secs = atoi(argv[arg++]);

	switch (fork()) {
	case -1:
		err(1, "fork failed");
	case 0:
		do_modprobe(atoi(argv[arg]), tochildren[0], secs, module);
	}

	for (i = arg+1; i < argc; i++) {
		char c;
		switch (fork()) {
		case -1:
			err(1, "fork failed");
		case 0:
			measure_latency(atoi(argv[i]), secs, 
					fromchild[1], tochildren[0]);
		}
		if (read(fromchild[0], &c, 1) != 1)
			err(1, "Read from child failed");
	}

	/* Tell them to go. */
	write(tochildren[1], "", 1);

	/* Wait for the children. */
	status = 0;
	for (i = arg; i < argc; i++) {
		if (status == 0) {
			wait(&status);
			if (!WIFEXITED(status) || WEXITSTATUS(status) != 0)
				status = 1;
		} else
			wait(NULL);
	}

	return status;
}


	
