Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1KUKnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:43:10 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:43154 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1KUKnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:43:08 -0500
Date: Mon, 21 Nov 2011 11:42:50 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        mhocko@suse.cz, Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
Message-ID: <20111121104250.GI1770@cmpxchg.org>
References: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 10:33:08AM +0900, KAMEZAWA Hiroyuki wrote:
> 
> I'll send this again when mm is shipped.
> I sometimes see mem_cgroup_split_huge_fixup() in perf report and noticed
> it's very slow. This fixes it. Any comments are welcome.
> 
> ==
> Subject: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
> 
> at split_huge_page(), mem_cgroup_split_huge_fixup() is called to
> handle page_cgroup modifcations. It takes move_lock_page_cgroup()
> and modify page_cgroup and LRU accounting jobs and called
> HPAGE_PMD_SIZE - 1 times.
> 
> But thinking again,
>   - compound_lock() is held at move_accout...then, it's not necessary
>     to take move_lock_page_cgroup().
>   - LRU is locked and all tail pages will go into the same LRU as
>     head is now on.
>   - page_cgroup is contiguous in huge page range.
> 
> This patch fixes mem_cgroup_split_huge_fixup() as to be called once per
> hugepage and reduce costs for spliting.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I agree with the changes, but since you are resending it anyway: I
think removing the move_lock and switching the hook to take care of
all tail pages in one go are two logical steps.  Would you mind
breaking it up into separate patches?

In any case,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
