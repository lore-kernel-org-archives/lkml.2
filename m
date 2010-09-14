Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0INSDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:03:07 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54084 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0INSDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:03:05 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: dave@gnu.org, ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [PATCH] net/9p: fix memory handling/allocation in rdma_request()
In-Reply-To: <1284393198.2055.1.camel@cowboy>
References: <1284393198.2055.1.camel@cowboy>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 14 Sep 2010 23:32:55 +0530
Message-ID: <m3d3sg5hkg.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 11:53:18 -0400, Davidlohr Bueso <dave@gnu.org> wrote:
> [PATCH] net/9p: fix memory handling/allocation in rdma_request()
> 
> Return -ENOMEM when erroring on kmalloc and fix memory leaks when returning on error.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Looks good.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> ---
>  net/9p/trans_rdma.c |   29 ++++++++++++++++++-----------
>  1 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
> index 0ea20c3..17c5ba7 100644
> --- a/net/9p/trans_rdma.c
> +++ b/net/9p/trans_rdma.c
> @@ -426,8 +426,10 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
> 
>  	/* Allocate an fcall for the reply */
>  	rpl_context = kmalloc(sizeof *rpl_context, GFP_KERNEL);
> -	if (!rpl_context)
> +	if (!rpl_context) {
> +		err = -ENOMEM;
>  		goto err_close;
> +	}
> 
>  	/*
>  	 * If the request has a buffer, steal it, otherwise
> @@ -445,8 +447,8 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
>  	}
>  	rpl_context->rc = req->rc;
>  	if (!rpl_context->rc) {
> -		kfree(rpl_context);
> -		goto err_close;
> +		err = -ENOMEM;
> +		goto err_free2;
>  	}
> 
>  	/*
> @@ -458,11 +460,8 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
>  	 */
>  	if (atomic_inc_return(&rdma->rq_count) <= rdma->rq_depth) {
>  		err = post_recv(client, rpl_context);
> -		if (err) {
> -			kfree(rpl_context->rc);
> -			kfree(rpl_context);
> -			goto err_close;
> -		}
> +		if (err)
> +			goto err_free1;
>  	} else
>  		atomic_dec(&rdma->rq_count);
> 
> @@ -471,8 +470,10 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
> 
>  	/* Post the request */
>  	c = kmalloc(sizeof *c, GFP_KERNEL);
> -	if (!c)
> -		goto err_close;
> +	if (!c) {
> +		err = -ENOMEM;
> +		goto err_free1;
> +	}
>  	c->req = req;
> 
>  	c->busa = ib_dma_map_single(rdma->cm_id->device,
> @@ -499,9 +500,15 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
>  	return ib_post_send(rdma->qp, &wr, &bad_wr);
> 
>   error:
> +	kfree(c);
> +	kfree(rpl_context->rc);
> +	kfree(rpl_context);
>  	P9_DPRINTK(P9_DEBUG_ERROR, "EIO\n");
>  	return -EIO;
> -
> + err_free1:
> +	kfree(rpl_context->rc);
> + err_free2:
> +	kfree(rpl_context);
>   err_close:
>  	spin_lock_irqsave(&rdma->req_lock, flags);
>  	if (rdma->state < P9_RDMA_CLOSING) {
> -- 
> 1.7.0.4
> 
> 
> 
> 
> ------------------------------------------------------------------------------
> Start uncovering the many advantages of virtual appliances
> and start using them to simplify application deployment and
> accelerate your shift to cloud computing
> http://p.sf.net/sfu/novell-sfdev2dev
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
