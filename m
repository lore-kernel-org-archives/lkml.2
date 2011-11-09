Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab1KJDyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:54:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966011Ab1KJDst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:04 2011
Message-Id: <20111109213204.219283718@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [216/264] [SCSI] Fix block queue and elevator memory leak in scsi_alloc_sdev
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit f7c9c6bb14f3104608a3a83cadea10a6943d2804 upstream.

When looking at memory consumption issues I noticed quite a
lot of memory in the kmalloc-2048 bucket:

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
  6561   6471  98%    2.30K    243       27     15552K kmalloc-2048

Over 15MB. slub debug shows that cfq is responsible for almost
all of it:

# sort -nr /sys/kernel/slab/kmalloc-2048/alloc_calls
6402 .cfq_init_queue+0xec/0x460 age=43423/43564/43655 pid=1 cpus=4,11,13

In scsi_alloc_sdev we do scsi_alloc_queue but if slave_alloc
fails we don't free it with scsi_free_queue.

The patch below fixes the issue:

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
   135     72  53%    2.30K      5       27       320K kmalloc-2048

# cat /sys/kernel/slab/kmalloc-2048/alloc_calls
3 .cfq_init_queue+0xec/0x460 age=3811/3876/3925 pid=1 cpus=4,11,13

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_scan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -322,6 +322,7 @@ out_device_destroy:
 	scsi_device_set_state(sdev, SDEV_DEL);
 	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_dev);
+	scsi_free_queue(sdev->request_queue);
 	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)


