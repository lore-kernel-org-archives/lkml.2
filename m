Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2FMMOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:14:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:15188 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab2FMMOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:14:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165096300"
Date: Wed, 13 Jun 2012 20:14:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] writeback: avoid race when update bandwidth
Message-ID: <20120613121434.GA937@localhost>
References: <1339501561-4570-1-git-send-email-liwp.linux@gmail.com>
 <20120612115219.GA17348@localhost>
 <20120613035920.GV22848@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613035920.GV22848@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 01:59:20PM +1000, Dave Chinner wrote:
> On Tue, Jun 12, 2012 at 07:52:19PM +0800, Fengguang Wu wrote:
> > On Tue, Jun 12, 2012 at 07:46:01PM +0800, Wanpeng Li wrote:
> > > From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> > > 
> > > "V1 -> V2"
> > > * remove dirty_lock
> > > 
> > > Since bdi->wb.list_lock is used to protect the b_* lists,
> > > so the flushers who call wb_writeback to writeback pages will
> > > stuck when bandwidth update policy holds this lock. In order
> > > to avoid this race we can introduce a new bandwidth_lock who
> > > is responsible for protecting bandwidth update policy.
> > > 
> > > Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> > 
> > Applied with a new title "writeback: use a standalone lock for
> > updating write bandwidth". "race" is sensitive because it often
> > refers to some locking error.
> 
> Fengguang - can we get some evidence that this is a contended lock
> before changing the scope of it? All of the previous "breaking up
> global locks" have been done based on lock contention data, so
> moving back to a global lock for this needs to have the same
> analysis provided...

Good point. Attached is the lockstat for the case "10 disks each runs
100 dd dirtier tasks":

        lkp-ne02/JBOD-10HDD-thresh=4G/xfs-100dd-1-3.2.0-rc5

The wb->list_lock contention is much better than I expected, which is
good.  What stand out are
                                                        waittime-total
- &rq->lock             by double_rq_lock()             6738952.13
- clockevents_lock      by clockevents_notify()         2155554.37
- mapping->tree_lock    by test_clear_page_writeback()   931550.13
- sb_lock               by grab_super_passive()          918815.87
- &zone->lru_lock       by pagevec_lru_move_fn()         912681.05

- sysfs_mutex           by sysfs_permission()           24029975.20 # mutex
- ip->i_lock            by xfs_ilock()                  18428284.10 # mrlock

Thanks,
Fengguang
