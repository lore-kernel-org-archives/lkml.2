Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0FKQ3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:29:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab0FKQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:29:13 -0400
Date: Fri, 11 Jun 2010 12:29:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100611162912.GC24707@infradead.org>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
 <20100608090811.GA5949@infradead.org>
 <20100608092814.GB27717@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100608092814.GB27717@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:28:14AM +0100, Mel Gorman wrote:
> >  - we also need to care about ->releasepage.  At least for XFS it
> >    can end up in the same deep allocator chain as ->writepage because
> >    it does all the extent state conversions, even if it doesn't
> >    start I/O. 
> 
> Dang.
> 
> >    I haven't managed yet to decode the ext4/btrfs codepaths
> >    for ->releasepage yet to figure out how they release a page that
> >    covers a delayed allocated or unwritten range.
> > 
> 
> If ext4/btrfs are also very deep call-chains and this series is going more
> or less the right direction, then avoiding calling ->releasepage from direct
> reclaim is one, somewhat unfortunate, option. The second is to avoid it on
> a per-filesystem basis for direct reclaim using PF_MEMALLOC to detect
> reclaimers and PF_KSWAPD to tell the difference between direct
> reclaimers and kswapd.

I went throught this a bit more and I can't actually hit that code in
XFS ->releasepage anymore.  I've also audited the caller and can't see
how we could theoretically hit it anymore.  Do the VM gurus know a case
where we would call ->releasepage on a page that's actually dirty and
hasn't been through block_invalidatepage before?

