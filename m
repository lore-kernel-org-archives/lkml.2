Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1FSNzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 09:55:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50861
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953Ab1FSNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 09:55:23 -0400
Date: Sun, 19 Jun 2011 09:55:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [RFC] virtio: Support releasing lock during kick
Message-ID: <20110619135507.GA25728@infradead.org>
References: <1277328242-10685-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <20110619074841.GA8613@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619074841.GA8613@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 10:48:41AM +0300, Michael S. Tsirkin wrote:
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4ce953f..a8672ec 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -433,6 +433,8 @@ void blk_run_queue(struct request_queue *q)
>  	spin_lock_irqsave(q->queue_lock, flags);
>  	__blk_run_queue(q);
>  	spin_unlock_irqrestore(q->queue_lock, flags);
> +	if (q->request_done)
> +		q->request_done(q);

We have quite a few cases where __blk_run_queue is called directly, and
one more (although not applicable to virtio-blk) that calls ->request_fn
directly.

I think Stefan's way is the way to go for now, releasing and reacquiring
the queue lock once in ->request_fn is much less than the common IDE and
SCSI setups do today.

Eventually ->queue_lock should be split from the driver-internal lock,
and we could do a more efficient calling convention than the one per
request blk_peek_request.  I've started looking into that, but it's
going to take a while.

