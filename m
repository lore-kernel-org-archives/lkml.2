Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab1KCGlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:41:23 -0400
Received: from ozlabs.org ([203.10.76.45]:58372 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1KCGko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:40:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] virtio: support unlocked queue kick
In-Reply-To: <874nylua4z.fsf@rustcorp.com.au>
References: <20111005195403.407628164@bombadil.infradead.org> <20111005195529.964397366@bombadil.infradead.org> <87r52qgaf3.fsf@rustcorp.com.au> <20111006131828.GC19023@redhat.com> <20111101144045.GA15433@redhat.com> <87ty6ntdmf.fsf@rustcorp.com.au> <20111102072544.GA6967@infradead.org> <874nylua4z.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 03 Nov 2011 15:45:37 +1030
Message-ID: <871utpu6py.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Nov 2011 14:31:48 +1030, Rusty Russell <rusty@rustcorp.com.au> wrote:
> So let's change the API for everyone, into:
> 
>         bool virtqueue_should_kick(struct virtqueue *vq);
>         void virtqueue_kick(struct virtqueue *vq);
> 
> Patch series coming...

Nope, that sucked.  virtqueue_should_kick() has side effects (it has to,
if you want the actual kick to be outside the lock).

I stole the names from your patch instead, just added some documentation
and restored the "EXPORT_SYMBOL_GPL(virtqueue_kick);".  No Signed-off-by
on yours.

Also, one trivial nit.  You did:

	bool need_kick = false;
...
	if (vq->event) {
		if (vring_need_event(vring_avail_event(&vq->vring), new, old))
			need_kick = true;
	} else {
		if (!(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY))
			need_kick = true;
	}
...
        return need_kick;

I prefer to use uninitialized vars where possible:

        bool kick;

	if (vq->event) {
		kick = vring_need_event(vring_avail_event(&vq->vring), new, old);
	} else {
		kick = (!(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY));
	}
...
        return kick;

This way, GCC will give an uninitialized var warning if someone changes
the code and forgets to set kick.  This is especially noticeable with
err values and complex functions using goto.

Thanks,
Rusty.
