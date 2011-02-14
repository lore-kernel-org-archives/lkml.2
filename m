Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1BNLsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:48:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab1BNLsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:48:01 -0500
Message-ID: <4D591664.6090203@redhat.com>
Date: Mon, 14 Feb 2011 12:47:48 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH] loop: clear read-only flag in loop_clr_fd.
References: <4D573BBB.6090200@redhat.com> <1297594735-5593-1-git-send-email-tm@tao.ma> <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma> <4D580A8B.5050508@redhat.com> <20110214103026.GA18742@htj.dyndns.org>
In-Reply-To: <20110214103026.GA18742@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/14/2011 11:30 AM, Tejun Heo wrote:
> Umm... This was reported some time ago and patches were already
> posted.  Milan, can you test whether the following two patches fix the
> problems you're seeing?  Jens, what's the status of these patches?
>
>   http://thread.gmane.org/gmane.linux.kernel/1090211/focus=1090666
>
With patch below (loop cannot be built as module) it fixes the loop problem.

But it doesn't fix the read-only snapshot issue and I guess there will be
the same problem with read-only MD code too.
(so the 2) issue here https://lkml.org/lkml/2011/2/12/209).

If the call is changed intentionally, we have to fix unconditional blkdev open
calls with read-write flag in this code.
Before doing that I would like to know if it was intentional change or not...

You can simple try this reproducer (works on older kernel, second readonly
snapshot create fails now with permission denied)
+ dmsetup create x --readonly --table '0 131072 snapshot /dev/loop0 /dev/loop1 p 8'
device-mapper: reload ioctl failed: Permission denied

#!/bin/bash -x
modprobe loop

dd if=/dev/zero of=/x.img bs=1M count=64
dd if=/dev/zero of=/xs.img bs=1M count=64
losetup /dev/loop0 /x.img
losetup /dev/loop1 /xs.img
sync
dmsetup create x --table "0 131072 snapshot /dev/loop0 /dev/loop1 p 8"
udevadm settle
dmsetup remove x

losetup -d /dev/loop0
losetup -d /dev/loop1
losetup -r /dev/loop0 /x.img
losetup -r /dev/loop1 /xs.img
dmsetup create x --readonly --table "0 131072 snapshot /dev/loop0 /dev/loop1 p 8"
dmsetup table

dmsetup remove x
losetup -d /dev/loop0
losetup -d /dev/loop1

Milan

--
Export bdgrap to allow loop module build 

Signed-off-by: Milan Broz <mbroz@redhat.com> 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 333a7bb..c9cf9f7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -574,6 +574,7 @@ struct block_device *bdgrab(struct block_device *bdev)
 	ihold(bdev->bd_inode);
 	return bdev;
 }
+EXPORT_SYMBOL(bdgrab);
 
 long nr_blockdev_pages(void)
 {


