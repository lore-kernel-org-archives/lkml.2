Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab2C1DkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 23:40:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57696 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab2C1DkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 23:40:22 -0400
X-IronPort-AV: E=Sophos;i="4.75,329,1330876800"; 
   d="scan'208";a="4635276"
Message-ID: <4F728831.2090406@cn.fujitsu.com>
Date: Wed, 28 Mar 2012 11:40:33 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: Kay Sievers <kay.sievers@vrfy.org>,
        Tokunaga Kei <tokunaga.keiich@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        UDEV <linux-hotplug@vger.kernel.org>
Subject: [RFC PATCH] virtio_blk: Checking "private_data"  to avoid kernel
 panic when hotplugging
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-28 11:38:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-28 11:38:07,
	Serialize complete at 2012-03-28 11:38:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On guest with upstream's kernel(3.3.0-rc7), I
mounted virtblk as:
   a) # mkfs /dev/vda
   b) # mount /dev/vda /mnt
   c) # cd /mnt

Then I did hotplug for virtblk via virsh on host as:
   a) # sudo virsh detach-disk guest vda
   b) # sudo virsh attach-disk guest /media/data/test.img vda

I encountered guest's kernel panic (*probability *
*event*)whose backtrace liked this:

PID: 2496   TASK: ffff88001f5de080  CPU: 0   COMMAND: "blkid"
  #0 [ffff88001afdbb00] machine_kexec at ffffffff81031fcb
  #1 [ffff88001afdbb60] crash_kexec at ffffffff810b8f72
  #2 [ffff88001afdbc30] oops_end at ffffffff814f04b0
  #3 [ffff88001afdbc60] die at ffffffff8100f26b
  #4 [ffff88001afdbc90] do_general_protection at ffffffff814f0042
  #5 [ffff88001afdbcc0] general_protection at ffffffff814ef815
     [exception RIP: virtio_check_driver_offered_feature+27]
     RIP: ffffffffa00540cb  RSP: ffff88001afdbd78  RFLAGS: 00010206
     RAX: ffffffff810ffde0  RBX: ffff88001f14a800  RCX: 000000004cf0758b
     RDX: 4ce86d8b4ce0658b  RSI: 0000000000000007  RDI: ffffffff81a970a0
     RBP: ffff88001afdbd78   R8: ffffffffa009d060   R9: 0000000000000100
     R10: 0000000000000006  R11: 0000000000000246  R12: 000000000000101d
     R13: 0000000000005331  R14: ffffffff81a970a0  R15: 0000000000000000
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
  #6 [ffff88001afdbd80] virtblk_ioctl at ffffffffa009c459 [virtio_blk]
  #7 [ffff88001afdbdc0] __blkdev_driver_ioctl at ffffffff81257317
  #8 [ffff88001afdbe00] blkdev_ioctl at ffffffff8125779d
  #9 [ffff88001afdbe50] block_ioctl at ffffffff811aec5c
#10 [ffff88001afdbe60] vfs_ioctl at ffffffff81189342
#11 [ffff88001afdbea0] do_vfs_ioctl at ffffffff811894e4
#12 [ffff88001afdbf30] sys_ioctl at ffffffff81189a61
#13 [ffff88001afdbf80] system_call_fastpath at ffffffff8100b0f2
     RIP: 0000003f566dd847  RSP: 00007fffa23e6130  RFLAGS: 00010202
     RAX: 0000000000000010  RBX: ffffffff8100b0f2  RCX: 0000000000000008
     RDX: 0000000000000000  RSI: 0000000000005331  RDI: 0000000000000003
     RBP: 0000000040000000   R8: 0000003f5699b580   R9: 0000000000000100
     R10: 0000000000000006  R11: 0000000000000246  R12: 0000000000000000
     R13: 0000003f59020ba0  R14: 0000000000000003  R15: 000000000241f030
     ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b

This panic was triggered by the command of "blkid" in
udev's rule "60-persistent-storage.rules".

So, when the virtblk was reattached, command "blkid"
probed filesystem metadata of disks. At that moment,
virtblk_ioctl() was called, but the data of "virtio_blk"
"bdev->bd_disk->private_data" pointing to may not be
updated for the sync reason.

This patch do this check to avoid panic.

Any comment will be appreciated.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
  virtio_blk.c |    6 ++++++
  1 file changed, 6 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c4a60ba..4ac81f8 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -245,6 +245,12 @@ static int virtblk_ioctl(struct block_device *bdev, 
fmode_t mode,
         struct virtio_blk *vblk = disk->private_data;

         /*
+        * Check whether the private data pointer has been updated.
+        */
+       if (vblk != vblk->vdev->priv)
+               return -EFAULT;
+
+       /*
          * Only allow the generic SCSI ioctls if the host can support it.
          */
         if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_SCSI))


Thanks,
Ren
