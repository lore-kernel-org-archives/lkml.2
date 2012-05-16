Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab2EPPKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:10:47 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58519 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab2EPPKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:10:44 -0400
Subject: Re: [V2 PATCH 9/9] vhost: zerocopy: poll vq in zerocopy callback
From: Shirley Ma <mashirle@us.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
In-Reply-To: <4FB317C8.90002@redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120502034254.11782.27314.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <1337100630.8220.4.camel@oc3660625478.ibm.com>  <4FB317C8.90002@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 May 2012 08:10:27 -0700
Message-ID: <1337181027.10741.13.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051615-7182-0000-0000-00000187A22D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 10:58 +0800, Jason Wang wrote:
> >>   drivers/vhost/vhost.c |    1 +
> >>   1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> >> index 947f00d..7b75fdf 100644
> >> --- a/drivers/vhost/vhost.c
> >> +++ b/drivers/vhost/vhost.c
> >> @@ -1604,6 +1604,7 @@ void vhost_zerocopy_callback(void *arg)
> >>          struct vhost_ubuf_ref *ubufs = ubuf->arg;
> >>          struct vhost_virtqueue *vq = ubufs->vq;
> >>
> >> +       vhost_poll_queue(&vq->poll);
> >>          /* set len = 1 to mark this desc buffers done DMA */
> >>          vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
> >>          kref_put(&ubufs->kref, vhost_zerocopy_done_signal);
> > Doing so, we might have redundant vhost_poll_queue(). Do you know in
> > which scenario there might be missing of adding and signaling during
> > zerocopy?
> 
> Yes, as we only do signaling and adding during tx work, if there's no
> tx 
> work when the skb were sent, we may lose the opportunity to let guest 
> know about the completion. It's easy to be reproduced with netperf
> test. 

The reason which host signals guest is to free guest tx buffers, if
there is no tx work, then it's not necessary to signal the guest unless
guest runs out of memory. The pending buffers will be released
virtio_net device gone.

What's the behavior of netperf test when you hit this situation?

Thanks
Shirley

