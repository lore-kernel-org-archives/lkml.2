Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab2FAHok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 03:44:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55774 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab2FAHoj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 1 Jun 2012 03:44:39 -0400
Message-Id: <4FC88F030200007800087B34@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 01 Jun 2012 08:44:35 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/blkfront: Add BUG_ON to deal
 with misbehaving backends.
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
 <1337982603-15692-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1205281111460.26786@kaball-desktop>
 <4FC4A10F0200007800086842@nat28.tlf.novell.com>
 <20120531181712.GA19700@phenom.dumpdata.com>
In-Reply-To: <20120531181712.GA19700@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 31.05.12 at 20:17, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> The blkfront_remove part is .. that is going to take some surgery to do
> and I don't think I am going to be able to attempt that within the next 
> couple
> of weeks. So lets put that on the TODO list and just do this one?

That sounds okay to me.

> From 4aabb5b44778fc0c0b8d4f5a2e2cd8e8490064d7 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Fri, 25 May 2012 17:34:51 -0400
> Subject: [PATCH] xen/blkfront: Add WARN to deal with misbehaving backends.
> 
> Part of the ring structure is the 'id' field which is under
> control of the frontend. The frontend stamps it with "some"
> value (this some in this implementation being a value less
> than BLK_RING_SIZE), and when it gets a response expects
> said value to be in the response structure. We have a check
> for the id field when spolling new requests but not when
> de-spolling responses.
> 
> We also add an extra check in add_id_to_freelist to make
> sure that the 'struct request' was not NULL - as we cannot
> pass a NULL to __blk_end_request_all, otherwise that crashes
> (and all the operations that the response is dealing with
> end up with __blk_end_request_all).
> 
> Lastly we also print the name of the operation that failed.
> 
> [v1: s/BUG/WARN/ suggested by Stefano]

That's only partly true, since ...

> [v2: Add extra check in add_id_to_freelist]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkfront.c |   39 +++++++++++++++++++++++++++++----------
>  1 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 60eed4b..c7ef8a4 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -144,11 +144,22 @@ static int get_id_from_freelist(struct blkfront_info 
> *info)
>  static void add_id_to_freelist(struct blkfront_info *info,
>  			       unsigned long id)
>  {
> +	BUG_ON(info->shadow[id].req.u.rw.id != id);
>  	info->shadow[id].req.u.rw.id  = info->shadow_free;
> +	BUG_ON(info->shadow[id].request == NULL);

... there's now even two BUG_ON()s here. I would think these
checks should either happen at the call site, or the function
should return an error indication; in any case should these just
result in warnings just like the out-of-range check you added.

>  	info->shadow[id].request = NULL;
>  	info->shadow_free = id;
>  }
>  
> +static const char *op_name(int op)
> +{
> +	const char *names[BLKIF_OP_DISCARD+1] = {

	static const char *const names[] = {

> +		"read" , "write", "barrier", "flush", "reserved", "discard"};

Perhaps using dedicated initializers would be preferable here?

> +
> +	if (op > BLKIF_OP_DISCARD)

	if (op >= ARRAY_SIZE(names))

(all three adjustments making future additions less intrusive -
they could be single-line then).

Jan

> +		return "unknown";
> +	return names[op];
> +}
>  static int xlbd_reserve_minors(unsigned int minor, unsigned int nr)
>  {
>  	unsigned int end = minor + nr;
> @@ -746,6 +757,18 @@ static irqreturn_t blkif_interrupt(int irq, void 
> *dev_id)
>  
>  		bret = RING_GET_RESPONSE(&info->ring, i);
>  		id   = bret->id;
> +		/*
> +		 * The backend has messed up and given us an id that we would
> +		 * never have given to it (we stamp it up to BLK_RING_SIZE -
> +		 * look in get_id_from_freelist.
> +		 */
> +		if (id >= BLK_RING_SIZE) {
> +			/* We can't safely get the 'struct request' as
> +			 * the id is busted. So limp along. */
> +			WARN(1, "%s: response to %s has incorrect id (%d)!\n",
> +			     info->gd->disk_name, op_name(bret->operation), id);
> +			continue;
> +		}
>  		req  = info->shadow[id].request;
>  
>  		if (bret->operation != BLKIF_OP_DISCARD)
> @@ -758,8 +781,8 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
>  		case BLKIF_OP_DISCARD:
>  			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
>  				struct request_queue *rq = info->rq;
> -				printk(KERN_WARNING "blkfront: %s: discard op failed\n",
> -					   info->gd->disk_name);
> +				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
> +					   info->gd->disk_name, op_name(bret->operation));
>  				error = -EOPNOTSUPP;
>  				info->feature_discard = 0;
>  				info->feature_secdiscard = 0;
> @@ -771,18 +794,14 @@ static irqreturn_t blkif_interrupt(int irq, void 
> *dev_id)
>  		case BLKIF_OP_FLUSH_DISKCACHE:
>  		case BLKIF_OP_WRITE_BARRIER:
>  			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
> -				printk(KERN_WARNING "blkfront: %s: write %s op failed\n",
> -				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
> -				       "barrier" :  "flush disk cache",
> -				       info->gd->disk_name);
> +				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
> +				       info->gd->disk_name, op_name(bret->operation));
>  				error = -EOPNOTSUPP;
>  			}
>  			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
>  				     info->shadow[id].req.u.rw.nr_segments == 0)) {
> -				printk(KERN_WARNING "blkfront: %s: empty write %s op failed\n",
> -				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
> -				       "barrier" :  "flush disk cache",
> -				       info->gd->disk_name);
> +				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
> +				       info->gd->disk_name, op_name(bret->operation));
>  				error = -EOPNOTSUPP;
>  			}
>  			if (unlikely(error)) {
> -- 
> 1.7.7.6


