Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2FMPeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:34:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab2FMPem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:34:42 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
	<x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
	<20120613144840.GA3055@localhost>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 13 Jun 2012 11:34:20 -0400
In-Reply-To: <20120613144840.GA3055@localhost> (Fengguang Wu's message of
	"Wed, 13 Jun 2012 22:48:40 +0800")
Message-ID: <x49lijr8bur.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> Hi Jeff,
>
> On Wed, Jun 13, 2012 at 10:27:50AM -0400, Jeff Moyer wrote:
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
> Yes, in the case of syncing the whole superblock.
> Basically sync() does its job in two steps:
>
> for all sb:
>         writeback_inodes_sb_nr() # WB_SYNC_NONE
>         sync_inodes_sb()         # WB_SYNC_ALL
>
>> For devices that are really slow, it may make
>> more sense to tune the system so that you don't have too much writeback
>> I/O submitted at once.  Dropping nr_requests for the given queue should
>> fix this situation, I would think.
>
> The worried case is about sync() waiting
>
>         (nr_dirty + nr_writeback) / write_bandwidth
>
> time, where it is nr_dirty that could grow rather large.
>
> For example, if dirty threshold is 1GB and write_bandwidth is 10MB/s,
> the sync() will have to wait for 100 seconds. If there are heavy
> dirtiers running during the sync, it will typically take several
> hundreds of seconds (which looks not that good, but still much better
> than being livelocked in some old kernels)..
>
>> This really feels like we're papering over the problem.
>
> That's true. The majority users probably don't want to cache 100s
> worth of data in memory. It may be worthwhile to add a new per-bdi
> limit whose unit is number-of-seconds (of dirty data).

Hi, Fengguang,

Another option is to limit the amount of time we wait to the amount of
time we expect to have to wait.  IOW, if we can estimate the amount of
time we think the I/O will take to complete, we can set the
hung_task_timeout[1] to *that* (with some fudge factor).  Do you have a
mechanism in place today to make such an estimate?  The benefit of this
solution is obvious: you still get notified when tasks are actually
hung, but you don't get false warnings.

Thanks for your quick and detailed response, by the way!

-Jeff

[1] I realize that hung_task_timeout is global.  We could simulate a
per-task timeout by simply looping in wait_for_completion_timeout until
expected_time - waited_time <= hung_task_timeout, and then doing
the wait_for_completion (without the timeout).
