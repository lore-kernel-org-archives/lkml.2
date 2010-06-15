Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab0FOK5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:57:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab0FOK5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:57:44 -0400
Date: Tue, 15 Jun 2010 06:57:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
Message-ID: <20100615105740.GC31051@infradead.org>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
 <1276514273-27693-12-git-send-email-mel@csn.ul.ie>
 <20100614231144.GG6590@dastard>
 <20100614162143.04783749.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614162143.04783749.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 04:21:43PM -0700, Andrew Morton wrote:
> Yup.
> 
> But then, this all really should be done at the block layer so other
> io-submitting-paths can benefit from it.
> 
> IOW, maybe "the sort queue is the submission queue" wasn't a good idea.

Even if has not effect on the actual I/O patters it has a massive
benefit for the filesystem.  When probing delalloc/unwritten space at
least XFS does try to convert a larger extent forward from the index,
but doesn't bother to go backwards.  By providing the trivial sort here
we make life a lot easier for the filesystem.

In addition to that we do get better I/O patters especially with short
queues as smart writepage implementatons will also submit the next few
pages, which is essentially free given how the storage works.
This means we already have a page cleaned before we might even submit it
without sorting.

