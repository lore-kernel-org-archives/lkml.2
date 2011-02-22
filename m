Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1BVTOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:14:09 -0500
Received: from daytona.panasas.com ([67.152.220.89]:18537 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1BVTOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:14:06 -0500
Message-ID: <4D640AF7.8010505@panasas.com>
Date: Tue, 22 Feb 2011 11:13:59 -0800
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Jan Kara <jack@suse.cz>, djwong <djwong@us.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
References: <20110222020022.GH32261@tux1.beaverton.ibm.com> <4D634D8F.4070401@panasas.com> <20110222114222.GA24728@quack.suse.cz> <1298379714-sup-3015@think>
In-Reply-To: <1298379714-sup-3015@think>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Feb 2011 19:14:01.0949 (UTC) FILETIME=[AA1AB0D0:01CBD2C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 05:02 AM, Chris Mason wrote:
> [ resend sorry if you get this twice ]
> 
> Excerpts from Jan Kara's message of 2011-02-22 06:42:22 -0500:
>>   Hi Boaz,
>>
>> On Mon 21-02-11 21:45:51, Boaz Harrosh wrote:
>>> On 02/21/2011 06:00 PM, Darrick J. Wong wrote:
>>>> Last summer there was a long thread entitled "Wrong DIF guard tag on ext2
>>>> write" (http://marc.info/?l=linux-scsi&m=127530531808556&w=2) that started a
>>>> discussion about how to deal with the situation where one program tells the
>>>> kernel to write a block to disk, the kernel computes the checksum of that data,
>>>> and then a second program begins writing to that same block before the disk HBA
>>>> can DMA the memory block, thereby causing the disk to complain about being sent
>>>> invalid checksums.
>>>
>>> The brokenness is in ext2/3 if you'll use btrfs, xfs and I think late versions
>>> of ext4 it should work much better. (If you still have problems please report
>>> them, those FSs advertise stable pages write-out)
>>   Do they? I've just checked ext4 and xfs and they don't seem to enforce
>> stable pages. They do lock the page (which implicitely happens in mm code
>> for any filesystem BTW) but this is not enough. You have to wait for
>> PageWriteback to get cleared and only btrfs does that.
>>  
>>> This problem is easily fixed at the FS layer or even at VFS, by overriding mk_write
>>> and syncing with write-out for example by taking the page-lock. Currently each
>>> FS is to itself because in VFS it would force the behaviour on FSs that it does
>>> not make sense to.
>>   Yes, it's easy to fix but at a performance cost for any application doing
>> frequent rewrites regardless whether integrity features are used or not.
>> And I don't think that's a good thing. I even remember someone measured the
>> hit last time this came up and it was rather noticeable.
> 
> Do you remember which workload this was?  I do remember someone
> mentioning a specific workload, but can't recall which one now.  fsx is
> definitely slower when we wait for writeback, but that's because it's
> all evil inside.
> 
Me too
I have been asking on many occasions on multiple mailing lists and LSF last
year, if any one did any benchmarks on this issue, and no one came forward.
So please if someone is hiding his resaults come and show us we want to see?

I've been Playing with this for my raid5 code and Actually the problem
is not that bad. I'm using tar to exercise that. What I can see that
I can actually wait on a single page every once in like 15-30 seconds
but never consecutively on multiple pages. Because usually you wait on
an IOed page but all the pages in an IO are completed together and the
reset of the modifications go through.

I could not find any measurable performance difference, it was all well inside
the margin of the test. But maybe tar is just bad test.

>>
>>> Note that the proper solution does not copy any data, just forces the app to
>>> wait before changing write-out pages.
>>   I think that's up for discussion. In fact what is going to be faster
>> depends pretty much on your system config. If you have enough CPU/RAM
>> bandwidth compared to storage speed, you're better of doing copying. If
>> you can barely saturate storage with your CPU/RAM, waiting is probably
>> better for you. 
>>
>> Moreover if you do data copyout, you push the performance cost only on
>> users of the integrity feature which is nice. But on the other hand users
>> of integrity take the cost even if they are not doing rewrites.
>>
>> A solution which is technically plausible and penalizing only rewrites
>> of data-integrity protected pages would be a use of shadow pages as Darrick
>> describes below. So I'd lean towards that long term. But for now I think
>> Darrick's solution is OK to make the integrity feature actually useful and
>> later someone can try something more clever.
> 
> Rewrites in flight should be very rare though, and I think the bouncing
> is going to have a big impact on the intended workloads.  It's not just
> the cost of the copy, it's also the increased time as we beat on the
> page allocator.
> 
> We're working on adding stable pages to ext34 and other filesystems
> missing it.  When the work is done we can benchmark and decide on the
> tradeoffs.
> 

Thanks, that would be nice. I bet the simple wait on write-out will beat
copy-everything , any day of the week.

Why don't we put some flags on the BDI that requests stable write-out
and devices with diff enabled or the likes of raid1/4/5/6 can turn
it on? (Also iscsi integrity checks as well)

> -chris

Boaz
