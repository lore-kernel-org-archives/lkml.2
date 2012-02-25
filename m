Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2BYGyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 01:54:15 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40218 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2BYGyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 01:54:14 -0500
Date: Sat, 25 Feb 2012 12:24:03 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120225065403.GB12313@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1321495153.5100.7.camel@marge.simson.net>
 <1321544313.6308.25.camel@marge.simson.net>
 <1321545376.2495.1.camel@laptop>
 <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <1329761661.6276.146.camel@marge.simpson.net>
 <20120223104959.GA8454@linux.vnet.ibm.com>
 <1329996064.7411.106.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329996064.7411.106.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022420-0260-0000-0000-0000009938AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2012-02-23 12:21:04]:

> Unpinned netperf TCP_RR and/or tbench pairs?  Anything that's wakeup
> heavy should tell the tail.

Here are some tbench numbers:

Machine : 2 Intel Xeon X5650 (Westmere) CPUs (6 core/package)
Kernel  : tip (HEAD at ebe97fa)
dbench  : v4.0

One tbench server/client pair was run on same host 5 times (with
fs-cache being purged each time) and avg of 5 run for various cases
noted below:

Case A : HT enabled (24 logical CPUs)

Thr'put	 : 168.166 MB/s (SD_SHARE_PKG_RESOURCES + !SD_BALANCE_WAKE)
Thr'put	 : 169.564 MB/s (SD_SHARE_PKG_RESOURCES + SD_BALANCE_WAKE at mc/smt)
Thr'put	 : 173.151 MB/s (!SD_SHARE_PKG_RESOURCES + !SD_BALANCE_WAKE)

Case B : HT disabled (12 logical CPUs)

Thr'put	 : 167.977 MB/s (SD_SHARE_PKG_RESOURCES + !SD_BALANCE_WAKE)
Thr'put	 : 167.891 MB/s (SD_SHARE_PKG_RESOURCES + SD_BALANCE_WAKE at mc)
Thr'put	 : 173.801 MB/s (!SD_SHARE_PKG_RESOURCES + !SD_BALANCE_WAKE)

Observations:

a. ~3% improvement seen with SD_SHARE_PKG_RESOURCES disabled, which I guess 
  reflects the cost of waking to a cold L2 cache.

b. No degradation seen with SD_BALANCE_WAKE enabled at mc/smt domains

IMO we need to detect tbench type paired wakeups as synchronous case, in
which case blindly wakeup the task to cur_cpu (as cost of L2 cache miss
could outweight the cost of any reduced scheduling latencies).

IOW select_task_rq_fair() needs to be given better hint as to whether L2
cache has been made warm by someone (interrupt handler or a producer
task), in which case (consumer) task needs to be woken in the same L2 cache
domain (i.e on cur_cpu itself)?

- vatsa

