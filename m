Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1CAKbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 05:31:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab1CAKbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 05:31:16 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
To: Petr Uzel <petr.uzel@suse.cz>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] block: kill loop_mutex
Date: Tue, 1 Mar 2011 15:58:34 +0530
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Arnd Bergmann <arnd@arndb.de>, stable@kernel.org
References: <20110225142729.GA4029@localhost>
In-Reply-To: <20110225142729.GA4029@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011558.34855.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 25, 2011 07:57:29 pm Petr Uzel wrote:
> Following steps lead to deadlock in kernel:
> 
> dd if=/dev/zero of=img bs=512 count=1000
> losetup -f img
> mkfs.ext2 /dev/loop0
> mount -t ext2 -o loop /dev/loop0 mnt
> umount mnt/
> 
> Stacktrace:
> [<c102ec04>] irq_exit+0x36/0x59
> [<c101502c>] smp_apic_timer_interrupt+0x6b/0x75
> [<c127f639>] apic_timer_interrupt+0x31/0x38
> [<c101df88>] mutex_spin_on_owner+0x54/0x5b
> [<fe2250e9>] lo_release+0x12/0x67 [loop]
> [<c10c4eae>] __blkdev_put+0x7c/0x10c
> [<c10a4da5>] fput+0xd5/0x1aa
> [<fe2250cf>] loop_clr_fd+0x1a9/0x1b1 [loop]
> [<fe225110>] lo_release+0x39/0x67 [loop]
> [<c10c4eae>] __blkdev_put+0x7c/0x10c
> [<c10a59d9>] deactivate_locked_super+0x17/0x36
> [<c10b6f37>] sys_umount+0x27e/0x2a5
> [<c10b6f69>] sys_oldumount+0xb/0xe
> [<c1002897>] sysenter_do_call+0x12/0x26
> [<ffffffff>] 0xffffffff
> 
> Regression since 2a48fc0ab24241755dc9, which introduced the private
> loop_mutex as part of the BKL removal process.
> 
> As per [1], the mutex can be safely removed.
> 
> [1] http://www.gossamer-threads.com/lists/linux/kernel/1341930
> 
> Addresses: https://bugzilla.novell.com/show_bug.cgi?id=669394
> Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=29172
> 

BKL was recursive, but the loop_mutex is not, which results in the hang during 
umount in case of  loop over loop with LO_FLAGS_AUTOCLEAR .

And I don't see any need for loop_mutex.

> Signed-off-by: Petr Uzel <petr.uzel@suse.cz>

Reviewed-by: Nikanth Karthikesan <knikanth@suse.de>

> ---
>  drivers/block/loop.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 49e6a54..dbf31ec 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -78,7 +78,6 @@
> 
>  #include <asm/uaccess.h>
> 
> -static DEFINE_MUTEX(loop_mutex);
>  static LIST_HEAD(loop_devices);
>  static DEFINE_MUTEX(loop_devices_mutex);
> 
> @@ -1501,11 +1500,9 @@ static int lo_open(struct block_device *bdev,
> fmode_t mode) {
>  	struct loop_device *lo = bdev->bd_disk->private_data;
> 
> -	mutex_lock(&loop_mutex);
>  	mutex_lock(&lo->lo_ctl_mutex);
>  	lo->lo_refcnt++;
>  	mutex_unlock(&lo->lo_ctl_mutex);
> -	mutex_unlock(&loop_mutex);
> 
>  	return 0;
>  }
> @@ -1515,7 +1512,6 @@ static int lo_release(struct gendisk *disk, fmode_t
> mode) struct loop_device *lo = disk->private_data;
>  	int err;
> 
> -	mutex_lock(&loop_mutex);
>  	mutex_lock(&lo->lo_ctl_mutex);
> 
>  	if (--lo->lo_refcnt)
> @@ -1540,7 +1536,6 @@ static int lo_release(struct gendisk *disk, fmode_t
> mode) out:
>  	mutex_unlock(&lo->lo_ctl_mutex);
>  out_unlocked:
> -	mutex_unlock(&loop_mutex);
>  	return 0;
>  }
