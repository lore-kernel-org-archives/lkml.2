Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0ELOvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:51:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60311 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753144Ab0ELOvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:51:03 -0400
Date: Wed, 12 May 2010 10:50:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matt Reimer <mattjreimer@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while 
 userspace is frozen?
In-Reply-To: <AANLkTikH7DvizJ9340SiksoIWU5KU2n-OCqWc4f_-z9v@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005121048420.1962-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Matt Reimer wrote:

> >> or has a consensus about how to fix this been
> >> achieved? I'm hitting the same problem and have some time to work on a
> >> fix.
> >
> > Generally, it looks like del_gendisk should thaw writeback threads, but not
> > during suspend, only during resume.
> 
> Thawing the writeback thread only during resume does fix the case
> Maxim originally presented:
> 
> 0. build kernel with CONFIG_MMC_UNSAFE_RESUME
> 1. insert SD card
> 2. suspend
> 3. remove SD card while suspended
> 4. resume from suspend hangs
> 
> But if CONFIG_MMC_UNSAFE_RESUME is not set, the kernel oopses during
> suspend because the MMC device suspend times out:
> 
> mmc0: card e624 removed
> **** DPM device timeout: pxa2xx-mci.0 (pxa2xx-mci)
> kernel BUG at /home/mreimer/sdg/android/android-2.1/kernel/drivers/base/power/main.c:453!
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = c0004000
> [00000000] *pgd=00000000
> Internal error: Oops: 817 [#1] PREEMPT
> 
> If I thaw the writeback thread unconditionally in del_gendisk() then
> suspend and resume work as expected for both CONFIG_MMC_UNSAFE_RESUME
> set/not set, even when the card is removed while suspended.
> 
> So what is the proper fix?

I don't see any reason not to let del_gendisk thaw the writeback thread
during suspend.  Since the device is going away anyhow, letting the
thread run shouldn't cause any problems.

Alan Stern

