Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1KBV41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:56:27 -0400
Received: from ozlabs.org ([203.10.76.45]:58942 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1KBV4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:56:25 -0400
Date: Thu, 3 Nov 2011 08:56:22 +1100
From: Anton Blanchard <anton@samba.org>
To: JBottomley@parallels.com, axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] Fix block queue and elevator memory leak in
 scsi_alloc_sdev
Message-ID: <20111103085622.2cde66ea@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
Cc: <stable@kernel.org>
---
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 44e8ca3..72273a0 100644
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
