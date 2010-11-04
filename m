Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0KDJHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:07:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55409 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0KDJHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GGGVxJkPJ8m62XeidYW7/MAY015JKqgkXDHi8axKFNy6dJbTCEkSSn/FPA+YuvUiSe
         7rtMlHk9uZcUXyd1c0grvZoLv2Do0sNn1MkjEiPY4LoWbkpIbQ+/nsPQIe/GjzIQfkAd
         qUWwZADTw2BUokfsD7CECKAZ49DaIRfC8hqGs=
Subject: Re: [PATCH v14 06/17] Use callback to deal with skb_release_data()
 specially.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <1288861465.2659.44.camel@edumazet-laptop>
References: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
	 <bd4abd1568dfc75daed6713f9a568bf0f895de4b.1288860477.git.xiaohui.xin@intel.com>
	 <1288861465.2659.44.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 10:07:43 +0100
Message-ID: <1288861663.2659.47.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 10:04 +0100, Eric Dumazet a écrit :

> Hmm, I suggest you read the comment two lines above.
> 
> If destructor_arg is now cleared each time we allocate a new skb, then,
> please move it before dataref in shinfo structure, so that the following
> memset() does the job efficiently...


Something like :

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e6ba898..2dca504 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -195,6 +195,9 @@ struct skb_shared_info {
 	__be32          ip6_frag_id;
 	__u8		tx_flags;
 	struct sk_buff	*frag_list;
+	/* Intermediate layers must ensure that destructor_arg
+	 * remains valid until skb destructor */
+	void		*destructor_arg;
 	struct skb_shared_hwtstamps hwtstamps;
 
 	/*
@@ -202,9 +205,6 @@ struct skb_shared_info {
 	 */
 	atomic_t	dataref;
 
-	/* Intermediate layers must ensure that destructor_arg
-	 * remains valid until skb destructor */
-	void *		destructor_arg;
 	/* must be last field, see pskb_expand_head() */
 	skb_frag_t	frags[MAX_SKB_FRAGS];
 };



