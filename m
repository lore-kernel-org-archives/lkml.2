Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab1KVK3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:29:36 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37930 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab1KVK3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:29:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPl2y055LGY5/2dsb2JhbABDqkyBBoFyAQEEATocDxQFCwgDGC4UJQMhE4gFtRISiVpjBJQ/iQWJGA
Date: Tue, 22 Nov 2011 21:29:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [3.2-rc2] loop device balance_dirty_pages_nr throttling hang
Message-ID: <20111122102931.GD8098@dastard>
References: <20111121142056.GF2386@dastard>
 <20111122035629.GE20982@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122035629.GE20982@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:56:29AM +0800, Wu Fengguang wrote:
> Hi Dave,
> 
> On Mon, Nov 21, 2011 at 10:20:56PM +0800, Dave Chinner wrote:
> > Hi Fengguang,
> > 
> > I just found a way of hanging a system and taking it down. I haven't
> > tried to narrow down the test case - it's pretty simple - because it
> > time for sleep here.
> 
> Yeah, once the global dirty limit is exceeded, the system would appear
> hang because many applications will block in balance_dirty_pages().
> 
> I created a script for this case, however cannot reproduce it..
> 
> The test box has 32GB memory and 110GB /dev/sda7, so I lowered
> the dirty_bytes=400MB and xfs "-b size=10g" explicitly in the script.

The VM I was running was a 2p, 2GB RAM config running on a 7200rpm
SATA drive, so maybe all your extra RAM has some impact on it.

> During the test run on 3.2.0-rc1, I find the dirty pages rarely exceed
> the background dirty threshold (200MB).

Which means your IO rates are high enough to keep the number of
dirty pages under control?

> Would you try run this and see if this it's a problem of the test script?
> 
> root@snb /home/wfg# cat ./test-loop-fallocate.sh
....

Ok, so using your script my system doesn't hang, either.

I suspect the difference is that I was reproducing this with a used
image file. It had somewhere in the order of 750MB of space used
prior to running the test. I'd been using the image to test large
filesystem support for xfstests. I'd done a bunch of testing with
XFS on the loop device, and was trying to get the ext4 support to
work when I was seeing these hangs. I manually ran the
losetup/mount/mkfs loopdev/mount/falloc step to get it to hang.

So I think the state of the underlying image file has something to
do with the hang. Most likely due to the IO rates, I think....

I'll try to reproduce it by running xfstests on XFS on it again
before trying ext4 again (your script blew away the old image file I
had). Alternatively, you can try writing lots of small random blocks
to the image file before running the ext4 portion of the test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
