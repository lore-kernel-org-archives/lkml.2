Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab2LCCon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:44:43 -0500
Received: from ozlabs.org ([203.10.76.45]:52561 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab2LCCoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:44:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr,
        shiyer@redhat.com, Jason Wang <jasowang@redhat.com>
Subject: Re: [net-next rfc v7 1/3] virtio-net: separate fields of sending/receiving queue from virtnet_info
In-Reply-To: <1354011360-39479-2-git-send-email-jasowang@redhat.com>
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com> <1354011360-39479-2-git-send-email-jasowang@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 03 Dec 2012 12:25:42 +1030
Message-ID: <87y5hfj3vl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> To support multiqueue transmitq/receiveq, the first step is to separate queue
> related structure from virtnet_info. This patch introduce send_queue and
> receive_queue structure and use the pointer to them as the parameter in
> functions handling sending/receiving.

OK, seems like a straightforward xform: a few nit-picks:

> +/* Internal representation of a receive virtqueue */
> +struct receive_queue {
> +	/* Virtqueue associated with this receive_queue */
> +	struct virtqueue *vq;
> +
> +        struct napi_struct napi;
> +
> +        /* Number of input buffers, and max we've ever had. */
> +        unsigned int num, max;

Weird whitespace here.

> +
> +	/* Work struct for refilling if we run low on memory. */
> +	struct delayed_work refill;

I can't really see the justificaiton for a refill per queue.  Just have
one work iterate all the queues if it happens, unless it happens often
(in which case, we need to look harder at this anyway).

>  struct virtnet_info {
>  	struct virtio_device *vdev;
> -	struct virtqueue *rvq, *svq, *cvq;
> +	struct virtqueue *cvq;
>  	struct net_device *dev;
>  	struct napi_struct napi;

You leave napi here, and take it away in the next patch.  I think it's
supposed to go away now.

Cheers,
Rusty.
