Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2INOpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:45:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab2INOpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:45:46 -0400
Date: Fri, 14 Sep 2012 16:45:43 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        viro@zeniv.linux.org.uk, hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120914144543.GB4952@quack.suse.cz>
References: <87wr002z39.fsf@devron.myhome.or.jp>
 <20120913063906.GA24974@localhost>
 <871ui6e4tl.fsf@devron.myhome.or.jp>
 <20120914111429.GA19509@localhost>
 <87r4q4n6r1.fsf@devron.myhome.or.jp>
 <20120914131952.GA4952@quack.suse.cz>
 <87ipbgn2gz.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipbgn2gz.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14-09-12 22:44:28, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> page reclaim and fsync path have FS handler. So, FS can control those.
> >> 
> >> The modern FS have to control to flush carefully. Many FSes are already
> >> ignoring if wbc->sync_mode != WB_SYNC_ALL (e.g. ext3_write_inode,
> >> nilfs_writepages), and have own FS task to flush.
> >   Out of curiosity, what exactly do you need to control in your filesystem
> > that makes flusher thread unusable for you? You still have a lot of
> > flexibility with ->write_inode() and ->writepages() callbacks...
> 
> If flusher is working, it clears dirty flags of inode. But if those
> handers can't flush at the time, we have to do redirty or something to
> prevent the reclaim.
  Well, if this is your only problem then I'd see better options than just
disabling flusher thread. If the inability to write inode is rare, then
redirtying seems like a reasonable option (despite I agree it's a bit
ugly). If the inability to write is common, then you'll probably have to do
the dirty inode tracking yourself in some list and expose inodes to VM when
they are ready to be written. Or you handle writing of inodes yourself but
leave writing of pages on flusher thread...

Because when you disable flusher thread completely you have to put all the
smarts to avoid livelocks, keep fairness among processes, write old data,
keep number of dirty pages under control into your filesystem which leads
to a lot of duplication.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
