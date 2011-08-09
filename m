Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1HIQxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:53:08 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59279 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1HIQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:53:07 -0400
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stufever@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
In-Reply-To: <1312907945-1982-1-git-send-email-wangshaoyan.pt@taobao.com>
References: <1312907945-1982-1-git-send-email-wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 18:53:04 +0200
Message-ID: <1312908784.2371.53.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 10 août 2011 à 00:39 +0800, stufever@gmail.com a écrit :
> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> 
>   drivers/net/gianfar_ethtool.c:765: warning: the frame size of 2048 bytes is larger than 1024 bytes
> 
> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> ---
>  drivers/net/gianfar_ethtool.c |   20 +++++++++++++++++---
>  1 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
> index 6e35069..134fe1b 100644
> --- a/drivers/net/gianfar_ethtool.c
> +++ b/drivers/net/gianfar_ethtool.c
> @@ -686,10 +686,21 @@ static int gfar_ethflow_to_filer_table(struct gfar_private *priv, u64 ethflow, u
>  {
>  	unsigned int last_rule_idx = priv->cur_filer_idx;
>  	unsigned int cmp_rqfpr;
> -	unsigned int local_rqfpr[MAX_FILER_IDX + 1];
> -	unsigned int local_rqfcr[MAX_FILER_IDX + 1];
> +	unsigned int *local_rqfpr;
> +	unsigned int *local_rqfcr;
>  	int i = 0x0, k = 0x0;
>  	int j = MAX_FILER_IDX, l = 0x0;
> +	int ret = 1;
> +
> +	local_rqfpr = kmalloc(sizeof(unsigned int) * (MAX_FILER_IDX + 1),
> +		GFP_KERNEL);
> +	local_rqfcr = kmalloc(sizeof(unsigned int) * (MAX_FILER_IDX + 1),
> +		GFP_KERNEL);
> +	if (!local_rqfpr || !local_rqfcr) {
> +		pr_err("Out of memory\n");

	Please remove this pr_err(), kmalloc() will complain already.

> +		ret = 0;
> +		got err;
> +	}
>  
>  	switch (class) {
>  	case TCP_V4_FLOW:
> @@ -765,7 +776,10 @@ static int gfar_ethflow_to_filer_table(struct gfar_private *priv, u64 ethflow, u
>  		priv->cur_filer_idx = priv->cur_filer_idx - 1;
>  	}
>  
> -	return 1;
> +err:
> +	kfree(local_rqfcr);
> +	kfree(local_rqfpr);
> +	return ret;
>  }
>  

You should now track all "return 0;" done in this function to make sure
no memory leak is added by your patch.



