Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0FPAfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 20:35:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50392 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab0FPAf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 20:35:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Jun 2010 09:30:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-Id: <20100616093059.7765574f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100615135408.GJ26788@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	<1276514273-27693-13-git-send-email-mel@csn.ul.ie>
	<4C16A567.4080000@redhat.com>
	<20100615114510.GE26788@csn.ul.ie>
	<4C17815A.8080402@redhat.com>
	<20100615133727.GA27980@infradead.org>
	<20100615135408.GJ26788@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 14:54:08 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On Tue, Jun 15, 2010 at 09:37:27AM -0400, Christoph Hellwig wrote:
> > On Tue, Jun 15, 2010 at 09:34:18AM -0400, Rik van Riel wrote:
> > > If direct reclaim can overflow the stack, so can direct
> > > memcg reclaim.  That means this patch does not solve the
> > > stack overflow, while admitting that we do need the
> > > ability to get specific pages flushed to disk from the
> > > pageout code.
> > 
> > Can you explain what the hell memcg reclaim is and why it needs
> > to reclaim from random contexts?
> 
> Kamezawa Hiroyuki has the full story here but here is a summary.
> 
Thank you.

> memcg is the Memory Controller cgroup
> (Documentation/cgroups/memory.txt). It's intended for the control of the
> amount of memory usable by a group of processes but its behaviour in
> terms of reclaim differs from global reclaim. It has its own LRU lists
> and kswapd operates on them.

No, we don't use kswapd. But we have some hooks in kswapd for implementing
soft-limit. Soft-limit is for giving a hint for kswapd "please reclaim memory
from this memcg" when global memory exhausts and kswapd runs.

What a memcg use when it his limit is just direct reclaim.
(*) Justfing using a cpu by a kswapd because a memcg hits limit is difficult 
    for me. So, I don't use kswapd until now.
    When direct-reclaim is used, cost-of-reclaim will be charged against
    a cpu cgroup which a thread belongs to.


> What is surprising is that direct reclaim
> for a process in the control group also does not operate within the
> cgroup.
Sorry, I can't understand ....

> 
> Reclaim from a cgroup happens from the fault path. The new page is
> "charged" to the cgroup. If it exceeds its allocated resources, some
> pages within the group are reclaimed in a path that is similar to direct
> reclaim except for its entry point.
> 
yes.

> So, memcg is not reclaiming from a random context, there is a limited
> number of cases where a memcg is reclaiming and it is not expected to
> overflow the stack.
> 

I think so. Especially, we'll never see 1k stack use of select().

> > It seems everything that has a cg in it's name that I stumbled over
> > lately seems to be some ugly wart..
> > 
> 
> The wart in this case is that the behaviour of page reclaim within a
> memcg and globally differ a fair bit.
> 

Sorry. But there has been very long story to reach current implementations.
But don't worry, of memcg is not activated (not mounted), it doesn't affect
the behavior of processes ;)

But Hmm..

>[kamezawa@bluextal mmotm-2.6.35-0611]$ wc -l mm/memcontrol.c
>4705 mm/memcontrol.c

may need some diet :(


Thanks,
-Kame


