Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab2GFDQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:16:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab2GFDQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:16:03 -0400
Message-ID: <4FF658E4.6030008@redhat.com>
Date: Fri, 06 Jul 2012 11:17:56 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: mst@redhat.com, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 2/5] virtio_ring: move queue_index to vring_virtqueue
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>  <1341484194-8108-3-git-send-email-jasowang@redhat.com> <1341488454.18786.15.camel@lappy>
In-Reply-To: <1341488454.18786.15.camel@lappy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 07:40 PM, Sasha Levin wrote:
> On Thu, 2012-07-05 at 18:29 +0800, Jason Wang wrote:
>> Instead of storing the queue index in virtio infos, this patch moves them to
>> vring_virtqueue and introduces helpers to set and get the value. This would
>> simplify the management and tracing.
>>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
> This patch actually fails to compile:
>
> drivers/virtio/virtio_mmio.c: In function ‘vm_notify’:
> drivers/virtio/virtio_mmio.c:229:13: error: ‘struct virtio_mmio_vq_info’ has no member named ‘queue_index’
> drivers/virtio/virtio_mmio.c: In function ‘vm_del_vq’:
> drivers/virtio/virtio_mmio.c:278:13: error: ‘struct virtio_mmio_vq_info’ has no member named ‘queue_index’
> make[2]: *** [drivers/virtio/virtio_mmio.o] Error 1
>
> It probably misses the following hunks:
>
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index f5432b6..12b6180 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -222,11 +222,10 @@ static void vm_reset(struct virtio_device *vdev)
>   static void vm_notify(struct virtqueue *vq)
>   {
>          struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
> -       struct virtio_mmio_vq_info *info = vq->priv;
>
>          /* We write the queue's selector into the notification register to
>           * signal the other end */
> -       writel(info->queue_index, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
> +       writel(virtqueue_get_queue_index(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
>   }
>
>   /* Notify all virtqueues on an interrupt. */
> @@ -275,7 +274,7 @@ static void vm_del_vq(struct virtqueue *vq)
>          vring_del_virtqueue(vq);
>
>          /* Select and deactivate the queue */
> -       writel(info->queue_index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
> +       writel(virtqueue_get_queue_index(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
>          writel(0, vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
>
>          size = PAGE_ALIGN(vring_size(info->num, VIRTIO_MMIO_VRING_ALIGN));
>
Oops, I miss the virtio mmio part, thanks for pointing this.
