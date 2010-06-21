Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab0FUSF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:05:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59361 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab0FUSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:05:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6020"; a="45076722"
Message-ID: <4C1FAA05.9030006@codeaurora.org>
Date: Mon, 21 Jun 2010 11:05:57 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: hrtimer and context switch overhead -- udelay to "usleep"?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Circa 2007 there was talk of a patch to replace the underlying msleep
Implementation with hrtimers ( http://lkml.org/lkml/2007/8/3/250 ); this
ended up not happening for several reasons, but the idea of a usleep
call built on hrtimers was at one point tossed around in the discussion.
However, it seems that usleep idea never made it past that thread.

I was wondering then about the potential overhead / cost / worth of a
usleep function. Consider the hypothetical usleep:

static int __sched do_usleep_range(unsigned long min, unsigned long max)
{
	ktime_t kmin;
	unsigned long delta;

	kmin = ktime_set(0, min * NSEC_PER_USEC);
	delta = max - min;
	return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
}

/**
 * usleep_range - Drop in replacement for udelay where wakeup is flexible
 * @min: Minimum time in usecs to sleep
 * @max: Maximum time in usecs to sleep
 */
void usleep_range(unsigned long min, unsigned long max)
{
	__set_current_state(TASK_UNINTERRUPTIBLE);
	do_usleep_range(min, max);
}

EXPORT_SYMBOL(usleep_range);

static inline void usleep(unsigned long usecs)
{
	usleep_range(usecs, usecs);
}


I have been doing some work in device driver writing lately, and an
unfortunately common bit of code seems to be:

write_some_bits(...)
/* Need to let hardware latch */
udelay(100)

100us is a fairly middle-ground value, there are many calls to udelay(1~5)
as well as some as high as udelay(800)! This seems like an awfully long
time to be busy waiting, particularly if another part of the kernel could
be doing something else.

My question then is would a function such as usleep that replaces some of
the longer calls to udelay be "worth it" and at what point would an
appropriate cut-off between udelay and usleep be found? The first two
questions that come to mind then are:
 
What is the approximate cost of a context switch, quantified?

   I found 2 papers circa 2007 that seek to answer this, though they
   are a bit dated:

      http://www.cs.rochester.edu/u/cli/research/switch.pdf
      IBM eServer, dual 2.0GHz Pentium Xeon; 512 KB L2, cache line 128B
      Linux 2.6.17, RHEL 9, gcc 3.2.2 (-O0)
      3.8 us / context switch

      http://delivery.acm.org/10.1145/1290000/1281703/a3-david.pdf
      ARMv5, ARM926EJ-S on an OMAP1610 (set to 120MHz clock)
      Linux 2.6.20-rc5-omap1
      48 us / context switch

What is the overhead of an hrtimer? Would it be 'bad' to start using
a lot more of them in sleeps?

	From what I could tell, the overhead of hrtimers is fairly
	negligible, but that is just from reading documentation,
	anyone with numbers or experience here would be greatly
	appreciated.


Finally, to address any potential questions of why this isn't built on
top of do_nanosleep, the function usleep_range seems very valuable for
power applications; many of the delays are simply waiting for something
to complete, thus I would prefer if they did not themselves instigate
a wake-up; also, do_nanosleep seems like it is built to be an interface
for the user-space nanosleep function - it did not seem like a good fit.


Lastly, it is worth noting that there are many calls to udelay that
*cannot* be switched to usleep; udelay is used often to implement some
degree of bitbanging that would not take kindly to the more
unpredictable usleep. This idea is *not* intended for those
applications.


I appreciate any insight!

-Pat

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
