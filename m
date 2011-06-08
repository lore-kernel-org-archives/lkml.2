Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1FHAVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:21:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:27232 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab1FHAVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:21:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="8863807"
Date: Wed, 8 Jun 2011 08:20:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/15] writeback: split inode_wb_list_lock into
 bdi_writeback.list_lock
Message-ID: <20110608002057.GD19547@localhost>
References: <20110607213236.634026193@intel.com>
 <20110607213854.267319164@intel.com>
 <20110607160319.57f27481.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607160319.57f27481.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 07:03:19AM +0800, Andrew Morton wrote:
> On Wed, 08 Jun 2011 05:32:43 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> >  static void bdev_inode_switch_bdi(struct inode *inode,
> >  			struct backing_dev_info *dst)
> >  {
> > -	spin_lock(&inode_wb_list_lock);
> > +	struct backing_dev_info *old = inode->i_data.backing_dev_info;
> > +
> > +	if (unlikely(dst == old))		/* deadlock avoidance */
> > +		return;
> 
> Why does this occur?

That's a fix from Hugh Dickins:

        Yesterday's mmotm hangs at startup, and with lockdep it reports:
        BUG: spinlock recursion on CPU#1, blkid/284 - with bdi_lock_two()
        called from bdev_inode_switch_bdi() in the backtrace.  It appears
        that this function is sometimes called with new the same as old.

The problem becomes clear when looking at bdi_lock_two(), which will
immediately deadlock itself if called with (wb1 == wb2):

  void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2)
  {
          if (wb1 < wb2) {
                  spin_lock(&wb1->list_lock);                                                                         
                  spin_lock_nested(&wb2->list_lock, 1);
          } else {
                  spin_lock(&wb2->list_lock);
                  spin_lock_nested(&wb1->list_lock, 1);
          }
  }

Thanks,
Fengguang
