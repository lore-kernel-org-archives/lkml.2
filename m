Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0DNAKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:10:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14324 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0DNAKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:10:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=t52AiV4WpyFHm4VjejFHwX/7DHTnQEZtbPlaVv4QP7ehf0h9KtFiWYwrmQ1NvbXMv
	HN1TN26YPEac0Y9VHgK7Q==
Subject: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org
From: Salman <sqazi@google.com>
Cc: csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Date: Tue, 13 Apr 2010 17:08:18 -0700
Message-ID: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we discussed earlier this year, Google has an implementation that it
would like to share.  I have finally gotten around to porting it to
v2.6.33 and cleaning up the interfaces.  It is provided in the following
messages for your review.  I realize that when we first discussed this
idea, a lot of ideas were presented for enhancing it.  Thanks alot for
your suggestions.  I haven't gotten around to implementing any of them.

The ones that I still find appealing are:

0. Providing approximate synchronization between cores, regardless
of their independant settings in order to improve power savings.   We have
to balance this with eager injection (i.e. avoiding injection when
an interactive task needs to run).

A stricter synchronization between cores is needed to make idle cycle injector
work on hyperthreaded systems.  This is a some what separate issue, as
there should only be one idle cycle injector minimum idle setting per
physical core.

1. It's not possible to directly use hard limits to implement the
type of assurance that we need.  However, doing something similar to CPU hard
limits, to implement a global power cap. It is not strictly necessary for
Google's purposes.  The outcome of the trade offs is not immediately clear to
me.  I need to do some prototyping.

Now, back to the current set of patches.

Testing:

The patches were tested using the following program.  The output was:

# /export/hda3/kidled_test /dev/cgroup/
Latency Test:

Count without injection: 9441
Count with 80% injection (batch) 1805 (idle 8099305661)
Count with 80% injection (interactive): 9439 (idle 8054796135)
Lost wake ups (batch): 7636
Lost wake ups (interactive): 2
Priority Test:

Low priority got:  26197453ns
High priority got: 1971369919ns
Idle Time:         8021629325ns

Test program follows:


/*
 *  A set of tests for the idle cycle injector.
 */

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>
#include <assert.h>
#include <time.h>
#include <sched.h>

char *cpu_cgroup_dir;

#define NUM_SECONDS	10
#define NSEC_PER_SEC	1000000000L
#define USEC_PER_MSEC	1000
#define USEC_PER_SEC	1000000L

int start_while_one(void)
{
	int pid;
	pid = fork();
	if (pid > 0)
		return pid;

	if (pid < 0) {
		printf("Antagonist fork failed\n");
		exit(EXIT_FAILURE);
	}

	while(1);
}

#define write_file(filename, fmt, ...)		\
	do {					\
		FILE *f;			\
		f = fopen(filename, "w");	\
		fprintf(f, fmt, __VA_ARGS__);	\
		fclose(f);			\
	} while(0)

#define read_file(filename, fmt, ...)		\
	do {					\
		FILE *f;			\
		f = fopen(filename, "r");	\
		fscanf(f, fmt, __VA_ARGS__);	\
		fclose(f);			\
	} while(0)


int do_latency_protagonist(int interactive, long *total_idle)
{
	char my_cgroup[200];
	char file[200];
	int  count;
	int i;
	struct timespec ts;
	long base;
	long now;
	long idle, busy, lazy, eager;

	/* Put ourselves in an interactive cgroup */
	sprintf(my_cgroup, "%s/protogonist", cpu_cgroup_dir);
	rmdir(my_cgroup);
	mkdir(my_cgroup, 0755);
	sprintf(file, "%s/cpu.power_interactive", my_cgroup);
	write_file(file, "%d\n", interactive);
	sprintf(file, "%s/cpuset.mems", my_cgroup);
	write_file(file, "%d\n", 0);
	sprintf(file, "%s/cpuset.cpus", my_cgroup);
	write_file(file, "%d\n", 0);
	sprintf(file, "%s/tasks", my_cgroup);
	write_file(file, "%d\n", getpid());

	count = 0;
	if (total_idle) {
		read_file("/proc/sys/kernel/kidled/cpu/0/stats",
			"%ld %ld %ld %ld\n",
			&idle, &busy, &lazy, &eager);
		*total_idle = idle;
	}
	clock_gettime(CLOCK_MONOTONIC, &ts);
	base = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
	while (1) {
		usleep(USEC_PER_MSEC);
		count++;
		clock_gettime(CLOCK_MONOTONIC, &ts);
		now = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
		if (now - base > NUM_SECONDS*NSEC_PER_SEC)
			break;
	}

	if (total_idle) {
		read_file("/proc/sys/kernel/kidled/cpu/0/stats",
			"%ld %ld %ld %ld\n",
			&idle, &busy, &lazy, &eager);
			*total_idle = idle - *total_idle;
	}

	return count;
}

/*
 * Test for the eager injection case of power capping.
 *
 * Protagonist: frequently waking interactive thread that does little work.
 * Antagonist:  constantly running batch thread.
 *
 */
