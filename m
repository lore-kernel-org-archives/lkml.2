Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab0LNPkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:40:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:9138 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab0LNPkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:40:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,342,1288594800"; 
   d="scan'208";a="583623266"
Date: Tue, 14 Dec 2010 23:40:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/35] nfs: in-commit pages accounting and wait queue
Message-ID: <20101214154026.GA8959@localhost>
References: <20101213144646.341970461@intel.com>
 <20101213150329.831955132@intel.com>
 <1292274951.8795.28.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292274951.8795.28.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 05:15:51AM +0800, Trond Myklebust wrote:
> On Mon, 2010-12-13 at 22:47 +0800, Wu Fengguang wrote:
> > plain text document attachment (writeback-nfs-in-commit.patch)
> > When doing 10+ concurrent dd's, I observed very bumpy commits submission
> > (partly because the dd's are started at the same time, and hence reached
> > 4MB to-commit pages at the same time). Basically we rely on the server
> > to complete and return write/commit requests, and want both to progress
> > smoothly and not consume too many pages. The write request wait queue is
> > not enough as it's mainly network bounded. So add another commit request
> > wait queue. Only async writes need to sleep on this queue.
> > 
> 
> I'm not understanding the above reasoning. Why should we serialise
> commits at the per-filesystem level (and only for non-blocking flushes
> at that)?

I did the commit wait queue after seeing this graph, where there is
very bursty pattern of commit submission and hence completion:

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2953M-2.6.37-rc3+-2010-12-03-01/nfs-commit-1000.png

leading to big fluctuations, eg. the almost straight up/straight down
lines below
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2953M-2.6.37-rc3+-2010-12-03-01/vmstat-dirty-300.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2953M-2.6.37-rc3+-2010-12-03-01/dirty-pages.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2953M-2.6.37-rc3+-2010-12-03-01/dirty-pages-200.png

A commit wait queue will help wipe out the "peaks". The "fixed" graph
is
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2952M-2.6.37-rc5+-2010-12-09-03-23/vmstat-dirty-300.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2952M-2.6.37-rc5+-2010-12-09-03-23/dirty-pages.png

Blocking flushes don't need to wait on this queue because they already
throttle themselves by waiting on the inode commit lock before/after
the commit.  They actually should not wait on this queue, to prevent
sync requests being unnecessarily blocked by async ones.

Thanks,
Fengguang
