Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0JMCQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 22:16:59 -0400
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:26812 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751733Ab0JMCQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 22:16:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Oct 2010 22:16:57 EDT
From: Bruno Randolf <br1@einfach.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add generic exponentially weighted moving average function
Date: Wed, 13 Oct 2010 11:10:21 +0900
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
References: <20101006093225.8739.14012.stgit@tt-desk> <20101012173352.0a458c24.randy.dunlap@oracle.com>
In-Reply-To: <20101012173352.0a458c24.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NURtMpfcE8Nsfn2"
Message-Id: <201010131110.21341.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_NURtMpfcE8Nsfn2
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

Hello Randy!

Thank you for taking the time to look at this!

On Wed October 13 2010 09:33:52 Randy Dunlap wrote:
> On Wed, 06 Oct 2010 18:32:25 +0900 Bruno Randolf wrote:
> > This adds a generic exponentially weighted moving average function. This
> > implementation makes use of a structure which keeps a scaled up internal
> > representation to reduce rounding errors.
> > 
> > The idea for this implementation comes from the rt2x00 driver
> > (rt2x00link.c) and i would like to use it in several places in the
> > mac80211 and ath5k code.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> 
> I guess I don't understand "exponentially weighted" or why that would
> be desirable.  Please try to explain (briefly).

It just means, that more recent values are given a higher priority. The 
influence of older values decreases exponentially.

This is desirable if we want to have an average, but we are more interested in 
the recent development. One example where that makes sense is the signal 
strength of a station in a wireless LAN. As the signal strength can vary 
significantly for every packet, just looking at one packet is misleading. 
We are not so much interested in a long term average, as a station might move 
- we are more interested in the average of the last X (say 8) packets, giving 
most priority to the last value.

http://en.wikipedia.org/wiki/Exponentially_weighted_moving_average#Exponential_moving_average

This is one example, but I found several places in the kernel code where 
something like this is used, usually open coded. That's why I tought a general 
function for this can make sense.

> I'm attaching a test program that I did.  I don't especially like the
> results of it.  Maybe it's due to the exponential weighting. (?)
> 
> The test program tells me that the sum of 3 samples is 8 & average = 2:
> i.e., not rounded up.

Oh, I see. I guess I should use DIV_ROUND_CLOSEST. I attach a new version of 
the test program.

> And that the sum of 6 samples is 30 & average = 4. (!!)
> And that the sum of 10 samples is 80 & average = 5. (!!)
> 
> Am I just not understanding the function or am I misusing it?

You should keep 'samples' constant every time you call the function. It is the 
factor which defines how fast the influence of older values decreases. Higher 
values will take more older samples into account. E.g. use it like this:

moving_average(avg, val, 4);

I should have documented that better, I guess... And maybe rename it to 
'factor'.

Also a moving average makes more sense when you use it more often, depending 
on how high 'samples' is. E.g. here is the output of the test program with 
'sampes' of 4 and 20 iterations. I also print 'savg' (simple average) which is 
sum/count:

count: 1, val: 1, sum: 1, savg: 1, avg: 1, internal: 1000
count: 2, val: 3, sum: 4, savg: 2, avg: 2, internal: 1500
count: 3, val: 4, sum: 8, savg: 2, avg: 2, internal: 2125
count: 4, val: 6, sum: 14, savg: 3, avg: 3, internal: 3093
count: 5, val: 7, sum: 21, savg: 4, avg: 4, internal: 4069
count: 6, val: 9, sum: 30, savg: 5, avg: 5, internal: 5301
count: 7, val: 10, sum: 40, savg: 5, avg: 6, internal: 6475
count: 8, val: 12, sum: 52, savg: 6, avg: 8, internal: 7856
count: 9, val: 13, sum: 65, savg: 7, avg: 9, internal: 9142
count: 10, val: 15, sum: 80, savg: 8, avg: 11, internal: 10606
count: 11, val: 16, sum: 96, savg: 8, avg: 12, internal: 11954
count: 12, val: 18, sum: 114, savg: 9, avg: 13, internal: 13465
count: 13, val: 19, sum: 133, savg: 10, avg: 15, internal: 14848
count: 14, val: 21, sum: 154, savg: 11, avg: 16, internal: 16386
count: 15, val: 22, sum: 176, savg: 11, avg: 18, internal: 17789
count: 16, val: 24, sum: 200, savg: 12, avg: 19, internal: 19341
count: 17, val: 25, sum: 225, savg: 13, avg: 21, internal: 20755
count: 18, val: 27, sum: 252, savg: 14, avg: 22, internal: 22316
count: 19, val: 28, sum: 280, savg: 14, avg: 24, internal: 23737
count: 20, val: 30, sum: 310, savg: 15, avg: 25, internal: 25302

Especially towards the end you can see how a moving average gives preference 
to the newer values.

> > Is this the right place to add it? Who to CC:?
> 
> Try Andrew. (added)

I attach a new version of the test program. If you can generally agree that 
this can be included in the kernel, I'll work on an improved version of my 
patch.

Thank you for your feedback!

Bruno

--Boundary-00=_NURtMpfcE8Nsfn2
Content-Type: text/x-csrc;
  charset="UTF-8";
  name="moving-avg.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="moving-avg.c"

#if 0
This adds a generic exponentially weighted moving average function. This
implementation makes use of a structure which keeps a scaled up internal
representation to reduce rounding errors.

The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
and i would like to use it in several places in the mac80211 and ath5k code.
#endif

#ifndef _LINUX_AVERAGE_H
#define _LINUX_AVERAGE_H

#define AVG_FACTOR	1000

struct avg_val {
	int value;
	int internal;
};

#define DIV_ROUND_CLOSEST(x, divisor)(			\
{							\
	typeof(divisor) __divisor = divisor;		\
	(((x) + ((__divisor) / 2)) / (__divisor));	\
}							\
)


/**
 * moving_average -  Exponentially weighted moving average
 * @avg: average structure
 * @val: current value
 * @samples: number of samples. This defines how fast the influence of older
 *	values decreases. Use the same number every time you call this
 *	function for a single avg_val!. 
 *
 * This implementation make use of a struct avg_val to prevent rounding
 * errors.
 */
static inline struct avg_val
moving_average(const struct avg_val avg, const int val, const int samples)
{
	struct avg_val ret;
	ret.internal = avg.internal  ?
		(((avg.internal * (samples - 1)) +
			(val * AVG_FACTOR)) / samples) :
		(val * AVG_FACTOR);
	ret.value = DIV_ROUND_CLOSEST(ret.internal, AVG_FACTOR);
	return ret;
}

#endif /* _LINUX_AVERAGE_H */


#include <stdio.h>

int main(int argc, char *argv[])
{
	struct avg_val	avg = {};
	int count;
	int val;
	int sum = 0;

	for (count = 1; count <= 20; count++) {
		val = count + count/2;
		sum += val;
		avg = moving_average(avg, val, 4);
		printf("count: %d, val: %d, sum: %d, savg: %d, avg: %d, internal: %d\n",
			count, val, sum, sum/count, avg.value, avg.internal);
	}

	return 0;
}

--Boundary-00=_NURtMpfcE8Nsfn2--
