Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0EDCG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 22:06:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44245 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab0EDCGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 22:06:24 -0400
Message-ID: <4BDF8118.3090200@linux.vnet.ibm.com>
Date: Mon, 03 May 2010 19:06:16 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Carl Love <carll@us.ibm.com>, Maynard Johnson <mpjohn@us.ibm.com>
Subject: [BUG] perf_events: PERF_FORMAT_GROUP not working correctly when monitoring
 another task
Content-Type: multipart/mixed;
 boundary="------------050706060409000805040200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050706060409000805040200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

In the last couple of days, I've run across what appears to be a kernel bug in 2.6.33.3 (haven't tested later kernels yet) having to do with using the PERF_FORMAT_GROUP feature in combination with enable_on_exec and reading counts from a remote task.

What happens is that when we go to read the entire group up, only the first counter in can be accessed; the read() call returns too few bytes.  This problem doesn't occur if measuring the from the same task.

I have attached a "cut down", though it's not terribly small.  It is a cut down from the "task" example program in libpfm4/perf_examples.  In addition to trimming the program down a lot, I've removed the dependency on libpfm4 and made modifications so that it will compile in the tools/perf subdirectory.  If you copy the attachment into your tools/perf subdir, you should be able to compile it with just:

gcc -o show_fg_bug show_fg_bug.c

Then invoke it by passing it an executable that will give it something to chew on a little, e.g.:

./show_fg_bug md5sum `which gdb`

The test cases creates two counters and places them in the same group, and sets the PERF_FORMAT_GROUP option on the first counter.  It fork/execs the child and when the child is done executing, it reads back the counter values.

When I run it, I see this output:

% ./show_fg_bug md5sum `which gdb`
825b15d7279ef21d6c9d018d775758ae  /usr/bin/gdb
Error! tried to read 40 bytes, but got 32
            58684138 PERF_COUNT_HW_CPU_CYCLES (35469840 : 35469840)
                   0 PERF_COUNT_HW_INSTRUCTIONS (35469840 : 35469840)

Oddly enough, if you look at the "nr" (number of counters) value that gets read up as part of the group, it is two, but it can only read the first of the two counters.  Another data point is that it doesn't matter how many counters you add to the group, only the first can be read up.

Please let me know if you have any questions about this.

Thanks for your consideration,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR 
cjashfor@us.ibm.com

--------------050706060409000805040200
Content-Type: text/plain;
 name="show_fg_bug.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="show_fg_bug.c"

/*
 * task_inherit.c - example of a task counting event in a tree of child processes
 *
 * Copyright (c) 2009 Google, Inc
 * Contributed by Stephane Eranian <eranian@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * This test case is a cut down of the program perf_examples/task from libpfm4.
 */
#include <sys/types.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdarg.h>

#include <sys/wait.h>
#include "perf.h"

typedef struct {
        struct perf_event_attr hw;
        uint64_t value, prev_value;
        uint64_t enabled, running;
        char *name;
        int fd;
} perf_event_desc_t;

int
child(char **arg)
{
	/*
	 * execute the requested command
	 */
	execvp(arg[0], arg);
	fprintf(stderr, "cannot exec: %s\n", arg[0]);
	exit(1);
	/* not reached */
}

static inline uint64_t
perf_scale(uint64_t *values)
{
	uint64_t res = 0;

	if (values[2])
		res = (uint64_t)((double)values[0] * values[1]/values[2]);
	return res;
}


static void
read_group(perf_event_desc_t *fds, int num)
{
	uint64_t *values;
	size_t sz;
	int i, ret;

	/*
	 * 	{ u64		nr;
	 * 	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
	 * 	  { u64		time_running; } && PERF_FORMAT_RUNNING
	 * 	  { u64		value;
	 * 	    { u64	id;           } && PERF_FORMAT_ID
	 * 	  }		cntr[nr];
	 * 	} && PERF_FORMAT_GROUP
	 *
	 * we do not use FORMAT_ID in this program
	 */
	sz = sizeof(uint64_t) * (3 + num);
	values = malloc(sz);
	if (!values)
		fprintf(stderr, "cannot allocate memory for values\n");

	ret = read(fds[0].fd, values, sz);
	if (ret != sz) { /* unsigned */
		if (ret == -1)
			fprintf(stderr, "cannot read values\n");
		else	/* likely pinned and could not be loaded */
			fprintf(stderr, "Error! tried to read %d bytes, but got %d\n", (int)sz, ret);
	}

	/*
	 * propagate to save area
	 */
	for(i = 0; i < num; i++) {
		values[0] = values[3+i];
		/*
		 * scaling because we may be sharing the PMU and
		 * thus may be multiplexed
		 */
		fds[i].prev_value = fds[i].value;
		fds[i].value = perf_scale(values);
		fds[i].enabled = values[1];
		fds[i].running = values[2];
	}
	free(values);
}


