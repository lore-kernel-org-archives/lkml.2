Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2I1Ilz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:41:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:56562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2I1Ilw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:41:52 -0400
Message-ID: <506562CE.2070500@kernel.dk>
Date: Fri, 28 Sep 2012 10:41:50 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] loop: Make explicit loop device destruction lazy
References: <1348812593-21344-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1348812593-21344-1-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-28 08:09, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfstests has always had random failures of tests due to loop devices
> failing to be torn down and hence leaving filesytems that cannot be
> unmounted. This causes test runs to immediately stop.
> 
> Over the past 6 or 7 years we've added hacks like explicit unmount
> -d commands for loop mounts, losetup -d after unmount -d fails, etc,
> but still the problems persist.  Recently, the frequency of loop
> related failures increased again to the point that xfstests 259 will
> reliably fail with a stray loop device that was not torn down.
> 
> That is despite the fact the test is above as simple as it gets -
> loop 5 or 6 times running mkfs.xfs with different paramters:
> 
>         lofile=$(losetup -f)
>         losetup $lofile "$testfile"
>         "$MKFS_XFS_PROG" -b size=512 $lofile >/dev/null || echo "mkfs failed!"
>         sync
>         losetup -d $lofile
> 
> And losteup -d $lofile is failing with EBUSY on 1-3 of these loops
> every time the test is run.
> 
> Turns out that blkid is running simultaneously with losetup -d, and
> so it sees an elevated reference count and returns EBUSY.  But why
> is blkid running? It's obvious, isn't it? udev has decided to try
> and find out what is on the block device as a result of a creation
> notification. And it is racing with mkfs, so might still be scanning
> the device when mkfs finishes and we try to tear it down.
> 
> So, make losetup -d force autoremove behaviour. That is, when the
> last reference goes away, tear down the device. xfstests wants it
> *gone*, not causing random teardown failures when we know that all
> the operations the tests have specifically run on the device have
> completed and are no longer referencing the loop device.

I hear that %^#@#! blkid behavior, it is such a pain in the neck. I
don't know how many times I've had to explain that behaviour to people
who run write testing with tracing, wonder wtf there are reads in the
trace.

Patch looks fine, seems like the sane thing to do (lazy-remove on last
drop) for this case.

-- 
Jens Axboe

