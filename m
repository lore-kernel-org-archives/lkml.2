Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1JTIqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:46:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35981 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1JTIqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:46:07 -0400
Message-ID: <1319100362.3781.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] virtio_net: Clean up set_skb_frag()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Krishna Kumar <krkumar2@in.ibm.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        virtualization@lists.linux-foundation.org
Date: Thu, 20 Oct 2011 10:46:02 +0200
In-Reply-To: <20111020081727.509.83122.sendpatchset@krkumar2.in.ibm.com>
References: <20111020081727.509.83122.sendpatchset@krkumar2.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 octobre 2011 à 13:47 +0530, Krishna Kumar a écrit :
> Remove manual initialization in set_skb_frag, and instead
> use __skb_fill_page_desc() to do the same. Patch tested
> on net-next.
> 
> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> ---
>  drivers/net/virtio_net.c |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff -ruNp org/drivers/net/virtio_net.c new/drivers/net/virtio_net.c
> --- org/drivers/net/virtio_net.c	2011-10-20 08:34:31.000000000 +0530
> +++ new/drivers/net/virtio_net.c	2011-10-20 08:43:57.000000000 +0530
> @@ -143,18 +143,15 @@ static void skb_xmit_done(struct virtque
>  static void set_skb_frag(struct sk_buff *skb, struct page *page,
>  			 unsigned int offset, unsigned int *len)
>  {
> +	int size = min((unsigned)PAGE_SIZE - offset, *len);
>  	int i = skb_shinfo(skb)->nr_frags;
> -	skb_frag_t *f;
>  
> -	f = &skb_shinfo(skb)->frags[i];
> -	skb_frag_size_set(f, min((unsigned)PAGE_SIZE - offset, *len));
> -	f->page_offset = offset;
> -	__skb_frag_set_page(f, page);
> +	__skb_fill_page_desc(skb, i, page, offset, size);
>  
> -	skb->data_len += skb_frag_size(f);
> -	skb->len += skb_frag_size(f);
> +	skb->data_len += size;
> +	skb->len += size;
>  	skb_shinfo(skb)->nr_frags++;
> -	*len -= skb_frag_size(f);
> +	*len -= size;
>  }
>  
>  static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> 
> --

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Seems fine to me. There is a truesize patch for this driver, I'll send
it once your patch is in.