static void
print_counts(perf_event_desc_t *fds, int num)
{
	int i;


	read_group(fds, num);
	for(i = 0; i < num; i++) {
		double ratio;
		uint64_t val;

		val = fds[i].value - fds[i].prev_value;

		ratio = 0.0;
		if (fds[i].enabled)
			ratio = 1.0 * fds[i].running / fds[i].enabled;

		if (ratio == 1.0)
			printf("%'20"PRIu64" %s (%'"PRIu64" : %'"PRIu64")\n", val, fds[i].name, fds[i].enabled, fds[i].running);
		else
			if (ratio == 0.0)
				printf("%'20"PRIu64" %s (did not run: incompatible events, too many events in a group, competing session)\n", val, fds[i].name);
			else
				printf("%'20"PRIu64" %s (scaled from %.2f%% of time)\n", val, fds[i].name, ratio*100.0);

	}
}

int
parent(char **arg)
{
	perf_event_desc_t *fds;
	int status, ret, i, num;
	int ready[2], go[2];
	char buf;
	pid_t pid;

	num = 2;
	fds = calloc(num, sizeof(perf_event_desc_t));

	fds[0].name = "PERF_COUNT_HW_CPU_CYCLES";
	fds[0].hw.type = PERF_TYPE_HARDWARE;
	fds[0].hw.config = PERF_COUNT_HW_CPU_CYCLES;
	fds[1].name = "PERF_COUNT_HW_INSTRUCTIONS";
	fds[1].hw.type = PERF_TYPE_HARDWARE;
	fds[1].hw.type = PERF_COUNT_HW_INSTRUCTIONS;

	ret = pipe(ready);
	if (ret)
		fprintf(stderr, "cannot create pipe ready");

	ret = pipe(go);
	if (ret)
		fprintf(stderr, "cannot create pipe go");


	/*
	 * Create the child task
	 */
	if ((pid = fork()) == -1)
		fprintf(stderr, "Cannot fork process");

	/*
	 * and launch the child code
	 *
	 * The pipe is used to avoid a race condition
	 * between for() and exec(). We need the pid
	 * of the new tak but we want to start measuring
	 * at the first user level instruction. Thus we
	 * need to prevent exec until we have attached
	 * the events.
	 */
	if (pid == 0) {
		close(ready[0]);
		close(go[1]);

		/*
		 * let the parent know we exist
		 */
		close(ready[1]);
		if (read(go[0], &buf, 1) == -1)
			fprintf(stderr, "unable to read go_pipe");


		exit(child(arg));
	}

	close(ready[1]);
	close(go[0]);

	if (read(ready[0], &buf, 1) == -1)
		fprintf(stderr, "unable to read child_ready_pipe");

	close(ready[0]);

	fds[0].fd = -1;
	for(i = 0; i < num; i++) {
		/*
		 * create leader disabled with enable_on-exec
		 */
		fds[i].hw.disabled = (i == 0);
		fds[i].hw.enable_on_exec = (i == 0);
		fds[i].hw.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
			 PERF_FORMAT_TOTAL_TIME_RUNNING | PERF_FORMAT_GROUP;

		fds[i].fd = sys_perf_event_open(&fds[i].hw, pid, -1, fds[0].fd, 0);
		if (fds[i].fd == -1) {
			warn("cannot attach event %d %s", i, fds[i].name);
			goto error;
		}
	}	

	close(go[1]);

	waitpid(pid, &status, 0);

	print_counts(fds, num);

	for(i = 0; i < num; i++)
		close(fds[i].fd);

	free(fds);
	return 0;
error:
	free(fds);
	kill(SIGKILL, pid);
	return -1;
}


int
main(int argc, char **argv)
{
	int c;

	if (argc < 2) {
		fprintf(stderr, "you must specify a command to execute\n");
	} 

	return parent(&argv[1]);
}

--------------050706060409000805040200--

