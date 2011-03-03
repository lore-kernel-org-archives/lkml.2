Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab1CCNbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:31:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:20582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974Ab1CCNbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:31:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,258,1297065600"; 
   d="scan'208";a="893369633"
Date: Thu, 3 Mar 2011 21:31:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Fix mapping->writeback_index to point to the last
 written page
Message-ID: <20110303133119.GA16562@localhost>
References: <4D676067.8050200@ce.jp.nec.com>
 <20110302221808.GG7496@quack.suse.cz>
 <4D6EFC4B.30505@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EFC4B.30505@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:26:19AM +0800, Jun'ichi Nomura wrote:
> Hi Jan,
> 
> thank you for the comments.
> 
> On 03/03/11 07:18, Jan Kara wrote:
> > On Fri 25-02-11 16:55:19, Jun'ichi Nomura wrote:
> >> I think it's intended for sequential writer.
> >   Not exactly. The code is meant so that background writeback gets to
> > writing the end of a file which gets continuously dirtied (if we always
> > started at the beginning, nr_to_write could always get to 0 before we reach
> > end of the file).
> 
> Ah, ok. Thanks.
> My patch doesn't break the above goal.

Yeah.

> >> Otherwise, the last written page was left dirty until the writeback
> >> wraps around.
> >>
> >> I.e. if the sequential dirtier has written on pagecache as '*'s below:
> >>
> >>    |*******|*******|****---|-------|-------|     ( |---| is a page )
> >>
> >> then, writeback happens:
> >>
> >>    |-------|-------|-------|-------|-------|
> >>
> >> and the dirtier continues:
> >>
> >>    |-------|-------|----***|*******|*****--|
> >>                    A       B
> >>
> >> Next writeback should start from page A, not B.
> >   Yes, this is downside of our current scheme. Have you actually observed
> > it in practice or is it mostly a theoretic concern?
> 
> Half practical, half theoretic.
> It has been observed with a real application, which uses a big ring file.
> 
> I took a trace with a test program for example:
> 
> [1st writeback session]
>        ...
>        flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898514 + 8
>        flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898522 + 8
>        flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898530 + 8
>        flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898538 + 8
>        flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898546 + 8
>      kworker/0:1-11    4571: block_rq_issue: 8,0 W 0 () 94898514 + 40
> >>     flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898554 + 8
> >>     flush-8:0-2743  4571: block_rq_issue: 8,0 W 0 () 94898554 + 8
> 
> [2nd writeback session after 35sec]
>        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898562 + 8
>        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898570 + 8
>        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898578 + 8
>        ...
>      kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94898562 + 640
>      kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899202 + 72
>        ...

        >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899962 + 8
        >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899970 + 8
        >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899978 + 8
        >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899986 + 8
        >        flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899994 + 8
==>     >      kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899962 + 40
        > >>     flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898554 + 8
==>     > >>     flush-8:0-2743  4606: block_rq_issue: 8,0 W 0 () 94898554 + 8

I'd expect the wrapped around 94898554+8 to be merged with 94899962+8.
Why kworker/0:1-11 is submitting the request early? And the second
request is submitted by flush-8:0-2743.

> The 1st writeback ended at block 94898562. (94898554+8)
> The 2nd writeback started there.
> However, since the last page at the 1st writeback was just redirtied,
> the 2nd writeback looped back to block 94898554 after sequentially
> submitting blocks from 94898562 to 94900001.
> 
> 1 extra seek which could be avoided.
> I haven't seen fatal problem with the latest kernel, though.
> 
> With older kernels (before 2.6.29, without commit 31a12666),
> kupdate leaves the dirty pages like spots until the application wraps
> around the ring. (It could take hours to days.)
> That led me to this code.
> 
> > But as I'm thinking about it, it wouldn't harm our original aim to do
> > what you propose and it can help this relatively common case. So I think
> > it's a good idea. Fengguang, what do you think?

I see no problem too.

Tested-by: Wu Fengguang <fengguang.wu@intel.com>

I compared the writeback_single_inode trace (https://lkml.org/lkml/2011/3/3/73)
and find no differences other than the 1-offset in the index field.

writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=292 wrote=8192 to_write=-1 index=8191
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=2820 wrote=8192 to_write=0 index=16383
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=8644 wrote=8192 to_write=0 index=24575
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=15664 wrote=8192 to_write=0 index=32767
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=21660 wrote=8192 to_write=0 index=40959
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=27592 wrote=8192 to_write=0 index=49151
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=34700 wrote=8192 to_write=0 index=57343
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=40936 wrote=8192 to_write=0 index=65535
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=47556 wrote=8192 to_write=0 index=73727
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=53660 wrote=8192 to_write=0 index=81919
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=60220 wrote=8192 to_write=0 index=90111
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=67156 wrote=8192 to_write=0 index=98303
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=73796 wrote=8192 to_write=0 index=106495
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=79948 wrote=8192 to_write=0 index=114687
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=86176 wrote=8192 to_write=0 index=122879

writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=480 wrote=8192 to_write=-1 index=8192
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=536 wrote=8192 to_write=0 index=16384
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=828 wrote=8192 to_write=0 index=24576
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=1540 wrote=8192 to_write=0 index=32768
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=2084 wrote=8192 to_write=0 index=40960
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=2620 wrote=8192 to_write=0 index=49152
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=3156 wrote=8192 to_write=0 index=57344
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=4008 wrote=8192 to_write=0 index=65536
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=4964 wrote=8192 to_write=0 index=73728
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=5560 wrote=8192 to_write=0 index=81920
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=6132 wrote=8192 to_write=0 index=90112
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=7436 wrote=8192 to_write=-180 index=98304
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=8200 wrote=8192 to_write=0 index=106496
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=8652 wrote=8192 to_write=0 index=114688
writeback_single_inode: bdi 8:0: ino=12 state=I_DIRTY_PAGES age=9424 wrote=8192 to_write=0 index=122880

Thanks,
Fengguang
