Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab2GAHCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 03:02:51 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:40332 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2GAHCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 03:02:31 -0400
Date: Sun, 1 Jul 2012 09:02:28 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        simon@fire.lp0.eu
Subject: Re: Leap second insertion causes futex to repeatedly timeout
Message-ID: <20120701070228.GA246@x4>
References: <alpine.LNX.2.01.1207010247430.7313@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1207010247430.7313@frira.zrqbmnf.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.07.01 at 02:57 +0200, Jan Engelhardt wrote:
> 
> This year's leap second insertion has had the strange effect on at least 
> Linux versions 3.4.4 (my end) and 3.5-rc4 (Simon's box, Cc) that certain 
> processes use up all CPU power, because of futexes repeatedly timing 
> out. This seems to only affect certain processes.
> 
> Simon observes - http://s85.org/owXfmLvt - that 
> Firefox/Thunderbird/Chrome/Java are affected.

On my ntp synchronized Linux 3.5 testbox I saw a similar issue.

The leap second was successfully inserted last night:
Jul  1 01:59:59 x4 kernel: Clock: inserting leap second 23:59:60 UTC

Because glibc-2.16 was released yesterday I've build it this morning.
During "make check" I saw several mutex related tests failures. For
example /nptl/tst-mutex5a.c failed with a "premature timeout difference"
of one second.

tst-mutex5a.c:
#define TYPE PTHREAD_MUTEX_ADAPTIVE_NP
#include "tst-mutex5.c"

from tst-mutex5.c:
// ...
  gettimeofday (&tv, NULL);
  TIMEVAL_TO_TIMESPEC (&tv, &ts);

  ts.tv_sec += 2;	/* Wait 2 seconds.  */

  err = pthread_mutex_timedlock (&m, &ts);
// ...
    {
      int clk_tck = sysconf (_SC_CLK_TCK);

      gettimeofday (&tv2, NULL);

      tv2.tv_sec -= tv.tv_sec;
      tv2.tv_usec -= tv.tv_usec;
      if (tv2.tv_usec < 0)
	{
	  tv2.tv_usec += 1000000;
	  tv2.tv_sec -= 1;
	}

      /* Be a bit tolerant, add one CLK_TCK.  */
      tv2.tv_usec += 1000000 / clk_tck;
      if (tv2.tv_usec >= 1000000)
	{
	  tv2.tv_usec -= 1000000;
	  ++tv2.tv_sec;
	}

      if (tv2.tv_sec < 2)
	{
	  printf ("premature timeout: %ld.%06ld difference\n",
		  tv2.tv_sec, tv2.tv_usec);
	  return 1;
	}
    }
// ...

-- 
Markus
