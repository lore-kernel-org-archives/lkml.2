Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1H2VNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:13:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38931 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab1H2VNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:13:18 -0400
Message-ID: <4E5C00E0.3080107@archlinux.us>
Date: Mon, 29 Aug 2011 23:13:04 +0200
From: fogobogo <fogobogo@archlinux.us>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to use CLOCK_REALTIME_ALARM
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Since alarmtimers have been mainlined there are now 2 new clock id's, 
CLOCK_REALTIME_ALARM and CLOCK_BOOTTIME_ALARM which are supposed to wake 
up a machine from suspend too. It's roughly outlined here:

http://lwn.net/Articles/429925/

Now me residing in userspace wonder how to use those. It's the first 
time I try to use a kernel interface and it is quite possible the 
problem is on my end but I have no clue what might be wrong. Here is 
some barely working code:

#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/types.h>
#include <time.h>

void
func()
{
     printf("pong.\n");
}

int
main(int argc, char *argv[])
{
     timer_t id;

     struct itimerspec A;
     struct sigevent se;

     int rc; /* return code */

     se.sigev_notify = SIGEV_THREAD;
     se.sigev_notify_function = func;
     se.sigev_notify_attributes = NULL;

     /* doesn't accept CLOCK_REALTIME_ALARM */
     rc = timer_create(CLOCK_REALTIME, &se, &id);
     printf("%d\n",rc);

     /* the only place that seems to actually accept it */
     clock_gettime(CLOCK_REALTIME_ALARM, &A.it_value);

     A.it_value.tv_sec += 10;

     A.it_interval.tv_sec = 0;
     A.it_interval.tv_nsec = 0;

     /* set timer */
     rc = timer_settime(&id, TIMER_ABSTIME, &A, 0);
     printf("%d\n",rc);

     printf("ping.\n");

     /* bad. bad. bad. */
     while(1);

     return 0;
}

I'd appreciate if someone could point me on what I'm doing wrong or tell 
me if the new clock id's work at all.

please CC answers. thanks in advance.
