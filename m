Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab0I3VDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 17:03:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:54995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab0I3VDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:03:50 -0400
Date: Thu, 30 Sep 2010 23:02:51 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [2.6.36-rc1] unmount livelock due to racing with bdi-flusher
 threads
Message-ID: <20100930210250.GE3573@quack.suse.cz>
References: <20100821084126.GE31488@dastard>
 <20100913024128.GC411@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913024128.GC411@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 13-09-10 12:41:28, Dave Chinner wrote:
> ping?
  Pong ;) I finally had a look at this. Thanks for reporting this.

> > I just had an umount take a very long time burning a CPU the entire
> > time. It wasn't the unmount thread, either, it was the the bdi
> > flusher thread for the the filesystem being unmounted. It was
> > spinning with this perf top trace:
> > 
> >            553144.00 76.9% writeback_inodes_wb  [kernel.kallsyms]
> >            106434.00 14.8% __ticket_spin_lock   [kernel.kallsyms]
> >             25646.00  3.6% __ticket_spin_unlock [kernel.kallsyms]
> >             10512.00  1.5% _raw_spin_lock       [kernel.kallsyms]
> >              9606.00  1.3% put_super            [kernel.kallsyms]
> >              7920.00  1.1% __put_super          [kernel.kallsyms]
> >              5592.00  0.8% down_read_trylock    [kernel.kallsyms]
> >                46.00  0.0% kfree                [kernel.kallsyms]
> >                22.00  0.0% __do_softirq         [kernel.kallsyms]
> >                19.00  0.0% wb_writeback         [kernel.kallsyms]
> >                16.00  0.0% wb_do_writeback      [kernel.kallsyms]
> >                 8.00  0.0% queue_io             [kernel.kallsyms]
> >                 6.00  0.0% run_timer_softirq    [kernel.kallsyms]
> >                 6.00  0.0% local_bh_enable_ip   [kernel.kallsyms]
> > 
> > This went on for ~7m25s (according to the pmchart trace I had on
> > screen) before something broke the livelock by writing the inodes to
> > disk (maybe the xfssyncd) and the unmount then completed a couple
> > of seconds later.
> > 
> > From the above profile, I'm assuming that writeback_inodes_wb() was
> > seeing pin_sb_for_writeback(sb) failing and moving dirty inodes from
> > the the b_io to the b_more_io list, then being called again,
> > splicing the inodes on b_more_io back to b_io, and then failed again
> > to pin_sb_for_writeback() for each inode, moving them back to the
> > b_more_io list....
> > 
> > This is on 2.6.36-rc1 + the radix tree fixes for writeback.
  Indeed, your analysis looks correct. The trouble is following:

  Flusher thread                           Umount
- start processing background writeback
					   - get s_mount for writing
					   - queue syncing work for flusher
					   - waits until flusher thread
					     gets to it
- loops infinitely, trying to get s_umount
  for reading

In principle a classical ABBA deadlock. Actually, there are more
complicated (and harder to hit) cases like:

  Flusher thread	  Sync				Remount
- processes background
  writeback
			  - gets s_umount for reading
			  - queues syncing work
			  - waits for syncing work
							- tries to get
							  s_umount for writing
							  and blocks
- now loops infinitely
  since it cannot get
  s_umount for reading anymore

The question is how to properly resolve it. The cases like the second one
above show that it's not enough to just somehow work-around writeback
during umount. Also it's not only background writeback that can get
deadlocked like this but generally anything submitted via
__bdi_start_writeback (as these kinds of writeback do not have superblock
specified).

I think the best resolution of this problem would be to change the work
that is submitted via bdi_start_writeback() (i.e., the work without
superblock = work which needs to do locking) to "target based scheme" like
Christoph wanted already some time ago. I actually have a patch to do this
for background writeback so I will just modify it to apply to a wider range
of writeback as well. Or Christoph, do you already have some patches in
this direction?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
