Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030920Ab2HQIhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:37:34 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:54525 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030881Ab2HQIh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:37:27 -0400
Date: Fri, 17 Aug 2012 09:37:19 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: JBottomley@parallels.com
Cc: pbonzini@redhat.com, bharrosh@panasas.com, mc@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        zwanp@cn.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        Wang Sen <senwang@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Message-ID: <20120817083719.GA8485@stefanha-thinkpad.localdomain>
References: <1343629506-29627-1-git-send-email-senwang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343629506-29627-1-git-send-email-senwang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12081708-0342-0000-0000-000002978079
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 02:25:06PM +0800, Wang Sen wrote:
> When using the commands below to write some data to a virtio-scsi LUN of the
> QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.
> 
>         # sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
>         # sudo mount /dev/sdb /mnt
>         # dd if=/dev/zero of=/mnt/file bs=1M count=1024
> 
> In current implementation, sg_set_buf is called to add buffers to sg list which
> is put into the virtqueue eventually. But if there are some HighMem pages in
> table->sgl you can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
> return NULL value. This will cause QEMU exit when virtqueue_map_sg is called
> in QEMU because an invalid GPA is passed by virtqueue.
> 
> Two solutions are discussed here:
> http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/00675.html
> 
> Finally, value assignment approach was adopted because:
> 
> Value assignment creates a well-formed scatterlist, because the termination 
> marker in source sg_list has been set in blk_rq_map_sg(). The last entry of the
> source sg_list is just copied to the the last entry in destination list.  Note 
> that, for now, virtio_ring does not care about the form of the scatterlist and 
> simply processes the first out_num + in_num consecutive elements of the sg[] 
> array.
> 
> I have tested the patch on my workstation. QEMU would not crash any more.
> 
> Cc: <stable@vger.kernel.org> # 3.4: 4fe74b1: [SCSI] virtio-scsi: SCSI driver
> Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 1b38431..6661610 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -198,7 +198,7 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
>  	int i;
> 
>  	for_each_sg(table->sgl, sg_elem, table->nents, i)
> -		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
> +		sg[idx++] = *sg_elem;
> 
>  	*p_idx = idx;
>  }
> -- 
> 1.7.9.5

Paolo has acked and no further issues have been raised.

James: Can this be merged?

Stefan

