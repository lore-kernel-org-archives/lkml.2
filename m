Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1CQQNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:13:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1CQQNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:13:00 -0400
Date: Thu, 17 Mar 2011 17:12:19 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
Message-ID: <20110317161219.GZ10696@random.random>
References: <4D817234.9070106@jp.fujitsu.com>
 <4D8172D7.3040201@jp.fujitsu.com>
 <20110317041424.GD11094@one.firstfloor.org>
 <4D819A2A.8050606@jp.fujitsu.com>
 <20110317062612.GE11094@one.firstfloor.org>
 <4D81BB87.10803@jp.fujitsu.com>
 <20110317140401.GX10696@random.random>
 <20110317152559.GG11094@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317152559.GG11094@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 04:25:59PM +0100, Andi Kleen wrote:
> > isn't 100% correct and probably it's impossible to make it 100%
> > correct across the whole kernel (for example the compound_head is safe
> > for THP but it's still unsafe for hugetlbfs while the page is being
> > tear down), so it's probably ok that it tends to work in practice 100%
> 
> I would like to fix known oopses in the existing paths, so that should
> be probably fixed. 

I agree with that. And still an oops is better than silent memory
corruption.

> We measured KSM some time ago on some simple workloads (a couple
> of window guests) and it turned out that KSM memory tends to be 
> only a very small fraction of total physical memory. So it was
> deemed not very important for hwpoison.

So it's your choice, I'm fine either ways...

What I can tell is with the default khugepaged scan rate, the
collapse_huge_page will have an impact much smaller than KSM. It could
have more impact than KSM if you increase khugepaged load to 100% with
sysfs (because of the more memory that is covered by khugepaged
compared to only the shared portion of KSM). Then the window gets much
bigger, but still minor, if you can't trigger it with the testsuite
it's even less likely to ever happen in practice.

Did you try the testsuite with khugepaged at 100% load? I think that's
good indication if this window has any practical significance.

But note that 100% khugepaged is unrealistic, because of how fast
khugepaged is, even a 10% CPU scan background load would be too
extreme even for huge amounts of memory.

So it's mostly up to you..

I think it needs more comments to explain why there are more loops
(only the lock_page has the comment) otherwise I guess over time it'll
get optimized away back again from people reading the code and not
checking ancient history in the git comments. Best would also be to
make it conditional to CONFIG_MEMORY_FAILURE=y but doing that for the
loops is a mess, at least the lock_page is doable (not that it matters
much but it's almost like a comment..).
