Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2GJXAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:00:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42806 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764Ab2GJXAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:00:33 -0400
Message-ID: <4FFCB404.1000705@us.ibm.com>
Date: Tue, 10 Jul 2012 16:00:20 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix for leapsecond caused hrtimer/futex issue (updated)
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------080809030105090306060500"
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071023-6078-0000-0000-00000D151754
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080809030105090306060500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/10/2012 03:43 PM, John Stultz wrote:
> Over the weekend, Thomas got a chance to review the leap second fix
> in more detail and had a few additional changes he wanted to make
> to improve performance as well as style.
>
> So this iteration includes his modifications.
>
> Once merged, I'll be working to get the backports finished as quickly
> as I can and sent to -stable.
>

Once again, here's the test case I've been using to stress test 
leapsecond insertion/deletion (the deletion testing is new since last 
round).

thanks
-john


--------------080809030105090306060500
Content-Type: text/x-csrc;
 name="leap-a-day.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="leap-a-day.c"

/* Leap second stress test
 *              by: john stultz (johnstul@us.ibm.com)
 *              (C) Copyright IBM 2012
 *              Licensed under the GPLv2
 *
 *  This test signals the kernel to insert a leap second
 *  every day at midnight GMT. This allows for stessing the
 *  kernel's leap-second behavior, as well as how well applications
 *  handle the leap-second discontinuity.
 *
 *  Usage: leap-a-day [-s]
 *
 *  Options:
 *	-s:	Each iteration, set the date to 10 seconds before midnight GMT.
 *		This speeds up the number of leapsecond transitions tested,
 *		but because it calls settimeofday frequently, advancing the
 *		time by 24 hours every ~16 seconds, it may cause application
 *		disruption.
 *
 *  Other notes: Disabling NTP prior to running this is advised, as the two
 *		 may conflict in thier commands to the kernel.
 *
 *  To build:
 *	$ gcc leap-a-day.c -o leap-a-day -lrt
 */



#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <sys/timex.h>
#include <string.h>
#include <signal.h>

#define NSEC_PER_SEC 1000000000ULL

/* returns 1 if a <= b, 0 otherwise */
static inline int in_order(struct timespec a, struct timespec b)
{
        if(a.tv_sec < b.tv_sec)
                return 1;
        if(a.tv_sec > b.tv_sec)
                return 0;
        if(a.tv_nsec > b.tv_nsec)
                return 0;
        return 1;
}

struct timespec timespec_add(struct timespec ts, unsigned long long ns)
{
	ts.tv_nsec += ns;
	while(ts.tv_nsec >= NSEC_PER_SEC) {
		ts.tv_nsec -= NSEC_PER_SEC;
		ts.tv_sec++;
	}
	return ts;
}


char* time_state_str(int state)
{
	switch (state) {
		case TIME_OK:	return "TIME_OK";
		case TIME_INS:	return "TIME_INS";
		case TIME_DEL:	return "TIME_DEL";
		case TIME_OOP:	return "TIME_OOP";
		case TIME_WAIT:	return "TIME_WAIT";
		case TIME_BAD:	return "TIME_BAD";
	}
	return "ERROR"; 
}

/* clear NTP time_status & time_state */
void clear_time_state(void)
{
	struct timex tx;
	int ret;

	/*
	 * XXX - The fact we have to call this twice seems
	 * to point to a slight issue in the kernel's ntp state
	 * managment. Needs to be investigated further.
	 */

	tx.modes = ADJ_STATUS;
	tx.status = STA_PLL;
	ret = adjtimex(&tx);

	tx.modes = ADJ_STATUS;
	tx.status = 0;
	ret = adjtimex(&tx);
}

/* Make sure we cleanup on ctrl-c */
void handler(int unused)
{
	clear_time_state();
	exit(0);
}


