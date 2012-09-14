Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab2INMxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:53:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:58393 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab2INMxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:53:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,422,1344236400"; 
   d="scan'208";a="222147148"
Date: Fri, 14 Sep 2012 20:53:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120914125312.GA20973@localhost>
References: <87wr002z39.fsf@devron.myhome.or.jp>
 <20120913063906.GA24974@localhost>
 <871ui6e4tl.fsf@devron.myhome.or.jp>
 <20120914111429.GA19509@localhost>
 <87r4q4n6r1.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4q4n6r1.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 09:12:02PM +0900, OGAWA Hirofumi wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> 
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

Yeah, that test is mainly to improve IO efficiency for
non-data-integrity writes.

> The writeback task is always called with sync_mode != WB_SYNC_ALL except
> sync_inodes_sb(). But FS has sb->s_op->sync_fs() handler for
> sync_inodes_sb() path. So, writeback task just bothers FS to control to
> flush.
> 
> Also it wants to control the reclaimable of inode cache too, because FS
> have to control to flush, and wants to use inode in own FS task, and it
> knows when inode is cleaned and can be reclaimed.
> 
> I thought there are 2 options - 1) pin inode with iget(), and iput() on
> own FS task, 2) disable writeback task and care about inode reclaim by
> dirty flags.
> 
> (1) was complex (e.g. inode can be the orphan inode), and seems to be
> ineffective workaround to survive with writeback task.

In principle, the VFS should of course give enough flexibility for the
FS. But it's all about the details that matter. As for the
BDI_CAP_NO_WRITEBACK approach, I'm afraid you'll not get the expected
"FS control" through it. Because the flusher thread may already have a
long queue of works which will take long time to finish. It even have
its internal background/periodic works that's not controllable this
way, see wb_check_background_flush().

And BDI_CAP_NO_WRITEBACK is expected to be a static/constant flag that
always evaluate to true/false for a given bdi.  There will be
correctness problems if you change the BDI_CAP_NO_WRITEBACK flag
dynamically.

Thanks,
Fengguang
