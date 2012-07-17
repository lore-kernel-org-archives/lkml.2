Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2GQSRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:17:15 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52313 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2GQSRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:17:13 -0400
Message-ID: <5005ABC2.8050006@us.ibm.com>
Date: Tue, 17 Jul 2012 11:15:30 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.0-stable: Fix for leapsecond deadlock & hrtimer/futex
 issue
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com> <20120717175741.GA3665@1wt.eu>
In-Reply-To: <20120717175741.GA3665@1wt.eu>
Content-Type: multipart/mixed;
 boundary="------------070005060505010000020008"
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071718-9360-0000-0000-0000087DEC5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070005060505010000020008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/17/2012 10:57 AM, Willy Tarreau wrote:
> Hi John,
>
> On Tue, Jul 17, 2012 at 01:33:47PM -0400, John Stultz wrote:
>> I've already done backports to all the stable kernels to 2.6.32, and
>> will send out the rest soon.
> That's very much appreciated, thank you! Do not hesitate to send me
> your reproducers, I'll happily run some tests.

Attached are two tests. One is general exerciser of the leapsecond code 
(leap-a-day) which also notes if it sees the hrtimer/futuex early 
expiration issue, and the other is a much faster (almost immediate) 
reproducer for the leapsecond deadlock (leapcrash).

The leapcrash test will likely wedge unpatched systems in hardirq 
context, and has caused lost (dirty) data in my testing, so BEWARE!
RUN AT YOUR OWN RISK!

And of course, the leap-a-day has the same potential, but doesn't tickle 
the deadlock issue as aggressively.

thanks
-john





--------------070005060505010000020008
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
		printf("ERROR: hrtimer early expiration failure observed.\n");
	}

}



int main(int argc, char** argv) 
{
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
		struct timespec ts;
		struct timex tx;
		time_t now, next_leap;

		/* Get the current time */
		clock_gettime(CLOCK_REALTIME, &ts);

		/* Calculate the next possible leap second 23:59:60 GMT */
		next_leap = ts.tv_sec;
		next_leap += 86400 - (next_leap % 86400);


		if (settime) {
			struct timeval tv;
			tv.tv_sec = next_leap - 10;
			tv.tv_usec = 0;
			settimeofday(&tv, NULL);
			printf("Setting time to %s", ctime(&tv.tv_sec));
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
		ts.tv_sec = next_leap - 3;
		ts.tv_nsec = 0;

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

--------------070005060505010000020008
Content-Type: text/x-csrc;
 name="leapcrash.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="leapcrash.c"

/* Demo leapsecond deadlock
 *              by: john stultz (johnstul@us.ibm.com)
 *              (C) Copyright IBM 2012
 *              Licensed under the GPL
 *
 * This test demonstrates leapsecond deadlock that is possibe
 * on kernels from 2.6.26 to 3.3.
 *
 * WARNING: THIS WILL LIKELY HARDHANG SYSTEMS AND MAY LOSE DATA
 * RUN AT YOUR OWN RISK!
 *  To build:
 *	$ gcc leapcrash.c -o leapcrash -lrt
 */



#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <sys/timex.h>
#include <string.h>
#include <signal.h>



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


int  main(void)
{
	struct timex tx;
	struct timespec ts;
	time_t next_leap;
	int count =0;

	setbuf(stdout, NULL);

	signal(SIGINT, handler);
	signal(SIGKILL, handler);
	printf("This runs continuously. Press ctrl-c to stop\n");

	clear_time_state();


	/* Get the current time */
	clock_gettime(CLOCK_REALTIME, &ts);

	/* Calculate the next possible leap second 23:59:60 GMT */
	next_leap = ts.tv_sec;
	next_leap += 86400 - (next_leap % 86400);

	while (1) {
		struct timeval tv;


		/* set the time to 2 seconds before the leap */
		tv.tv_sec = next_leap - 2;
		tv.tv_usec = 0;
		settimeofday(&tv, NULL);

		adjtimex(&tx);

		/* hammer on adjtime w/ STA_INS */
		while (tx.time.tv_sec < next_leap + 1) {
			/* Set the leap second insert flag */
			tx.modes = ADJ_STATUS;
			tx.status = STA_INS;
			adjtimex(&tx);
		}
		clear_time_state();
		printf(".");
	}
	return 0;
}

--------------070005060505010000020008--

