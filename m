Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab1GHKgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:36:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1GHKgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:36:47 -0400
Message-ID: <4E16DE10.4050509@redhat.com>
Date: Fri, 08 Jul 2011 18:38:08 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110126 Red Hat/3.1.8-1.el6 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: set log when updating used flags or avail
 event
References: <20110621100426.6777.68855.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com> <20110621100438.6777.20695.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com> <20110707125728.GA2469@redhat.com>
In-Reply-To: <20110707125728.GA2469@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 08:57 PM, Michael S. Tsirkin wrote:
> Subject: vhost: used ring logging cleanup
>
> remove extra log bit setting for used ring updates: it's no longer
> necessary.  Also, use vhost_avail_event instead of duplicating offset
> math.
>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> ---
>
>> We need set log when updating used flags and avail event. Otherwise guest may
>> see stale values after migration and then do not exit or exit unexpectedly.
>>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
> OK but this means we set the log twice now.
> Also, hardcording offset is not as nice as using
> vhost_avail_event. So I think the below is needed
> on top. Comments?
>

Right, thanks for the cleanup.

>   drivers/vhost/vhost.c |   29 +++++++++--------------------
>   1 files changed, 9 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 540591b..c5f96ba 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -946,14 +946,16 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
>
>   static int vhost_update_used_flags(struct vhost_virtqueue *vq)
>   {
> +	void __user *used;
>   	if (put_user(vq->used_flags,&vq->used->flags)<  0)
>   		return -EFAULT;
>   	if (unlikely(vq->log_used)) {
>   		/* Make sure the flag is seen before log. */
>   		smp_wmb();
>   		/* Log used flag write. */
> -		log_write(vq->log_base,
> -			  vq->log_addr + offsetof(struct vring_used, flags),
> +		used =&vq->used->flags;
> +		log_write(vq->log_base, vq->log_addr +
> +			  (used - (void __user *)vq->used),
>   			  sizeof vq->used->flags);
>   		if (vq->log_ctx)
>   			eventfd_signal(vq->log_ctx, 1);
> @@ -966,13 +968,14 @@ static int vhost_update_avail_event(struct vhost_virtqueue *vq, u16 avail_event)
>   	if (put_user(vq->avail_idx, vhost_avail_event(vq)))
>   		return -EFAULT;
>   	if (unlikely(vq->log_used)) {
> +		void __user *used;
>   		/* Make sure the event is seen before log. */
>   		smp_wmb();
>   		/* Log avail event write */
> -		log_write(vq->log_base,
> -			  vq->log_addr + offsetof(struct vring_used,
> -						  ring[vq->num]),
> -			  sizeof avail_event);
> +		used = vhost_avail_event(vq);
> +		log_write(vq->log_base, vq->log_addr +
> +			  (used - (void __user *)vq->used),
> +			  sizeof *vhost_avail_event(vq));
>   		if (vq->log_ctx)
>   			eventfd_signal(vq->log_ctx, 1);
>   	}
> @@ -1474,20 +1477,6 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>   			return false;
>   		}
>   	}
> -	if (unlikely(vq->log_used)) {
> -		void __user *used;
> -		/* Make sure data is seen before log. */
> -		smp_wmb();
> -		used = vhost_has_feature(dev, VIRTIO_RING_F_EVENT_IDX) ?
> -			&vq->used->flags : vhost_avail_event(vq);
> -		/* Log used flags or event index entry write. Both are 16 bit
> -		 * fields. */
> -		log_write(vq->log_base, vq->log_addr +
> -			   (used - (void __user *)vq->used),
> -			  sizeof(u16));
> -		if (vq->log_ctx)
> -			eventfd_signal(vq->log_ctx, 1);
> -	}
>   	/* They could have slipped one in as we were doing that: make
>   	 * sure it's written, then check again. */
>   	smp_mb();

