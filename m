Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1CQOEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1CQOEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:04:41 -0400
Date: Thu, 17 Mar 2011 15:04:01 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
Message-ID: <20110317140401.GX10696@random.random>
References: <4D817234.9070106@jp.fujitsu.com>
 <4D8172D7.3040201@jp.fujitsu.com>
 <20110317041424.GD11094@one.firstfloor.org>
 <4D819A2A.8050606@jp.fujitsu.com>
 <20110317062612.GE11094@one.firstfloor.org>
 <4D81BB87.10803@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D81BB87.10803@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hidetoshi,

On Thu, Mar 17, 2011 at 04:43:03PM +0900, Hidetoshi Seto wrote:
> Still I think making the window smaller than now is worthwhile,
> no matter it is change from 0.1% to 0.01%, or from 0.01% to 0.001%.
> 
> Or did you find the downside of the check here?

Well it makes the code more a little more complicated for something
that looks impossible to trigger in the first place.

The slowdown of these changes is probably not significant because the
2m copy should dominate the collapse_huge_page cost, but it still add
locked ops and loops that weren't there before so technically it is a
microslowdown.

NOTE: if this closed the race window 100% I would not disagree with
this. If there's still a 0.001% chance of hitting the race like Andi
hints, then I don't find it very attractive. I think memory failure
isn't 100% correct and probably it's impossible to make it 100%
correct across the whole kernel (for example the compound_head is safe
for THP but it's still unsafe for hugetlbfs while the page is being
tear down), so it's probably ok that it tends to work in practice 100%
reliably when the task is running in userland but we leave holes when
kernel is mangling the page structures and moving stuff around,
otherwise we litter the kernel code without much practical benefit, I
guess KSM has the same issues of khugepaged for example.

So again, I'm not against making these changes, but I don't find them
very attractive and I'm unsure if we should go down this route
whenever the objective of the patch is only to reduce the race window
(that is incredibly small and not reproducible to start with, and it's
a theoretical race that hardly anybody could trigger) instead of
actually closing the race completely. But thanks a lot for your
effort, I see your point, I'm just not sure if it's worth it. I think
I'll let other comments on this...
