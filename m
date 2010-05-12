Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0ELJWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab0ELJWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:22:48 -0400
From: Juan Quintela <quintela@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] vhost: fix barrier pairing
In-Reply-To: <20100511172633.GA9091@redhat.com> (Michael S. Tsirkin's message
	of "Tue, 11 May 2010 20:26:33 +0300")
References: <20100511172633.GA9091@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Date: Wed, 12 May 2010 11:22:12 +0200
Message-ID: <m3wrv9tqyj.fsf@trasno.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> wrote:
> According to memory-barriers.txt, an smp memory barrier
> should always be paired with another smp memory barrier,
> and I quote "a lack of appropriate pairing is almost certainly an
> error".
>
> In case of vhost, failure to flush out used index
> update before looking at the interrupt disable flag
> could result in missed interrupts, resulting in
> networking hang under stress.
>
> This might happen when flags read bypasses used index write.
> So we see interrupts disabled and do not interrupt, at the
> same time guest writes flags value to enable interrupt,
> reads an old used index value, thinks that
> used ring is empty and waits for interrupt.
>
> Note: the barrier we pair with here is in
> drivers/virtio/virtio_ring.c, function
> vring_enable_cb.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Dave, I think this is needed in 2.6.34, I'll send a pull
> request after doing some more testing.
>
> Rusty, Juan, could you take a look as well please?
> Thanks!

I would have prefered to put it:

void vhost_add_used_and_signal(struct vhost_dev *dev,
			       struct vhost_virtqueue *vq,
			       unsigned int head, int len)
{
	vhost_add_used(vq, head, len);
>>>>    smp_mb();
	vhost_signal(dev, vq);
}

Because it looks strange to have a barrier as the 1st instruction of a
function.  And this way it is clearer (at least to me) what we are
protecting.

But on the other hand, we would have to put a comment explainingthat all
users of vhost_signal() have to put that smp_mb() so .....

Perhaps just improving the commet stating that the corresponding barrier
is there?

> Note: the barrier we pair with here is in
> drivers/virtio/virtio_ring.c, function
> vring_enable_cb.

Good catch.

Later, Juan.
