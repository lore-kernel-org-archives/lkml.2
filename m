Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1IMUHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:07:05 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:53464 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932421Ab1IMUHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:07:04 -0400
Date: Tue, 13 Sep 2011 15:06:58 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched_rt: Migrate equal priority tasks to available CPUs
Message-ID: <20110913200658.GC2362@BohrerMBP.rgmadvisors.com>
References: <1315837684-18733-1-git-send-email-sbohrer@rgmadvisors.com>
 <1315919147.26295.1.camel@gandalf.stny.rr.com>
 <20110913162713.GA2362@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913162713.GA2362@BohrerMBP.rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 11:27:14AM -0500, Shawn Bohrer wrote:
> On Tue, Sep 13, 2011 at 09:05:46AM -0400, Steven Rostedt wrote:
> > Looks good, but do you have a test case that shows the issue? I like to
> > have something that proves even the obvious before making changes to the
> > schedule.
>
> I played around a little this morning trying to make a simple test case
> that reproduces the issue, but so far I've been unsuccessful.  My simple
> test cases trying to simulate the workload above actually do get evenly
> distributed across all CPUs.  If I get some more time I'll see if I can
> get an example to trigger the issue, but feel free to see if you can
> reproduce it as well.

Alright, I'm still having trouble making a case that actually resulted
in some CPUs left completely idle while others are loaded, but the
rough test case below does still show the benefit of the patch.

$ gcc -o sched_rt_migration sched_rt_migration.c
$ chrt -f 1 ./sched_rt_migration &

# Run 5 times with 3.0
$ sudo trace-cmd record -e sched:sched_switch -e sched:sched_wakeup sleep 1
$ trace-cmd report -r -w -F 'sched: comm == "sched_rt_migrat" || next_comm == "sched_rt_migrat"' | tail -4

Wakeup Latency
Average: 2.551 usecs Max: 188.409 usecs
Average: 2.372 usecs Max: 187.185 usecs
Average: 2.559 usecs Max: 182.151 usecs
Average: 2.628 usecs Max: 180.113 usecs
Average: 2.559 usecs Max: 178.105 usecs

# Run 5 with 3.0 + patch

Wakeup Latency
Average: 0.730 usecs Max: 8.037 usecs
Average: 0.721 usecs Max: 16.613 usecs
Average: 0.718 usecs Max: 16.613 usecs
Average: 0.693 usecs Max: 58.095 usecs
Average: 0.703 usecs Max: 11.078 usecs

So you can see that the patch does decrease both the Average and the
max wakeup latency.



#include <sys/time.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <time.h>
#include <sys/sysinfo.h>
#include <stdint.h>
#include <sys/timerfd.h>


#define WORKLOAD_HIGH 100000
#define WORKLOAD_LOW  100

void worker()
{
	int timerfd, ret;
	struct itimerspec new_value, old_value;

	timerfd = timerfd_create(CLOCK_MONOTONIC, 0);
	if (timerfd == -1) {
		perror("timerfd_create");
		return;
	}

	new_value.it_value.tv_sec = 0;
	new_value.it_value.tv_nsec = 250000;
	new_value.it_interval.tv_sec = 0;
	new_value.it_interval.tv_nsec = 250000;

	ret = timerfd_settime(timerfd, 0, &new_value, &old_value);
	if (ret == -1) {
		perror("timerfd_settime");
		return;
	}

	while (1) {
		int i, j, loops, event_count;
		uint64_t buf;
		for (i = 0; i < 10; ++i) {
			read(timerfd, &buf, sizeof(buf));

			if (i == 0)
				loops = WORKLOAD_HIGH;
			else
				loops = WORKLOAD_LOW;
			for (j = 0; j < loops; ++j)
				/* burn cpu */;
		}
	}
}


int main ()
{
	int i, nprocs;
	pid_t pid;


	nprocs = get_nprocs();
	for (i = 0; i < 2 * nprocs - 1; ++i) {
		pid = fork();
		if (pid == 0)
			worker();
		else if (pid == -1)
			perror("fork");
	}

	worker();
}


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

