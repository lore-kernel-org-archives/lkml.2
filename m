Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0IUMBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:01:05 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:59198 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750887Ab0IUMBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:01:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/bDdFSi0XbRVo/8Wjmxj+iqvJ3QjypT6T+qGMSIL
	i5N+guTctm3EhH
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced
 forks) (v4)
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100920191929.GA29026@Krystal>
References: <20100920191929.GA29026@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 14:01:18 +0200
Message-Id: <1285070478.24680.76.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 15:19 -0400, Mathieu Desnoyers wrote:

> Kernel used: mainline 2.6.35.2 with smaller min_granularity and check_preempt
> vruntime vs runtime comparison patches applied.

My test kernel is fresh baked v2.6.36-rc5.

> - START_DEBIT (vanilla setting)
> 
> maximum latency: 26409.0 µs
> average latency: 6762.1 µs
> missed timer events: 0

Mine are much worse, as I have 0bf377bb reverted to keep my base test
numbers relevant while tinkering.  These are fresh though.

maximum latency: 69261.1 µs     130058.0 µs     106636.9 µs
average latency:  9169.6 µs       9456.4 µs       9281.7 µs
missed timer events: 0                0              0

pert vs make -j3, 30 sec sample time
pert/s:       70 >6963.47us:      857 min:  0.06 max:60738.53 avg:10738.03 sum/s:754884us overhead:75.49%
pert/s:       70 >10471.13us:      847 min:  0.12 max:73405.91 avg:10674.23 sum/s:753245us overhead:75.31%
pert/s:       72 >12703.37us:      790 min:  0.11 max:55287.48 avg:10299.53 sum/s:749463us overhead:74.84%
pert/s:       71 >14825.31us:      740 min:  0.11 max:57264.25 avg:10581.39 sum/s:751984us overhead:75.20%

> - NO_START_DEBIT, NO_START_NICE
> 
> maximum latency: 10001.8 µs
> average latency: 1618.7 µs
> missed timer events: 0

maximum latency: 19948.5 µs     19215.4 µs     19526.3 µs
average latency:  5000.1 µs      4712.2 µs      5005.5 µs
missed timer events:   0              0              0

pert vs make -j3, 30 sec sample time
pert/s:       61 >8928.57us:      743 min:  0.15 max:78659.33 avg:12895.03 sum/s:787026us overhead:78.64%
pert/s:       62 >12853.44us:      700 min:  0.12 max:83828.68 avg:12525.78 sum/s:778686us overhead:77.84%
pert/s:       61 >15566.82us:      675 min:  0.11 max:67289.16 avg:12685.47 sum/s:781002us overhead:78.07%
pert/s:       61 >18254.31us:      690 min:  1.40 max:72051.21 avg:12832.17 sum/s:782762us overhead:78.27%

> - START_NICE
> 
> maximum latency: 8351.2 µs
> average latency: 1597.7 µs
> missed timer events: 0

maximum latency: 34004.7 µs     34712.5 µs     46956.6 µs
average latency:  7886.9 µs      8099.8 µs      8060.3 µs
missed timer events: 0               0             0

pert vs make -j3, 30 sec sample time
pert/s:      104 >5610.69us:     1036 min:  0.05 max:56740.62 avg:6047.66 sum/s:628957us overhead:62.90%
pert/s:      104 >8617.90us:      884 min:  0.15 max:65410.85 avg:5954.64 sum/s:623253us overhead:62.25%
pert/s:      116 >11005.35us:      837 min:  0.14 max:60020.97 avg:4963.97 sum/s:577641us overhead:57.76%
pert/s:       99 >13632.91us:      863 min:  0.14 max:68019.67 avg:6542.21 sum/s:648987us overhead:64.86%


V4 seems to have lost some effectiveness wrt new thread latency, and
tilted the fairness scaled considerably further in the 100% hog's favor.

> @@ -481,6 +483,8 @@ static u64 sched_slice(struct cfs_rq *cf
>  			load = &lw;
>  		}
>  		slice = calc_delta_mine(slice, se->load.weight, load);
> +		if (se->fork_nice_penality)
> +			slice <<= se->fork_nice_penality;
>  	}
>  	return slice;
>  }

Hm.  Parent/child can exec longer (?), but also sit in the penalty box
longer, so pay through the nose.  That doesn't look right.  Why mess
with slice?  Neither effect seems logical.

Since this is mostly about reducing latencies for the non-fork
competition, maybe a kinder gentler START_DEBIT would work.  Let the
child inherit parent's vruntime, charge a fraction of the vruntime
equalizer bill _after_ it execs, until the bill has been paid, or
whatnot.

(I've tried a few things, and my bit-bucket runneth over, so this idea
probably sucks rocks too;)

	-Mike

