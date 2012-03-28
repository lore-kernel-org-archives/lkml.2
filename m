Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab2C1UcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:32:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab2C1UcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:32:13 -0400
Date: Wed, 28 Mar 2012 16:32:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] virtio-blk: Call revalidate_disk() upon online disk resize
Message-ID: <20120328203200.GE3376@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a virtio disk is open in guest and a disk resize operation is done,
(virsh blockresize), new size is not visible to tools like "fdisk -l".
This seems to be happening as we update only part->nr_sects and not
bdev->bd_inode size.

Call revalidate_disk() which should take care of it. I tested growing disk
size of already open disk and it works for me.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/virtio_blk.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2012-03-27 17:05:07.000000000 -0400
+++ linux-2.6/drivers/block/virtio_blk.c	2012-03-28 15:55:03.943462782 -0400
@@ -351,6 +351,7 @@ static void virtblk_config_changed_work(
 		  cap_str_10, cap_str_2);
 
 	set_capacity(vblk->disk, capacity);
+	revalidate_disk(vblk->disk);
 done:
 	mutex_unlock(&vblk->config_lock);
 }
