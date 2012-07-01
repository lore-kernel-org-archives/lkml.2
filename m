Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2GAWFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 18:05:19 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45736 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab2GAWFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 18:05:16 -0400
Message-ID: <4FF0C994.2020300@us.ibm.com>
Date: Sun, 01 Jul 2012 15:05:08 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 0/2][RFC] Potential fix for leapsecond caused futex issue
 (v2)
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------050507070900030908090603"
x-cbid: 12070122-3534-0000-0000-00000A040D48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050507070900030908090603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/01/2012 11:29 AM, John Stultz wrote:
> TODOs:
> * Chase down the futex/hrtimer interaction to see if this could
> be triggered in any other way.

Ok, got a little more detailed diagnosis of what is going on figured out:

* Leap second occurs, CLOCK_REALTIME is set back one second.

* As clock_was_set() is not called, the hrtimer base.offset value for 
CLOCK_REALTIME is not updated, thus its sense of wall time is one second 
ahead of the timekeeping core's.

* At interrupt time (T), the hrtimer code expires all CLOCK_REALTIME 
based timers set for T+1s and before, causing early expirations for 
timers between T and T+1s since the hrtimer code's sense of time is one 
second ahead.

* This causes all TIMER_ABSTIME CLOCK_REALTIME timers to expire one 
second early.

* More problematically, all sub-second TIMER_ABSTIME CLOCK_REALTIME 
timers will return immediately.  If any such timer calls are done in a 
loop (as commonly done with futex_wait or other timeouts), this will 
cause load spikes in those applications.

* This state persists until clock_was_set() is called (most easily done 
via settimeofday())


I've used the attached test case to demonstrate triggering a leap-second 
and its effect on CLOCK_REALTIME hrtimers.

The test sets a leapsecond to trigger in 10 seconds, then in a loop 
sleeps for half a second via clock_nanosleep, printing out the current 
time, and the delta from the target wakeup time for 30 seconds.

When the leap second triggers, on affected machines you'll see the 
output streams quickly, with negative diff values, as clock_nanosleep is 
immediately returning.

To build:
gcc leaptest-timer.c -o leaptest-timer -lrt


I've reproduced this behaviour in kernel versions:
     v3.5-rc4
     v2.6.37
     v2.6.32.59
(And quite likely all in-between).

I haven't been able to build or boot anything earlier with the distro on 
my current test boxes, but I'm working to get older distro installed so 
I can do further testing.

Likely has potentially been around 
since:746976a301ac9c9aa10d7d42454f8d6cdad8ff2b in v2.6.22, as Ben Blum 
and Jan Ceuleers already noted.

With my fix to call clock_was_set when we apply a leapsecond, I no 
longer see the issue.

thanks
-john


--------------050507070900030908090603
Content-Type: text/x-csrc;
 name="leaptest-timer.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="leaptest-timer.c"

/* Leap second timer test
 *              by: john stultz (johnstul@us.ibm.com)
 *              (C) Copyright IBM 2012
 *              Licensed under the GPL
 */


#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <sys/timex.h>


#define CALLS_PER_LOOP 64
#define NSEC_PER_SEC 1000000000ULL

struct timespec timespec_add(struct timespec ts, unsigned long long ns)
{
	ts.tv_nsec += ns;
	while(ts.tv_nsec >= NSEC_PER_SEC) {
		ts.tv_nsec -= NSEC_PER_SEC;
		ts.tv_sec++;
	}
	return ts;
}

struct timespec timespec_diff(struct timespec a, struct timespec b)
{
	long long ns;
	int neg = 0;

	ns = a.tv_sec *NSEC_PER_SEC + a.tv_nsec;
	ns -= b.tv_sec *NSEC_PER_SEC + b.tv_nsec;

	if (ns < 0) {
		neg = 1;
		ns = -ns;
	}
	a.tv_sec = ns/NSEC_PER_SEC;
	a.tv_nsec = ns%NSEC_PER_SEC;

	if (neg) {
		a.tv_sec = -a.tv_sec;
		a.tv_nsec = -a.tv_nsec;
	}

	return a;
}


int  main(void)
{
	struct timeval tv;
	struct timex tx;
	int i, inconsistent;
	long now, then;
	struct timespec ts;

	int clock_type 		= CLOCK_REALTIME;
	int flag 		= TIMER_ABSTIME;
	long long sleeptime	= NSEC_PER_SEC/2;


	/* clear TIME_WAIT */
	tx.modes = ADJ_STATUS;
	tx.status = 0;
	adjtimex(&tx);

	sleep(2);

	/* Get the current time */
	gettimeofday(&tv, NULL);

	/* Calculate the next leap second */
	tv.tv_sec += 86400 - tv.tv_sec % 86400;

	/* Set the time to be 10 seconds from that time */
	tv.tv_sec -= 10;
	settimeofday(&tv, NULL);


	/* Set the leap second insert flag */
	tx.modes = ADJ_STATUS;
	tx.status = STA_INS;
	adjtimex(&tx);

	clock_gettime(clock_type, &ts);
	now = then = ts.tv_sec;
	while(now - then < 30){
		struct timespec target, diff, rem;
		rem.tv_sec = 0;
		rem.tv_nsec = 0;

		if (flag == TIMER_ABSTIME)
			target = timespec_add(ts, sleeptime);
		else
			target = timespec_add(rem, sleeptime);

		clock_nanosleep(clock_type, flag, &target, &rem);
		clock_gettime(clock_type, &ts);

		diff = timespec_diff(ts, target);
		printf("now: %ld:%ld  diff: %ld:%ld rem: %ld:%ld\n",
				ts.tv_sec, ts.tv_nsec,
				diff.tv_sec, diff.tv_nsec,
				rem.tv_sec, rem.tv_nsec);
		now = ts.tv_sec;
	}

	/* clear TIME_WAIT */
	tx.modes = ADJ_STATUS;
	tx.status = 0;
	adjtimex(&tx);

	return 0;
}

--------------050507070900030908090603--