/* Test for known hrtimer failure */
void test_hrtimer_failure(void)
{
	struct timespec now, target;

	clock_gettime(CLOCK_REALTIME, &now);
	target = timespec_add(now, NSEC_PER_SEC/2);
	clock_nanosleep(CLOCK_REALTIME, TIMER_ABSTIME, &target, NULL);
	clock_gettime(CLOCK_REALTIME, &now);

	if (!in_order(target, now)) {
		printf("Note: hrtimer early expiration failure observed.\n");
	}

}



int main(int argc, char** argv) 
{
	struct timeval tv;
	struct timex tx;
	struct timespec ts;
	int settime = 0;
	int insert = 1;

	signal(SIGINT, handler);
	signal(SIGKILL, handler);
	printf("This runs continuously. Press ctrl-c to stop\n");


	/* Process arguments */
	if (argc > 1) {
		if (!strncmp(argv[1], "-s", 2)) {
			printf("Setting time to speed up testing\n");
			settime = 1;
		} else {
			printf("Usage: %s [-s]\n", argv[0]);
			printf("	-s: Set time to right before leap second each iteration\n");
		}
	}

	printf("\n");
	while (1) {
		int ret;
		time_t now, next_leap;
		/* Get the current time */
		gettimeofday(&tv, NULL);

		/* Calculate the next possible leap second 23:59:60 GMT */
		tv.tv_sec += 86400 - (tv.tv_sec % 86400);
		next_leap = ts.tv_sec = tv.tv_sec;

		if (settime) {
			tv.tv_sec -= 10;
			settimeofday(&tv, NULL);
			printf("Setting time to %s", ctime(&ts.tv_sec));
		}

		/* Reset NTP time state */
		clear_time_state();

		/* Set the leap second insert flag */
		tx.modes = ADJ_STATUS;
		if (insert) 
			tx.status = STA_INS;
		else
			tx.status = STA_DEL;
		ret = adjtimex(&tx);
		if (ret < 0 ) {
			printf("Error: Problem setting STA_INS/STA_DEL!: %s\n",
							time_state_str(ret));
			return -1;
		}

		/* Validate STA_INS was set */
		ret = adjtimex(&tx);
		if (tx.status != STA_INS && tx.status != STA_DEL) {
			printf("Error: STA_INS/STA_DEL not set!: %s\n",
							time_state_str(ret));
			return -1;
		}

		printf("Scheduling leap second for %s", ctime(&next_leap));
	
		/* Wake up 3 seconds before leap */
		ts.tv_sec -= 3;
		while(clock_nanosleep(CLOCK_REALTIME, TIMER_ABSTIME, &ts, NULL))
			printf("Something woke us up, returning to sleep\n");

		/* Validate STA_INS is still set */
		ret = adjtimex(&tx);
		if (tx.status != STA_INS && tx.status != STA_DEL) {
			printf("Something cleared STA_INS/STA_DEL, setting it again.\n");
			tx.modes = ADJ_STATUS;
			if (insert) 
				tx.status = STA_INS;
			else
				tx.status = STA_DEL;
			ret = adjtimex(&tx);
		}

		/* Check adjtimex output every half second */
		now = tx.time.tv_sec;
		while (now < next_leap+2) {
			char buf[26];
			ret = adjtimex(&tx);

			ctime_r(&tx.time.tv_sec, buf);
			buf[strlen(buf)-1] = 0; /*remove trailing\n */

			printf("%s + %6ld us\t%s\n",
					buf,
					tx.time.tv_usec, 
					time_state_str(ret));
			now = tx.time.tv_sec;
			/* Sleep for another half second */
			ts.tv_sec = 0;
			ts.tv_nsec = NSEC_PER_SEC/2;
			clock_nanosleep(CLOCK_MONOTONIC, 0, &ts, NULL);			
		}
		/* Switch to using other mode */
		insert = !insert;

		/* Note if kernel has known hrtimer failure */
		test_hrtimer_failure();

		printf("Leap complete\n\n");
	}

	clear_time_state();
	return 0;
}

--------------080809030105090306060500--

