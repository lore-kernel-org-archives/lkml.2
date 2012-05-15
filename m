Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab2EOQvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:51:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39232 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab2EOQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:51:39 -0400
Subject: Re: [V2 PATCH 9/9] vhost: zerocopy: poll vq in zerocopy callback
From: Shirley Ma <mashirle@us.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
In-Reply-To: <20120502034254.11782.27314.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120502034254.11782.27314.stgit@amd-6168-8-1.englab.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 09:50:30 -0700
Message-ID: <1337100630.8220.4.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051516-5518-0000-0000-0000046BD8AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 11:42 +0800, Jason Wang wrote:
> We add used and signal guest in worker thread but did not poll the
> virtqueue
> during the zero copy callback. This may lead the missing of adding and
> signalling during zerocopy. Solve this by polling the virtqueue and
> let it
> wakeup the worker during callback.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vhost.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 947f00d..7b75fdf 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1604,6 +1604,7 @@ void vhost_zerocopy_callback(void *arg)
>         struct vhost_ubuf_ref *ubufs = ubuf->arg;
>         struct vhost_virtqueue *vq = ubufs->vq;
> 
> +       vhost_poll_queue(&vq->poll);
>         /* set len = 1 to mark this desc buffers done DMA */
>         vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
>         kref_put(&ubufs->kref, vhost_zerocopy_done_signal);

Doing so, we might have redundant vhost_poll_queue(). Do you know in
which scenario there might be missing of adding and signaling during
zerocopy?

Thanks
Shirley

