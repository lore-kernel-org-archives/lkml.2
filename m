Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2LRNdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:33:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573Ab2LRNdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:33:08 -0500
Date: Tue, 18 Dec 2012 15:36:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        rusty@rustcorp.com.au, asias@redhat.com, stefanha@redhat.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
 buffers
Message-ID: <20121218133606.GC26110@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
 <1355833972-20319-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355833972-20319-2-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some comments without arguing about whether the performance
benefit is worth it.

On Tue, Dec 18, 2012 at 01:32:48PM +0100, Paolo Bonzini wrote:
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index cf8adb1..39d56c4 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -7,6 +7,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/device.h>
>  #include <linux/mod_devicetable.h>
> +#include <linux/dma-direction.h>
>  #include <linux/gfp.h>
>  
>  /**
> @@ -40,6 +41,26 @@ int virtqueue_add_buf(struct virtqueue *vq,
>  		      void *data,
>  		      gfp_t gfp);
>  
> +struct virtqueue_buf {
> +	struct virtqueue *vq;
> +	struct vring_desc *indirect, *tail;

This is wrong: virtio.h does not include virito_ring.h,
and it shouldn't by design depend on it.

> +	int head;
> +};
> +

Can't we track state internally to the virtqueue?
Exposing it seems to buy us nothing since you can't
call add_buf between start and end anyway.


> +int virtqueue_start_buf(struct virtqueue *_vq,
> +			struct virtqueue_buf *buf,
> +			void *data,
> +			unsigned int count,
> +			unsigned int count_sg,
> +			gfp_t gfp);
> +
> +void virtqueue_add_sg(struct virtqueue_buf *buf,
> +		      struct scatterlist sgl[],
> +		      unsigned int count,
> +		      enum dma_data_direction dir);
> +

And idea: in practice virtio scsi seems to always call sg_init_one, no?
So how about we pass in void* or something and avoid using sg and count?
This would make it useful for -net BTW.

> +void virtqueue_end_buf(struct virtqueue_buf *buf);
> +
>  void virtqueue_kick(struct virtqueue *vq);
>  
>  bool virtqueue_kick_prepare(struct virtqueue *vq);
> -- 
> 1.7.1
> 
