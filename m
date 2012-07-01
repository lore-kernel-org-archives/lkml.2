Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab2GASeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:34:22 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46081 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2GASeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:34:21 -0400
Message-ID: <4FF09824.6040909@linaro.org>
Date: Sun, 01 Jul 2012 11:34:12 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2][RFC] Potential fix for leapsecond caused futex issue
 (v2)
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------030908070207010507070004"
x-cbid: 12070118-5518-0000-0000-000005ADFAD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030908070207010507070004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/01/2012 11:29 AM, John Stultz wrote:
> From: John Stultz <john.stultz@linaro.org>
>
> Here's round two on this one.
And again, attached is the test case I've been using to trigger 
leapseconds, should anyone else want to help with testing the patches or 
reproducing problems.

To build:
gcc leaptest.c -o leaptest -lrt

thanks
-john


--------------030908070207010507070004
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

--------------030908070207010507070004--

