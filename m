Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2BFWyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:54:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65191 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2BFWx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:53:59 -0500
Message-ID: <1328568833.2476.1.camel@edumazet-laptop>
Subject: Re: [PATCH] bnx2x: Fix mem leak in bnx2x_tpa_stop() if build_skb()
 fails.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: netdev@vger.kernel.org, Eilon Greenstein <eilong@broadcom.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Eliezer Tamir <eliezert@broadcom.com>
Date: Mon, 06 Feb 2012 23:53:53 +0100
In-Reply-To: <alpine.LNX.2.00.1202062224210.20532@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202062224210.20532@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 février 2012 à 22:28 +0100, Jesper Juhl a écrit :
> We allocate memory for 'new_data' with kmalloc(). If we get the memory
> we then try to build_skb() and if that should fail (which it can) we
> do not enter 'if (likely(skb)) {' and actually use 'new_data' but
> instead fall through to the 'drop:' label and end up returning from
> the function without ever assigning 'new'data' to anything or freeing
> it. That leaks the memory allocated to 'new_data'.
> 
> This patch fixes the memory leak by doing a kfree(new_data) in the
> case where build_skb() fails (or where allocation of 'new_data' itself
> fails, but in taht case it's just a harmless kfree(NULL)).
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
>  No hardware to test, so compile tested only.
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 03f3935..7aee469 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -523,7 +523,6 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
>  		skb = build_skb(data);
>  
>  	if (likely(skb)) {
> -
>  #ifdef BNX2X_STOP_ON_ERROR
>  		if (pad + len > fp->rx_buf_size) {
>  			BNX2X_ERR("skb_put is about to fail...  "
> @@ -557,7 +556,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
>  
>  		return;
>  	}
> -
> +	kfree(new_data);
>  drop:
>  	/* drop the packet and keep the buffer in the bin */
>  	DP(NETIF_MSG_RX_STATUS,
> -- 
> 1.7.9
> 
> 

Good catch, my bad.

Thanks

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



