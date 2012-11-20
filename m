Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2KTUCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:02:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab2KTUC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:02:29 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
        tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous direct I/O requests
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074131.24645.38489.stgit@blackbox.djwong.org>
	<20121120100751.GB1408@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 20 Nov 2012 15:02:15 -0500
In-Reply-To: <20121120100751.GB1408@quack.suse.cz> (Jan Kara's message of
	"Tue, 20 Nov 2012 11:07:51 +0100")
Message-ID: <x49sj84hwl4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> @@ -1279,6 +1280,9 @@ struct ext4_sb_info {
>>  	/* workqueue for dio unwritten */
>>  	struct workqueue_struct *dio_unwritten_wq;
>>  
>> +	/* workqueue for aio+dio+o_sync disk cache flushing */
>> +	struct workqueue_struct *aio_dio_flush_wq;
>> +
>   Umm, I'm not completely decided whether we really need a separate
> workqueue. But it doesn't cost too much so I guess it makes some sense -
> fsync() is rather heavy so syncing won't starve extent conversion...

I'm assuming you'd like me to convert the names from flush to fsync,
yes?

>> +
>> +	/*
>> +	 * If we are running in nojournal mode, just flush the disk
>> +	 * cache and return.
>> +	 */
>> +	if (!journal)
>> +		return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
>   And this is wrong as well - you need to do work similar to what
> ext4_sync_file() does. Actually it would be *much* better if these two
> sites used the same helper function. Which also poses an interesting
> question about locking - do we need i_mutex or not? Forcing a transaction
> commit is definitely OK without it, similarly as grabbing transaction ids
> from inode or ext4_should_journal_data() test. __sync_inode() call seems
> to be OK without i_mutex as well so I believe we can just get rid of it
> (getting i_mutex from the workqueue is a locking nightmare we don't want to
> return to).

Just to be clear, are you saying you would like me to remove the
mutex_lock/unlock pair from ext4_sync_file?  (I had already factored out
the common code between this new code path and the fsync path in my tree.)

>> @@ -149,8 +209,11 @@ void ext4_add_complete_io(ext4_io_end_t *io_end)
>>  	struct workqueue_struct *wq;
>>  	unsigned long flags;
>>  
>> -	BUG_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
>> -	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
>> +	BUG_ON(!ext4_io_end_deferred(io_end));
>> +	if (io_end->flag & EXT4_IO_END_UNWRITTEN)
>> +		wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
>> +	else
>> +		wq = EXT4_SB(io_end->inode->i_sb)->aio_dio_flush_wq;
>   Umm, I'd prefer if we used aio_dio_flush_wq when EXT4_IO_END_NEEDS_SYNC
> is set. That way slow syncing works will be always offloaded to a separate
> workqueue.

OK.

Thanks!
Jeff
