Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2HaT1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 15:27:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab2HaT1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:27:52 -0400
Date: Fri, 31 Aug 2012 15:27:38 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 0/4] Fix a crash when block device is read and block size
 is changed at the same time
In-Reply-To: <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com> 
 <20120628111541.GB17515@quack.suse.cz>  <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
  <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com> 
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com> 
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com> 
 <1343508252.2626.13184.camel@edumazet-glaptop> 
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com> 
 <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2012, Mikulas Patocka wrote:

> Hi
> 
> This is a series of patches to prevent a crash when when someone is 
> reading block device and block size is changed simultaneously. (the crash 
> is already happening in the production environment)
> 
> The first patch adds a rw-lock to struct block_device, but doesn't use the 
> lock anywhere. The reason why I submit this as a separate patch is that on 
> my computer adding an unused field to this structure affects performance 
> much more than any locking changes.
> 
> The second patch uses the rw-lock. The lock is locked for read when doing 
> I/O on the block device and it is locked for write when changing block 
> size.
> 
> The third patch converts the rw-lock to a percpu rw-lock for better 
> performance, to avoid cache line bouncing.
> 
> The fourth patch is an alternate percpu rw-lock implementation using RCU 
> by Eric Dumazet. It avoids any atomic instruction in the hot path.
> 
> Mikulas

I tested performance of patches. I created 4GB ramdisk, I initially filled 
it with zeros (so that ramdisk allocation-on-demand doesn't affect the 
results).

I ran fio to perform 8 concurrent accesses on 8 core machine (two 
Barcelona Opterons):
time fio --rw=randrw --size=4G --bs=512 --filename=/dev/ram0 --direct=1 
--name=job1 --name=job2 --name=job3 --name=job4 --name=job5 --name=job6 
--name=job7 --name=job8

The results actually show that the size of struct block_device and 
alignment of subsequent fields in struct inode have far more effect on 
result that the type of locking used. (struct inode is placed just after 
struct block_device in "struct bdev_inode" in fs/block-dev.c)

plain kernel 3.5.3: 57.9s
patch 1: 43.4s
patches 1,2: 43.7s
patches 1,2,3: 38.5s
patches 1,2,3,4: 58.6s

You can see that patch 1 improves the time by 14.5 seconds, but all that 
patch 1 does is adding an unused structure field.

Patch 3 is 4.9 seconds faster than patch 1, althogh patch 1 does no 
locking at all and patch 3 does per-cpu locking. So, the reason for the 
speedup is different sizeof of struct block_device (and subsequently, 
different alignment of struct inode), rather than locking improvement.

I would be interested if other people did performance testing of the 
patches too.

Mikulas
