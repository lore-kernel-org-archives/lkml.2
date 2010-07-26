Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0GZMrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 08:47:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:11115 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab0GZMrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 08:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,261,1278313200"; 
   d="scan'208";a="538792309"
Date: Mon, 26 Jul 2010 20:47:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/6] writeback: sync expired inodes first in background
 writeback
Message-ID: <20100726124723.GA14937@localhost>
References: <20100722050928.653312535@intel.com>
 <20100722061822.906037624@intel.com>
 <20100726105736.GM5300@csn.ul.ie>
 <20100726120011.GG6284@localhost>
 <20100726122054.GF3280@quack.suse.cz>
 <20100726123141.GA13146@localhost>
 <20100726123907.GG3280@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726123907.GG3280@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 08:39:07PM +0800, Jan Kara wrote:
> On Mon 26-07-10 20:31:41, Wu Fengguang wrote:
> > On Mon, Jul 26, 2010 at 08:20:54PM +0800, Jan Kara wrote:
> > > On Mon 26-07-10 20:00:11, Wu Fengguang wrote:
> > > > On Mon, Jul 26, 2010 at 06:57:37PM +0800, Mel Gorman wrote:
> > > > > On Thu, Jul 22, 2010 at 01:09:32PM +0800, Wu Fengguang wrote:
> > > > > > A background flush work may run for ever. So it's reasonable for it to
> > > > > > mimic the kupdate behavior of syncing old/expired inodes first.
> > > > > > 
> > > > > > The policy is
> > > > > > - enqueue all newly expired inodes at each queue_io() time
> > > > > > - retry with halfed expire interval until get some inodes to sync
> > > > > > 
> > > > > > CC: Jan Kara <jack@suse.cz>
> > > > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > > > 
> > > > > Ok, intuitively this would appear to tie into pageout where we want
> > > > > older inodes to be cleaned first by background flushers to limit the
> > > > > number of dirty pages encountered by page reclaim. If this is accurate,
> > > > > it should be detailed in the changelog.
> > > > 
> > > > Good suggestion. I'll add these lines:
> > > > 
> > > > This is to help reduce the number of dirty pages encountered by page
> > > > reclaim, eg. the pageout() calls. Normally older inodes contain older
> > > > dirty pages, which are more close to the end of the LRU lists. So
> > >   Well, this kind of implicitely assumes that once page is written, it
> > > doesn't get accessed anymore, right?
> > 
> > No, this patch is not evicting the page :)
>   Sorry, I probably wasn't clear enough :) I meant: The claim that "older
> inodes contain older dirty pages, which are more close to the end of the
> LRU lists" assumes that once page is written it doesn't get accessed
> again. For example files which get continual random access (like DB files)
> can have rather old dirtied_when but some of their pages are accessed quite
> often...

Ah yes. That leads to another fact: smaller inodes tend to have more
strong correlations between its inode dirty age and pages' dirty age. 

This is one of the reason to not sync huge dirty inode in one shot.
Instead of

        sync  1G for inode A
        sync 10M for inode B
        sync 10M for inode C
        sync 10M for inode D

It's better to

        sync 128M for inode A
        sync  10M for inode B
        sync  10M for inode C
        sync  10M for inode D
        sync 128M for inode A
        sync 128M for inode A
        sync 128M for inode A
        sync  10M for inode E (newly expired)
        sync 128M for inode A
        ...

Thanks,
Fengguang
