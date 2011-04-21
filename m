Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1DUHJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 03:09:52 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16261 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab1DUHJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 03:09:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEEALrWr015LHHJgWdsb2JhbAClRhUBARYmJcYQDoVoBA
Date: Thu, 21 Apr 2011 17:09:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 5/6] writeback: try more writeback as long as something
 was written
Message-ID: <20110421070947.GA12436@dastard>
References: <20110419030003.108796967@intel.com>
 <20110419030532.778889102@intel.com>
 <20110419102016.GD5257@quack.suse.cz>
 <20110419111601.GA18961@localhost>
 <20110419211008.GD9556@quack.suse.cz>
 <20110420075053.GB30672@localhost>
 <20110420152211.GC4991@quack.suse.cz>
 <20110421033325.GA13764@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421033325.GA13764@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 11:33:25AM +0800, Wu Fengguang wrote:
> I collected the writeback_single_inode() traces (patch attached for
> your reference) each for several test runs, and find much more
> I_DIRTY_PAGES after patchset. Dave, do you know why there are so many
> I_DIRTY_PAGES (or radix tag) remained after the XFS ->writepages() call,
> even for small files?
> 
> wfg /tmp% g -c I_DIRTY_PAGES trace-*
> trace-moving-expire-1:28213
> trace-no-moving-expire:6684
> 
> wfg /tmp% g -c I_DIRTY_DATASYNC trace-*
> trace-moving-expire-1:179
> trace-no-moving-expire:193
> 
> wfg /tmp% g -c I_DIRTY_SYNC trace-* 
> trace-moving-expire-1:29394
> trace-no-moving-expire:31593
> 
> wfg /tmp% wc -l trace-*
>    81108 trace-moving-expire-1
>    68562 trace-no-moving-expire

Likely just timing. When IO completes and updates the inode IO size,
XFS calls mark_inode_dirty() again to ensure that the metadata that
was changed gets written out at a later point in time.
Hence every single file that is created by the test will be marked
dirty again after the first write has returned and disappeared.

Why you see different numbers? it's timing dependent based on Io
completion rates - if you have a fast disk the IO completion can
occur before write_inode() is called and so the inode can be written
and the dirty page state removed in the one writeback_single_inode()
call...

That's my initial guess without looking at it in any real detail,
anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
