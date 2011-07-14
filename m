Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab1GOACe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 20:02:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39498 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab1GOACd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 20:02:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 15 Jul 2011 08:55:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Dave Chinner <david@fromorbit.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
 direct reclaim
Message-Id: <20110715085520.23feca2d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110714150700.GC23587@infradead.org>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-2-git-send-email-mgorman@suse.de>
	<20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714044643.GA3203@infradead.org>
	<20110714134634.4a7a15c8.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714150700.GC23587@infradead.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011 11:07:00 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jul 14, 2011 at 01:46:34PM +0900, KAMEZAWA Hiroyuki wrote:
> > > XFS and btrfs already disable writeback from memcg context, as does ext4
> > > for the typical non-overwrite workloads, and none has fallen apart.
> > > 
> > > In fact there's no way we can enable them as the memcg calling contexts
> > > tend to have massive stack usage.
> > > 
> > 
> > Hmm, XFS/btrfs adds pages to radix-tree in deep stack ?
> 
> We're using a fairly deep stack in normal buffered read/write,
> wich is almost 100% common code.  It's not just the long callchain
> (see below), but also that we put the unneeded kiocb and a vector
> of I/O vects on the stack:
> 
> vfs_writev
> do_readv_writev
> do_sync_write
> generic_file_aio_write
> __generic_file_aio_write
> generic_file_buffered_write
> generic_perform_write
> block_write_begin
> grab_cache_page_write_begin
> add_to_page_cache_lru
> add_to_page_cache
> add_to_page_cache_locked
> mem_cgroup_cache_charge
> 
> this might additionally come from in-kernel callers like nfsd,
> which has even more stack space used.  And at this point we only
> enter the memcg/reclaim code, which last time I had a stack trace
> ate up another about 3k of stack space.
> 

Hmm. I'll prepare 2 functions for memcg 
  1. asynchronous memory reclaim as kswapd does.
  2. dirty_ratio

please remove ->writepage 1st. It may break memcg but it happens sometimes.
We'll do fix.

Thanks,
-Kame

