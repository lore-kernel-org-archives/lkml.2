Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab2IIXdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:33:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755827Ab2IIXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:09 -0400
Message-Id: <20120909224202.234884154@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Asias He <asias@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 85/95] virtio_blk: Drop unused request tracking list
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asias He <asias@redhat.com>

commit f65ca1dc6a8c81c6bd72297d4399ec5f4c1f3a01 upstream.

Benchmark shows small performance improvement on fusion io device.

Before:
  seq-read : io=1,024MB, bw=19,982KB/s, iops=39,964, runt= 52475msec
  seq-write: io=1,024MB, bw=20,321KB/s, iops=40,641, runt= 51601msec
  rnd-read : io=1,024MB, bw=15,404KB/s, iops=30,808, runt= 68070msec
  rnd-write: io=1,024MB, bw=14,776KB/s, iops=29,552, runt= 70963msec

After:
  seq-read : io=1,024MB, bw=20,343KB/s, iops=40,685, runt= 51546msec
  seq-write: io=1,024MB, bw=20,803KB/s, iops=41,606, runt= 50404msec
  rnd-read : io=1,024MB, bw=16,221KB/s, iops=32,442, runt= 64642msec
  rnd-write: io=1,024MB, bw=15,199KB/s, iops=30,397, runt= 68991msec

Signed-off-by: Asias He <asias@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/virtio_blk.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -27,9 +27,6 @@ struct virtio_blk
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
 
-	/* Request tracking. */
-	struct list_head reqs;
-
 	mempool_t *pool;
 
 	/* Process context for config space updates */
@@ -53,7 +50,6 @@ struct virtio_blk
 
 struct virtblk_req
 {
-	struct list_head list;
 	struct request *req;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
@@ -97,7 +93,6 @@ static void blk_done(struct virtqueue *v
 		}
 
 		__blk_end_request_all(vbr->req, error);
-		list_del(&vbr->list);
 		mempool_free(vbr, vblk->pool);
 	}
 	/* In case queue is stopped waiting for more buffers. */
@@ -182,7 +177,6 @@ static bool do_req(struct request_queue
 		return false;
 	}
 
-	list_add_tail(&vbr->list, &vblk->reqs);
 	return true;
 }
 
@@ -394,7 +388,6 @@ static int __devinit virtblk_probe(struc
 		goto out_free_index;
 	}
 
-	INIT_LIST_HEAD(&vblk->reqs);
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
 	sg_init_table(vblk->sg, vblk->sg_elems);
@@ -559,9 +552,6 @@ static void __devexit virtblk_remove(str
 	vblk->config_enable = false;
 	mutex_unlock(&vblk->config_lock);
 
-	/* Nothing should be pending. */
-	BUG_ON(!list_empty(&vblk->reqs));
-
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 


