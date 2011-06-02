Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab1FBC31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 22:29:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:46392 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759227Ab1FBC3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 22:29:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,307,1304319600"; 
   d="scan'208";a="12316034"
Date: Thu, 2 Jun 2011 10:29:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/18] writeback fixes and cleanups for 2.6.40 (v3)
Message-ID: <20110602022919.GB6015@localhost>
References: <20110519214530.939830917@intel.com>
 <20110523090739.GA27894@infradead.org>
 <20110523092838.GA25829@localhost>
 <20110524032859.GA17429@localhost>
 <20110601153142.0bf83332.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601153142.0bf83332.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Thu, Jun 02, 2011 at 06:31:42AM +0800, Andrew Morton wrote:
> On Tue, 24 May 2011 11:28:59 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Mon, May 23, 2011 at 05:28:38PM +0800, Wu Fengguang wrote:
> > > On Mon, May 23, 2011 at 05:07:39PM +0800, Christoph Hellwig wrote:
> > > > Wu, Andrew,
> > > > 
> > > > what's the plan for these for 2.6.40?  We'll need to make some progress
> > > > in this area, and even if we can't get everything it we should make sure
> > > > to at least include the updated versions of those in -mm.  But even
> > > > some of the later ones are pretty low risk.
> 
> I've been waiting for this work to stabilize a bit more.

Yeah, there were many careful reviews going on thanks to Jan and Dave.

> > > Yes, except for patch 14 which does not include external behavior
> > > changes besides the good full write chunk size for large files, the
> > > patches not in -mm are pretty trivial ones.
> > > 
> > > Aside from my simple tests, Alex also helped going through the LKP
> > > tests with the patchset and find no writeback regressions.
> > 
> > I'll rearrange the series and move patch 14 to the end, so that the
> > patches come in order
> > 
> > - 10 (updated) patches in -mm
> > - 6 more trivial patches that is safe to go upstream after -rc1 
> > - the current patch 14 and patch 16 (that depends on 14)
> 
> I didn't merge the writeback patches for -rc1 due to uncertainty about
> their readiness.  Here's what I'm sitting on:
> 
> 
> writeback-pass-writeback_control-down-to-move_expired_inodes.patch
> writeback-introduce-writeback_controlinodes_cleaned.patch
> writeback-try-more-writeback-as-long-as-something-was-written.patch
> writeback-the-kupdate-expire-timestamp-should-be-a-moving-target.patch
> writeback-sync-expired-inodes-first-in-background-writeback.patch
> writeback-refill-b_io-iff-empty.patch
> writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
> writeback-elevate-queue_io-into-wb_writeback.patch
> writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage.patch
> writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock.patch
> writeback-avoid-extra-sync-work-at-enqueue-time.patch
> 
> Are these all up-todate and considered ready to go?

The v4 patches are the most up-to-date ones. Since the whole patchset
has been re-organized, please drop the -mm patches and take all v4
patches except 06, 17 and 18:

[PATCH 06/18] writeback: sync expired inodes first in background writeback
[PATCH 17/18] writeback: make writeback_control.nr_to_write straight
[PATCH 18/18] writeback: rearrange the wb_writeback() loop

IMHO the other patches are ready to go. The recent updates are mostly code
refactor. For the behavior changes, no writeback regressions show up
in the LKP tests and the dd+tar tests show consistent speedup for ext4
and xfs.
 
> I have a couple of notes I made:
> 
> #writeback-try-more-writeback-as-long-as-something-was-written.patch: sync livelocks
> 
> IOW, someone reported livelocks with sync, or speculated that it might
> cause them.

It's reported by me and then fixed by patch 01 and 02:

[PATCH 01/18] writeback: introduce .tagged_writepages for the WB_SYNC_NONE sync stage
[PATCH 02/18] writeback: update dirtied_when for synced inode to prevent livelock

> #writeback-sync-expired-inodes-first-in-background-writeback.patch: TBU??
> 
> "to be updated".

I've recommended to drop this patch. It cannot be trivially updated
due to either space or CPU overheads and will at least need more
discussions with some numbers collected on the exact CPU overheads.

Thanks,
Fengguang
