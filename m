Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab2IKQNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:13:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:59992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab2IKQNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:13:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,406,1344236400"; 
   d="scan'208";a="191442267"
Date: Wed, 12 Sep 2012 00:15:47 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        ShuoX Liu <shuox.liu@intel.com>, youquan.song@intel.com
Subject: Re: KS/Plumbers: c-state governor BOF
Message-ID: <20120912041547.GB23544@linux-youquan.bj.intel.com>
References: <5037B36A.8000209@redhat.com> <20120912024342.GA23544@linux-youquan.bj.intel.com> <504F5A18.8080701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504F5A18.8080701@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your patches could make a lot of sense when integrated with my
> patches:
>
> http://people.redhat.com/riel/cstate/
> However, we should probably get the tracepoint upstream first,
> so we can know for sure :)

I can not access the patches at this directory. Can you send it to me?
I will look at your patches and then integrated with my patches to look
what will happen tomorrow.

Do you have test case share? or ideas how to show the benefit.

I have done many test for my pathes. It show some benefit big or small
in various cases, but there is no negative effect showed at least. 
 
I have two onviced test cases to show the great benefit
1.  turbostat v1 (before 3.5)
2. I write the simple test application which also show greate benefit.
running it by #./idle_predict -l 8


I write a simple application using usleep which it is clear to the
repeat mode prediction failure will greatly effect the application with
such repeat pattern.

-----------------------
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
		"  --delay	-t  Sleep time (uS)in shallow
Cstate\n");
}

void *simple_loop() {
	int idle_num = 1;
	while (*shutdown) {
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
	*shutdown = 0;
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
	*shutdown = 1;

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

