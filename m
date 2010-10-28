Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0J1KZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 06:25:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48573 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab0J1KZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 06:25:29 -0400
Date: Thu, 28 Oct 2010 06:25:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fs: Lock the inode LRU list separately
Message-ID: <20101028102521.GA6141@infradead.org>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-4-git-send-email-david@fromorbit.com>
 <20101027090530.GB16443@infradead.org>
 <20101027222444.GC2715@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027222444.GC2715@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That doesn't happen because the counter is only modified when
> the inode is moved on/off the list and there are checks to avoid
> removing an inode that is not on the list. Also, the inode is not
> removed from the LRU in dispose_one_inode - it is always done when
> the inode is marked I_FREEING while the i_lock is held before
> calling dispose_one_inode().
> 
> Basically I wanted to remove the strange "inode is not on the LRU if
> it is dirty or under writeback" accounting checks and make the
> accounting symmetric with adding/removing the inodes from the LRU.
> These are protected by list_empty() checks, so should always end up
> with the correct accounting.
> 
> hence the only special case now is prune_icache() which already
> holds the inode_lru_lock() so can't call the helper. Besides, we
> don't need any checks there because we know the inode is on the LRU
> already....

Indeed.  What about adding a

	BUG_ON(!list_empty(&inode->i_lru));

to evict to ensure this invariant?

