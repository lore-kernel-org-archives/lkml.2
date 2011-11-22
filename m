Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab1KVKt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:49:27 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:26002 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654Ab1KVKtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:49:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKh6y055LGY5/2dsb2JhbABDqkyBBoFyAQEFOhwPFBAIAxguFCUDIRO9HxKJWmMElD+JBYkY
Date: Tue, 22 Nov 2011 21:49:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [3.2-rc2] loop device balance_dirty_pages_nr throttling hang
Message-ID: <20111122104921.GE8098@dastard>
References: <20111121142056.GF2386@dastard>
 <20111122035629.GE20982@localhost>
 <20111122102931.GD8098@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122102931.GD8098@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 09:29:31PM +1100, Dave Chinner wrote:
> I suspect the difference is that I was reproducing this with a used
> image file. It had somewhere in the order of 750MB of space used
> prior to running the test. I'd been using the image to test large
> filesystem support for xfstests. I'd done a bunch of testing with
> XFS on the loop device, and was trying to get the ext4 support to
> work when I was seeing these hangs. I manually ran the
> losetup/mount/mkfs loopdev/mount/falloc step to get it to hang.
> 
> So I think the state of the underlying image file has something to
> do with the hang. Most likely due to the IO rates, I think....
> 
> I'll try to reproduce it by running xfstests on XFS on it again
> before trying ext4 again (your script blew away the old image file I
> had). Alternatively, you can try writing lots of small random blocks
> to the image file before running the ext4 portion of the test.

At a rough approximation, the image file after xfs tests has run on
it for a while has somewhere on the high side of 30000 allocated
extents in it. So that could have significant impact on the layout
of the file and the IO patterns that result.

But, I just noticed that the discard that mkfs.ext4 will result in
all the extents being discarded in the underlying image file (due to
the fact the loopback device now supports hole punching), so the
previous state of the image file is getting trashed by the mkfs.ext4
execution, too. I think I already had a ext4 filesystem in some state
before I started running this manual prealloc test....

So, let me go back to running test 223 and then trying again with
having run mkfs on the loop device.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
