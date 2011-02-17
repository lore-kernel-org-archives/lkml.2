Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1BQKcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 05:32:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1BQKcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 05:32:16 -0500
Date: Thu, 17 Feb 2011 11:32:14 +0100
From: Jan Kara <jack@suse.cz>
To: Feng Tang <feng.tang@intel.com>
Cc: Jan Kara <jack@suse.cz>, "op.q.liu@gmail.com" <op.q.liu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: ext2 write performance regression from 2.6.32
Message-ID: <20110217103214.GA4947@quack.suse.cz>
References: <AANLkTinES_gU=MxbSnidorsKDsMnAwzHVx+yntOLCf=f@mail.gmail.com>
 <AANLkTikvpyTPVnP1cxC4rSLARO3thpscyhmB4=BpFW-G@mail.gmail.com>
 <20110215144641.05318556@feng-i7>
 <20110215111126.GD17313@quack.suse.cz>
 <AANLkTikGdud4FX0TcC-Sf_-_V-i8doZ73m63B=JA4kWp@mail.gmail.com>
 <20110216174031.183180c4@feng-i7>
 <20110216143530.GA5592@quack.suse.cz>
 <20110217140846.2196b756@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217140846.2196b756@feng-i7>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-02-11 14:08:46, Feng Tang wrote:
> On Wed, 16 Feb 2011 22:35:30 +0800
> Jan Kara <jack@suse.cz> wrote:
> > On Wed 16-02-11 17:40:31, Feng Tang wrote:
> > > Hi,
> > > 
> > > I made out a debug patch which try to delay the pure FS metadata
> > > writeback (maxim 30 seconds to match current writeback expire
> > > time). It works for me on 2.6.32, and the dd performance is
> > > restored.
> > > 
> > > Please help to review it, thanks!
> > > 
> > > btw, I've sent out the block dump info requested by Jan Kara, but
> > > didn't see it on LKML, so attached them again.
> > > 
> > > - Feng
> > > 
> > > From c35548c7d0c3a334d24c26adab277ef62b9825db Mon Sep 17 00:00:00
> > > 2001 From: Feng Tang <feng.tang@intel.com>
> > > Date: Wed, 16 Feb 2011 17:27:36 +0800
> > > Subject: [PATCH] writeback: delay the file system metadata
> > > writeback in 30 seconds
> > > 
> > > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > > ---
> > >  fs/fs-writeback.c |   10 ++++++++++
> > >  1 files changed, 10 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > index 9d5360c..418fd9e 100644
> > > --- a/fs/fs-writeback.c
> > > +++ b/fs/fs-writeback.c
> > > @@ -635,6 +635,16 @@ static void writeback_inodes_wb(struct
> > > bdi_writeback *wb, continue;
> > >  		}
> > >  
> > > +		if ((wbc->sync_mode != WB_SYNC_ALL)
> > > +			&& !inode->i_ino
> > > +			&& !strcmp(inode->i_sb->s_id, "bdev")) {
> > > +			if (inode->dirtied_when + 30 * HZ >
> > > jiffies) {
> > > +				list_move(&inode->i_list,
> > > &wb->b_dirty);
> > > +				continue;
> > > +			} 
> > > +		}
> > > +
> > > +
> >   Doh, this is a crude hack! Nice for debugging but no way to get
> > this into the kernel. We have to find a cleaner way to speedup the
> > writeback...
> 
> I just tested you 5 writeback patches, and they don't fix the problem,
> the FS metadata are still periodically written back every one or two
> seconds. Attached the block dump on 2.6.37 + your patches.
Yes, so I didn't expect the writeout of metadata will disappear, just the
IO pattern should be better. So you didn't observe any change in throughput
with my patches vs without them?

Looking at the block trace, we write about 8 MB of data before doing
metadata writeback. That's about the best what I'd expect with current
writeback settings so things worked as expected.

Hmm, but probably flash card is simple and does not have any
Flash Translation Layer and so each write of one metadata block costs us as
a rewrite of the whole erase block which may well be in a MB range? That
would explain it. Raising MAX_WRITEBACK_PAGES would help here but given
the throughput of the flash card, the fairness of writeback when there are
more inodes to write would be already rather bad so that's not a good
solution either.
 
> And ye, I agree my patch is kinds of hacky, but its main point is
> to delay the file system metadata writeback (no longer than current
> writeback expiration limit: 30 seconds) to make the normal data pages
> writeback as sequential as possible. Could we go on tuning it in this
> direction?
Apart from my aesthetical feelings, the patch brings also some technical
difficulties. For example if lots of dirtying happens against device inode
(metadata heavy workload), we need to push out dirty pages from the device
inode to clean dirty memory. Otherwise the processes would just stall in
balance_dirty_pages() for 30 s waiting for pages to get cleaned. Another
issue is that under heavier load, the inode will get redirtied while you
are writing metadata. Thus i_dirtied_when need not change.  Finally, if the
load is not so trivial like your single dd write, but there happens also
some other activity in the filesystem (like syslog writing to the device
once in a while or so), then your large dd write will be mixed with small
writes to other files anyway and thus performance will degrade.

That being said I don't see an easy solution to your problem. The fact that
2.6.30 didn't write metadata was more a bug than a feature but happened to
work good for your flash card. A solution that comes to my mind is that we
could have a "write chunk size" parameter in each BDI (it would make sense
not only for flash devices but also for RAID) and writeback would be aware
that written amount is always rounded up to "write chunk size". This
ignores filesystem fragmentation but that might be dealt with. And if we
are doing well with cleaning pages, we may skip writes that have small
cleaned_pages / write_chunk_size ratio. But we'd have to be careful not to
delay such "inprofitable" writes for too long. So it's not so easy to
implement this.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
