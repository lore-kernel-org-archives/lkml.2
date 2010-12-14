Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab0LNP53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:57:29 -0500
Received: from mx2.netapp.com ([216.240.18.37]:56463 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759407Ab0LNP52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:57:28 -0500
X-IronPort-AV: E=Sophos;i="4.59,342,1288594800"; 
   d="scan'208";a="494766179"
Subject: Re: [PATCH 29/35] nfs: in-commit pages accounting and wait queue
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
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
In-Reply-To: <20101214154026.GA8959@localhost>
References: <20101213144646.341970461@intel.com>
	 <20101213150329.831955132@intel.com>
	 <1292274951.8795.28.camel@heimdal.trondhjem.org>
	 <20101214154026.GA8959@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Tue, 14 Dec 2010 10:57:25 -0500
Message-ID: <1292342245.2976.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 14 Dec 2010 15:57:27.0084 (UTC) FILETIME=[9AE69EC0:01CB9BA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 23:40 +0800, Wu Fengguang wrote:
> On Tue, Dec 14, 2010 at 05:15:51AM +0800, Trond Myklebust wrote:
> > On Mon, 2010-12-13 at 22:47 +0800, Wu Fengguang wrote:
> > > plain text document attachment (writeback-nfs-in-commit.patch)
> > > When doing 10+ concurrent dd's, I observed very bumpy commits submission
> > > (partly because the dd's are started at the same time, and hence reached
> > > 4MB to-commit pages at the same time). Basically we rely on the server
> > > to complete and return write/commit requests, and want both to progress
> > > smoothly and not consume too many pages. The write request wait queue is
> > > not enough as it's mainly network bounded. So add another commit request
> > > wait queue. Only async writes need to sleep on this queue.
> > > 
> > 
> > I'm not understanding the above reasoning. Why should we serialise
> > commits at the per-filesystem level (and only for non-blocking flushes
> > at that)?
> 
> I did the commit wait queue after seeing this graph, where there is
> very bursty pattern of commit submission and hence completion:
> 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2953M-2.6.37-rc3+-2010-12-03-01/nfs-commit-1000.png
> 
> leading to big fluctuations, eg. the almost straight up/straight down
> lines below
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2953M-2.6.37-rc3+-2010-12-03-01/vmstat-dirty-300.png
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2953M-2.6.37-rc3+-2010-12-03-01/dirty-pages.png
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2953M-2.6.37-rc3+-2010-12-03-01/dirty-pages-200.png
> 
> A commit wait queue will help wipe out the "peaks". The "fixed" graph
> is
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2952M-2.6.37-rc5+-2010-12-09-03-23/vmstat-dirty-300.png
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/nfs-100dd-1M-8p-2952M-2.6.37-rc5+-2010-12-09-03-23/dirty-pages.png
> 
> Blocking flushes don't need to wait on this queue because they already
> throttle themselves by waiting on the inode commit lock before/after
> the commit.  They actually should not wait on this queue, to prevent
> sync requests being unnecessarily blocked by async ones.

OK, but isn't it better then to just abort the commit, and have the
relevant async process retry it later?

This is a code path which is followed by kswapd, for instance. It seems
dangerous to be throttling that instead of allowing it to proceed (and
perhaps being able to free up memory on some other partition in the mean
time).

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

