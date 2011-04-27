Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab1D0QzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:55:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16432 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759537Ab1D0QzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:55:19 -0400
Message-ID: <4DB84A5E.7080609@oracle.com>
Date: Wed, 27 Apr 2011 11:54:54 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CAFCATUAFLAF_1301673577011-962016341 Lanikai/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/21] sched: Reduce runqueue lock contention -v6
References: <20110405152338.692966333@chello.nl>
In-Reply-To: <20110405152338.692966333@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DB84A62.0011:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 10:23 AM, Peter Zijlstra wrote:
> This patch series aims to optimize remote wakeups by moving most of the
> work of the wakeup to the remote cpu and avoid bouncing runqueue data
> structures where possible.
>
> As measured by sembench (which basically creates a wakeup storm) on my
> dual-socket westmere:
>
> $ for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do echo performance>  $i; done
> $ echo 4096 32000 64 128>  /proc/sys/kernel/sem
> $ ./sembench -t 2048 -w 1900 -o 0
>
> unpatched: run time 30 seconds 647278 worker burns per second
> patched:   run time 30 seconds 816715 worker burns per second
>
> I've queued this series for .40.

Here are the results of running sembench on a 128 cpu box. In all of the
below cases, I had to use the kernel parameter idle=mwait to eliminate
spinlock contention in clockevents_notify() in the idle loop. I'll try
to track down what can be done about that later.

I took Peter's patches from the tip/sched/locking tree. I got similar
results directly from that branch, but separated them out to try to
isolate some irregular behavior that mostly went away when I added
idle=mwait. Since that branch was on top of 2.6.39-rc3, I used that
as a base.

The other patchset in play is Chris Mason's semtimedop optimization
patches. By themselves, I didn't see an improvement with Chris' patches,
but in conjunction with Peter's, they gave the best results. When
combining the patches, I removed Chris' batched wakeup patch, since it
conflicted with Peter's patchset and really isn't needed any more.

(It's been a while since Chris posted these. They are in the 
"unbreakable" git tree,
http://oss.oracle.com/git/?p=linux-2.6-unbreakable.git;a=summary ,
and ported easily to mainline. I can repost them.)

I used Chris's latest sembench, http://oss.oracle.com/~mason/sembench.c
and the command "./sembench -t 2048 -w 1900 -o 0".  I got similar
burns-per-second numbers when cranking up the parameters to
"./sembench -t 16384 -w 15000 -o 0".


2.6.38:

2048 threads, waking 1900 at a time
using ipc sem operations
main thread burns: 6549
worker burn count total 12443100 min 6068 max 6105 avg 6075
run time 30 seconds 414770 worker burns per second

2.6.39-rc3:

worker burn count total 11876900 min 5791 max 5805 avg 5799
run time 30 seconds 395896 worker burns per second

2.6.39-rc3 + mason's semtimedop patches:

worker burn count total 9988300 min 4868 max 4896 avg 4877
run time 30 seconds 332943 worker burns per second

2.6.39-rc3 + mason's patches (no batch wakeup patch):

worker burn count total 9743200 min 4750 max 4786 avg 4757
run time 30 seconds 324773 worker burns per second

2.6.39-rc3 + peterz's patches:

worker burn count total 14430500 min 7038 max 7060 avg 7046
run time 30 seconds 481016 worker burns per second

2.6.39-rc3 + mason's patches + peterz's patches:

worker burn count total 15072700 min 7348 max 7381 avg 7359
run time 30 seconds 502423 worker burns per second
