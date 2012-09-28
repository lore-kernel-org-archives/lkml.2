Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299Ab2I1TAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:00:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab2I1TAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wang Sen <senwang@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 125/262] SCSI: scsi: virtio-scsi: Fix address translation failure of HighMem pages used by sg list
Date: Fri, 28 Sep 2012 11:50:54 -0700
Message-Id: <20120928183012.826679900@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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


