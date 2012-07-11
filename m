Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab2GKQF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807Ab2GKQF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:05:57 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Deadlocks due to per-process plugging
References: <20120711133735.GA8122@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 11 Jul 2012 12:05:51 -0400
In-Reply-To: <20120711133735.GA8122@quack.suse.cz> (Jan Kara's message of
	"Wed, 11 Jul 2012 15:37:35 +0200")
Message-ID: <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hello,
>
>   we've recently hit a deadlock in our QA runs which is caused by the
> per-process plugging code. The problem is as follows:
>   process A					process B (kjournald)
>   generic_file_aio_write()
>     blk_start_plug(&plug);
>     ...
>     somewhere in here we allocate memory and
>     direct reclaim submits buffer X for IO
>     ...
>     ext3_write_begin()
>       ext3_journal_start()
>         we need more space in a journal
>         so we want to checkpoint old transactions,
>         we block waiting for kjournald to commit
>         a currently running transaction.
> 						journal_commit_transaction()
> 						  wait for IO on buffer X
> 						  to complete as it is part
> 						  of the current transaction
>
>   => deadlock since A waits for B and B waits for A to do unplug.
> BTW: I don't think this is really ext3/ext4 specific. I think other
> filesystems can get into problems as well when direct reclaim submits some
> IO and the process subsequently blocks without submitting the IO.

So, I thought schedule would do the flush.  Checking the code:

asmlinkage void __sched schedule(void)
{
        struct task_struct *tsk = current;

        sched_submit_work(tsk);
        __schedule();
}

And sched_submit_work looks like this:

static inline void sched_submit_work(struct task_struct *tsk)
{
        if (!tsk->state || tsk_is_pi_blocked(tsk))
                return;
        /*
         * If we are going to sleep and we have plugged IO queued,
         * make sure to submit it to avoid deadlocks.
         */
        if (blk_needs_flush_plug(tsk))
                blk_schedule_flush_plug(tsk);
}

This eventually ends in a call to blk_run_queue_async(q) after
submitting the I/O from the plug list.  Right?  So is the question
really why doesn't the kblockd workqueue get scheduled?

Cheers,
Jeff
