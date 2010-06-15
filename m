Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0FONy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:54:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53589 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab0FONy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:54:26 -0400
Date: Tue, 15 Jun 2010 14:54:08 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100615135408.GJ26788@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-13-git-send-email-mel@csn.ul.ie> <4C16A567.4080000@redhat.com> <20100615114510.GE26788@csn.ul.ie> <4C17815A.8080402@redhat.com> <20100615133727.GA27980@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100615133727.GA27980@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 09:37:27AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 15, 2010 at 09:34:18AM -0400, Rik van Riel wrote:
> > If direct reclaim can overflow the stack, so can direct
> > memcg reclaim.  That means this patch does not solve the
> > stack overflow, while admitting that we do need the
> > ability to get specific pages flushed to disk from the
> > pageout code.
> 
> Can you explain what the hell memcg reclaim is and why it needs
> to reclaim from random contexts?

Kamezawa Hiroyuki has the full story here but here is a summary.

memcg is the Memory Controller cgroup
(Documentation/cgroups/memory.txt). It's intended for the control of the
amount of memory usable by a group of processes but its behaviour in
terms of reclaim differs from global reclaim. It has its own LRU lists
and kswapd operates on them. What is surprising is that direct reclaim
for a process in the control group also does not operate within the
cgroup.

Reclaim from a cgroup happens from the fault path. The new page is
"charged" to the cgroup. If it exceeds its allocated resources, some
pages within the group are reclaimed in a path that is similar to direct
reclaim except for its entry point.

So, memcg is not reclaiming from a random context, there is a limited
number of cases where a memcg is reclaiming and it is not expected to
overflow the stack.

> It seems everything that has a cg in it's name that I stumbled over
> lately seems to be some ugly wart..
> 

The wart in this case is that the behaviour of page reclaim within a
memcg and globally differ a fair bit.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
