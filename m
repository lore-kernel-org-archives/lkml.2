Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0JXONV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 10:13:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab0JXONU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 10:13:20 -0400
Date: Sun, 24 Oct 2010 10:13:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101024141310.GA21513@infradead.org>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
 <20101022031431.GK12506@dastard>
 <20101022103705.GK19804@ZenIV.linux.org.uk>
 <20101023213752.GR19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023213752.GR19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 10:37:52PM +0100, Al Viro wrote:
> 	* invalidate_inodes() - collect I_FREEING/I_WILL_FREE on a separate
> list, then (after we'd evicted the stuff we'd decided to evict) wait until
> they get freed by whatever's freeing them already.

Note that we would only have to do this for the umount case.  For others
it's pretty pointless.

But I think there's a better way to do it, and that's per-sb inode lru
lists.  By adopting the scheme from prune_dcache we'd always have
s_umount exclusive for inode reclaims, and per defintion we would not
have any ongoing reclaim when we do enter umount.  It would also allow
us to get rid of iprune_sem and the nasty unsolved locking issues it
causes.

