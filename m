Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0JAGBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:01:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0JAGBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:01:03 -0400
Date: Fri, 1 Oct 2010 02:01:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/17] fs: icache lock lru/writeback lists
Message-ID: <20101001060103.GE32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:18:38PM +1000, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> The inode moves between different lists protected by the inode_lock. Introduce
> a new lock that protects all of the lists (dirty, unused, in use, etc) that the
> inode will move around as it changes state. As this is mostly a list for
> protecting the writeback lists, name it wb_inode_list_lock and nest all the
> list manipulations in this lock inside the current inode_lock scope.

As a band-aid to get rid of the inode_lock this might be fine, but I
don't really like it.  For one all the list are per-bdi_writeback, so
the lock should be as well.  Second the lock is held over far too long
periods during writeback, which leads to a lot of whacky trylock
operations and unlock and sleep cycles inside it.  In practice we only
need it in the places where we manipulate the lists.

Also it feels like it really should nest outside i_lock, not inside it,
but I need to look more deeply to figure why that might not easily be
possible.

But maybe all that is better left as a separate patch on top of the
current queue.

