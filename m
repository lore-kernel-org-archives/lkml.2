Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2E3Gqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:46:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36623 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2E3Gqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:46:43 -0400
Subject: Re: [PATCH] net: sock: validate data_len before allocating skb in
 sock_alloc_send_pskb()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mst@redhat.com
In-Reply-To: <20120530054702.6146.8503.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120530054702.6146.8503.stgit@amd-6168-8-1.englab.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 May 2012 08:46:23 +0200
Message-ID: <1338360383.2760.84.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 13:47 +0800, Jason Wang wrote:
> We need to validate the number of pages consumed by data_len, otherwise frags
> array could be overflowed by userspace. So this patch validate data_len and
> return -EMSGSIZE when data_len may occupies more frags than MAX_SKB_FRAGS.
> 
> Cc: stable@vger.kernel.org [2.6.27+]
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  net/core/sock.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 653f8c0..4ad5fa5 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1599,6 +1599,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
>  
>  	timeo = sock_sndtimeo(sk, noblock);
>  	while (1) {
> +		int npages;
>  		err = sock_error(sk);
>  		if (err != 0)
>  			goto failure;
> @@ -1607,17 +1608,20 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
>  		if (sk->sk_shutdown & SEND_SHUTDOWN)
>  			goto failure;
>  
> +		err = -EMSGSIZE;
> +		npages = (data_len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
> +		if (npages > MAX_SKB_FRAGS)
> +			goto failure;
> +
>  		if (atomic_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf) {
>  			skb = alloc_skb(header_len, gfp_mask);
>  			if (skb) {
> -				int npages;
>  				int i;
>  
>  				/* No pages, we're done... */
>  				if (!data_len)
>  					break;
>  
> -				npages = (data_len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
>  				skb->truesize += data_len;
>  				skb_shinfo(skb)->nr_frags = npages;
>  				for (i = 0; i < npages; i++) {
> 


Why doing this test in the while (1) block, it should be done before the
loop...

Or even in the caller, note net/unix/af_unix.c does this right.

        if (len > SKB_MAX_ALLOC)
                data_len = min_t(size_t,
                                 len - SKB_MAX_ALLOC,
                                 MAX_SKB_FRAGS * PAGE_SIZE);

        skb = sock_alloc_send_pskb(sk, len - data_len, data_len,
                                   msg->msg_flags & MSG_DONTWAIT, &err);


