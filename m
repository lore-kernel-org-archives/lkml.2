Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0KHIYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:24:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43972 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab0KHIYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 03:24:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G52E4s58HZfEqgaKIPAoX6O0P+ZVnnde9HW7CUKVaChmTRFG6UGf/SsnAiG6QERXS4
         Z3m/hXETDI64kbh8amLZlglkTDBkvDPEVQfw++ssReQVy3I+TM+24j4yirbgsNZhk+gf
         gtNAg0j8F64rSuPSTzrEsdFI7lwkQXKgo+eRo=
Subject: Re: Re:[PATCH v14 06/17] Use callback to deal with
 skb_release_data() specially.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <1289203430-5935-1-git-send-email-xiaohui.xin@intel.com>
References: <1288861663.2659.47.camel@edumazet-laptop>
	 <1289203430-5935-1-git-send-email-xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 09:24:46 +0100
Message-ID: <1289204686.2478.375.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 08 novembre 2010 à 16:03 +0800, xiaohui.xin@intel.com a écrit :
> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> >> Hmm, I suggest you read the comment two lines above.
> >>
> >> If destructor_arg is now cleared each time we allocate a new skb, then,
> >> please move it before dataref in shinfo structure, so that the following
> >> memset() does the job efficiently...
> >
> >
> >Something like :
> >
> >diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >index e6ba898..2dca504 100644
> >--- a/include/linux/skbuff.h
> >+++ b/include/linux/skbuff.h
> >@@ -195,6 +195,9 @@ struct skb_shared_info {
> > 	__be32          ip6_frag_id;
> > 	__u8		tx_flags;
> > 	struct sk_buff	*frag_list;
> >+	/* Intermediate layers must ensure that destructor_arg
> >+	 * remains valid until skb destructor */
> >+	void		*destructor_arg;
> > 	struct skb_shared_hwtstamps hwtstamps;
> >
> > 	/*
> >@@ -202,9 +205,6 @@ struct skb_shared_info {
> > 	 */
> > 	atomic_t	dataref;
> >
> >-	/* Intermediate layers must ensure that destructor_arg
> >-	 * remains valid until skb destructor */
> >-	void *		destructor_arg;
> > 	/* must be last field, see pskb_expand_head() */
> > 	skb_frag_t	frags[MAX_SKB_FRAGS];
> > };
> >
> >
> 
> Will that affect the cache line?

What do you mean ?

> Or, we can move the line to clear destructor_arg to the end of __alloc_skb().
> It looks like as the following, which one do you prefer?
> 
> Thanks
> Xiaohui
> 
> ---
>  net/core/skbuff.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index c83b421..df852f2 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -224,6 +224,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  
>  		child->fclone = SKB_FCLONE_UNAVAILABLE;
>  	}
> +	shinfo->destructor_arg = NULL;
>  out:
>  	return skb;
>  nodata:

I dont understand why you want to do this.

This adds an instruction, makes code bigger, and no obvious gain for me,
at memory transactions side.

If integrated in the existing memset(), cost is an extra iteration to
perform the clear of this field.


