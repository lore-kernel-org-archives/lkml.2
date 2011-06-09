Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab1FIKlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 06:41:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1FIKlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 06:41:11 -0400
Message-ID: <4DF0A374.6090504@redhat.com>
Date: Thu, 09 Jun 2011 06:41:56 -0400
From: Mark Wu <dwu@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
References: <1306913069-23637-1-git-send-email-dwu@redhat.com> <87mxi1xfz0.fsf@rustcorp.com.au> <4DEF744D.9040702@redhat.com> <87mxhrgba6.fsf@rustcorp.com.au> <20110609091433.GB11773@htj.dyndns.org>
In-Reply-To: <20110609091433.GB11773@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 05:14 AM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jun 09, 2011 at 08:51:05AM +0930, Rusty Russell wrote:
>> On Wed, 08 Jun 2011 09:08:29 -0400, Mark Wu <dwu@redhat.com> wrote:
>>> Hi Rusty,
>>> Yes, I can't figure out an instance of disk probing in parallel either, but as
>>> per the following commit, I think we still need use lock for safety. What's your opinion?
>>>
>>> commit 4034cc68157bfa0b6622efe368488d3d3e20f4e6
>>> Author: Tejun Heo <tj@kernel.org>
>>> Date:   Sat Feb 21 11:04:45 2009 +0900
>>>
>>>     [SCSI] sd: revive sd_index_lock
>>>
>>>     Commit f27bac2761cab5a2e212dea602d22457a9aa6943 which converted sd to
>>>     use ida instead of idr incorrectly removed sd_index_lock around id
>>>     allocation and free.  idr/ida do have internal locks but they protect
>>>     their free object lists not the allocation itself.  The caller is
>>>     responsible for that.  This missing synchronization led to the same id
>>>     being assigned to multiple devices leading to oops.
>>
>> I'm confused.  Tejun, Greg, anyone can probes happen in parallel?
>>
>> If so, I'll have to review all my drivers.
> 
> Unless async is explicitly used, probe happens sequentially.  IOW, if
> there's no async_schedule() call, things won't happen in parallel.
> That said, I think it wouldn't be such a bad idea to protect ida with
> spinlock regardless unless the probe code explicitly requires
> serialization.
> 
> Thanks.
> 
Since virtio blk driver doesn't use async probe, it needn't use spinlock to protect ida.
So remove the lock from patch.

>From fbb396df9dbf8023f1b268be01b43529a3993d57 Mon Sep 17 00:00:00 2001
From: Mark Wu <dwu@redhat.com>
Date: Thu, 9 Jun 2011 06:34:07 -0400
Subject: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index

Current index allocation in virtio-blk is based on a monotonically
increasing variable "index". It could cause some confusion about disk
name in the case of hot-plugging disks. And it's impossible to find the
lowest available index by just maintaining a simple index. So it's
changed to use ida to allocate index via referring to the index
allocation in scsi disk.

Signed-off-by: Mark Wu <dwu@redhat.com>
---
 drivers/block/virtio_blk.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 079c088..bf81ab6 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -8,10 +8,13 @@
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
 #include <scsi/scsi_cmnd.h>
+#include <linux/idr.h>
 
 #define PART_BITS 4
 
-static int major, index;
+static int major;
+static DEFINE_IDA(vd_index_ida);
+
 struct workqueue_struct *virtblk_wq;
 
 struct virtio_blk
@@ -23,6 +26,7 @@ struct virtio_blk
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
+	u32 index;
 
 	/* Request tracking. */
 	struct list_head reqs;
@@ -343,12 +347,23 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	struct request_queue *q;
 	int err;
 	u64 cap;
-	u32 v, blk_size, sg_elems, opt_io_size;
+	u32 v, blk_size, sg_elems, opt_io_size, index;
 	u16 min_io_size;
 	u8 physical_block_exp, alignment_offset;
 
-	if (index_to_minor(index) >= 1 << MINORBITS)
-		return -ENOSPC;
+	do {
+		if (!ida_pre_get(&vd_index_ida, GFP_KERNEL))
+			return -ENOMEM;
+		err = ida_get_new(&vd_index_ida, &index);
+	} while (err == -EAGAIN);
+
+	if (err)
+		return err;
+
+	if (index_to_minor(index) >= 1 << MINORBITS) {
+		err =  -ENOSPC;
+		goto out_free_index;
+	}
 
 	/* We need to know how many segments before we allocate. */
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_SEG_MAX,
@@ -421,7 +436,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->private_data = vblk;
 	vblk->disk->fops = &virtblk_fops;
 	vblk->disk->driverfs_dev = &vdev->dev;
-	index++;
+	vblk->index = index;
 
 	/* configure queue flush support */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
@@ -516,6 +531,8 @@ out_free_vq:
 	vdev->config->del_vqs(vdev);
 out_free_vblk:
 	kfree(vblk);
+out_free_index:
+	ida_remove(&vd_index_ida, index);
 out:
 	return err;
 }
@@ -538,6 +555,7 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	mempool_destroy(vblk->pool);
 	vdev->config->del_vqs(vdev);
 	kfree(vblk);
+	ida_remove(&vd_index_ida, vblk->index);
 }
 
 static const struct virtio_device_id id_table[] = {
-- 
1.7.1

