Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1IAODB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:03:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757596Ab1IAOC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:02:57 -0400
Date: Thu, 1 Sep 2011 15:02:54 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/3] compaction: compact unevictable page
Message-ID: <20110901140254.GH14369@suse.de>
References: <cover.1321112552.git.minchan.kim@gmail.com>
 <8ef02605a7a76b176167d90a285033afa8513326.1321112552.git.minchan.kim@gmail.com>
 <20110831111954.GB17512@redhat.com>
 <20110831144150.GA1860@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110831144150.GA1860@barrios-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 11:41:50PM +0900, Minchan Kim wrote:
> On Wed, Aug 31, 2011 at 01:19:54PM +0200, Johannes Weiner wrote:
> > On Sun, Nov 13, 2011 at 01:37:42AM +0900, Minchan Kim wrote:
> > > Now compaction doesn't handle mlocked page as it uses __isolate_lru_page
> > > which doesn't consider unevicatable page. It has been used by just lumpy so
> > > it was pointless that it isolates unevictable page. But the situation is
> > > changed. Compaction could handle unevictable page and it can help getting
> > > big contiguos pages in fragment memory by many pinned page with mlock.
> > 
> > This may result in applications unexpectedly faulting and waiting on
> > mlocked pages under migration.  I wonder how realtime people feel
> > about that?
> 
> I didn't consider it but it's very important point.
> The migrate_page can call pageout on dirty page so RT process could wait on the
> mlocked page during very long time.

On the plus side, the filesystem that is likely to suffer from this
is btrfs. The other important cases avoid the writeout.

> I can mitigate it with isolating mlocked page in case of !sync but still we can't
> guarantee the time because we can't know how many vmas point the page so that try_to_unmap
> could spend lots of time.
> 

This loss of guarantee arguably violates POSIX 1B as part of the
real-time extension. The wording is "The function mlock shall cause
those whole pages containing any part of the address space of the
process starting at address addr and continuing for len bytes to be
memory resident until unlocked or until the process exits or execs
another process image."

It defines locking as "memory locking guarantees the residence of
portions of the address space. It is implementation defined whether
locking memory guarantees fixed translation between virtual addresses
(as seen by the process) and physical addresses."

As it's up to the implementation whether to preserve the physical
page mapping, it's allowed for compaction to move that page. However,
as it mlock is recommended for use by time-critical applications,
I fear we would be breaking developer expectations on the behaviour
of mlock even if it is permitted by POSIX.

> We can think it's a trade off between high order allocation VS RT latency.
> Now I am biasing toward RT latency as considering mlock man page.
> 
> Any thoughts?
> 

At the very least it should not be the default behaviour. I do not have
suggestions on how it could be enabled though. It's a bit obscure to
have as a kernel parameter or even a proc tunable and it's not a perfect
for /sys/kernel/mm/transparent_hugepage/defrag either.

How big of a problem is it that mlocked pages are not compacted at the
moment?

-- 
Mel Gorman
SUSE Labs
