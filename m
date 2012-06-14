Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2FNNgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:36:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:55534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab2FNNgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:36:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165647732"
Date: Thu, 14 Jun 2012 21:36:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
Message-ID: <20120614133600.GB14883@localhost>
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
 <x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
 <20120613144840.GA3055@localhost>
 <x49lijr8bur.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49lijr8bur.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Wed, Jun 13, 2012 at 11:34:20AM -0400, Jeff Moyer wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> 
> > Hi Jeff,
> >
> > On Wed, Jun 13, 2012 at 10:27:50AM -0400, Jeff Moyer wrote:
> >> Wanpeng Li <liwp.linux@gmail.com> writes:
> >> 
> >> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> >> > index f2d0109..df879ee 100644
> >> > --- a/fs/fs-writeback.c
> >> > +++ b/fs/fs-writeback.c
> >> > @@ -1311,7 +1311,11 @@ void writeback_inodes_sb_nr(struct super_block *sb,
> >> >  
> >> >  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> >> >  	bdi_queue_work(sb->s_bdi, &work);
> >> > -	wait_for_completion(&done);
> >> > +	if (sysctl_hung_task_timeout_secs)
> >> > +		while (!wait_for_completion_timeout(&done, HZ/2))
> >> > +			;
> >> > +	else
> >> > +		wait_for_completion(&done);
> >> >  }
> >> >  EXPORT_SYMBOL(writeback_inodes_sb_nr);
> >> 
> >> Is it really expected that writeback_inodes_sb_nr will routinely queue
> >> up more than 2 seconds worth of I/O (Yes, I understand that it isn't the
> >> only entity issuing I/O)? 
> >
> > Yes, in the case of syncing the whole superblock.
> > Basically sync() does its job in two steps:
> >
> > for all sb:
> >         writeback_inodes_sb_nr() # WB_SYNC_NONE
> >         sync_inodes_sb()         # WB_SYNC_ALL
> >
> >> For devices that are really slow, it may make
> >> more sense to tune the system so that you don't have too much writeback
> >> I/O submitted at once.  Dropping nr_requests for the given queue should
> >> fix this situation, I would think.
> >
> > The worried case is about sync() waiting
> >
> >         (nr_dirty + nr_writeback) / write_bandwidth
> >
> > time, where it is nr_dirty that could grow rather large.
> >
> > For example, if dirty threshold is 1GB and write_bandwidth is 10MB/s,
> > the sync() will have to wait for 100 seconds. If there are heavy
> > dirtiers running during the sync, it will typically take several
> > hundreds of seconds (which looks not that good, but still much better
> > than being livelocked in some old kernels)..
> >
> >> This really feels like we're papering over the problem.
> >
> > That's true. The majority users probably don't want to cache 100s
> > worth of data in memory. It may be worthwhile to add a new per-bdi
> > limit whose unit is number-of-seconds (of dirty data).
> 
> Hi, Fengguang,
> 
> Another option is to limit the amount of time we wait to the amount of
> time we expect to have to wait.  IOW, if we can estimate the amount of
> time we think the I/O will take to complete, we can set the
> hung_task_timeout[1] to *that* (with some fudge factor).  Do you have a
> mechanism in place today to make such an estimate?  The benefit of this
> solution is obvious: you still get notified when tasks are actually
> hung, but you don't get false warnings.

Good idea! Yes we can do some estimation and adaptively extend the
hang timeout for the current writeback_inodes_sb_nr()/sync_inodes_sb()
call.

Note that it's not going to reliably get rid of false warnings due to
estimation errors, which could be pretty large and unavoidable on
change of workload. But still, it would be a net improvement and
perhaps enough to get rid of most false warnings, while still being
able to catch livelock or other kind of task hang.

Thanks,
Fengguang
