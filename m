Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1BIUGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:06:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436Ab1BIUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:06:46 -0500
Date: Wed, 9 Feb 2011 12:05:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Kent Overstreet <kent.overstreet@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] vmscan: fix zone shrinking exit when scan work is done
Message-Id: <20110209120550.2bd18590.akpm@linux-foundation.org>
In-Reply-To: <20110209182846.GN3347@random.random>
References: <20110209154606.GJ27110@cmpxchg.org>
	<20110209164656.GA1063@csn.ul.ie>
	<20110209182846.GN3347@random.random>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011 19:28:46 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Wed, Feb 09, 2011 at 04:46:56PM +0000, Mel Gorman wrote:
> > On Wed, Feb 09, 2011 at 04:46:06PM +0100, Johannes Weiner wrote:
> > > Hi,
> > > 
> > > I think this should fix the problem of processes getting stuck in
> > > reclaim that has been reported several times.
> > 
> > I don't think it's the only source but I'm basing this on seeing
> > constant looping in balance_pgdat() and calling congestion_wait() a few
> > weeks ago that I haven't rechecked since. However, this looks like a
> > real fix for a real problem.
> 
> Agreed. Just yesterday I spent some time on the lumpy compaction
> changes after wondering about Michal's khugepaged 100% report, and I
> expected some fix was needed in this area (as I couldn't find any bug
> in khugepaged yet, so the lumpy compaction looked the next candidate
> for bugs).
> 
> I've also been wondering about the !nr_scanned check in
> should_continue_reclaim too but I didn't look too much into the caller
> (I was tempted to remove it all together). I don't see how checking
> nr_scanned can be safe even after we fix the caller to avoid passing
> non-zero values if "goto restart".
> 
> nr_scanned is incremented even for !page_evictable... so it's not
> really useful to insist, just because we scanned something, in my
> view. It looks bogus... So my proposal would be below.
> 
> ====
> Subject: mm: stop checking nr_scanned in should_continue_reclaim
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> nr_scanned is incremented even for !page_evictable... so it's not
> really useful to insist, just because we scanned something.

So if reclaim has scanned 100% !page_evictable pages,
should_continue_reclaim() can return true and we keep on scanning?

That sounds like it's both good and bad :( Is this actually a problem? 
What sort of behaviour could it cause and under what circumstances?

Johannes's patch is an obvious bugfix and I'll run with it for now, but
please let's have a further think abut the impact of the
!page_evictable pages.

