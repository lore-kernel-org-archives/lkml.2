Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1GIJHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 05:07:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37972 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1GIJHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 05:07:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 Jul 2011 11:05:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>,
        Tarak Reddy <tarak.reddy@in.ibm.com>,
        "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Check that queue is alive in
 blk_insert_cloned_request()
Message-ID: <20110709110538.35e1ea1e@stein>
In-Reply-To: <1310166270-23196-1-git-send-email-roland@kernel.org>
References: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
	<1310166270-23196-1-git-send-email-roland@kernel.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 08 Roland Dreier wrote:
> This fixes crashes such as the below that I see when the storage
> underlying a dm-multipath device is hot-removed.  The problem is that
> dm requeues a request to a device whose block queue has already been
> cleaned up, and blk_insert_cloned_request() doesn't check if the queue
> is alive, but rather goes ahead and tries to queue the request.  This
> ends up dereferencing the elevator that was already freed in
> blk_cleanup_queue().
[...]
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1706,6 +1706,9 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>  		return -EIO;
>  #endif
>  
> +	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
> +		return -EIO;
> +
>  	spin_lock_irqsave(q->queue_lock, flags);
>  
>  	/*

Not knowing the calling contexts or having tried to learn about them, I am
wondering:  What prevents the elevator to be freed right after the flag
was checked?
-- 
Stefan Richter
-=====-==-== -=== -=--=
http://arcgraph.de/sr/
