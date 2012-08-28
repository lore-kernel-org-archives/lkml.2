Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab2H1OG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:06:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42716 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2H1OG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:06:57 -0400
Message-ID: <503CD097.2020900@gmail.com>
Date: Tue, 28 Aug 2012 16:07:19 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120826 Thunderbird/14.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/5] virtio-scsi: allocate target pointers in a separate
 memory block
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com> <1346154857-12487-4-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1346154857-12487-4-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 01:54 PM, Paolo Bonzini wrote:
> We will place the request virtqueues in the flexible array member.
> 
> Refining the virtqueue API would let us drop the sglist copy, at
> which point the pointer-to-array-of-pointers can become a simple
> pointer-to-array.  It would both simplify the allocation and remove a
> dereference in several hot paths.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c |   23 +++++++++++++++--------
>  1 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 595af1a..62fec04 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -77,7 +77,7 @@ struct virtio_scsi {
>  	/* Get some buffers ready for event vq */
>  	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
>  
> -	struct virtio_scsi_target_state *tgt[];
> +	struct virtio_scsi_target_state **tgt;
>  };
>  
>  static struct kmem_cache *virtscsi_cmd_cache;
> @@ -615,10 +615,13 @@ static void virtscsi_remove_vqs(struct virtio_device *vdev)
>  	/* Stop all the virtqueues. */
>  	vdev->config->reset(vdev);
>  
> -	num_targets = sh->max_id;
> -	for (i = 0; i < num_targets; i++) {
> -		kfree(vscsi->tgt[i]);
> -		vscsi->tgt[i] = NULL;
> +	if (vscsi->tgt) {
> +		num_targets = sh->max_id;
> +		for (i = 0; i < num_targets; i++) {
> +			kfree(vscsi->tgt[i]);

Since we now kmalloc() the vscsi->tgt array, it doesn't get zeroed anymore.

This means that if for example, num_targets=3, and the second
virtscsi_alloc_tgt() in virtscsi_init() failed, we're going to kfree() garbage here.


Thanks,
Sasha

> +			vscsi->tgt[i] = NULL;
> +		}
> +		kfree(vscsi->tgt);
>  	}
>  	vdev->config->del_vqs(vdev);
> @@ -660,6 +663,12 @@ static int virtscsi_init(struct virtio_device *vdev,
>  	/* We need to know how many segments before we allocate.  */
>  	sg_elems = virtscsi_config_get(vdev, seg_max) ?: 1;
>  
> +	vscsi->tgt = kmalloc(num_targets *
> +			sizeof(struct virtio_scsi_target_state *), GFP_KERNEL);
> +	if (!vscsi->tgt) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
>  	for (i = 0; i < num_targets; i++) {
>  		vscsi->tgt[i] = virtscsi_alloc_tgt(vdev, sg_elems);
>  		if (!vscsi->tgt[i]) {
> @@ -685,9 +694,7 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
>  
>  	/* Allocate memory and link the structs together.  */
>  	num_targets = virtscsi_config_get(vdev, max_target) + 1;
> -	shost = scsi_host_alloc(&virtscsi_host_template,
> -		sizeof(*vscsi)
> -		+ num_targets * sizeof(struct virtio_scsi_target_state));
> +	shost = scsi_host_alloc(&virtscsi_host_template, sizeof(*vscsi));
>  
>  	if (!shost)
>  		return -ENOMEM;
> 

