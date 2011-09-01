Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab1IAMk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:40:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38862 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab1IAMkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:40:25 -0400
Subject: Re: Problem with perf hardware counters grouping
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Hommey <mh@glandium.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 01 Sep 2011 14:40:17 +0200
In-Reply-To: <20110901115935.GA19550@glandium.org>
References: <20110831085718.GB13884@glandium.org>
	 <1314878012.11566.7.camel@twins> <20110901115935.GA19550@glandium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314880817.11566.19.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 13:59 +0200, Mike Hommey wrote:

> > I'm guessing you're running on something x86, either AMD-Fam10-12 or
> > Intel-NHM+.
> 
> Core2Duo

Ah, ok, then you're also using the fixed purpose thingies.

> > What happens with your >3 case is that while the group is valid and
> > could fit on the PMU, it won't fit at runtime because the NMI watchdog
> > is taking one and won't budge (cpu-pinned counter have precedence over
> > any other kind), effectively starving your group of pmu runtime.
> 
> That makes sense. But how exactly is not using groups different, then?
> perf, for instance doesn't use groups, and can get all the hardware
> counters.

The purpose of groups is to co-schedule events on the PMU, that is we
mandate that all members of the group are configured at the same time.
Note that this does not imply the group is scheduled at all times
(although you could request that by setting the perf_event_attr::pinned
on the leader).

By not using groups but individual counters we do not have this
restriction and perf will schedule them individually.

Now perf with rotate events when there are more than can physically fit
on the PMU at any one time, including groups. This can create the
appearance that all 4 are in fact working.

# perf stat -e instructions  ~/loop_ld

 Performance counter stats for '/root/loop_ld':

       400,765,771 instructions              #    0.00  insns per cycle        

       0.085995705 seconds time elapsed

# perf stat -e instructions -e instructions -e instructions -e instructions -e instructions -e instructions ~/loop_1b_ld

 Performance counter stats for '/root/loop_1b_ld':

       398,136,503 instructions              #    0.00  insns per cycle         [83.45%]
       400,387,443 instructions              #    0.00  insns per cycle         [83.62%]
       400,076,744 instructions              #    0.00  insns per cycle         [83.60%]
       400,221,739 instructions              #    0.00  insns per cycle         [83.62%]
       400,038,563 instructions              #    0.00  insns per cycle         [83.60%]
       402,085,668 instructions              #    0.00  insns per cycle         [82.94%]

       0.085712325 seconds time elapsed


This is on a wsm (4 gp + 1 fp counter capable of counting insn) with NMI
disabled.

Note the [83%] thing, that indicates these things got over committed and
we had to rotate the counters. In particular it is the ration between
PERF_FORMAT_TOTAL_TIME_ENABLED and PERF_FORMAT_TOTAL_TIME_RUNNING and we
use that to scale up the count.


