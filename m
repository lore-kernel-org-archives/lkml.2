Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab0D0Sxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:53:46 -0400
Received: from relay2.sgi.com ([192.48.179.30]:45545 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752912Ab0D0Sxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:53:45 -0400
Date: Tue, 27 Apr 2010 13:53:43 -0500
From: Robin Holt <holt@sgi.com>
To: Stefani Seibold <stefani@seibold.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Weirdness in /proc/<pid>/maps and /proc/<pid>/stat.
Message-ID: <20100427185343.GR4920@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With commit d899bf7b, the behavior of field 28 of /proc/<pid>/stat
was changed as was /proc/<pid>/maps.  I don't know if that change was
correct, but its resulting behavior is much more difficult to explain.
I was wondering if we could determine what the "correct" behavior is
before I spend much more time trying to give it the wrong behavior.

My test program is attached below.  Essentially:
fork() -> pthread_create() -> fork()

x86_64 2.6.32 stable kernel:
Step			stat-28		maps-threadstack
p (parent)		0x7fff5607ddc0	N/A
c (child)		0x7fff55c7dc50	N/A
ppthread		0x7f2cf5c9bff0	0x7f2cf5c9d000:007feff0
ppthread+fork		0x7f2cf589be30	0x7f2cf5c9d000:003fee30
cpthread		0x7f2cf589be30  0x7f2cf5c9d000:007feff0
cpthread+fork		0x7f2cf589be30	0x7f2cf5c9d000:003fee30
Note: For all of the above, the /proc/<pids>/task/*/maps files had the
stack line like:
7fff55c7d000-7fff56081000 rw-p 00000000 00:00 0                         [stack]

The problems I see are:
1)  In the fork() case, we are using the current userland stack
    pointer for task->stack_start.  This appears wrong as the
    function which called fork() may be returned to and may
    further return to higher level callers, finding sp now
    beyond the value reported in /proc/self/stat.  Additionally,
    the value reported for the child of the fork has no relationship
    to the stack size rlimit any longer.

2)  In the pthread + fork case, in addition to the problem
    above, the size information in /proc/self/maps
    is incorrect as it does not take into consideration
    the same return paths.

The problem I am running into is coming up with any way to
make the task->stack_start value usable.

Thanks,
Robin Holt

------------------------------- Example --------------------------------
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <asm-generic/unistd.h>

#include <sys/types.h>

pid_t
my_fork(void)
{
	char test_array[2097152];
	pid_t child;

	printf("pid %d my_fork array at %p\n", getpid(), test_array);
	child = fork();
	return child;
}

void
*as_pthread(void *ignore)
{
	char test_array[2097152];

	printf("pid %d pthread array at %p\n", getpid(), test_array);
	my_fork();
	sleep(600);

	return NULL;
}

int
main (int argc, char **argv)
{
	char test_array[2097152];
	pid_t child;
	pthread_t pt;

	printf("pid %d is parent 0x%p\n", getpid(), test_array);

	child = my_fork();
	if (child)
		printf("child of main is %d\n", child);
	else
		sleep(1);
	pthread_create(&pt, NULL, as_pthread, NULL);
	sleep(600);
	return 0;
}
