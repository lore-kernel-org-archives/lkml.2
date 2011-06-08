Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1FHAgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:36:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067Ab1FHAgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:36:18 -0400
Date: Tue, 7 Jun 2011 17:35:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/15] writeback: split inode_wb_list_lock into
 bdi_writeback.list_lock
Message-Id: <20110607173527.e153478e.akpm@linux-foundation.org>
In-Reply-To: <20110608002057.GD19547@localhost>
References: <20110607213236.634026193@intel.com>
	<20110607213854.267319164@intel.com>
	<20110607160319.57f27481.akpm@linux-foundation.org>
	<20110608002057.GD19547@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011 08:20:57 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Wed, Jun 08, 2011 at 07:03:19AM +0800, Andrew Morton wrote:
> > On Wed, 08 Jun 2011 05:32:43 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > >  static void bdev_inode_switch_bdi(struct inode *inode,
> > >  			struct backing_dev_info *dst)
> > >  {
> > > -	spin_lock(&inode_wb_list_lock);
> > > +	struct backing_dev_info *old = inode->i_data.backing_dev_info;
> > > +
> > > +	if (unlikely(dst == old))		/* deadlock avoidance */
> > > +		return;
> > 
> > Why does this occur?
> 
> That's a fix from Hugh Dickins:

yes, I remember it.  And I remember rubberiness about this at the time ;)

>         Yesterday's mmotm hangs at startup, and with lockdep it reports:
>         BUG: spinlock recursion on CPU#1, blkid/284 - with bdi_lock_two()
>         called from bdev_inode_switch_bdi() in the backtrace.  It appears
>         that this function is sometimes called with new the same as old.
> 
> The problem becomes clear when looking at bdi_lock_two(), which will
> immediately deadlock itself if called with (wb1 == wb2):
> 
>   void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2)
>   {
>           if (wb1 < wb2) {
>                   spin_lock(&wb1->list_lock);                                                                         
>                   spin_lock_nested(&wb2->list_lock, 1);
>           } else {
>                   spin_lock(&wb2->list_lock);
>                   spin_lock_nested(&wb1->list_lock, 1);
>           }
>   }

But why are we asking bdev_inode_switch_bdi() to switch an inode to a
bdi where it already resides?

