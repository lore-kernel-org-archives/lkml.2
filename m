Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab2FAKR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:17:27 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:38011 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab2FAKR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:17:26 -0400
X-IronPort-AV: E=Sophos;i="4.75,698,1330905600"; 
   d="scan'208";a="12783130"
Date: Fri, 1 Jun 2012 11:16:29 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/blkfront: Add BUG_ON to deal with
 misbehaving backends.
In-Reply-To: <20120531181712.GA19700@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1206011111590.26786@kaball-desktop>
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com> <1337982603-15692-3-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.00.1205281111460.26786@kaball-desktop> <4FC4A10F0200007800086842@nat28.tlf.novell.com>
 <20120531181712.GA19700@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Konrad Rzeszutek Wilk wrote:
> The blkfront_remove part is .. that is going to take some surgery to do
> and I don't think I am going to be able to attempt that within the next couple
> of weeks. So lets put that on the TODO list and just do this one?

OK

> >From 4aabb5b44778fc0c0b8d4f5a2e2cd8e8490064d7 Mon Sep 17 00:00:00 2001
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
> @@ -144,11 +144,22 @@ static int get_id_from_freelist(struct blkfront_info *info)
>  static void add_id_to_freelist(struct blkfront_info *info,
>  			       unsigned long id)
>  {
> +	BUG_ON(info->shadow[id].req.u.rw.id != id);
>  	info->shadow[id].req.u.rw.id  = info->shadow_free;
> +	BUG_ON(info->shadow[id].request == NULL);
>  	info->shadow[id].request = NULL;
>  	info->shadow_free = id;
>  }

Like Jan said, it would be best to change the two BUG_ON into WARN_ON
and return an error.


> +static const char *op_name(int op)
> +{
> +	const char *names[BLKIF_OP_DISCARD+1] = {
> +		"read" , "write", "barrier", "flush", "reserved", "discard"};
> +
> +	if (op > BLKIF_OP_DISCARD)
> +		return "unknown";
> +	return names[op];
> +}

Considering that op is an int, shoudn't we check for negative values
too?


>  static int xlbd_reserve_minors(unsigned int minor, unsigned int nr)
>  {
>  	unsigned int end = minor + nr;
> @@ -746,6 +757,18 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
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

Do you think it would be better to goto error_out, instead of continue?
I guess that depends on whether we expect the other requests to be in a
good shape or not...
