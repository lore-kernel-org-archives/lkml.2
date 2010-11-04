Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0KDJEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:04:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62003 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0KDJEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V0+E39aw/cmh5GrSv9b1apQUTwxiycZqO8rml1Epsx0BHbclrLo39/uVWTwQC1t8wW
         9i2xXGxbrAC06DCBHEhW6uyNbRiyJTBU/CD7rt7ypRjYh3NVFxz/6yxgEMoUPZ4cYJdh
         Pktg/Nj+3ChalavTod9DpQgSxtphP/xSm5VGU=
Subject: Re: [PATCH v14 06/17] Use callback to deal with skb_release_data()
 specially.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <bd4abd1568dfc75daed6713f9a568bf0f895de4b.1288860477.git.xiaohui.xin@intel.com>
References: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
	 <bd4abd1568dfc75daed6713f9a568bf0f895de4b.1288860477.git.xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 10:04:25 +0100
Message-ID: <1288861465.2659.44.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 17:05 +0800, xiaohui.xin@intel.com a écrit :
> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> If buffer is external, then use the callback to destruct
> buffers.
> 
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
> Reviewed-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  net/core/skbuff.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index c83b421..5e6d69c 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -210,6 +210,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  
>  	/* make sure we initialize shinfo sequentially */
>  	shinfo = skb_shinfo(skb);
> +	shinfo->destructor_arg = NULL;

Hmm, I suggest you read the comment two lines above.

If destructor_arg is now cleared each time we allocate a new skb, then,
please move it before dataref in shinfo structure, so that the following
memset() does the job efficiently...

>  	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
>  	atomic_set(&shinfo->dataref, 1);
>  
> @@ -343,6 +344,13 @@ static void skb_release_data(struct sk_buff *skb)
>  		if (skb_has_frags(skb))
>  			skb_drop_fraglist(skb);
>  
> +		if (skb->dev && dev_is_mpassthru(skb->dev)) {
> +			struct skb_ext_page *ext_page =
> +				skb_shinfo(skb)->destructor_arg;
> +			if (ext_page && ext_page->dtor)
> +				ext_page->dtor(ext_page);
> +		}
> +
>  		kfree(skb->head);
>  	}
>  }


