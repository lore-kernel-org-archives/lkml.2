Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2INLSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:18:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:53290 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab2INLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:18:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,422,1344236400"; 
   d="scan'208";a="222123135"
Date: Fri, 14 Sep 2012 19:18:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120914111847.GB19509@localhost>
References: <87wr002z39.fsf@devron.myhome.or.jp>
 <20120913063906.GA24974@localhost>
 <871ui6e4tl.fsf@devron.myhome.or.jp>
 <87wqzwn9ha.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqzwn9ha.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 08:13:05PM +0900, OGAWA Hirofumi wrote:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> 
> > Fengguang Wu <fengguang.wu@intel.com> writes:
> >
> >> On Wed, Sep 12, 2012 at 03:28:42AM +0900, OGAWA Hirofumi wrote:
> >>> 
> >>> If bdi has BDI_CAP_NO_WRITEBACK, bdi_forker_thread() doesn't start
> >>> writeback thread. This means there is no consumer of work item made
> >>> by bdi_queue_work().
> >>> 
> >>> This adds to checking of !bdi_cap_writeback_dirty(sb->s_bdi) before
> >>> calling bdi_queue_work(), otherwise queued work never be consumed.
> >>> 
> >>> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> >>> ---
> >>> 
> >>>  fs/fs-writeback.c |    7 +++++--
> >>>  1 file changed, 5 insertions(+), 2 deletions(-)
> >>> 
> >>> diff -puN fs/fs-writeback.c~noop_backing_dev_info-check-fix fs/fs-writeback.c
> >>> --- linux/fs/fs-writeback.c~noop_backing_dev_info-check-fix	2012-09-11 06:12:30.000000000 +0900
> >>> +++ linux-hirofumi/fs/fs-writeback.c	2012-09-11 06:12:30.000000000 +0900
> >>> @@ -120,6 +120,9 @@ __bdi_start_writeback(struct backing_dev
> >>>  {
> >>>  	struct wb_writeback_work *work;
> >>>  
> >>> +	if (!bdi_cap_writeback_dirty(bdi))
> >>> +		return;
> >>
> >> Will someone in the current kernel actually call
> >> __bdi_start_writeback() on a BDI_CAP_NO_WRITEBACK bdi?
> >>
> >> If the answer is no, VM_BUG_ON(!bdi_cap_writeback_dirty(bdi)) looks better.
> >
> > I guess nobody call it in current kernel though. Hmm.., but we also have
> > check in __mark_inode_dirty(), nobody should be using it, right?
> >
> > If we defined it as the bug, I can't see what BDI_CAP_NO_WRITEBACK wants
> > to do actually.  We are not going to allow to disable the writeback task?
> 
> ping.
> 
> You are saying we should change bdi_cap_writeback_dirty(bdi) to
> VM_BUG_ON() too in __mark_inode_dirty()? And probably, you are going to
> remove the usage of BDI_CAP_NO_WRITEBACK for sb->s_bdi?

No, I'm talking about this chunk only. My feeling is, adding the
bdi_cap_writeback_dirty() detection in __bdi_start_writeback() sounds
too late. If ever the test is false, it may well indicate a bug in the
callers. Obviously the callers all assume success because
__bdi_start_writeback() does not even return a value.

Thanks,
Fengguang
