Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0JTCvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:51:35 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58893 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab0JTCve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:51:34 -0400
Date: Tue, 19 Oct 2010 21:51:31 -0500
From: Robin Holt <holt@sgi.com>
To: Julia Lawall <julia@diku.dk>
Cc: Robin Holt <holt@sgi.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/misc/sgi-xp/xpc_uv.c: convert nested
 spin_lock_irqsave to spin_lock
Message-ID: <20101020025130.GE14068@sgi.com>
References: <1287481436-26656-4-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287481436-26656-4-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:43:56AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> If spin_lock_irqsave is called twice in a row with the same second
> argument, the interrupt state at the point of the second call overwrites
> the value saved by the first call.  Indeed, the second call does not need
> to save the interrupt state, so it is changed to a simple spin_lock.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression lock1,lock2;
> expression flags;
> @@
> 
> *spin_lock_irqsave(lock1,flags)
> ... when != flags
> *spin_lock_irqsave(lock2,flags)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Robin Holt <holt@sgi.com>

> 
> ---
>  drivers/misc/sgi-xp/xpc_uv.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
> index 1f59ee2..7aeaef7 100644
> --- a/drivers/misc/sgi-xp/xpc_uv.c
> +++ b/drivers/misc/sgi-xp/xpc_uv.c
> @@ -451,9 +451,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
>  
>  		if (msg->activate_gru_mq_desc_gpa !=
>  		    part_uv->activate_gru_mq_desc_gpa) {
> -			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
> +			spin_lock(&part_uv->flags_lock);
>  			part_uv->flags &= ~XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV;
> -			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
> +			spin_unlock(&part_uv->flags_lock);
>  			part_uv->activate_gru_mq_desc_gpa =
>  			    msg->activate_gru_mq_desc_gpa;
>  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
