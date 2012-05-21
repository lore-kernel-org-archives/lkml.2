Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab2EUCoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 22:44:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54722 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab2EUCoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 22:44:30 -0400
Date: Mon, 21 May 2012 10:51:49 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: consider all swapped back pages in used-once logic
Message-ID: <20120521025149.GA32375@gmail.com>
Mail-Followup-To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan@kernel.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>
References: <1337246033-13719-1-git-send-email-mhocko@suse.cz>
 <20120517195342.GB1800@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120517195342.GB1800@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 09:54:25PM +0200, Johannes Weiner wrote:
> On Thu, May 17, 2012 at 11:13:53AM +0200, Michal Hocko wrote:
> > [64574746 vmscan: detect mapped file pages used only once] made mapped pages
> > have another round in inactive list because they might be just short
> > lived and so we could consider them again next time. This heuristic
> > helps to reduce pressure on the active list with a streaming IO
> > worklods.
> > This patch fixes a regression introduced by this commit for heavy shmem
> > based workloads because unlike Anon pages, which are excluded from this
> > heuristic because they are usually long lived, shmem pages are handled
> > as a regular page cache.
> > This doesn't work quite well, unfortunately, if the workload is mostly
> > backed by shmem (in memory database sitting on 80% of memory) with a
> > streaming IO in the background (backup - up to 20% of memory). Anon
> > inactive list is full of (dirty) shmem pages when watermarks are
> > hit. Shmem pages are kept in the inactive list (they are referenced)
> > in the first round and it is hard to reclaim anything else so we reach
> > lower scanning priorities very quickly which leads to an excessive swap
> > out.
> > 
> > Let's fix this by excluding all swap backed pages (they tend to be long
> > lived wrt. the regular page cache anyway) from used-once heuristic and
> > rather activate them if they are referenced.
> 
> Yes, the algorithm only makes sense for file cache, which is easy to
> reclaim.  Thanks for the fix!

Hi Johannes,

Out of curiosity, I notice that, in this patch (64574746), the commit log
said that this patch aims to reduce the impact of pages used only once.
Could you please tell why you think these pages will flood the active
list?  How do you find this problem?

Actually, we met a huge regression in our product system.  This
application uses mmap/munmap and read/write simultaneously.  Meanwhile
it wants to keep mapped file pages in memory as much as possible.  But
this patch causes that mapped file pages are reclaimed frequently.  So I
want to know whether or not this patch consider this situation.  Thank
you.

Regards,
Zheng
