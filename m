Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab2C1LLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:11:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab2C1LLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:11:16 -0400
Date: Wed, 28 Mar 2012 13:11:16 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kay Sievers <kay.sievers@vrfy.org>,
        Tokunaga Kei <tokunaga.keiich@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        UDEV <linux-hotplug@vger.kernel.org>
Subject: Re: [RFC PATCH] virtio_blk: Checking "private_data"  to avoid kernel
 panic when hotplugging
Message-ID: <20120328111115.GE6194@redhat.com>
References: <4F728831.2090406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F728831.2090406@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 11:40:33AM +0800, Ren Mingxin wrote:
>  Hi,
> 
> On guest with upstream's kernel(3.3.0-rc7), I
> mounted virtblk as:
>   a) # mkfs /dev/vda
>   b) # mount /dev/vda /mnt
>   c) # cd /mnt
> 
> Then I did hotplug for virtblk via virsh on host as:
>   a) # sudo virsh detach-disk guest vda
>   b) # sudo virsh attach-disk guest /media/data/test.img vda

Did a quick test and I don't seem to see a panic.
How reproducible is this for you?

> I encountered guest's kernel panic (*probability *
> *event*)whose backtrace liked this:
> 
> PID: 2496   TASK: ffff88001f5de080  CPU: 0   COMMAND: "blkid"
>  #0 [ffff88001afdbb00] machine_kexec at ffffffff81031fcb
>  #1 [ffff88001afdbb60] crash_kexec at ffffffff810b8f72
>  #2 [ffff88001afdbc30] oops_end at ffffffff814f04b0
>  #3 [ffff88001afdbc60] die at ffffffff8100f26b
>  #4 [ffff88001afdbc90] do_general_protection at ffffffff814f0042
>  #5 [ffff88001afdbcc0] general_protection at ffffffff814ef815
>     [exception RIP: virtio_check_driver_offered_feature+27]
>     RIP: ffffffffa00540cb  RSP: ffff88001afdbd78  RFLAGS: 00010206
>     RAX: ffffffff810ffde0  RBX: ffff88001f14a800  RCX: 000000004cf0758b
>     RDX: 4ce86d8b4ce0658b  RSI: 0000000000000007  RDI: ffffffff81a970a0
>     RBP: ffff88001afdbd78   R8: ffffffffa009d060   R9: 0000000000000100
>     R10: 0000000000000006  R11: 0000000000000246  R12: 000000000000101d
>     R13: 0000000000005331  R14: ffffffff81a970a0  R15: 0000000000000000
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #6 [ffff88001afdbd80] virtblk_ioctl at ffffffffa009c459 [virtio_blk]
>  #7 [ffff88001afdbdc0] __blkdev_driver_ioctl at ffffffff81257317
>  #8 [ffff88001afdbe00] blkdev_ioctl at ffffffff8125779d
>  #9 [ffff88001afdbe50] block_ioctl at ffffffff811aec5c
> #10 [ffff88001afdbe60] vfs_ioctl at ffffffff81189342
> #11 [ffff88001afdbea0] do_vfs_ioctl at ffffffff811894e4
> #12 [ffff88001afdbf30] sys_ioctl at ffffffff81189a61
> #13 [ffff88001afdbf80] system_call_fastpath at ffffffff8100b0f2
>     RIP: 0000003f566dd847  RSP: 00007fffa23e6130  RFLAGS: 00010202
>     RAX: 0000000000000010  RBX: ffffffff8100b0f2  RCX: 0000000000000008
>     RDX: 0000000000000000  RSI: 0000000000005331  RDI: 0000000000000003
>     RBP: 0000000040000000   R8: 0000003f5699b580   R9: 0000000000000100
>     R10: 0000000000000006  R11: 0000000000000246  R12: 0000000000000000
>     R13: 0000003f59020ba0  R14: 0000000000000003  R15: 000000000241f030
>     ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b
> 
> This panic was triggered by the command of "blkid" in
> udev's rule "60-persistent-storage.rules".

The weird thing is, we should not get any ioctls
before add_disk is called.

> 
> So, when the virtblk was reattached, command "blkid"
> probed filesystem metadata of disks. At that moment,
> virtblk_ioctl() was called, but the data of "virtio_blk"
> "bdev->bd_disk->private_data" pointing to may not be
> updated for the sync reason.

Sorry, what does "for the sync reason" mean?
private_data seems to be set at device probe
and never changed.

> This patch do this check to avoid panic.
> 
> Any comment will be appreciated.
> 
> Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
> ---
>  virtio_blk.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index c4a60ba..4ac81f8 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -245,6 +245,12 @@ static int virtblk_ioctl(struct block_device
> *bdev, fmode_t mode,
>         struct virtio_blk *vblk = disk->private_data;
> 
>         /*
> +        * Check whether the private data pointer has been updated.
> +        */
> +       if (vblk != vblk->vdev->priv)
> +               return -EFAULT;
> +

I would change this to
BUG_ON(vblk != vblk->vdev->priv);

Add traces to virtblk_probe/virtblk_remove
and see where the bad device came from.

> +       /*
>          * Only allow the generic SCSI ioctls if the host can support it.
>          */
>         if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_SCSI))
> 
> 
> Thanks,
> Ren
