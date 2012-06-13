Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2FMOzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:55:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:60060 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab2FMOzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:55:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165172925"
Date: Wed, 13 Jun 2012 22:55:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
Message-ID: <20120613145516.GA3190@localhost>
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
 <x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
 <20120613144840.GA3055@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613144840.GA3055@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 10:48:40PM +0800, Fengguang Wu wrote:
> Hi Jeff,
> 
> On Wed, Jun 13, 2012 at 10:27:50AM -0400, Jeff Moyer wrote:
> > Wanpeng Li <liwp.linux@gmail.com> writes:
> > 
> > > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > index f2d0109..df879ee 100644
> > > --- a/fs/fs-writeback.c
> > > +++ b/fs/fs-writeback.c
> > > @@ -1311,7 +1311,11 @@ void writeback_inodes_sb_nr(struct super_block *sb,
> > >  
> > >  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> > >  	bdi_queue_work(sb->s_bdi, &work);
> > > -	wait_for_completion(&done);
> > > +	if (sysctl_hung_task_timeout_secs)
> > > +		while (!wait_for_completion_timeout(&done, HZ/2))
> > > +			;
> > > +	else
> > > +		wait_for_completion(&done);
> > >  }
> > >  EXPORT_SYMBOL(writeback_inodes_sb_nr);
> > 
> > Is it really expected that writeback_inodes_sb_nr will routinely queue
> > up more than 2 seconds worth of I/O (Yes, I understand that it isn't the
> > only entity issuing I/O)? 
> 
> Yes, in the case of syncing the whole superblock.
> Basically sync() does its job in two steps:
> 
> for all sb:
>         writeback_inodes_sb_nr() # WB_SYNC_NONE
>         sync_inodes_sb()         # WB_SYNC_ALL
> 
> > For devices that are really slow, it may make
> > more sense to tune the system so that you don't have too much writeback
> > I/O submitted at once.  Dropping nr_requests for the given queue should
> > fix this situation, I would think.

Note that this wait_for_completion() waits for the flusher to move
all dirty pages into writeback pages, which in turn will block in
get_request_wait(). So writeback_inodes_sb_nr() could in theory finish
quickly if the nr_requests is a huge value. But then sync_inodes_sb()
will come and sleep (longer) on each of the writeback pages..

Thanks,
Fengguang
