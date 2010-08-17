Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0HQIaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:30:24 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46885 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0HQIaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OldQg6Rf5ije2HAhuBnRCTvsGjV0nb9Dg5mJXO6X68THfcPV85ntON1dm19g2Kvisx
         lPOGI1dkr7IyhBz+G/ewWZ2W9RaQDad8xJGuGI3OtH45rmZ0GWKIpZc1py82Z0DV10YQ
         Y+W6JKblOxDCocGR4ZVDl4F5V2YAaUxd1jZh0=
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 10:30:17 +0200
Message-ID: <1282033817.2448.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 août 2010 à 15:16 +0800, Changli Gao a écrit :
> Since we don't change the tuple in the original direction, we can save it
> in ct->tuplehash[IP_CT_DIR_REPLY].hnode.pprev for __nf_conntrack_confirm()
> use.
> 
> __hash_conntrack() is split into two steps: ____hash_conntrack() is used
> to get the raw hash, and __hash_bucket() is used to get the bucket id.
> 
> In SYN-flood case, early_drop() doesn't need to recompute the hash again.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ---
>  net/netfilter/nf_conntrack_core.c |  117 ++++++++++++++++++++++++++------------
>  1 file changed, 82 insertions(+), 35 deletions(-)
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index df3eedb..947f0a9 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -65,14 +65,23 @@ EXPORT_SYMBOL_GPL(nf_conntrack_max);
>  DEFINE_PER_CPU(struct nf_conn, nf_conntrack_untracked);
>  EXPORT_PER_CPU_SYMBOL(nf_conntrack_untracked);
>  
> -static int nf_conntrack_hash_rnd_initted;
> -static unsigned int nf_conntrack_hash_rnd;
> -
> -static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
> -				  u16 zone, unsigned int size, unsigned int rnd)
> +static u32 ____hash_conntrack(const struct nf_conntrack_tuple *tuple, u16 zone)
>  {
>  	unsigned int n;
>  	u_int32_t h;
> +	static int rnd_initted;
> +	static unsigned int rnd;
> +	static DEFINE_SPINLOCK(rnd_lock);
> +
> +	if (unlikely(!rnd_initted)) {
> +		spin_lock_bh(&rnd_lock);
> +		if (!rnd_initted) {
> +			get_random_bytes(&rnd, sizeof(rnd));
> +			wmb();
> +			rnd_initted = 1;
> +		}
> +		spin_unlock_bh(&rnd_lock);
> +	}
>  

Three variables ?

static atomic_t rnd __read_mostly;

if (unlikely(!atomic_read(&rnd))) {
	unsigned int val;

	get_random_bytes(&val, sizeof(val));
	if (!val)
		val = 1;
	atomic_cmpxchg(&rnd, 0, val);
}


