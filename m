Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0IDIAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 04:00:32 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:59227 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753615Ab0IDIAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 04:00:31 -0400
Date: Sat, 4 Sep 2010 17:58:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after
 direct reclaim allocation fails
Message-ID: <20100904075840.GE705@dastard>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie>
 <1283504926-2120-4-git-send-email-mel@csn.ul.ie>
 <20100903160026.564fdcc9.akpm@linux-foundation.org>
 <20100904022545.GD705@dastard>
 <20100903202101.f937b0bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903202101.f937b0bb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 08:21:01PM -0700, Andrew Morton wrote:
> On Sat, 4 Sep 2010 12:25:45 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > Still, given the improvements in performance from this patchset,
> > I'd say inclusion is a no-braniner....
> 
> OK, thanks.
> 
> It'd be interesting to check the IPI frequency with and without -
> /proc/interrupts "CAL" field.  Presumably it went down a lot.

Maybe I suspected you would ask for this. I happened to dump
/proc/interrupts after the livelock run finished, so you're in
luck :)

The lines below are:

before: before running the single 50M inode create workload
after: the numbers after the run completes
livelock: the numbers after two runs with a livelock in the second

Vanilla 2.6.36-rc3:

before:      561   350   614   282   559   335   365   363
after:	   10472 10473 10544 10681  9818 10837 10187  9923

.36-rc3 With patchset:

before:      452   426   441   337   748   321   498   357
after:      9463  9112  8671  8830  9391  8684  9768  8971

The numbers aren't that different - roughly 10% lower on average
with the patchset. I will state that vanilla kernel runs I ijust did
had noticably more consistent performance than the previous results
I had acheived, so perhaps it wasn't triggering the livelock
conditions as effectively this time through.

And finally:

livelock:  59458 58367 58559 59493 59614 57970 59060 58207

So the livelock case tends to indicate roughly 40,000 more IPI
interrupts per CPU occurred.  The livelock occurred for close to 5
minutes, so that's roughly 130 IPIs per second per CPU....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
