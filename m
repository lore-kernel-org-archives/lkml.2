Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0DFOIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:08:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:49910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0DFOIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:08:14 -0400
Subject: Re: High priority threads causing severe CPU load imbalances
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4BBB334D.5040308@suse.de>
References: <4BBB334D.5040308@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 16:08:10 +0200
Message-ID: <1270562890.1595.438.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 18:42 +0530, Suresh Jayaraman wrote:
> I have a simple test program that accepts number of threads(pthreads) to
> be created as a input. Each of these threads that gets created invokes a
> function which is just a infinite while loop. The main function after
> creating those threads goes in a infinite loop itself
> 
> My test machine is a Dual Core AMD Opteron(tm) 860 with 8
> sockets(non-HT), I run this test program with number of threads ==
> number of CPUs:
> 
>    ./loadcpu -t 16
> 
> I see 100% CPU utilization on almost all CPUs (via mpstat/htop/vmstat).
> 
> When the above threads are running, if I introduce a few high priority
> threads by doing:
> 
>    nice -n -13 ./loadcpu -t 3
> 
> After a short while, I see a few CPUs becoming idle at ~0% utilization
> (the number of CPUs becoming idle equals roughly the number of high
> priority threads i.e. 3). When I stop the high priority threads, the CPU
> utilization comes back to normal i.e. ~100%.
> 
> This is reproducible on 2.6.32.10 stable kernel with all the recent all
> SMT fixes (I hope) and I think it would be reproducible in current
> upstream as well.

Why bother using -stable for reporting bugs?

> sched_mc_power_savings has been always set to 0.
> 
> I spent a while staring at the load balancing and the thread migration
> code, but could not figure out why this is happening. Would appreciate
> any pointers.

Right, except its not a severe imbalance as the subject suggests. For
some reason it seems to end up in a semi-stable state that is actually
quite balanced.

for ((i=0; i<8; i++)) do while :; do :; done & done
for ((i=0; i<3; i++)) do while :; do :; done & renice -n -15 -p $! ;
done

gets me:

Cpu0  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  : 99.0%us,  1.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu5  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu6  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:  16440840k total,  1073672k used, 15367168k free,   105844k buffers
Swap: 16777212k total,        0k used, 16777212k free,   296504k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 4370 root       5 -15  105m  804  304 R 100.1  0.0   0:45.02 bash
 4374 root       5 -15  105m  804  304 R 100.1  0.0   0:44.95 bash
 4372 root       5 -15  105m  804  304 R 99.1  0.0   0:45.00 bash
 4364 root      20   0  105m  804  304 R 51.0  0.0   0:33.06 bash
 4362 root      20   0  105m  800  300 R 50.0  0.0   0:33.17 bash
 4365 root      20   0  105m  804  304 R 50.0  0.0   0:33.75 bash
 4368 root      20   0  105m  804  304 R 50.0  0.0   0:33.32 bash
 4369 root      20   0  105m  804  304 R 50.0  0.0   0:33.38 bash
 4363 root      20   0  105m  804  304 R 49.1  0.0   0:33.65 bash
 4366 root      20   0  105m  804  304 R 49.1  0.0   0:33.29 bash
 4367 root      20   0  105m  804  304 R 49.1  0.0   0:33.54 bash 

So we have the 3 -15 loops on a cpu each, and the 8 0 loops on 2 cpus
each, and 1 cpu idle. That is actually quite balanced, 'better' would be
if those 0 loops would rotate over the 5 available cpus, but that would
also trash more caches I guess.

I'm not quite sure what makes the load-balancer end up in this situation
though, but I suspect the various imbalance_pct things might have
something to do with it.

It doesn't always end up in this state either, if you only start 2 -15
loops its a roll of the dice on what happens, sometimes it ends up with
the 6 cpus cycling the 2 extra tasks around, sometimes its 1 cpu idle
with cycling 1 task.

Unexpected, maybe, severe imbalance, no. Would be nice to get it to be a
little more stable behaviour though.



