Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1ELOED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:04:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab1ELOEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:04:01 -0400
Date: Thu, 12 May 2011 16:03:52 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ulrich Keller <uhkeller@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Sattler <tsattler@gmx.de>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
Message-ID: <20110512140352.GG11579@random.random>
References: <4DAF6C0B.3070009@gmx.de>
 <loom.20110511T124036-180@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20110511T124036-180@post.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulrich,

On Wed, May 11, 2011 at 10:53:18AM +0000, Ulrich Keller wrote:
> I am seeing exactly the same symptoms on my Lenovo T60 Core2 duo, 3GB RAM,
> running Arch Linux i686 with Kernel 2.6.38.6. When I've heavily used Firefox for
> a while, or used R with high memory usage (>1 GB), individual applications
> become unresponsive, new processes fail to start and after a while the whole
> system freezes. When it happens, iotop shows khugepaged and sometimes firefox at
> 99.99%.
> 
> I'd be happy to post information here when the problem occurs again. Anything
> other than "cat /proc/zoneinfo"?

SYSRQ+T run multiple times during the hang and /proc/zoneinfo as well
run multiple times during the hang is the best info we can have for
now, /proc/zoneinfo is the most interesting as it will show us the
values that the too_many_isolated loop is checking to decide if to
continue looping. Even better would be a crash dump, but you may not
have the setup for that.

The patch I posted likely fixes it, but it may not be the right fix. I
don't really like that logic anyway but if that logic is not the
problem and the stat accounting is not correct, clearly we can defer
changing too_many_isolated and focus on the real problem first.

It may not be something new, it may have been exposed by the
__GFP_NO_KSWAPD flag, kswapd is always immune from the
too_many_isolated loop, so it keeps the VM rolling and would normally
hide such problem if it ever happened before.  It might also be be
something wrong with the THP altered statistics (counting 512 pages
for each THP), in that case it would be THP specific, but I wonder why
it's not easy to reproduce.

So you've 2 cores, and probably a SMP kernel right? Is it a preempt
kernel (just in case it makes any difference.. I doubt)? i386 means
it's a 32bit kernel? Or you meant i386 to say x86? The previous report
is also on a 32bit kernel. 32bit didn't get nearly the same amount of
testing of 64bit, but it's hard to see how 32bit could matter here!

Could you both send your .config (the UP one from Thomas, and the one
from your core2duo laptop).

You also have CONFIG_TASKSTATS, CONFIG_TASK_DELAY_ACCT
CONFIG_TASK_XACCT, TASK_IO_ACCOUNTING all =y right?  Not everyone is
running iotop you both are (before this bugreport I had TASKSTAT=n and
I still have on most systems), so maybe it's something related to
TASKSTATS corrupting memory or screwing the accounting when iotop
runs? That's just an idea not to exclude even if almost certainly not
realistic. Did it ever happen on a system with TASKSTAT=n or not
running iotop to rule it out? (likely even if it's buggy, it won't be
noticeable unless iotop runs)

Being reproduced on UP probably means the per-cpu vmstat.c is not to
blame (especially if it happens both UP and SMP builds, and if preempt
is confirmed disabled).

We've to restrict the scope of the bug a bit and try to find commons in
the .config too.

Here I've no sign of hang from too_many_isolated from 39rc6 and I'm
sure it never occurred to me in the past.

Thanks a lot,
Andrea
