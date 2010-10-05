Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0JEWa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:30:27 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:49360 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757027Ab0JEWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:30:26 -0400
Date: Wed, 6 Oct 2010 09:30:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/17] fs: icache lock lru/writeback lists
Message-ID: <20101005223022.GL4681@dastard>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-7-git-send-email-david@fromorbit.com>
 <20101001060103.GE32349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001060103.GE32349@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 02:01:03AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:18:38PM +1000, Dave Chinner wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > The inode moves between different lists protected by the inode_lock. Introduce
> > a new lock that protects all of the lists (dirty, unused, in use, etc) that the
> > inode will move around as it changes state. As this is mostly a list for
> > protecting the writeback lists, name it wb_inode_list_lock and nest all the
> > list manipulations in this lock inside the current inode_lock scope.
> 
> As a band-aid to get rid of the inode_lock this might be fine, but I
> don't really like it.  For one all the list are per-bdi_writeback, so
> the lock should be as well.  Second the lock is held over far too long
> periods during writeback, which leads to a lot of whacky trylock
> operations and unlock and sleep cycles inside it.  In practice we only
> need it in the places where we manipulate the lists.

per-bdi writeback lock won't work with the patch set as it stands -
it also protects the LRU which is a global list. I'll have to pull
back another patch to split the LRU and IO lists to make this lock
per-bdi.

> Also it feels like it really should nest outside i_lock, not inside it,
> but I need to look more deeply to figure why that might not easily be
> possible.

Yeah, I'm trying to rework the patch series to not nest anything
inside i_lock. The more I look at all that trylock stuff, the more
my eyes bleed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
