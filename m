Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2FRSUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:20:41 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58475 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab2FRSUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:20:39 -0400
Message-ID: <4FDF7161.5020108@us.ibm.com>
Date: Mon, 18 Jun 2012 11:20:17 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Richard Cochran <richardcochran@gmail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
References: <4FDB8563.3030805@us.ibm.com> <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk> <20120617164751.GJ12429@burratino> <20120617173456.GA3684@netboy.at.omicron.at> <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/mixed;
 boundary="------------020000010707080304080306"
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061818-5806-0000-0000-000016583F64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020000010707080304080306
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/18/2012 06:55 AM, Ben Hutchings wrote:
> On Sun, 2012-06-17 at 19:34 +0200, Richard Cochran wrote:
>> On Sun, Jun 17, 2012 at 11:47:51AM -0500, Jonathan Nieder wrote:
>>> Ben Hutchings wrote:
>>>
>>> 6b43ae8a619d (ntp: Fix leap-second hrtimer livelock) sounds important,
>>> but the patch depends on bd3312681f69 (ntp: Add ntp_lock to replace
>>> xtime_locking) which does not have a commit message explaining its
>>> purpose (and that patch in turn depends on ea7cf49a7633).
> If I understand the commit message for 6b43ae8a619d correctly, the
> livelock results from ntp_lock and xtime_lock being acquired in opposite
> orders in two threads.  Which means it wasn't possible before ntp_lock
> was introduced in bd3312681f69.
Yes, I think Ben is right that before the ntp_lock split the potential 
deadlock couldn't happen.


>>> John, is that bug present in 3.2.y and 3.0.y, too?  Any hints for
>>> fixing it?
>> It looks like incrementing the TAI offset was wrong even before
>>
>>     6b43ae8a ntp: Fix leap-second hrtimer livelock  v3.4-rc1~44^2~9
>>
>> The offset should change upon entering state OOP, so something like
>> the following (untested) patch should fix it for 3.2.9.
> [...]
>
> It looks like this patch just changes the offset reported by adjtimex()
> during an inserted second; is that right?

Yep. It just makes sure the TAI offset is adjusted at the same point 
that the leapsecond is inserted (as opposed to a second late).

>
> Other than that, is 3.2.y likely to be OK?  Is there a good way to test
> that in advance; does
> <http://codemonkey.org.uk/2012/06/15/testing-leap-code/>  look
> reasonable?
Attached is a simple leap second test you can play with.

thanks
-john


--------------020000010707080304080306
Content-Type: text/x-csrc;
 name="leaptest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="leaptest.c"

/* Leap second test
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


int  main(void)
{
	struct timeval tv;
	struct timex tx;
	struct timespec list[CALLS_PER_LOOP];
	int i, inconsistent;
	int clock_type = CLOCK_REALTIME;
	long now, then;

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

	clock_gettime(clock_type, &list[0]);
	now = then = list[0].tv_sec;
	while(now - then < 30){
		inconsistent = 0;

		/* Fill list */
		for(i=0; i < CALLS_PER_LOOP; i++)
			clock_gettime(clock_type, &list[i]);

		/* Check for inconsistencies */
		for(i=0; i < CALLS_PER_LOOP-1; i++)
			if(!in_order(list[i],list[i+1]))
				inconsistent = i;

		/* display inconsistency */
		if(inconsistent){
			unsigned long long delta;
			for(i=0; i < CALLS_PER_LOOP; i++){
				if(i == inconsistent)
					printf("--------------------\n");
				printf("%lu:%lu\n",list[i].tv_sec,
							list[i].tv_nsec);
				if(i == inconsistent + 1 )
					printf("--------------------\n");
			}
			delta = list[inconsistent].tv_sec*NSEC_PER_SEC;
			delta += list[inconsistent].tv_nsec;
			delta -= list[inconsistent+1].tv_sec*NSEC_PER_SEC;
			delta -= list[inconsistent+1].tv_nsec;
			printf("Delta: %llu ns\n", delta);
			fflush(0);
			break;
		}
		now = list[0].tv_sec;
	}

	/* clear TIME_WAIT */
	tx.modes = ADJ_STATUS;
	tx.status = 0;
	adjtimex(&tx);

	return 0;
}

--------------020000010707080304080306--

