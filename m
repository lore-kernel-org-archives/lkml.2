Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1FHNLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:11:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab1FHNLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:11:06 -0400
Message-ID: <4DEF7521.6030902@redhat.com>
Date: Wed, 08 Jun 2011 09:12:01 -0400
From: Mark Wu <dwu@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
References: <1306913069-23637-1-git-send-email-dwu@redhat.com> <4DE5F78C.1010102@redhat.com> <20110602103406.GD7943@redhat.com>
In-Reply-To: <20110602103406.GD7943@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2011 06:34 AM, Michael S. Tsirkin wrote:
> On Wed, Jun 01, 2011 at 04:25:48AM -0400, Mark Wu wrote:
>> On 06/01/2011 03:24 AM, Mark Wu wrote:
>>> -	if (index_to_minor(index)>= 1<<  MINORBITS)
>>> -		return -ENOSPC;
>>> +	do {
>>> +		if (!ida_pre_get(&vd_index_ida, GFP_KERNEL))
>>> +			return err;
>>> +
>> There's a problem in above code: err is not initialized before
>> using, so change it to return -1;
>> +       do {
>> +               if (!ida_pre_get(&vd_index_ida, GFP_KERNEL))
>> +                       return -1;
> 
> Not -1. Pls return -ENOMEM.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi Michael,
Thanks for pointing out that. This is the revised patch.


>From ffe49efd20938952a09d5a87fe694a6f62937756 Mon Sep 17 00:00:00 2001
From: Mark Wu <dwu@redhat.com>
Date: Wed, 8 Jun 2011 08:25:53 -0400
Subject: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index

Current index allocation in virtio-blk is based on a monotonically
increasing variable "index". It could cause some confusion about disk
name in the case of hot-plugging disks. And it's impossible to find the
lowest available index by just maintaining a simple index. So it's
changed to use ida to allocate index via referring to the index
allocation in scsi disk.

Signed-off-by: Mark Wu <dwu@redhat.com>
---
 drivers/block/virtio_blk.c |   37 ++++++++++++++++++++++++++++++++-----
 1 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 079c088..f13b758 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -8,10 +8,14 @@
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
 #include <scsi/scsi_cmnd.h>
+#include <linux/idr.h>
 
 #define PART_BITS 4
 
-static int major, index;
+static int major;
+static DEFINE_SPINLOCK(vd_index_lock);
+static DEFINE_IDA(vd_index_ida);
+
 struct workqueue_struct *virtblk_wq;
 
 struct virtio_blk
@@ -23,6 +27,7 @@ struct virtio_blk
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
+	u32 index;
 
 	/* Request tracking. */
 	struct list_head reqs;
@@ -343,12 +348,26 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
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
+
+		spin_lock(&vd_index_lock);
+		err = ida_get_new(&vd_index_ida, &index);
+		spin_unlock(&vd_index_lock);
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
@@ -421,7 +440,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->private_data = vblk;
 	vblk->disk->fops = &virtblk_fops;
 	vblk->disk->driverfs_dev = &vdev->dev;
-	index++;
+	vblk->index = index;
 
 	/* configure queue flush support */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
@@ -516,6 +535,10 @@ out_free_vq:
 	vdev->config->del_vqs(vdev);
 out_free_vblk:
 	kfree(vblk);
+out_free_index:
+	spin_lock(&vd_index_lock);
+	ida_remove(&vd_index_ida, index);
+	spin_unlock(&vd_index_lock);
 out:
 	return err;
 }
@@ -538,6 +561,10 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	mempool_destroy(vblk->pool);
 	vdev->config->del_vqs(vdev);
 	kfree(vblk);
+
+	spin_lock(&vd_index_lock);
+	ida_remove(&vd_index_ida, vblk->index);
+	spin_unlock(&vd_index_lock);
 }
 
 static const struct virtio_device_id id_table[] = {
-- 
1.7.1
