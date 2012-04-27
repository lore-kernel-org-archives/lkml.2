Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab2D0DKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:10:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62124 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147Ab2D0DKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:10:22 -0400
Date: Fri, 27 Apr 2012 11:10:13 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Dave Johansen <davejohansen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High CPU usage of scheduler?
Message-ID: <20120427031013.GA9131@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <CAAcYxUdUBgwuxNKpiXp8r9-aw7+pi7U2E35dnsoL2RD9tf47oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAcYxUdUBgwuxNKpiXp8r9-aw7+pi7U2E35dnsoL2RD9tf47oQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 03:08:51PM -0700, Dave Johansen wrote:
> I am looking into moving an application from RHEL 5 to RHEL 6 and I
> noticed an unexpected increase in CPU usage. A little digging has led
> me to believe that the scheduler may be the culprit.
> 
> I created the attached test_select_work.c file to test this out. I
> compiled it with the following command on RHEL 5:
> 
> cc test_select_work.c -O2 -DSLEEP_TYPE=0 -Wall -Wextra -lm -lpthread
> -o test_select_work

Hmm...Do both RHEL 5 and RHEL 6 have high resolution timer enabled?

If not, could you please try to boot the one which enable high resolution
timer with 'highres=off' to see if things change?

Thanks,
Yong

> 
> I then played with the parameters until the execution time per
> iteration was about 1 ms on a Dell Precision m6500.
> 
> I got the following result on RHEL 5:
> 
>     ./test_select_work 1000 10000 300 4
>     time_per_iteration: min: 911.5 us avg: 913.7 us max: 917.1 us stddev: 2.4 us
>     ./test_select_work 1000 10000 300 8
>     time_per_iteration: min: 1802.6 us avg: 1803.9 us max: 1809.1 us
> stddev: 2.1 us
>     ./test_select_work 1000 10000 300 40
>     time_per_iteration: min: 7580.4 us avg: 8567.3 us max: 9022.0 us
> stddev: 299.6 us
> 
> And the following on RHEL 6:
> 
>     ./test_select_work 1000 10000 300 4
>     time_per_iteration: min: 914.6 us avg: 975.7 us max: 1034.5 us
> stddev: 50.0 us
>     ./test_select_work 1000 10000 300 8
>     time_per_iteration: min: 1683.9 us avg: 1771.8 us max: 1810.8 us
> stddev: 43.4 us
>     ./test_select_work 1000 10000 300 40
>     time_per_iteration: min: 7997.1 us avg: 8709.1 us max: 9061.8 us
> stddev: 310.0 us
> 
> On both versions, these results were about what I expected with the
> average amount of time per iteration scaling relatively linearly. I
> then recompiled with -DSLEEP_TYPE=1 and got the following results on
> RHEL 5:
> 
>     ./test_select_work 1000 10000 300 4
>     time_per_iteration: min: 1803.3 us avg: 1902.8 us max: 2001.5 us
> stddev: 113.8 us
>     ./test_select_work 1000 10000 300 8
>     time_per_iteration: min: 1997.1 us avg: 2002.0 us max: 2010.8 us
> stddev: 5.0 us
>     ./test_select_work 1000 10000 300 40
>     time_per_iteration: min: 6958.4 us avg: 8397.9 us max: 9423.7 us
> stddev: 619.7 us
> 
> And the following results on RHEL 6:
> 
>     ./test_select_work 1000 10000 300 4
>     time_per_iteration: min: 2107.1 us avg: 2143.1 us max: 2177.7 us
> stddev: 30.3 us
>     ./test_select_work 1000 10000 300 8
>     time_per_iteration: min: 2903.3 us avg: 2903.8 us max: 2904.3 us
> stddev: 0.3 us
>     ./test_select_work 1000 10000 300 40
>     time_per_iteration: min: 8877.7.1 us avg: 9016.3 us max: 9112.6 us
> stddev: 62.9 us
> 
> On RHEL 5, the results were about what I expected (4 threads taking
> twice as long because of the 1 ms sleep but the 8 threads taking the
> same amount of time since each thread is now sleeping for about half
> the time, and a still fairly linear increase with the 40 threads).
> 
> However, with RHEL 6, the time taken with 4 threads increased by about
> 15% more than the expected doubling and the 8 thread case increased by
> about 45% more than the expected slight increase. The increase in the
> 4 thread case seems to be that RHEL 6 is actually sleeping for a
> handful of microseconds more than 1 ms while RHEL 5 is only sleep
> about 900 us, but this doesn't explain the unexpectedly large increase
> in the 8 and 40 thread cases.
> 
> I saw similar types of behaviour with all 3 -DSLEEP_TYPE values. I
> also tried playing with the scheduler parameters in sysctl, but
> nothing seemed to have a significant impact on the results. Any ideas
> on how I can further diagnose this issue?
> 
> Thanks,
> Dave

