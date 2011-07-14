Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1GNQ3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:29:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab1GNQ3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:29:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=BJqbfcqpbSAIiAWBy6+LztzWFHFaRhb21Ajl6LoTtO2H8/YX5t0wr0M48Vk0cxu02
	q59KG49lMXdrHBi/npMHg==
MIME-Version: 1.0
In-Reply-To: <20110712223715.GC13656@quack.suse.cz>
References: <20110629165714.GF17590@quack.suse.cz>
	<20110629175534.GA32236@infradead.org>
	<20110629191518.GA23196@quack.suse.cz>
	<BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
	<20110711170042.GE5482@quack.suse.cz>
	<CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
	<20110711194835.GI5482@quack.suse.cz>
	<20110711201157.GA21460@infradead.org>
	<20110712103453.GC31226@quack.suse.cz>
	<20110712104132.GA14189@infradead.org>
	<20110712223715.GC13656@quack.suse.cz>
Date: Thu, 14 Jul 2011 09:29:34 -0700
Message-ID: <CAO81RMYJ76kdQ0qVuSSrfxugrTKAveSP98XQ2QF+VdbtjzJ--w@mail.gmail.com>
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

On Tue, Jul 12, 2011 at 3:37 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 12-07-11 06:41:32, Christoph Hellwig wrote:
>> On Tue, Jul 12, 2011 at 12:34:53PM +0200, Jan Kara wrote:
>> > > All block device inodes sit on blockdev_superblock, we got rid of inodes
>> > > without a superblock long time ago.
>> >   Sure, we can easily iterate also blockdev_superblock. What I meant is
>> > that blockdev_superblock will need a special handling since we otherwise
>> > ignore pseudo superblocks...
>>
>> Pseudo superblocks aren't ignored.  They are added to super_blocks like
>> all others, and iterate_supers doesn't skip over them.  The problem
>> is that blockdev_superblock doesn't have a proper s_bdi set, and thus
>> gets skipped over by __sync_filesystem.
>  Yes. But even if it was not skipped writeback_inodes_sb() doesn't have
> one flusher thread to kick to actually do the writeout (since each inode on
> blockdev_superblock belongs to a different bdi). So it's perfectly fine we
> skip blockdev_superblock.
>
>  If we want to fix the problem something like attached patch should do.
> Comments?

Your patch looks good to me, in that it does hit all the bdevs with
both WB_SYNC_NONE and SYNC_ALL.  However, I still say that the call to
wakeup_flusher_threads() in sys_sync() is superfluous, at least as
long as writeback_inodes_sb() waits for completion of the work item
that it enqueues.

Thanks,
Curt

>
>                                                                Honza
>
> PS: While testing the patch, I've noticed that block device can have any
> dirty data only if it is still open (__blkdev_put() writes all dirty pages)
> so that somehow limits how much people can be burned by sync not writing
> out block devices...
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
