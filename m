Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab2IQNvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:51:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:23963 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab2IQNvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,435,1344236400"; 
   d="scan'208";a="145899755"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org
Cc: Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH V2 0/3] x86,idle: Enhance cpuidle prediction to handle its failure 
Date: Mon, 17 Sep 2012 21:53:26 -0400
Message-Id: <1347933209-25939-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The prediction for future is difficult and when the cpuidle governor prediction 
fails and govenor possibly choose the shallower C-state than it should. How to 
quickly notice and find the failure becomes important for power saving.    

cpuidle menu governor has a method to predict the repeat pattern if there are 8
C-states residency which are continuous and the same or very close, so it will
predict the next C-states residency will keep same residency time.

This patchset adds a timer when menu governor choose a non-deepest C-state in
order to wake up quickly from shallow C-state to avoid staying too long at 
shallow C-state for prediction failure. The timer is set to a time out value 
that is greater than predicted time and if the timer with the value is triggered 
, we can confidently conclude prediction is failure. When prediction
succeeds, CPU is waken up from C-states in predicted time and the timer is not 
triggered and will be cancelled right after CPU waken up. When prediction fails,
the timer is triggered to wake up CPU from shallow C-states, so menu governor 
will quickly notice that prediction fails and then re-evaluates deeper C-states
 possibility. This patchset can improves cpuidle prediction process for both 
repeat mode and general mode.

There are 2 cases will clear show this patchset benefit.

One case is turbostat utility (tools/power/x86/turbostat) at kernel 3.3 or early
. turbostat utility will read 10 registers one by one at Sandybridge, so it will
generate 10 IPIs to wake up idle CPUs. So cpuidle menu governor will predict it
 is repeat mode and there is another IPI wake up idle CPU soon, so it keeps idle
 CPU stay at C1 state even though CPU is totally idle. However, in the turbostat
, following 10 registers reading is sleep 5 seconds by default, so the idle CPU
 will keep at C1 for a long time though it is idle until break event occurs.
In a idle Sandybridge system, run "./turbostat -v", we will notice that deep 
C-state dangles between "70% ~ 99%". After patched the kernel, we will notice
deep C-state stays at >99.98%.

Below is another case which will clearly show the patch much benefit:

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>
#include <time.h>
#include <pthread.h>

volatile int * shutdown;
volatile long * count;
int delay = 20;
int loop = 8;

void usage(void)
{
	fprintf(stderr,
		"Usage: idle_predict [options]\n"
		"  --help	-h  Print this help\n"
		"  --thread	-n  Thread number\n"
		"  --loop     	-l  Loop times in shallow Cstate\n"
		"  --delay	-t  Sleep time (uS)in shallow Cstate\n");
}

void *simple_loop() {
	int idle_num = 1;
	while (!(*shutdown)) {
		*count = *count + 1;
	
		if (idle_num % loop)
			usleep(delay);
		else {
			/* sleep 1 second */
			usleep(1000000);
			idle_num = 0;
		}
		idle_num++;
	}

}

static void sighand(int sig)
{
	*shutdown = 1;
}

int main(int argc, char *argv[])
{
	sigset_t sigset;
	int signum = SIGALRM;
	int i, c, er = 0, thread_num = 8;
	pthread_t pt[1024];

	static char optstr[] = "n:l:t:h:";

	while ((c = getopt(argc, argv, optstr)) != EOF)
		switch (c) {
			case 'n':
				thread_num = atoi(optarg);
				break;
			case 'l':
				loop = atoi(optarg);
				break;
			case 't':
				delay = atoi(optarg);
				break;
			case 'h':
			default:
				usage();
				exit(1);
		}

	printf("thread=%d,loop=%d,delay=%d\n",thread_num,loop,delay);
	count = malloc(sizeof(long));
	shutdown = malloc(sizeof(int));
	*count = 0;
	*shutdown = 0;

	sigemptyset(&sigset);
	sigaddset(&sigset, signum);
	sigprocmask (SIG_BLOCK, &sigset, NULL);
	signal(SIGINT, sighand);
	signal(SIGTERM, sighand);

	for(i = 0; i < thread_num ; i++)
		pthread_create(&pt[i], NULL, simple_loop, NULL);

	for (i = 0; i < thread_num; i++)
		pthread_join(pt[i], NULL);

	exit(0);
}

Get powertop v2 from git://github.com/fenrus75/powertop, build powertop.
After build the above test application, then run it.
Test plaform can be Intel Sandybridge or other recent platforms.
#./idle_predict -l 10 &
#./powertop

We will find that deep C-state will dangle between 40%~100% and much time spent
on C1 state. It is because menu governor wrongly predict that repeat mode
is kept, so it will choose the C1 shallow C-state even though it has chance to
sleep 1 second in deep C-state.
 
While after patched the kernel, we find that deep C-state will keep >99.6%. 

I also run plenty of testing and tuning with other benchmarks, the patcheset
also show some power saving and there is no negative result found at least.

The first version of patchset sent at May 11th 2012, 
http://lwn.net/Articles/496919/ "x86,idle: Enhance cpuidle prediction to handle
 its failure". 
Recently, I notice that Rik has raised a topic at KS/Plumbers,
http://lkml.indiana.edu/hypermail/linux/kernel/1208.3/00325.html
so I have a discussed with Rik about my patchset, it is a interesting and 
valuable topic, so I decide resend it again.  
Compare with patchset V1, V2 only change the description without code update. 

Thanks for help from Arjan, Len Brown and Rik!

Thanks
-Youquan
