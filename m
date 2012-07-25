Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab2GYMOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:14:20 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56688 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab2GYMOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:14:17 -0400
From: Wang Sen <senwang@linux.vnet.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, pbonzini@redhat.com, stefanha@linux.vnet.ibm.com,
        mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wang Sen <senwang@linux.vnet.ibm.com>
Subject: [PATCH v2] scsi: virtio-scsi: Fix address translation failure of HighMem pages used by sg list
Date: Wed, 25 Jul 2012 20:13:10 +0800
Message-Id: <1343218390-24310-1-git-send-email-senwang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12072512-3568-0000-0000-00000232D17A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the commands below to write some data to a virtio-scsi LUN of the
QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.

        # sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
        # sudo mount /dev/sdb /mnt
        # dd if=/dev/zero of=/mnt/file bs=1M count=1024

In current implementation, sg_set_buf is called to add buffers to sg list which
is put into the virtqueue eventually. But if there are some HighMem pages in
table->sgl you can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
return NULL value. This will cause QEMU exit when virtqueue_map_sg is called
in QEMU because an invalid GPA is passed by virtqueue.

I take Paolo's solution mentioned in last thread to avoid failure on handling 
flag bits.

I have tested the patch on my workstation. QEMU would not crash any more.

Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
---
 drivers/scsi/virtio_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1b38431..6661610 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -198,7 +198,7 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
 	int i;
 
 	for_each_sg(table->sgl, sg_elem, table->nents, i)
-		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
+		sg[idx++] = *sg_elem;
 
 	*p_idx = idx;
 }
-- 
1.7.9.5

