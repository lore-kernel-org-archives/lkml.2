Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2INNT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:19:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab2INNTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:19:55 -0400
Date: Fri, 14 Sep 2012 15:19:52 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Fengguang Wu <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk,
        jack@suse.cz, hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120914131952.GA4952@quack.suse.cz>
References: <87wr002z39.fsf@devron.myhome.or.jp>
 <20120913063906.GA24974@localhost>
 <871ui6e4tl.fsf@devron.myhome.or.jp>
 <20120914111429.GA19509@localhost>
 <87r4q4n6r1.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4q4n6r1.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14-09-12 21:12:02, OGAWA Hirofumi wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> >> >> @@ -120,6 +120,9 @@ __bdi_start_writeback(struct backing_dev
> >> >>  {
> >> >>  	struct wb_writeback_work *work;
> >> >>  
> >> >> +	if (!bdi_cap_writeback_dirty(bdi))
> >> >> +		return;
> >> >
> >> > Will someone in the current kernel actually call
> >> > __bdi_start_writeback() on a BDI_CAP_NO_WRITEBACK bdi?
> >> >
> >> > If the answer is no, VM_BUG_ON(!bdi_cap_writeback_dirty(bdi)) looks better.
> >> 
> >> I guess nobody call it in current kernel though. Hmm.., but we also have
> >> check in __mark_inode_dirty(), nobody should be using it, right?
> >> 
> >> If we defined it as the bug, I can't see what BDI_CAP_NO_WRITEBACK wants
> >> to do actually.  We are not going to allow to disable the writeback task?
> >
> >> I was going to use this to disable writeback task on my developing FS...
> >
> > That sounds like an interesting use case. Can you elaborate a bit more?
> >
> > Note that even if you disable __bdi_start_writeback() here, the kernel
> > may also start writeback in the page reclaim path, the fsync() path,
> > and perhaps more.
> 
> page reclaim and fsync path have FS handler. So, FS can control those.
> 
> The modern FS have to control to flush carefully. Many FSes are already
> ignoring if wbc->sync_mode != WB_SYNC_ALL (e.g. ext3_write_inode,
> nilfs_writepages), and have own FS task to flush.
  Out of curiosity, what exactly do you need to control in your filesystem
that makes flusher thread unusable for you? You still have a lot of
flexibility with ->write_inode() and ->writepages() callbacks...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
