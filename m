Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0GGBOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:14:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab0GGBOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:14:48 -0400
Date: Tue, 6 Jul 2010 21:14:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100707011428.GA3630@infradead.org>
References: <20100702125155.69c02f85.akpm@linux-foundation.org>
 <20100705134949.GC13780@csn.ul.ie>
 <20100706093529.CCD1.A69D9226@jp.fujitsu.com>
 <20100706101235.GE13780@csn.ul.ie>
 <AANLkTin8FotAC1GvjuoYU9XA2eiSr6FWWh6bwypTdhq3@mail.gmail.com>
 <20100706152539.GG13780@csn.ul.ie>
 <20100706202758.GC18210@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100706202758.GC18210@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 10:27:58PM +0200, Johannes Weiner wrote:
> It bypasses the fs.  On swapon, the blocks are resolved
> (mm/swapfile.c::setup_swap_extents) and then the writeout path uses
> bios directly (mm/page_io.c::swap_writepage).
> 
> (GFP_NOFS still includes __GFP_IO, so allows swapping)

Exactly.  Note that while the stack problems for swap writeout aren't
as bad as for filesystems as the whole allocator / extent map footprint
is missing it might still be an issue.  We still splice the whole block
I/O stack footprint over a random stack that might be filled up a lot.