void latency_test(void)
{
	int pid;
	int count_base;
	int count_injected;
	int count_injected_batch;
	long int_idle;
	long batch_idle;
	printf("Latency Test:\n\n");
	pid = start_while_one();
	write_file("/proc/sys/kernel/kidled/cpu/0/min_idle_percent",
                   "%d\n", 0);
	write_file("/proc/sys/kernel/kidled/cpu/0/interval",
		   "%d\n", 100);
	count_base = do_latency_protagonist(0, NULL);
	write_file("/proc/sys/kernel/kidled/cpu/0/min_idle_percent",
			"%d\n", 80);
	count_injected = do_latency_protagonist(1, &int_idle);
	count_injected_batch = do_latency_protagonist(0, &batch_idle);
	kill(pid, SIGKILL);
	printf("Count without injection: %d\n", count_base);
	printf("Count with 80%% injection (batch) %d (idle %ld)\n",
		 count_injected_batch, batch_idle);
	printf("Count with 80%% injection (interactive): %d (idle %ld)\n",
		count_injected, int_idle);
	printf("Lost wake ups (batch): %d\n",
		count_base - count_injected_batch);
	printf("Lost wake ups (interactive): %d\n",
		count_base - count_injected);

}

void make_prio_container(char *container_name, int priority, int pid)
{
	char my_cgroup[200];
	char file[200];
	sprintf(my_cgroup, "%s/%s", cpu_cgroup_dir, container_name);
	rmdir(my_cgroup);
	mkdir(my_cgroup, 0755);
	sprintf(file, "%s/cpu.power_capping_priority", my_cgroup);
	write_file(file, "%d\n", priority);
	sprintf(file, "%s/cpu.power_interactive", my_cgroup);
	write_file(file, "%d\n", 1);
	sprintf(file, "%s/cpuset.mems", my_cgroup);
	write_file(file, "%d\n", 0);
	sprintf(file, "%s/cpuset.cpus", my_cgroup);
	write_file(file, "%d\n", 0);
	sprintf(file, "%s/tasks", my_cgroup);
	write_file(file, "%d\n", pid);
}

/* If there are two processes with different power capping priorities, and
 * the enforcement interval is sufficiently small, the task with the
 * smaller priority should approx recieve its fair share minus the idle cycles
 * injected and the task with the larger priority should just recieve
 * its fair share.  Once the amount of idle cycles exceed the lower
 * priority task's fair share, the higher priority task's throughput is
 * impacted.
 */
void priority_test(void)
{
	char file[200];
	int pid1;
	int pid2;
	long low_prio_cpu;
	long high_prio_cpu;
	long low_prio_cpu_base;
	long high_prio_cpu_base;
	long idle, busy, lazy, eager, old_idle;

	printf("Priority Test:\n\n");

	write_file("/proc/sys/kernel/kidled/cpu/0/min_idle_percent",
			"%d\n", 80);
	write_file("/proc/sys/kernel/kidled/cpu/0/interval",
			"%d\n", 30);

	pid1 = start_while_one();
	pid2 = start_while_one();

	make_prio_container("high_prio", 14, pid1);
	make_prio_container("low_prio", 0, pid2);

	sprintf(file, "%s/high_prio/cpuacct.usage", cpu_cgroup_dir);
	read_file(file, "%ld\n", &high_prio_cpu_base);
	sprintf(file, "%s/low_prio/cpuacct.usage", cpu_cgroup_dir);
	read_file(file, "%ld\n", &low_prio_cpu_base);
	read_file("/proc/sys/kernel/kidled/cpu/0/stats",
		  "%ld %ld %ld %ld\n",
		  &old_idle, &busy, &lazy, &eager);

	usleep(NUM_SECONDS*USEC_PER_SEC);

	sprintf(file, "%s/high_prio/cpuacct.usage", cpu_cgroup_dir);
	read_file(file, "%ld\n", &high_prio_cpu);
	sprintf(file, "%s/low_prio/cpuacct.usage", cpu_cgroup_dir);
	read_file(file, "%ld\n", &low_prio_cpu);
	read_file("/proc/sys/kernel/kidled/cpu/0/stats",
		"%ld %ld %ld %ld\n",
		&idle, &busy, &lazy, &eager);
	printf("Low priority got:  %ldns\n", low_prio_cpu - low_prio_cpu_base);
	printf("High priority got: %ldns\n",
		high_prio_cpu - high_prio_cpu_base);
	printf("Idle Time:         %ldns\n", idle - old_idle);
	kill(pid1, SIGKILL);
	kill(pid2, SIGKILL);
}

/* Arguments: directory where cpu cgroup is mounted. */
int main(int argc, char **argv)
{
	unsigned long mask;
	if (argc < 2) {
		printf("Required argument 'cpu cgroup directory' missing\n");
		exit(EXIT_FAILURE);
	}

	/* Pin everything to CPU 0, so that one idle cycle injector applies */
	mask = (1 << 0);
	sched_setaffinity(0, sizeof(mask), &mask);

	cpu_cgroup_dir = argv[1];

	latency_test();
	priority_test();

	return 0;
}

---

Salman Qazi (3):
      [kidled]: introduce kidled.
      [kidled]: Add eager injection.
      [kidled]: Introduce power capping priority and LB awareness.


 Documentation/kidled.txt     |   89 +++++
 arch/x86/Kconfig             |    1 
 arch/x86/include/asm/idle.h  |    1 
 arch/x86/kernel/process_64.c |    2 
 drivers/misc/Gconfig.ici     |    1 
 include/linux/kidled.h       |   83 +++++
 include/linux/sched.h        |    3 
 kernel/Kconfig.ici           |    6 
 kernel/Makefile              |    1 
 kernel/kidled.c              |  693 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c               |  155 +++++++++
 kernel/sched_fair.c          |   77 +++++
 kernel/softirq.c             |   15 +
 kernel/sysctl.c              |   11 +
 14 files changed, 1127 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/kidled.txt
 create mode 100644 drivers/misc/Gconfig.ici
 create mode 100644 include/linux/kidled.h
 create mode 100644 kernel/Kconfig.ici
 create mode 100644 kernel/kidled.c

-- 
Salman Qazi
