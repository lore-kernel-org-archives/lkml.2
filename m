Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab2FNN06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:26:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:20297 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab2FNN04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:26:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165644742"
Date: Thu, 14 Jun 2012 21:26:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
Message-ID: <20120614132626.GA14883@localhost>
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
 <x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
 <20120613144840.GA3055@localhost>
 <20120614013533.GB15051@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614013533.GB15051@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 09:35:34AM +0800, Wanpeng Li wrote:
> On Wed, Jun 13, 2012 at 10:48:40PM +0800, Fengguang Wu wrote:
> >Hi Jeff,
> >
> >On Wed, Jun 13, 2012 at 10:27:50AM -0400, Jeff Moyer wrote:
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
> >Yes, in the case of syncing the whole superblock.
> >Basically sync() does its job in two steps:
> >
> >for all sb:
> >        writeback_inodes_sb_nr() # WB_SYNC_NONE
> >        sync_inodes_sb()         # WB_SYNC_ALL
> >
> >> For devices that are really slow, it may make
> >> more sense to tune the system so that you don't have too much writeback
> >> I/O submitted at once.  Dropping nr_requests for the given queue should
> >> fix this situation, I would think.
> >
> >The worried case is about sync() waiting
> >
> >        (nr_dirty + nr_writeback) / write_bandwidth
> >
> >time, where it is nr_dirty that could grow rather large.
> >
> >For example, if dirty threshold is 1GB and write_bandwidth is 10MB/s,
> >the sync() will have to wait for 100 seconds. If there are heavy
> >dirtiers running during the sync, it will typically take several
> >hundreds of seconds (which looks not that good, but still much better
> >than being livelocked in some old kernels)..
> >
> >> This really feels like we're papering over the problem.
> >
> >That's true. The majority users probably don't want to cache 100s
> >worth of data in memory. It may be worthwhile to add a new per-bdi
> >limit whose unit is number-of-seconds (of dirty data).
> Hi Fengguang,
>  
> Maybe we have already have a threshold "dirty_expire_interval" to ensure
> pages will not dirty more than 30 seconds. Why should add a similar
> variable ? I think per-bdi flusher will try its best to flush dirty pages 
> when waken up, just because the backing storages is too slow. :-)

dirty_expire_interval is used to start background writeback and not
used for throttling the dirtier task. So the heavy dirtier can still
outrun the flusher thread and push dirty pages all the way to the
dirty limits.

So to actually keep dirty pages under control 30s, we need some time
based _limit_. However I'm not sure whether we are going to do this.
Because the bandwidth estimation may not be accurate, especially that
it's initialized to an arbitrary 100MB/s for all newly detected disks,
whether it be slow USB keys or fast enterprise SSD. So now you claim
to throttle dirty pages under 30s worth of data, however the user can
still be able to dirty 300s worth of data on a newly plugged USB key.
That makes the interface look silly and not working to user expectations.

Another worry is that it will break some existing workloads because
the new limit triggers throttling for them earlier than before.

Thanks,
Fengguang
