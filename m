Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0DVMsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 08:48:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab0DVMs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 08:48:29 -0400
Date: Thu, 22 Apr 2010 14:48:28 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Denys Fedorysychenko <nuclearcat@nuclearcat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Message-ID: <20100422124827.GA5805@quack.suse.cz>
References: <201003311907.31342.nuclearcat@nuclearcat.com>
 <20100408092850.GA20488@quack.suse.cz>
 <20100419013702.GE2520@dastard>
 <20100419070458.GF2520@dastard>
 <20100421003309.GB4128@quack.suse.cz>
 <20100421015428.GC23541@dastard>
 <20100421132718.GA3327@quack.suse.cz>
 <20100422000652.GD23541@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422000652.GD23541@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-04-10 10:06:52, Dave Chinner wrote:
> On Wed, Apr 21, 2010 at 03:27:18PM +0200, Jan Kara wrote:
> > On Wed 21-04-10 11:54:28, Dave Chinner wrote:
> > > On Wed, Apr 21, 2010 at 02:33:09AM +0200, Jan Kara wrote:
> > > > On Mon 19-04-10 17:04:58, Dave Chinner wrote:
> > > > > The third flush - the sync one - does:
> .....
> > > > > some 75 seconds later having written only 1024 pages. In the mean
> > > > > time, the traces show dd blocked in balance_dirty_pages():
> .....
> > > > > And it appears to stay blocked there without doing any writeback at
> > > > > all - there are no wbc_balance_dirty_pages_written traces at all.
> > > > > That is, it is blocking until the number of dirty pages is dropping
> > > > > below the dirty threshold, then continuing to write and dirty more
> > > > > pages.
> > > >   I think this happens because sync writeback is running so I_SYNC is set
> > > > and thus we cannot do any writeout for the inode from balance_dirty_pages.
> > > 
> > > It's not even calling into writeback so the I_SYNC flag is way out of
> > > scope ;)
> >   Are you sure? The tracepoints are in wb_writeback() but
> > writeback_inodes_wbc() calls directly into writeback_inodes_wb() so you
> > won't see any of the tracepoints to trigger. So how do you know we didn't
> > get to writeback_single_inode?
> 
> The balance_dirty_pages() tracing code added this hunk:
> 
> @@ -536,11 +537,13 @@ static void balance_dirty_pages(struct address_space *mapping,
>                  * threshold otherwise wait until the disk writes catch
>                  * up.
>                  */
> +               trace_wbc_balance_dirty_start(&wbc);
>                 if (bdi_nr_reclaimable > bdi_thresh) {
>                         writeback_inodes_wbc(&wbc);
>                         pages_written += write_chunk - wbc.nr_to_write;
>                         get_dirty_limits(&background_thresh, &dirty_thresh,
>                                        &bdi_thresh, bdi);
> +                       trace_wbc_balance_dirty_written(&wbc);
>                 }
> 
>                 /*
> 
> So if we tried to do writeback from here, the
> wbc_balance_dirty_written trace would have been emitted, and that is
> not showing up very often in any of the traces. e.g:
> 
> $ grep balance t.t |grep start |wc -l
> 4356
> $ grep balance t.t |grep wait |wc -l
> 2171
> $ grep balance t.t |grep written |wc -l
> 7
  Ah, OK. I've missed the 'written' trace. Thanks for explanation. So it
means that enough pages are under writeback and we just wait in
balance_dirty_pages for writes to finish. That works as expected. Fine.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
