Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032532Ab2I1U1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:27:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63188 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032516Ab2I1U0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wang Sen <senwang@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 099/218] SCSI: scsi: virtio-scsi: Fix address translation failure of HighMem pages used by sg list
Date: Fri, 28 Sep 2012 13:15:16 -0700
Message-Id: <20120928201512.936632707@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Sen <senwang@linux.vnet.ibm.com>

commit 27e99ade81368e6fdda3212bff9345177cf9e57a upstream.

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

Two solutions are discussed here:
http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/00675.html

Finally, value assignment approach was adopted because:

Value assignment creates a well-formed scatterlist, because the termination
marker in source sg_list has been set in blk_rq_map_sg(). The last entry of the
source sg_list is just copied to the the last entry in destination list.  Note
that, for now, virtio_ring does not care about the form of the scatterlist and
simply processes the first out_num + in_num consecutive elements of the sg[]
array.

I have tested the patch on my workstation. QEMU would not crash any more.

Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/virtio_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -198,7 +198,7 @@ static void virtscsi_map_sgl(struct scat
 	int i;
 
 	for_each_sg(table->sgl, sg_elem, table->nents, i)
-		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
+		sg[idx++] = *sg_elem;
 
 	*p_idx = idx;
 }


