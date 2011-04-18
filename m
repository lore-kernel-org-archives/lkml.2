Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1DRTz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:55:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38724 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1DRTzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:55:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=AoUcXUy78yXTAVb9ZV+ZkuYIHtoq8Wg4Z8pFmNnHClVIT08g7y/wGSFH5DedVJ5sRO
         4etQDqGRNkpS9h6b0dQnvfrFyX6kQAlF1gOMN+8CYuvCTvysh3V7C2c/Wo7yLN3vd6zl
         tP4sLefREYU24JqDaRoTrKbdnL2wyrkJVr9NE=
MIME-Version: 1.0
In-Reply-To: <20110418092647.GB3837@infradead.org>
References: <20110418092647.GB3837@infradead.org>
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 18 Apr 2011 15:55:04 -0400
X-Google-Sender-Auth: tYmcw3L63c0RhmDrYaIcnD-obbM
Message-ID: <BANLkTikOKji3_p+bqMO4zoSnXFunEdue0g@mail.gmail.com>
Subject: Re: [PATCH] block: add blk_run_queue_async
To: Christoph Hellwig <hch@infradead.org>
Cc: jaxboe@fusionio.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 5:26 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Instead of overloading __blk_run_queue to force an offload to kblockd
> add a new blk_run_queue_async helper to do it explicitly.  I've kept
> the blk_queue_stopped check for now, but I suspect it's not needed
> as the check we do when the workqueue items runs should be enough.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6/block/blk-core.c
> ===================================================================
> --- linux-2.6.orig/block/blk-core.c     2011-04-18 10:48:11.010100413 +0200
> +++ linux-2.6/block/blk-core.c  2011-04-18 10:57:56.340262741 +0200
...
> @@ -317,6 +315,20 @@ void __blk_run_queue(struct request_queu
>  EXPORT_SYMBOL(__blk_run_queue);
>
>  /**
> + * blk_run_queue_async - run a single device queue in workqueue context
> + * @q: The queue to run
> + *
> + * Description:
> + *    Tells kblockd to perform the equivalent of @blk_run_queue on behalf
> + *    of us.
> + */
> +void blk_run_queue_async(struct request_queue *q)
> +{
> +       if (likely(!blk_queue_stopped(q)))
> +               queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);

I know Jens already queued this up 'for-linus' but why not use
kblockd_schedule_work(q, &q->delay_work)?
