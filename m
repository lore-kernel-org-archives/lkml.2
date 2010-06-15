Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab0FOKqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:46:10 -0400
Received: from corega.com.ru ([195.178.208.66]:50366 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049Ab0FOKqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:46:07 -0400
X-Greylist: delayed 1063 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2010 06:46:07 EDT
Date: Tue, 15 Jun 2010 14:28:22 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
Message-ID: <20100615102822.GA4010@ioremap.net>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-12-git-send-email-mel@csn.ul.ie> <20100614231144.GG6590@dastard> <20100614162143.04783749.akpm@linux-foundation.org> <20100615003943.GK6590@dastard> <20100614183957.ad0cdb58.akpm@linux-foundation.org> <20100615032034.GR6590@dastard> <20100614211515.dd9880dc.akpm@linux-foundation.org> <20100615063643.GS6590@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615063643.GS6590@dastard>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 04:36:43PM +1000, Dave Chinner (david@fromorbit.com) wrote:
> > Nope.  Large-number-of-small-files is a pretty common case.  If the fs
> > doesn't handle that well (ie: by placing them nearby on disk), it's
> > borked.
> 
> Filesystems already handle this case just fine as we see it from
> writeback all the time. Untarring a kernel is a good example of
> this...
> 
> I suggested sorting all the IO to be issued into per-mapping page
> groups because:
> 	a) makes IO issued from reclaim look almost exactly the same
> 	   to the filesytem as if writeback is pushing out the IO.
> 	b) it looks to be a trivial addition to the new code.
> 
> To me that's a no-brainer.

That doesn't coverup large-number-of-small-files pattern, since
untarring subsequently means creating something new, which FS can
optimize. Much more interesting case is when we have dirtied large
number of small files in kind-of random order and submitted them
down to disk.

Per-mapping sorting will not do anything good in this case, even if
files were previously created in a good facion being placed closely and
so on, and only block layer will find a correlation between adjacent
blocks in different files. But with existing queue management it has
quite a small opportunity, and that's what I think Andrew is arguing
about.

-- 
	Evgeniy Polyakov
