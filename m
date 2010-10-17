Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab0JQArN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:47:13 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33165 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab0JQArM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:47:12 -0400
Date: Sat, 16 Oct 2010 20:47:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/19] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101017004710.GC1614@infradead.org>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-5-git-send-email-david@fromorbit.com>
 <20101016092916.GA32197@amd>
 <20101016165930.GA20626@infradead.org>
 <20101016172924.GA3519@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016172924.GA3519@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 04:29:24AM +1100, Nick Piggin wrote:
> > I don't think the pointer check will work either.  By the time we retake
> > the lru lock the inode might already have been reaped through a call
> > to invalidate_inodes.  There's no way we can do anything with it after
> 
> I don't think you're right. If we re take inode_lock, ensure it is on
> the LRU, and call the can_unuse checks, there is no more problem than
> the regular loop taking items from the LRU, AFAIKS.

As long as we have the global inode lock it should indeed be safe.
But once we have a separate lru lock (global or per-zone, with or
without i_lock during the addition) there is nothing preventing the
inode from getting reused and re-added to the lru in the meantime.
Sure this is an extremly unlikely case, but there is no locking to
prevent it once inode_lock is gone.

