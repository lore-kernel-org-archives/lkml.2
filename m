Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab2I1PC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758343Ab2I1PC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:02:58 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] loop: Make explicit loop device destruction lazy
References: <1348812593-21344-1-git-send-email-david@fromorbit.com>
	<506562CE.2070500@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 28 Sep 2012 11:02:53 -0400
In-Reply-To: <506562CE.2070500@kernel.dk> (Jens Axboe's message of "Fri, 28
	Sep 2012 10:41:50 +0200")
Message-ID: <x49mx0ambqa.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2012-09-28 08:09, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>> 
>> xfstests has always had random failures of tests due to loop devices
>> failing to be torn down and hence leaving filesytems that cannot be
>> unmounted. This causes test runs to immediately stop.
>> 
>> Over the past 6 or 7 years we've added hacks like explicit unmount
>> -d commands for loop mounts, losetup -d after unmount -d fails, etc,
>> but still the problems persist.  Recently, the frequency of loop
>> related failures increased again to the point that xfstests 259 will
>> reliably fail with a stray loop device that was not torn down.
>> 
>> That is despite the fact the test is above as simple as it gets -
>> loop 5 or 6 times running mkfs.xfs with different paramters:
>> 
>>         lofile=$(losetup -f)
>>         losetup $lofile "$testfile"
>>         "$MKFS_XFS_PROG" -b size=512 $lofile >/dev/null || echo "mkfs failed!"
>>         sync
>>         losetup -d $lofile
>> 
>> And losteup -d $lofile is failing with EBUSY on 1-3 of these loops
>> every time the test is run.
>> 
>> Turns out that blkid is running simultaneously with losetup -d, and
>> so it sees an elevated reference count and returns EBUSY.  But why
>> is blkid running? It's obvious, isn't it? udev has decided to try
>> and find out what is on the block device as a result of a creation
>> notification. And it is racing with mkfs, so might still be scanning
>> the device when mkfs finishes and we try to tear it down.
>> 
>> So, make losetup -d force autoremove behaviour. That is, when the
>> last reference goes away, tear down the device. xfstests wants it
>> *gone*, not causing random teardown failures when we know that all
>> the operations the tests have specifically run on the device have
>> completed and are no longer referencing the loop device.
>
> I hear that %^#@#! blkid behavior, it is such a pain in the neck. I
> don't know how many times I've had to explain that behaviour to people
> who run write testing with tracing, wonder wtf there are reads in the
> trace.
>
> Patch looks fine, seems like the sane thing to do (lazy-remove on last
> drop) for this case.

Do we also want to prevent further opens?
