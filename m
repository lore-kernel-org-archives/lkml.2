Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0JMAgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 20:36:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18218 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab0JMAgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 20:36:08 -0400
Date: Tue, 12 Oct 2010 17:33:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add generic exponentially weighted moving average
 function
Message-Id: <20101012173352.0a458c24.randy.dunlap@oracle.com>
In-Reply-To: <20101006093225.8739.14012.stgit@tt-desk>
References: <20101006093225.8739.14012.stgit@tt-desk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Tue__12_Oct_2010_17_33_52_-0700_GLhD7tVWHLLN_Xye"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Tue__12_Oct_2010_17_33_52_-0700_GLhD7tVWHLLN_Xye
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 06 Oct 2010 18:32:25 +0900 Bruno Randolf wrote:

> This adds a generic exponentially weighted moving average function. This
> implementation makes use of a structure which keeps a scaled up internal
> representation to reduce rounding errors.
> 
> The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
> and i would like to use it in several places in the mac80211 and ath5k code.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>

I guess I don't understand "exponentially weighted" or why that would
be desirable.  Please try to explain (briefly).

I'm attaching a test program that I did.  I don't especially like the
results of it.  Maybe it's due to the exponential weighting. (?)

The test program tells me that the sum of 3 samples is 8 & average = 2:
i.e., not rounded up.

And that the sum of 6 samples is 30 & average = 4. (!!)
And that the sum of 10 samples is 80 & average = 5. (!!)

Am I just not understanding the function or am I misusing it?


Complete test program output:

> ./moving-avg 
count: 1, val: 1, sum: 1, avg: 1, internal: 1000
count: 2, val: 3, sum: 4, avg: 2, internal: 2000
count: 3, val: 4, sum: 8, avg: 2, internal: 2666
count: 4, val: 6, sum: 14, avg: 3, internal: 3499
count: 5, val: 7, sum: 21, avg: 4, internal: 4199
count: 6, val: 9, sum: 30, avg: 4, internal: 4999
count: 7, val: 10, sum: 40, avg: 5, internal: 5713
count: 8, val: 12, sum: 52, avg: 6, internal: 6498
count: 9, val: 13, sum: 65, avg: 7, internal: 7220
count: 10, val: 15, sum: 80, avg: 7, internal: 7998
>


> --
> Is this the right place to add it? Who to CC:?

Try Andrew. (added)

> 
> ---
>  include/linux/average.h |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/average.h
> 
> diff --git a/include/linux/average.h b/include/linux/average.h
> new file mode 100644
> index 0000000..2a00d3d
> --- /dev/null
> +++ b/include/linux/average.h
> @@ -0,0 +1,32 @@
> +#ifndef _LINUX_AVERAGE_H
> +#define _LINUX_AVERAGE_H
> +
> +#define AVG_FACTOR	1000
> +
> +struct avg_val {
> +	int value;
> +	int internal;
> +};
> +
> +/**
> + * moving_average -  Exponentially weighted moving average
> + * @avg: average structure
> + * @val: current value
> + * @samples: number of samples
> + *
> + * This implementation make use of a struct avg_val to prevent rounding
> + * errors.
> + */
> +static inline struct avg_val
> +moving_average(const struct avg_val avg, const int val, const int samples)
> +{
> +	struct avg_val ret;
> +	ret.internal = avg.internal  ?
> +		(((avg.internal * (samples - 1)) +
> +			(val * AVG_FACTOR)) / samples) :
> +		(val * AVG_FACTOR);
> +	ret.value = ret.internal / AVG_FACTOR;
> +	return ret;
> +}
> +
> +#endif /* _LINUX_AVERAGE_H */
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

--Multipart=_Tue__12_Oct_2010_17_33_52_-0700_GLhD7tVWHLLN_Xye
Content-Type: text/plain;
 name="moving-avg.c"
Content-Disposition: attachment;
 filename="moving-avg.c"
Content-Transfer-Encoding: 7bit

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

/**
 * moving_average -  Exponentially weighted moving average
 * @avg: average structure
 * @val: current value
 * @samples: number of samples
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
	ret.value = ret.internal / AVG_FACTOR;
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

	for (count = 1; count <= 10; count++) {
		val = count + count/2;
		sum += val;
		avg = moving_average(avg, val, count);
		printf("count: %d, val: %d, sum: %d, avg: %d, internal: %d\n",
			count, val, sum, avg.value, avg.internal);
	}

	return 0;
}

--Multipart=_Tue__12_Oct_2010_17_33_52_-0700_GLhD7tVWHLLN_Xye--
