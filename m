Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1KDJl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:41:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46671 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1KDJl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:41:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 4 Nov 2011 10:40:42 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jiri Slaby <jslaby@suse.cz>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
Message-ID: <20111104104042.46a33554@stein>
In-Reply-To: <20111103162634.GK4417@google.com>
References: <4EB2BC88.3070105@suse.cz>
	<20111103161436.GJ4417@google.com>
	<20111103162634.GK4417@google.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 03 Tejun Heo wrote:
> blk_cleanup_queue() may be called before elevator is set up on a
> queue which triggers the following oops.
[...]
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -407,8 +407,13 @@ void blk_cleanup_queue(struct request_queue *q)
>  	spin_unlock_irq(lock);
>  	mutex_unlock(&q->sysfs_lock);
>  
> -	/* drain all requests queued before DEAD marking */
> -	blk_drain_queue(q, true);
> +	/*
> +	 * Drain all requests queued before DEAD marking.  The caller might
> +	 * be trying to tear down @q before its elevator is initialized, in
> +	 * which case we don't want to call into draining.
> +	 */
> +	if (q->elevator)
> +		blk_drain_queue(q, true);
>  
>  	/* @q won't process any more request, flush async actions */
>  	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);

What prevents elevator_attach to be called and requests to be inserted
between 'if (q-elevator)' and 'blk_put_queue(q)'?
-- 
Stefan Richter
-=====-==-== =-== --=--
http://arcgraph.de/sr/
