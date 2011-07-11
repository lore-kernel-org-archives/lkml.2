Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab1GKRL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:11:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44997 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab1GKRL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:11:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=so+FrKWlSCSSJ+kH+itrlrLIKeSHNpTl7fCbyO4Ew7eZ6wH1r5GkjETlLjYZsBIRt
	5nzVSyKPdJfpPPfHhh6ug==
MIME-Version: 1.0
In-Reply-To: <20110711170042.GE5482@quack.suse.cz>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
	<20110629005422.GQ32466@dastard>
	<BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
	<20110629081155.GA5558@infradead.org>
	<20110629165714.GF17590@quack.suse.cz>
	<20110629175534.GA32236@infradead.org>
	<20110629191518.GA23196@quack.suse.cz>
	<BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
	<20110711170042.GE5482@quack.suse.cz>
Date: Mon, 11 Jul 2011 10:11:17 -0700
Message-ID: <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
Subject: Re: [PATCH] writeback: Don't wait for completion in writeback_inodes_sb_nr
From: Curt Wohlgemuth <curtw@google.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan:

On Mon, Jul 11, 2011 at 10:00 AM, Jan Kara <jack@suse.cz> wrote:
>  Hi Curt,
>
> On Fri 01-07-11 15:55:33, Curt Wohlgemuth wrote:
>> On Wed, Jun 29, 2011 at 12:15 PM, Jan Kara <jack@suse.cz> wrote:
>> > On Wed 29-06-11 13:55:34, Christoph Hellwig wrote:
>> >> On Wed, Jun 29, 2011 at 06:57:14PM +0200, Jan Kara wrote:
>> >> > > For sys_sync I'm pretty sure we could simply remove the
>> >> > > writeback_inodes_sb call and get just as good if not better performance,
>> >> >   Actually, it won't with current code. Because WB_SYNC_ALL writeback
>> >> > currently has the peculiarity that it looks like:
>> >> >   for all inodes {
>> >> >     write all inode data
>> >> >     wait for inode data
>> >> >   }
>> >> > while to achieve good performance we actually need something like
>> >> >   for all inodes
>> >> >     write all inode data
>> >> >   for all inodes
>> >> >     wait for inode data
>> >> > It makes a difference in an order of magnitude when there are lots of
>> >> > smallish files - SLES had a bug like this so I know from user reports ;)
>> >>
>> >> I don't think that's true.  The WB_SYNC_ALL writeback is done using
>> >> sync_inodes_sb, which operates as:
>> >>
>> >>   for all dirty inodes in bdi:
>> >>      if inode belongs to sb
>> >>         write all inode data
>> >>
>> >>   for all inodes in sb:
>> >>      wait for inode data
>> >>
>> >> we still do that in a big for each sb loop, though.
>> >  True but writeback_single_inode() has in it:
>> >        if (wbc->sync_mode == WB_SYNC_ALL) {
>> >                int err = filemap_fdatawait(mapping);
>> >                if (ret == 0)
>> >                        ret = err;
>> >        }
>> >  So we end up waiting much earlier. Probably we should remove this wait
>> > but that will need some audit I guess.
>>
>> So today for WB_SYNC_ALL from sync_inodes_sb(), we do:
>>   - queue a work item; this will
>>     - write all dirty inodes in a sb
>>       - write one inode's pages
>>       - wait on all inode's pages
>>   - wait for the work item
>>   - wait on all inodes in the sb (wait_sb_inodes)
>>
>> I guess the point of wait_sb_inodes() is to wait on all inodes that
>> were written in a previous writeback pass.
>  Yes. As we discussed with Christoph, waiting for each inode could be
> avoided in principle but we have to be careful not to break data
> consistency guarantees in some other path calling
> writeback_single_inode()...
>
>> One other issue I have with sync as it's structured is that we don't
>> do a WB_SYNC_ALL pass on any inode that's only associated with a block
>> device, and not on a mounted filesystem.  Blockdev mounts are
>> pseudo-mounts, and are explicitly skipped in __sync_filesystem().  So
>> if you've written directly to a block device and do a sync, the only
>> pass over the pages for this inode are via the
>> wakeup_flusher_threads() -- which operates on a BDI, regardless of the
>> superblock, and uses WB_SYNC_NONE.
>>
>> All the sync_filesystem() calls are per-sb, not per-BDI, and they'll
>> exclude pseudo-superblocks.
>>
>> I've seen cases in our modified kernels here at Google in which
>> lilo/shutdown failed because of a lack of WB_SYNC_ALL writeback for
>> /dev/sda (though I haven't been able to come up with a consistent test
>> case, nor reproduce this on an upstream kernel).
>  Ho hum, I wonder what would be the cleanest way to fix this. I guess we
> could make an exception for 'bdev' superblock in the code but it's ugly.

Yes, it's ugly.

You could declare that sync(2) is just doing it's job, that it's not
designed to write dirty pages from devices that don't have filesystems
mounted on them; that's what Christoph seems to be saying, and it's
what the man pages for sync(2) that I've seen say as well.  But
everybody I've talked to about this is surprised, so you could declare
it a bug as well :-) .

It seems to me that sys_sync *could* just dispense with iterating over
the superblocks, and just iterate over the BDIs, just as
wakeup_flusher_threads() does.  I.e., just do two passes over all BDIs
-- one with WB_SYNC_NONE, and one with WB_SYNC_ALL.  Well, not quite.
It would still have to go to each SB and call the quota_sync and
sync_fs callbacks, but those should be cheap.

And yes, this would make sys_sync and sys_syncfs more different than
they are today.

Thanks,
Curt

>                                                                Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
