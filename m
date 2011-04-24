Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1DXDPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 23:15:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:50757 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab1DXDPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 23:15:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,261,1301900400"; 
   d="scan'208";a="633196592"
Date: Sun, 24 Apr 2011 11:15:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] writeback: sync expired inodes first in background
 writeback
Message-ID: <20110424031531.GA11220@localhost>
References: <20110420080336.441157866@intel.com>
 <20110420080918.383880412@intel.com>
 <20110420164005.e3925965.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420164005.e3925965.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One of the many requirements for writeback is that if userspace is
> continually dirtying pages in a particular file, that shouldn't cause
> the kupdate function to concentrate on that file's newly-dirtied pages,
> neglecting pages from other files which were less-recently dirtied. 
> (and dirty nodes, etc).

Sadly I do find the old pages that the flusher never get a chance to
catch and write them out.

In the below case, if the task dirties pages fast enough at the end of
file, writeback_index will never get a chance to wrap back. There may
be various variations of this case.

file head
[          ***                        ==>***************]==>
           old pages          writeback_index            fresh dirties

Ironically the current kernel relies on pageout() to catch these
old pages, which is not only inefficient, but also not reliable.
If a full LRU walk takes an hour, the old pages may stay dirtied
for an hour.

We may have to do (conditional) tagged ->writepages to safeguard users
from losing data he'd expect to be written hours ago.

Thanks,
Fengguang
