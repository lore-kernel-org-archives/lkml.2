Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab2J3PwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:52:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab2J3PwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:52:03 -0400
Date: Tue, 30 Oct 2012 17:54:12 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Vlad Yasevich <vyasevic@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] vhost-net: reduce vq polling on tx zerocopy
Message-ID: <20121030155412.GA7256@redhat.com>
References: <cover.1351524501.git.mst@redhat.com>
 <3e57e2cde71a4270a8fef395c31f5f0e8a130c28.1351524502.git.mst@redhat.com>
 <508FF6A1.5060201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508FF6A1.5060201@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 11:47:45AM -0400, Vlad Yasevich wrote:
> On 10/29/2012 11:49 AM, Michael S. Tsirkin wrote:
> >It seems that to avoid deadlocks it is enough to poll vq before
> >  we are going to use the last buffer.  This should be faster than
> >c70aa540c7a9f67add11ad3161096fb95233aa2e.
> >
> >Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >---
> >  drivers/vhost/net.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >index 8e9de79..3967f82 100644
> >--- a/drivers/vhost/net.c
> >+++ b/drivers/vhost/net.c
> >@@ -197,8 +197,16 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, int status)
> >  {
> >  	struct vhost_ubuf_ref *ubufs = ubuf->ctx;
> >  	struct vhost_virtqueue *vq = ubufs->vq;
> >-
> >-	vhost_poll_queue(&vq->poll);
> >+	int cnt = atomic_read(&ubufs->kref.refcount);
> >+
> >+	/*
> >+	 * Trigger polling thread if guest stopped submitting new buffers:
> >+	 * in this case, the refcount after decrement will eventually reach 1
> >+	 * so here it is 2.
> >+	 * We also trigger polling periodically after each 16 packets.
> >+	 */
> >+	if (cnt <= 2 || !(cnt % 16))
> 
> Why 16?  Does it make sense to make it configurable?
> 
> -vlad

Probably not but I'll add a comment explaining why.

> >+		vhost_poll_queue(&vq->poll);
> >  	/* set len to mark this desc buffers done DMA */
> >  	vq->heads[ubuf->desc].len = status ?
> >  		VHOST_DMA_FAILED_LEN : VHOST_DMA_DONE_LEN;
> >
