Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0FOQpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:45:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab0FOQpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:45:16 -0400
Date: Tue, 15 Jun 2010 12:45:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100615164507.GA31952@infradead.org>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
 <20100615140011.GD28052@random.random>
 <20100615141122.GA27893@infradead.org>
 <20100615142219.GE28052@random.random>
 <20100615144342.GA3339@infradead.org>
 <20100615150850.GF28052@random.random>
 <20100615153838.GO26788@csn.ul.ie>
 <20100615161419.GH28052@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615161419.GH28052@random.random>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 06:14:19PM +0200, Andrea Arcangeli wrote:
> Again not what looks like from the stack trace. Also grepping for
> PF_MEMALLOC in fs/xfs shows nothing. In fact it's ext4_write_inode
> that skips the write if PF_MEMALLOC is set, not writepage apparently
> (only did a quick grep so I might be wrong). I suspect
> ext4_write_inode is the case I just mentioned about slab shrink, not
> ->writepage ;).
> 
> inodes are small, it's no big deal to keep an inode pinned and not
> slab-reclaimable because dirty, while skipping real writepage in
> memory pressure could really open a regression in oom false positives!
> One pagecache much bigger than one inode and there can be plenty more
> dirty pagecache than inodes.

Btw, those comments in ext3/ext4 don't make much sense.  The only
time iput_final ever calls into ->write_inode is when the filesystem
is beeing unmounted, which never happens with PF_MEMALLOC set.

