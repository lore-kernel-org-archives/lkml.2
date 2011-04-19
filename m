Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab1DSHGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:06:32 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4103 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab1DSHGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:06:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMEAIQzrU15LHHJgWdsb2JhbAClQhUBARYmJcV9DoVjBA
Date: Tue, 19 Apr 2011 17:02:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 2/6] writeback: the kupdate expire timestamp should be
 a moving target
Message-ID: <20110419070247.GE23985@dastard>
References: <20110419030003.108796967@intel.com>
 <20110419030532.392203618@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419030532.392203618@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 11:00:05AM +0800, Wu Fengguang wrote:
> Dynamically compute the dirty expire timestamp at queue_io() time.
> 
> writeback_control.older_than_this used to be determined at entrance to
> the kupdate writeback work. This _static_ timestamp may go stale if the
> kupdate work runs on and on. The flusher may then stuck with some old
> busy inodes, never considering newly expired inodes thereafter.
> 
> This has two possible problems:
> 
> - It is unfair for a large dirty inode to delay (for a long time) the
>   writeback of small dirty inodes.
> 
> - As time goes by, the large and busy dirty inode may contain only
>   _freshly_ dirtied pages. Ignoring newly expired dirty inodes risks
>   delaying the expired dirty pages to the end of LRU lists, triggering
>   the evil pageout(). Nevertheless this patch merely addresses part
>   of the problem.

When wb_writeback() is called with for_kupdate set, it initialises
wbc->older_than_this appropriately outside the writeback loop.
queue_io() is called once per writeback_inodes_wb() call, which is
once per loop in wb_writeback. All your change does is re-initialise
older_than_this once per loop in wb_writeback, jus tin a different
and very non-obvious place.

So why didn't you just re-initialise it inside the loop in
wb_writeback() and leave all the other code alone?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
