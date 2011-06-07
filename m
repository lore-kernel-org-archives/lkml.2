Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab1FGXvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:51:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:45363 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab1FGXvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:51:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="10867248"
Date: Wed, 8 Jun 2011 07:51:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/15] writeback: update dirtied_when for synced inode
 to prevent livelock
Message-ID: <20110607235127.GB19547@localhost>
References: <20110607213236.634026193@intel.com>
 <20110607213853.635444678@intel.com>
 <20110607160245.9270aa27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607160245.9270aa27.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 07:02:45AM +0800, Andrew Morton wrote:
> On Wed, 08 Jun 2011 05:32:38 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Explicitly update .dirtied_when on synced inodes, so that they are no
> > longer considered for writeback in the next round.
> 
> It sounds like this somewhat answers my questions for [1/15].
> 
> But I'm not seeing a description of exactly what caused the livelock.

The exact livelock condition is, during sync(1):

(1) no new inodes are dirtied
(2) an inode being actively dirtied

On (2), the inode will be tagged and synced with .nr_to_write=LONG_MAX.
When finished, it will be redirty_tail()ed because it's still dirty
and (.nr_to_write > 0). redirty_tail() won't update its ->dirtied_when
on condition (1). The sync work will then revisit it on the next
queue_io() and find it eligible again because its old ->dirtied_when
predates the sync work start time.

I'll add the above to the changelog.

> > We'll do more aggressive "keep writeback as long as we wrote something"
> > logic in wb_writeback(). The "use LONG_MAX .nr_to_write" trick in commit
> > b9543dac5bbc ("writeback: avoid livelocking WB_SYNC_ALL writeback") will
> > no longer be enough to stop sync livelock.
> > 
> > It can prevent both of the following livelock schemes:
> > 
> > - while true; do echo data >> f; done
> > - while true; do touch f;        done
> 
> You're kidding.  This livelocks sync(1)?  When did we break this?

There are no reported real cases for "touch f" style livelock.  It's
merely a possibility in theory and the more concurrent meta data
dirties, the more likelihood it will happen.

> Why is this?  Because the inode keeps on getting rotated to head-of-list?

Yes, when the inode is always redirty_tail()ed without updating its
->dirtied_when.

Thanks,
Fengguang
