Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2INNdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:33:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:20133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab2INNdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:33:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,423,1344236400"; 
   d="scan'208";a="222161248"
Date: Fri, 14 Sep 2012 21:33:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120914133300.GA22390@localhost>
References: <87wr002z39.fsf@devron.myhome.or.jp>
 <20120913063906.GA24974@localhost>
 <871ui6e4tl.fsf@devron.myhome.or.jp>
 <20120914111429.GA19509@localhost>
 <87r4q4n6r1.fsf@devron.myhome.or.jp>
 <20120914125312.GA20973@localhost>
 <87mx0sn463.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mx0sn463.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:07:48PM +0900, OGAWA Hirofumi wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> 
> >> The writeback task is always called with sync_mode != WB_SYNC_ALL except
> >> sync_inodes_sb(). But FS has sb->s_op->sync_fs() handler for
> >> sync_inodes_sb() path. So, writeback task just bothers FS to control to
> >> flush.
> >> 
> >> Also it wants to control the reclaimable of inode cache too, because FS
> >> have to control to flush, and wants to use inode in own FS task, and it
> >> knows when inode is cleaned and can be reclaimed.
> >> 
> >> I thought there are 2 options - 1) pin inode with iget(), and iput() on
> >> own FS task, 2) disable writeback task and care about inode reclaim by
> >> dirty flags.
> >> 
> >> (1) was complex (e.g. inode can be the orphan inode), and seems to be
> >> ineffective workaround to survive with writeback task.
> >
> > In principle, the VFS should of course give enough flexibility for the
> > FS. But it's all about the details that matter. As for the
> > BDI_CAP_NO_WRITEBACK approach, I'm afraid you'll not get the expected
> > "FS control" through it. Because the flusher thread may already have a
> > long queue of works which will take long time to finish. It even have
> > its internal background/periodic works that's not controllable this
> > way, see wb_check_background_flush().
> 
> wb_check_background_flush() is called from,
> 
> bdi_forker_thread()
>     bdi_writeback_thread()
>         wb_do_writeback()
>             wb_check_background_flush()
> 
> But, bdi_forker_thread() never start bdi_writeback_thread() if
> !bdi_cap_writeback_dirty(bdi).
> 
> Or I'm seeing something wrong here?

Nothing wrong.

> > And BDI_CAP_NO_WRITEBACK is expected to be a static/constant flag that
> > always evaluate to true/false for a given bdi.  There will be
> > correctness problems if you change the BDI_CAP_NO_WRITEBACK flag
> > dynamically.
> 
> I'm going to use it as static or per-sb by initialized in
> fill_super(). And it uses always BDI_CAP_NO_WRITEBACK if sb is
> available. Because own FS task flush instead.

Ah OK, sorry I didn't quite catch your use case.

But then if you set BDI_CAP_NO_WRITEBACK in the beginning, how come
__bdi_start_writeback() will be called at all?

Thanks,
Fengguang
