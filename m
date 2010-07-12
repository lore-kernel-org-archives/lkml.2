Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0GLDBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 23:01:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57064 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab0GLDBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 23:01:40 -0400
Date: Sun, 11 Jul 2010 23:01:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Li Shaohua <shaohua.li@intel.com>,
        Myklebust Trond <Trond.Myklebust@netapp.com>,
        "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
        Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 31/45] writeback: sync old inodes first in background
 writeback
Message-ID: <20100712030129.GA22769@infradead.org>
References: <20091007073818.318088777@intel.com>
 <20091007074905.131727024@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007074905.131727024@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 03:38:49PM +0800, Wu Fengguang wrote:
> A background flush work may run for ever. So it's reasonable for it to
> mimic the kupdate behavior of syncing old/expired inodes first.

I've looked at this a bit again after you pointed to this thread in
the direct reclaim thread, and I think we should be even more aggressive
in pushing out old inodes.

We basically have two types of I/O done from wb_do_writeback:

 - either we want to write all inodes for a given bdi/superblock.  That
   includes all WB_SYNC_ALL callers, but also things like
   writeback_inodes_sb and the wakeup_flusher_threads call from
   sys_sync.
 - or we have a specific goal, like for the background writeback or
   the wakeup_flusher_threads from free_more_memory.

For the first case there's obviously no point in doing any
older_than_this processing as we write out all inodes anyway.

For the second case we should always do a older_than_this pass _first_.
Rationale: we really should get the old inodes out ASAP, so that we
keep the amount of changes lost on a crash in the boundaries.
Furthermore the callers only need N pages cleaned, and they don't care
where from.  So if we can reach our goal with the older_than_this
writeback we're fine.  If the writeback loop is long enough we can
keep doing more of these later on as well.

Doing this should also help cleaning the code up a bit by moving the
wb_check_old_data_flush logic into wb_writeback and getting rid of the
for_kupdate paramter in struct wb_writeback_work.  I'm not even sure
it's worth keeping it in struct writeback_control.

