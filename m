Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2FNBfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:35:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54422 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2FNBfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:35:48 -0400
Date: Thu, 14 Jun 2012 09:35:34 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
Message-ID: <20120614013533.GB15051@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
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
>Hi Jeff,
>
>On Wed, Jun 13, 2012 at 10:27:50AM -0400, Jeff Moyer wrote:
>> Wanpeng Li <liwp.linux@gmail.com> writes:
>> 
>> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> > index f2d0109..df879ee 100644
>> > --- a/fs/fs-writeback.c
>> > +++ b/fs/fs-writeback.c
>> > @@ -1311,7 +1311,11 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>> >  
>> >  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>> >  	bdi_queue_work(sb->s_bdi, &work);
>> > -	wait_for_completion(&done);
>> > +	if (sysctl_hung_task_timeout_secs)
>> > +		while (!wait_for_completion_timeout(&done, HZ/2))
>> > +			;
>> > +	else
>> > +		wait_for_completion(&done);
>> >  }
>> >  EXPORT_SYMBOL(writeback_inodes_sb_nr);
>> 
>> Is it really expected that writeback_inodes_sb_nr will routinely queue
>> up more than 2 seconds worth of I/O (Yes, I understand that it isn't the
>> only entity issuing I/O)? 
>
>Yes, in the case of syncing the whole superblock.
>Basically sync() does its job in two steps:
>
>for all sb:
>        writeback_inodes_sb_nr() # WB_SYNC_NONE
>        sync_inodes_sb()         # WB_SYNC_ALL
>
>> For devices that are really slow, it may make
>> more sense to tune the system so that you don't have too much writeback
>> I/O submitted at once.  Dropping nr_requests for the given queue should
>> fix this situation, I would think.
>
>The worried case is about sync() waiting
>
>        (nr_dirty + nr_writeback) / write_bandwidth
>
>time, where it is nr_dirty that could grow rather large.
>
>For example, if dirty threshold is 1GB and write_bandwidth is 10MB/s,
>the sync() will have to wait for 100 seconds. If there are heavy
>dirtiers running during the sync, it will typically take several
>hundreds of seconds (which looks not that good, but still much better
>than being livelocked in some old kernels)..
>
>> This really feels like we're papering over the problem.
>
>That's true. The majority users probably don't want to cache 100s
>worth of data in memory. It may be worthwhile to add a new per-bdi
>limit whose unit is number-of-seconds (of dirty data).
Hi Fengguang,
 
Maybe we have already have a threshold "dirty_expire_interval" to ensure
pages will not dirty more than 30 seconds. Why should add a similar
variable ? I think per-bdi flusher will try its best to flush dirty pages 
when waken up, just because the backing storages is too slow. :-)

Best Regards,
Wanpeng Li

>
>Thanks,
>Fengguang
