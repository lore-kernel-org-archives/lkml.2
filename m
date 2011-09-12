Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1ILIBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 04:01:32 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36438 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab1ILIBb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:6:1>);
	Mon, 12 Sep 2011 04:01:31 -0400
Message-Id: <4E6DD8750200007800055ADA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 12 Sep 2011 09:01:25 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <jeremy.fitzhardinge@citrix.com>, <axboe@kernel.dk>, <stable@kernel.org>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] xen-blkfront: If no barrier or flush is
	 supported, use invalid operation.
References: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
 <1315593060-20031-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1315593060-20031-3-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.09.11 at 20:31, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> By default we would set the info->flush_op=0, and zero maps
> to BLKIF_OP_READ request code. So if the backend did not support
> either barrier ('feature-barrier') or flush ('feature-flush-cache')
> we would end up using that opcode for the flush/barrier request, meaning
> we actually do a READ request. Fortunatly for us, __generic_make_request
> checks q->flush_flags and realizes that we don't do FLUSH and removes
> the REQ_FLUSH | REQ_FUA so we never end up issuing a READ request
> for a flush request. However, other third party implementations of
> __make_request might not be so smart, so lets fix this up.

Wouldn't it be better to simply have blkif_queue_request() fail in that
case (and then it doesn't matter whether flush_op is set to 0 or -1)?
Not the least because older (forward-port) backends stall the incoming
queue and are possibly verbose for invalid requests seen.

Jan

> CC: stable@kernel.org 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkfront.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index e205d91..c4aa9da 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -97,7 +97,7 @@ struct blkfront_info
>  	struct blk_shadow shadow[BLK_RING_SIZE];
>  	unsigned long shadow_free;
>  	unsigned int feature_flush;
> -	unsigned int flush_op;
> +	int flush_op;
>  	unsigned int feature_discard;
>  	unsigned int discard_granularity;
>  	unsigned int discard_alignment;
> @@ -774,7 +774,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
>  				if (error == -EOPNOTSUPP)
>  					error = 0;
>  				info->feature_flush = 0;
> -				info->flush_op = 0;
> +				info->flush_op = -1; /* 0 is BLKIF_OP_READ */
>  				xlvbd_flush(info);
>  			}
>  			/* fall through */
> @@ -1207,7 +1207,7 @@ static void blkfront_connect(struct blkfront_info 
> *info)
>  	}
>  
>  	info->feature_flush = 0;
> -	info->flush_op = 0;
> +	info->flush_op = -1; /* 0 is BLKIF_OP_READ */
>  
>  	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
>  			    "feature-barrier", "%d", &barrier,
> @@ -1234,7 +1234,7 @@ static void blkfront_connect(struct blkfront_info 
> *info)
>  	if (!err && flush)
>  		info->flush_op = BLKIF_OP_FLUSH_DISKCACHE;
>  
> -	if (info->flush_op)
> +	if (info->flush_op > 0)
>  		info->feature_flush = REQ_FLUSH | REQ_FUA;
>  
>  	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,




