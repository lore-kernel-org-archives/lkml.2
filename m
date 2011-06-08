Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1FHBgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:36:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:9256 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713Ab1FHBgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:36:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="8893706"
Date: Wed, 8 Jun 2011 09:36:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/15] writeback: split inode_wb_list_lock into
 bdi_writeback.list_lock
Message-ID: <20110608013648.GA27934@localhost>
References: <20110607213236.634026193@intel.com>
 <20110607213854.267319164@intel.com>
 <20110607160319.57f27481.akpm@linux-foundation.org>
 <20110608002057.GD19547@localhost>
 <20110607173527.e153478e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607173527.e153478e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 08:35:27AM +0800, Andrew Morton wrote:
> On Wed, 8 Jun 2011 08:20:57 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Wed, Jun 08, 2011 at 07:03:19AM +0800, Andrew Morton wrote:
> > > On Wed, 08 Jun 2011 05:32:43 +0800
> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > >  static void bdev_inode_switch_bdi(struct inode *inode,
> > > >  			struct backing_dev_info *dst)
> > > >  {
> > > > -	spin_lock(&inode_wb_list_lock);
> > > > +	struct backing_dev_info *old = inode->i_data.backing_dev_info;
> > > > +
> > > > +	if (unlikely(dst == old))		/* deadlock avoidance */
> > > > +		return;
> > > 
> > > Why does this occur?
> > 
> > That's a fix from Hugh Dickins:
> 
> yes, I remember it.  And I remember rubberiness about this at the time ;)
> 
> >         Yesterday's mmotm hangs at startup, and with lockdep it reports:
> >         BUG: spinlock recursion on CPU#1, blkid/284 - with bdi_lock_two()
> >         called from bdev_inode_switch_bdi() in the backtrace.  It appears
> >         that this function is sometimes called with new the same as old.
> > 
> > The problem becomes clear when looking at bdi_lock_two(), which will
> > immediately deadlock itself if called with (wb1 == wb2):
> > 
> >   void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2)
> >   {
> >           if (wb1 < wb2) {
> >                   spin_lock(&wb1->list_lock);                                                                         
> >                   spin_lock_nested(&wb2->list_lock, 1);
> >           } else {
> >                   spin_lock(&wb2->list_lock);
> >                   spin_lock_nested(&wb1->list_lock, 1);
> >           }
> >   }
> 
> But why are we asking bdev_inode_switch_bdi() to switch an inode to a
> bdi where it already resides?

That's definitely an interesting problem.

I suspect it to be some inode pointing to &default_backing_dev_info
switches to the same &default_backing_dev_info, and did manage to
catch one such case, called from __blkdev_get():

        1196  out_clear:
        1197         disk_put_part(bdev->bd_part);
        1198         bdev->bd_disk = NULL;
        1199         bdev->bd_part = NULL;
        1200         WARN_ON(bdev->bd_inode->i_data.backing_dev_info ==
        1201                 &default_backing_dev_info);
==>     1202         bdev_inode_switch_bdi(bdev->bd_inode, &default_backing_dev_info);
        1203         if (bdev != bdev->bd_contains)
        1204                 __blkdev_put(bdev->bd_contains, mode, 1);
        1205         bdev->bd_contains = NULL;

The debug call trace is:

[   88.751130] ------------[ cut here ]------------
[   88.751546] WARNING: at /c/wfg/linux-next/fs/block_dev.c:1201 __blkdev_get+0x38a/0x40a()
[   88.752201] Hardware name:
[   88.752554] Modules linked in:
[   88.752866] Pid: 3214, comm: blkid Not tainted 3.0.0-rc2-next-20110607+ #372
[   88.753354] Call Trace:
[   88.753610]  [<ffffffff810700e0>] warn_slowpath_common+0x85/0x9d
[   88.753987]  [<ffffffff81070112>] warn_slowpath_null+0x1a/0x1c
[   88.754428]  [<ffffffff8116c57e>] __blkdev_get+0x38a/0x40a
[   88.754798]  [<ffffffff8116c8e3>] ? blkdev_get+0x2e5/0x2e5
[   88.755238]  [<ffffffff8116c7cb>] blkdev_get+0x1cd/0x2e5
[   88.755622]  [<ffffffff8192817b>] ? _raw_spin_unlock+0x2b/0x2f
[   88.759131]  [<ffffffff8116c8e3>] ? blkdev_get+0x2e5/0x2e5
[   88.759527]  [<ffffffff8116c961>] blkdev_open+0x7e/0x82
[   88.759896]  [<ffffffff8113e84f>] __dentry_open+0x1c8/0x31d
[   88.760341]  [<ffffffff8192817b>] ? _raw_spin_unlock+0x2b/0x2f
[   88.760737]  [<ffffffff8113f65c>] nameidata_to_filp+0x48/0x4f
[   88.761126]  [<ffffffff8114bafa>] do_last+0x5c8/0x71f
[   88.761552]  [<ffffffff8114cd7b>] path_openat+0x29d/0x34f
[   88.761932]  [<ffffffff8114ce6a>] do_filp_open+0x3d/0x89
[   88.762367]  [<ffffffff8192817b>] ? _raw_spin_unlock+0x2b/0x2f
[   88.762765]  [<ffffffff811577a1>] ? alloc_fd+0x10b/0x11d
[   88.763200]  [<ffffffff8113f771>] do_sys_open+0x10e/0x1a0
[   88.763581]  [<ffffffff81111813>] ? __do_fault+0x29a/0x46e
[   88.763960]  [<ffffffff8113f823>] sys_open+0x20/0x22
[   88.764380]  [<ffffffff8192ed42>] system_call_fastpath+0x16/0x1b
[   88.764782] ---[ end trace 28100c425ce9e560 ]---


Thanks,
Fengguang
