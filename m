Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2GQHLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:11:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57912 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab2GQHLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:11:18 -0400
Message-ID: <50050FD9.3070403@us.ibm.com>
Date: Tue, 17 Jul 2012 00:10:17 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.2-stable: Fix for leapsecond caused hrtimer/futex
 issue
References: <1342508724-14527-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1342508724-14527-1-git-send-email-johnstul@us.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------020709030805040202040605"
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071707-9360-0000-0000-00000878659E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020709030805040202040605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/17/2012 12:05 AM, John Stultz wrote:
> 1) Deadlock leapsecond issue that a few reports described.
>
> I spent some time over the weekend trying to find a way to reproduce
> the hard-hang issue some folks were reporting after the leapsecond.
> Initially I didn't think the 6b43ae8a619d17 leap-second hrimter livelock
> patch needed to be backported since, I assumed it required the ntp_lock
> split for it to be triggered, but looking again I found that the same
> issue could occur prior to splitting out the ntp_lock. So I've backported
> that fix (and its follow-on fixups) as well as created a test case
> to reproduce the hard-hang deadlock.

Attached is the test case I used to reproduce and test the solution to 
the hard-hang deadlock.

WARNING: THIS TEST WILL LIKELY HARD LOCK YOUR BOX IN IRQ CONTEXT!
YOU MAY LOSE DATA! RUN AT YOUR OWN RISK!

thanks
-john


--------------020709030805040202040605
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

--------------020709030805040202040605--

