Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2JRGnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:43:03 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52157 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab2JRGnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:43:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org, Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 0/5] x86,idle: Enhance menu governor C-state prediction
Date: Thu, 18 Oct 2012 08:46:44 +0200
Message-ID: <1442687.rHjvTAEjKG@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1350435880-19143-1-git-send-email-youquan.song@intel.com>
References: <1350435880-19143-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 16 of October 2012 21:04:35 Youquan Song wrote:
> 
> The prediction for future is difficult and when the cpuidle governor prediction 
> fails and govenor possibly choose the shallower C-state than it should. How to 
> quickly notice and find the failure becomes important for power saving.    
> 
> cpuidle menu governor has a method to predict the repeat pattern if there are 8
> C-states residency which are continuous and the same or very close, so it will
> predict the next C-states residency will keep same residency time.
> 
> This patchset adds a timer when menu governor choose a non-deepest C-state in
> order to wake up quickly from shallow C-state to avoid staying too long at 
> shallow C-state for prediction failure. The timer is set to a time out value 
> that is greater than predicted time and if the timer with the value is triggered 
> , we can confidently conclude prediction is failure. When prediction
> succeeds, CPU is waken up from C-states in predicted time and the timer is not 
> triggered and will be cancelled right after CPU waken up. When prediction fails,
> the timer is triggered to wake up CPU from shallow C-states, so menu governor 
> will quickly notice that prediction fails and then re-evaluates deeper C-states
>  possibility. This patchset can improves cpuidle prediction process for both 
> repeat mode and general mode.
> 
> The patchset integrates one patch from Rik van Riel <riel@redhat.com>, which try
> to find a typical interval along with cut the upside outliers depends on
> historical sleep intervals. The patch tends to choose a shallow C-state to
> achieve better performance and ehancement of prediction failure will advise it
> if the deepest C-state should be chosen.  
> 
> Testing result:
> 
> The whole patchset achieve good result after bunch of testing/tuning. 
> Testing on two sockets Sandybridge server, SPECPower2008 get 2%~5% increase
> ssj_ops/watt; Running benchmark in phoronix-test-suite: compress-7zip, 
> build-linux-kernel, apache, fio etc, it also proves to increase the 
> performance/power; What's more, it not only boosts the performance but also
> saves power.  
>  
> There are also 2 cases will clear show this patchset benefit.
> 
> One case is turbostat utility (tools/power/x86/turbostat) at kernel 3.3 or early
> . turbostat utility will read 10 registers one by one at Sandybridge, so it will
> generate 10 IPIs to wake up idle CPUs. So cpuidle menu governor will predict it
>  is repeat mode and there is another IPI wake up idle CPU soon, so it keeps idle
>  CPU stay at C1 state even though CPU is totally idle. However, in the turbostat
> , following 10 registers reading is sleep 5 seconds by default, so the idle CPU
>  will keep at C1 for a long time though it is idle until break event occurs.
> In a idle Sandybridge system, run "./turbostat -v", we will notice that deep 
> C-state dangles between "70% ~ 99%". After patched the kernel, we will notice
> deep C-state stays at >99.98%.
> 
> Below is another case which will clearly show the patch much benefit:
> 
> #include <stdlib.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <signal.h>
> #include <sys/time.h>
> #include <time.h>
> #include <pthread.h>
> 
> volatile int * shutdown;
> volatile long * count;
> int delay = 20;
> int loop = 8;
> 
> void usage(void)
> {
> 	fprintf(stderr,
> 		"Usage: idle_predict [options]\n"
> 		"  --help	-h  Print this help\n"
> 		"  --thread	-n  Thread number\n"
> 		"  --loop     	-l  Loop times in shallow Cstate\n"
> 		"  --delay	-t  Sleep time (uS)in shallow Cstate\n");
> }
> 
> void *simple_loop() {
> 	int idle_num = 1;
> 	while (!(*shutdown)) {
> 		*count = *count + 1;
> 	
> 		if (idle_num % loop)
> 			usleep(delay);
> 		else {
> 			/* sleep 1 second */
> 			usleep(1000000);
> 			idle_num = 0;
> 		}
> 		idle_num++;
> 	}
> 
> }
> 
> static void sighand(int sig)
> {
> 	*shutdown = 1;
> }
> 
> int main(int argc, char *argv[])
> {
> 	sigset_t sigset;
> 	int signum = SIGALRM;
> 	int i, c, er = 0, thread_num = 8;
> 	pthread_t pt[1024];
> 
> 	static char optstr[] = "n:l:t:h:";
> 
> 	while ((c = getopt(argc, argv, optstr)) != EOF)
> 		switch (c) {
> 			case 'n':
> 				thread_num = atoi(optarg);
> 				break;
> 			case 'l':
> 				loop = atoi(optarg);
> 				break;
> 			case 't':
> 				delay = atoi(optarg);
> 				break;
> 			case 'h':
> 			default:
> 				usage();
> 				exit(1);
> 		}
> 
> 	printf("thread=%d,loop=%d,delay=%d\n",thread_num,loop,delay);
> 	count = malloc(sizeof(long));
> 	shutdown = malloc(sizeof(int));
> 	*count = 0;
> 	*shutdown = 0;
> 
> 	sigemptyset(&sigset);
> 	sigaddset(&sigset, signum);
> 	sigprocmask (SIG_BLOCK, &sigset, NULL);
> 	signal(SIGINT, sighand);
> 	signal(SIGTERM, sighand);
> 
> 	for(i = 0; i < thread_num ; i++)
> 		pthread_create(&pt[i], NULL, simple_loop, NULL);
> 
> 	for (i = 0; i < thread_num; i++)
> 		pthread_join(pt[i], NULL);
> 
> 	exit(0);
> }
> 
> Get powertop v2 from git://github.com/fenrus75/powertop, build powertop.
> After build the above test application, then run it.
> Test plaform can be Intel Sandybridge or other recent platforms.
> #./idle_predict -l 10 &
> #./powertop
> 
> We will find that deep C-state will dangle between 40%~100% and much time spent
> on C1 state. It is because menu governor wrongly predict that repeat mode
> is kept, so it will choose the C1 shallow C-state even though it has chance to
> sleep 1 second in deep C-state.
>  
> While after patched the kernel, we find that deep C-state will keep >99.6%. 
> 
> Thanks for help from Arjan, Len Brown and Rik!

The whole series looks good to me, but I think it would be better to fold
patch [3/5] into [2/5] and use #defined symbols or enums instead of "magic"
numbers 1 and 2 as values for hrtimer_started.

Moreover, patch [4/5] seems to be a bug fix that should go into -stable
regardless of the other patches in the series.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
