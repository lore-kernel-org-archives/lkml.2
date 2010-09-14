Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0INB1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 21:27:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51076 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0INB1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 21:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hDKMeTRIXK2nZvN+Jw57nQKbqJoviZ6e12zec3jo4UnXaHDAaXWJcYhShKVOY3pEJ6
         txkUnAE0GrWcn6jNN/fxWjmUuwn9olPQo2EL7ak2uIx0a0MBNVCA+DJxQSgmHagn9EZ0
         dlmIA6eiROk3FFjfVWnZyJ4eB2XjNlEPIojLY=
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <1284284969.2928.18.camel@maxim-laptop>
References: <1284284969.2928.18.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 03:27:01 +0200
Message-ID: <1284427621.4127.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-12 at 11:49 +0200, Maxim Levitsky wrote: 
> Hi,
> 
> After a switch between hal to devkit stack, a different strategy of
> detecting a cdrom removal was applied.
> Instead of polling it, userspace just tells the kernel not to lock the
> dour (/proc/sys/dev/cdrom/lock) and as soon as user removes the disk,
> udev notifies the userspace and it unmounts it. Since CDROMs are
> readonly this is perfectly safe and fits the same procedure used for all
> other removable disks. (usb, flash cards, etc..)
> 
> (Well, most cdroms aren't really read-only these days, but state of
> packet writing is so sad these days that is doesn't matter).
> 
> However 2.6.36 doesn't detect that removal.
> According to udevadm monitor --property no uevents are send on removal.
Correction, this is regression between 2.6.34 and 2.6.35. This shows how
much I use cd these days...


I bisected it down to this:

6b4517a7913a09d3259bb1d21c9cb300f12294bd is the first bad commit
commit 6b4517a7913a09d3259bb1d21c9cb300f12294bd
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Apr 7 18:53:59 2010 +0900

    block: implement bd_claiming and claiming block
    
    Currently, device claiming for exclusive open is done after low level
    open - disk->fops->open() - has completed successfully.  This means
    that exclusive open attempts while a device is already exclusively
    open will fail only after disk->fops->open() is called.
    
    cdrom driver issues commands during open() which means that O_EXCL
    open attempt can unintentionally inject commands to in-progress
    command stream for burning thus disturbing burning process.  In most
    cases, this doesn't cause problems because the first command to be
    issued is TUR which most devices can process in the middle of burning.
    However, depending on how a device replies to TUR during burning,
    cdrom driver may end up issuing further commands.
    
    This can't be resolved trivially by moving bd_claim() before doing
    actual open() because that means an open attempt which will end up
    failing could interfere other legit O_EXCL open attempts.
    ie. unconfirmed open attempts can fail others.
    
    This patch resolves the problem by introducing claiming block which is
    started by bd_start_claiming() and terminated either by bd_claim() or
    bd_abort_claiming().  bd_claim() from inside a claiming block is
    guaranteed to succeed and once a claiming block is started, other
    bd_start_claiming() or bd_claim() attempts block till the current
    claiming block is terminated.
    
    bd_claim() can still be used standalone although now it always
    synchronizes against claiming blocks, so the existing users will keep
    working without any change.
    
    blkdev_open() and open_bdev_exclusive() are converted to use claiming
    blocks so that exclusive open attempts from these functions don't
    interfere with the existing exclusive open.
    
    This problem was discovered while investigating bko#15403.
    
      https://bugzilla.kernel.org/show_bug.cgi?id=15403
    
    The burning problem itself can be resolved by updating userspace
    probing tools to always open w/ O_EXCL.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Reported-by: Matthias-Christian Ott <ott@mirix.org>
    Cc: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

The bisect log:


maxim@maxim-laptop:~/software/kernel/linux-2.6$ git bisect log
git bisect start
# bad: [9fe6206f400646a2322096b56c59891d530e8d51] Linux 2.6.35
git bisect bad 9fe6206f400646a2322096b56c59891d530e8d51
# good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
# good: [e0bc5d4a54938eedcde14005210e6c08aa9727e4] Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging
git bisect good e0bc5d4a54938eedcde14005210e6c08aa9727e4
# bad: [d30fda355188272430d3865db2ff9e24b4135ae3] posix-cpu-timers: avoid "task->signal != NULL" checks
git bisect bad d30fda355188272430d3865db2ff9e24b4135ae3
# bad: [d79df0b1eda0099a22cbcece01ce5e7d222450de] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
git bisect bad d79df0b1eda0099a22cbcece01ce5e7d222450de
# good: [6969a434737dd82f7343e3fcd529bc320508d9fc] Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
git bisect good 6969a434737dd82f7343e3fcd529bc320508d9fc
# good: [e34d2c5fa2254197b0a01925cc6f77e12552f9b9] staging:iio: ABI documentation (partial)
git bisect good e34d2c5fa2254197b0a01925cc6f77e12552f9b9
# good: [7fb794b32cbd7e97e37628cb67279b86c1436e84] Staging: vt6655: remove unused SUCCESS definition
git bisect good 7fb794b32cbd7e97e37628cb67279b86c1436e84
# bad: [fc8ce1941d668c70e57a07f13f5a63e73e5dbff3] drbd: Fix: Do not detach, if a bio with a barrier fails
git bisect bad fc8ce1941d668c70e57a07f13f5a63e73e5dbff3
# bad: [8d4ce82b3ccd755c8ba401469ced5286b1e02284] drbd: don't start a resync without access to up-to-date Data
git bisect bad 8d4ce82b3ccd755c8ba401469ced5286b1e02284
# good: [1a3cbbc5a5e8a66934aa0947896a4aca6fd77298] block: factor out bd_may_claim()
git bisect good 1a3cbbc5a5e8a66934aa0947896a4aca6fd77298
# bad: [0f3942a39ed768c967cb71ea0e9be7fc94112713] block: kill some useless goto's in blk-cgroup.c
git bisect bad 0f3942a39ed768c967cb71ea0e9be7fc94112713
# bad: [3f14d792f9a8fede64ce918dbb517f934497a4f8] blkdev: add blkdev_issue_zeroout helper function
git bisect bad 3f14d792f9a8fede64ce918dbb517f934497a4f8
# bad: [fbd9b09a177a481eda256447c881f014f29034fe] blkdev: generalize flags for blkdev_issue_fn functions
git bisect bad fbd9b09a177a481eda256447c881f014f29034fe
# bad: [6b4517a7913a09d3259bb1d21c9cb300f12294bd] block: implement bd_claiming and claiming block
git bisect bad 6b4517a7913a09d3259bb1d21c9cb300f12294bd


Best regards,
	Maxim Levitsky

