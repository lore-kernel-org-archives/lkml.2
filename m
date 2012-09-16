Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2IPVtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 17:49:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab2IPVtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:49:16 -0400
Date: Sun, 16 Sep 2012 23:49:12 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        viro@zeniv.linux.org.uk, hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120916214912.GA7503@quack.suse.cz>
References: <87wr002z39.fsf@devron.myhome.or.jp>
 <20120913063906.GA24974@localhost>
 <871ui6e4tl.fsf@devron.myhome.or.jp>
 <20120914111429.GA19509@localhost>
 <87r4q4n6r1.fsf@devron.myhome.or.jp>
 <20120914131952.GA4952@quack.suse.cz>
 <87ipbgn2gz.fsf@devron.myhome.or.jp>
 <20120914144543.GB4952@quack.suse.cz>
 <878vccmygy.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vccmygy.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 15-09-12 00:10:53, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> If flusher is working, it clears dirty flags of inode. But if those
> >> handers can't flush at the time, we have to do redirty or something to
> >> prevent the reclaim.
> >   Well, if this is your only problem then I'd see better options than just
> > disabling flusher thread. If the inability to write inode is rare, then
> > redirtying seems like a reasonable option (despite I agree it's a bit
> > ugly). If the inability to write is common, then you'll probably have to do
> > the dirty inode tracking yourself in some list and expose inodes to VM when
> > they are ready to be written. Or you handle writing of inodes yourself but
> > leave writing of pages on flusher thread...
> 
> Basically all data can be data-integrity write like data logging, so it
> would be more than common. And ->writepages() will also ignore WBC_SYNC_NONE.
> 
> > Because when you disable flusher thread completely you have to put all the
> > smarts to avoid livelocks, keep fairness among processes, write old data,
> > keep number of dirty pages under control into your filesystem which leads
> > to a lot of duplication.
> 
> I'm not sure what you meant though. What is the difference with ignoring
> WBC_SYNC_NONE?
  When you completely ignore WB_SYNC_NONE writeback, you'll soon drive the
machine close to dirty limits and processes dirtying pages will get
throttled. Because flusher threads won't be able to write pages - they
do WB_SYNC_NONE writeback when we have too many dirty pages - processes
will be throttled until somebody calls sync(1) or someone writes the data
for some other reason... So I suspect things won't really work as you
expect.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
