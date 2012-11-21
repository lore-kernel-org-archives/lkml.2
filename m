Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2KUQ6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:58:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab2KUQ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:58:30 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
        tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 1/9] vfs: Handle O_SYNC AIO DIO in generic code properly
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074123.24645.41965.stgit@blackbox.djwong.org>
	<20121121100809.GE23339@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Nov 2012 11:58:05 -0500
In-Reply-To: <20121121100809.GE23339@infradead.org> (Christoph Hellwig's
	message of "Wed, 21 Nov 2012 05:08:09 -0500")
Message-ID: <x497gpevqoy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Nov 19, 2012 at 11:41:23PM -0800, Darrick J. Wong wrote:
>> Provide VFS helpers for handling O_SYNC AIO DIO writes.  Filesystems wanting to
>> use the helpers have to pass DIO_SYNC_WRITES to __blockdev_direct_IO.  If the
>> filesystem doesn't provide its own direct IO end_io handler, the generic code
>> will take care of issuing the flush.  Otherwise, the filesystem's custom end_io
>> handler is passed struct dio_sync_io_work pointer as 'private' argument, and it
>> must call generic_dio_end_io() to finish the AIO DIO.  The generic code then
>> takes care to call generic_write_sync() from a workqueue context when AIO DIO
>> is complete.
>> 
>> Since all filesystems using blockdev_direct_IO() need O_SYNC aio dio handling
>> and the generic suffices for them, make blockdev_direct_IO() pass the new
>> DIO_SYNC_WRITES flag.
>
> I'd like to use this as a vehicle to revisit how dio completions work.

I don't like the sound of that.  ;-)  It sounds like this bugfix may get
further delayed by the desire for unrelated code cleanup.

> Now that the generic code has a reason to defer aio completions to a
> workqueue can we maybe take the whole offload to a workqueue code into
> the direct-io code instead of reimplementing it in ext4 and xfs?

On the surface, I don't see a problem with that.

> From a simplicity point of view I'd love to do it unconditionally, but I
> also remember that this was causing performance regressions on important
> workload.  So maybe we just need a flag in the dio structure, with a way
> that the get_blocks callback can communicate that it's needed.

Yeah, adding context switches to the normal io completion path is a
non-starter.

> For the specific case of O_(D)SYNC aio this would allos allow to call
> ->fsync from generic code instead of the filesystems having to
> reimplement this.

This is the only reason I'd even consider such a cleanup for this
series.  Alas, I don't find it compelling enough to do the work.

>> +		if (dio->sync_work)
>> +			private = dio->sync_work;
>> +		else
>> +			private = dio->private;
>> +
>>  		dio->end_io(dio->iocb, offset, transferred,
>> -			    dio->private, ret, is_async);
>> +			    private, ret, is_async);
>
> Eww.  I'd be much happier to add a new argument than having two
> different members passed as the private argument.

OK.

> Maybe it's even time to bite the bullet and make struct dio public
> and pass that to the end_io argument as well as generic_dio_end_io.

But I don't agree with that.  Really, nothing needs to know about the
struct dio outside of fs/direct-io.c.

>> +		/* No IO submitted? Skip syncing... */
>> +		if (!dio->result && dio->sync_work) {
>> +			kfree(dio->sync_work);
>> +			dio->sync_work = NULL;
>> +		}
>> +		generic_dio_end_io(dio->iocb, offset, transferred,
>> +				   dio->sync_work, ret, is_async);
>
>
> Any reason the check above isn't done inside of generic_dio_end_io?

Jan?  It does seem as though it might make more sense to do the check in
generic_dio_end_io.

>> +static noinline int dio_create_flush_wq(struct super_block *sb)
>> +{
>> +	struct workqueue_struct *wq =
>> +				alloc_workqueue("dio-sync", WQ_UNBOUND, 1);
>> +
>> +	if (!wq)
>> +		return -ENOMEM;
>> +	/*
>> +	 * Atomically put workqueue in place. Release our one in case someone
>> +	 * else won the race and attached workqueue to superblock.
>> +	 */
>> +	if (cmpxchg(&sb->s_dio_flush_wq, NULL, wq))
>> +		destroy_workqueue(wq);
>> +	return 0;
>
> Eww.  Workqueues are cheap, just create it on bootup instead of this
> uglyness. Also I don't really see any reason to make it per-fs instead
> of global.

I would prefer to keep it per-fs.  Consider the possibility for sync
work on your database device being backed up behind sync work for your
root file system.  So, given my preference to keep it per-fs, would you
rather the workqueues get created at mount time?

Cheers,
Jeff
