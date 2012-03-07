Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2CGFp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:45:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:18839 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2CGFpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:45:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115703520"
Date: Tue, 6 Mar 2012 21:40:49 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Greg Thelen <gthelen@google.com>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] writeback: introduce the pageout work
Message-ID: <20120307054049.GA12256@localhost>
References: <20120228140022.614718843@intel.com>
 <20120228144747.198713792@intel.com>
 <20120228160403.9c9fa4dc.akpm@linux-foundation.org>
 <20120301110404.GC4385@quack.suse.cz>
 <20120301114151.GA19049@localhost>
 <20120301114634.957da8d2.akpm@linux-foundation.org>
 <20120303132555.GA6312@localhost>
 <20120306163742.b71bf57b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306163742.b71bf57b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 04:37:42PM -0800, Andrew Morton wrote:
> On Sat, 3 Mar 2012 21:25:55 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > > > get_page() looks the perfect solution to verify if the struct inode
> > > > pointer (w/o igrab) is still live and valid.
> > > > 
> > > > [...upon rethinking...] Oh but still we need to lock some page to pin
> > > > the inode during the writeout. Then there is the dilemma: if the page
> > > > is locked, we effectively keep it from being written out...
> > > 
> > > No, all you need to do is to structure the code so that after the page
> > > gets unlocked, the kernel thread does not touch the address_space.  So
> > > the processing within the kthread is along the lines of
> > > 
> > > writearound(locked_page)
> > > {
> > > 	write some pages preceding locked_page;	/* touches address_space */
> > 
> > It seems the above line will lead to ABBA deadlock.
> > 
> > At least btrfs will lock a number of pages in lock_delalloc_pages().
> 
> Well, this code locks multiple pages too.  I forget what I did about
> that - probably trylock.  Dirty pages aren't locked for very long.

Yeah, trylock will be OK. And if the filesystems all do trylocks when
writing out any extra pages they try to piggy back, the ABBA deadlock
can be avoided. That makes the get_page()+trylock_page() scheme feasible.

Thanks,
Fengguang
