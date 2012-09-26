Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2IZNrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab2IZNri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:47:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 0/4] Fix a crash when block device is read and block size is changed at the same time
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	<x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
	<x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
	<1343508252.2626.13184.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
	<1343556630.2626.13257.camel@edumazet-glaptop>
	<1343586962.2626.13266.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com>
	<x49liguyg6r.fsf@segfault.boston.devel.redhat.com>
	<x49wqzswdn3.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com>
	<x49ehlzrt01.fsf@segfault.boston.devel.redhat.com>
	<x49sja6ouv4.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1209251850380.21075@file.rdu.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 26 Sep 2012 09:47:23 -0400
In-Reply-To: <Pine.LNX.4.64.1209251850380.21075@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Tue, 25 Sep 2012 18:58:24 -0400 (EDT)")
Message-ID: <x49obkskiac.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> On Tue, 25 Sep 2012, Jeff Moyer wrote:
>
>> Jeff Moyer <jmoyer@redhat.com> writes:
>> 
>> > Mikulas Patocka <mpatocka@redhat.com> writes:
>> >
>> >> Hi Jeff
>> >>
>> >> Thanks for testing.
>> >>
>> >> It would be interesting ... what happens if you take the patch 3, leave 
>> >> "struct percpu_rw_semaphore bd_block_size_semaphore" in "struct 
>> >> block_device", but remove any use of the semaphore from fs/block_dev.c? - 
>> >> will the performance be like unpatched kernel or like patch 3? It could be 
>> >> that the change in the alignment affects performance on your CPU too, just 
>> >> differently than on my CPU.
>> >
>> > It turns out to be exactly the same performance as with the 3rd patch
>> > applied, so I guess it does have something to do with cache alignment.
>> > Here is the patch (against vanilla) I ended up testing.  Let me know if
>> > I've botched it somehow.
>> >
>> > So, I next up I'll play similar tricks to what you did (padding struct
>> > block_device in all kernels) to eliminate the differences due to
>> > structure alignment and provide a clear picture of what the locking
>> > effects are.
>> 
>> After trying again with the same padding you used in the struct
>> bdev_inode, I see no performance differences between any of the
>> patches.  I tried bumping up the number of threads to saturate the
>> number of cpus on a single NUMA node on my hardware, but that resulted
>> in lower IOPS to the device, and hence consumption of less CPU time.
>> So, I believe my results to be inconclusive.
>
> For me, the fourth patch with RCU-based locks performed better, so I am 
> submitting that.
>
>> After talking with Vivek about the problem, he had mentioned that it
>> might be worth investigating whether bd_block_size could be protected
>> using SRCU.  I looked into it, and the one thing I couldn't reconcile is
>> updating both the bd_block_size and the inode->i_blkbits at the same
>> time.  It would involve (afaiui) adding fields to both the inode and the
>> block_device data structures and using rcu_assign_pointer  and
>> rcu_dereference to modify and access the fields, and both fields would
>> need to protected by the same struct srcu_struct.  I'm not sure whether
>> that's a desirable approach.  When I started to implement it, it got
>> ugly pretty quickly.  What do others think?
>
> Using RCU doesn't seem sensible to me (except for lock implementation, as 
> it is in patch 4). The major problem is that the block layer reads 
> blocksize multiple times and when different values are read, a crash may 
> happen - RCU doesn't protect you against that - if you read a variable 
> multiple times in a RCU-protected section, you can still get different 
> results.

SRCU is sleepable, so could be (I think) used in the same manner as your
rw semaphore.  The only difference is that it would require changing the
bd_blocksize and the i_blkbits to pointers and protecting them both with
the same srcu struct.  Then, the inode i_blkbits would also need to be
special cased, so that we only require such handling when it is
associated with a block device.  It got messy.

> If we wanted to use RCU, we would have to read blocksize just once and 
> pass the value between all functions involved - that would result in a 
> massive code change.

If we did that, we wouldn't need rcu at all, would we?

Cheers,
Jeff