> #include <float.h>
> #include <math.h>
> #include <poll.h>
> #include <pthread.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/select.h>
> #include <sys/time.h>
> 
> 
> // Uncomment to use select inside the loop of each of the threads
> #define SLEEP_TYPE 1
> // Uncomment to use poll inside the loop of each of the threads
> //#define SLEEP_TYPE 2
> // Uncomment to use usleep inside the loop of each of the threads
> //#define SLEEP_TYPE 3
> 
> 
> struct thread_info {
> 	int sleep_time;
> 	int num_iterations;
> 	int work_size;
> };
> 
> void *do_test(void *arg)
> {
> 	const struct thread_info *tinfo = (struct thread_info *)arg;
> 
> 	const int sleep_time = tinfo->sleep_time;
> 	const int num_iterations = tinfo->num_iterations;
> 	const int work_size = tinfo->work_size;
> 
> #if SLEEP_TYPE == 1
> 	// Data for calling select
> 	struct timeval ts;
> #elif SLEEP_TYPE == 2
> 	// Data for calling poll
> 	struct pollfd pfd;
> #endif
> 	// Data for doing work
> 	int *buf;
> 	int pseed;
> 	int inum, bnum;
> 	// Data for tracking the time
>   struct timeval before, after;
> 	long long *diff;
>  
> 	buf = calloc(work_size, sizeof(int));
> 	diff = malloc(sizeof(unsigned long long));
> 
> #if SLEEP_TYPE == 2
> 	// Initialize the poll data
> 	pfd.fd = 0;
> 	pfd.events = 0;
> #endif
> 
> 	// Get the time before starting the processing
>   gettimeofday(&before, NULL);
> 
> 	// Do the requested number of iterations
> 	for (inum=0; inum<num_iterations; ++inum) {
> #if SLEEP_TYPE == 1
> 		ts.tv_sec = 0;
> 		ts.tv_usec = sleep_time;
> 		select(0, 0, 0, 0, &ts);
> #elif SLEEP_TYPE == 2
> 		poll(&pfd, 1, sleep_time / 1000);
> #elif SLEEP_TYPE == 3
> 		usleep(sleep_time);
> #else
> 		// Get rid of warning about unused variable
> 		(void)sleep_time;
> #endif
> 
> 		// Fill in a buffer with random numbers (taken from latt.c by Jens Axboe <jens.axboe@oracle.com>)
> 		pseed = 1;
> 		for (bnum=0; bnum<work_size; ++bnum) {
> 			pseed = pseed * 1103515245 + 12345;
> 			buf[bnum] = (pseed / 65536) % 32768;
> 		}
> 	}
> 
> 	// Get the time after starting the processing
>   gettimeofday(&after, NULL);
> 
> 	// Calculate the delta time
>   *diff = 1000000LL * (after.tv_sec - before.tv_sec);
>   *diff += after.tv_usec - before.tv_usec;
> 
> 	// Clean up the data
> 	free(buf);
> 
> 	return diff;
> }
> 
> int main(int argc, char **argv)
> {
> 	if (argc < 4) {
> 		printf("Usage: %s <sleep_time> <num_iterations> <work_size> <num_threads>\n", argv[0]);
> 		return -1;
> 	}
> 
> 	struct thread_info tinfo;
> 	int s, tnum, num_threads;
> 	pthread_attr_t attr;
> 	pthread_t *threads;
> 	long long *res;
> 	long long *times;
> 
> 	// Get the parameters
> 	tinfo.sleep_time = atoi(argv[1]);
> 	tinfo.num_iterations = atoi(argv[2]);
> 	tinfo.work_size = atoi(argv[3]) * 1024;
> 	num_threads = atoi(argv[4]);
> 
> 	// Initialize the thread creation attributes
> 	s = pthread_attr_init(&attr);
>   if (s != 0) {
> 		printf("Error initializing thread attributes\n");
> 		return -2;
> 	}
> 
> 	// Allocate the memory to track the threads
>  	threads = calloc(num_threads, sizeof(pthread_t));
>  	times = calloc(num_threads, sizeof(unsigned long long));
> 	if (threads == NULL) {
> 		printf("Error allocating memory to track threads\n");
> 		return -3;
> 	}
> 
> 	// Start all of the threads
> 	for (tnum=0; tnum<num_threads; ++tnum) {
> 		s = pthread_create(&threads[tnum], &attr, &do_test, &tinfo);
> 
> 		if (s != 0) {
> 			printf("Error starting thread\n");
> 			return -4;
> 		}
> 	}
> 
> 	// Clean up the thread creation attributes
> 	s = pthread_attr_destroy(&attr);
>   if (s != 0) {
> 		printf("Error cleaning up thread attributes\n");
> 		return -5;
> 	}
> 
> 	// Wait for all the threads to finish
> 	for (tnum=0; tnum<num_threads; ++tnum) {
> 		s = pthread_join(threads[tnum], (void **)(&res));
> 
> 		if (s != 0) {
> 			printf("Error waiting for thread\n");
> 			return -6;
> 		}
> 
> 		// Save the time
> 		times[tnum] = *res;
> 
> 		// And clean it up
> 		free(res);
> 	}
> 
> 	// Calculate the min, max, and average times
> 	float min_time = FLT_MAX;
> 	float max_time = -FLT_MAX;
> 	float avg_time = 0;
> 	for (tnum=0; tnum<num_threads; ++tnum) {
> 		if (times[tnum] < min_time)
> 			min_time = times[tnum];
> 		if (times[tnum] > max_time)
> 			max_time = times[tnum];
> 		avg_time += (times[tnum] - avg_time) / (float)(tnum + 1);
> 	}
> 	// Calculate the standard deviation of the time
> 	float stddev_time = 0;
> 	if (num_threads > 1) {
> 		for (tnum=0; tnum<num_threads; ++tnum)
> 			stddev_time += pow(times[tnum] - avg_time, 2);
> 		stddev_time = sqrtf(stddev_time / (num_threads - 1));
> 	}
> 
> 	// Print out the statistics of the times
> 	printf("time_per_iteration: min: %.1f us avg: %.1f us max: %.1f us stddev: %.1f us\n",
> 			min_time / tinfo.num_iterations,
> 			avg_time / tinfo.num_iterations,
> 			max_time / tinfo.num_iterations,
> 			stddev_time / tinfo.num_iterations);
> 
> 	// Clean up the allocated threads
> 	free(threads);
> 
> 	return 0;
> }


-- 
Only stand for myself
