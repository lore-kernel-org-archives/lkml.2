Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966064Ab2EORaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:30:55 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58092 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965223Ab2EORay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:30:54 -0400
Subject: Re: [V2 PATCH 2/9] macvtap: zerocopy: fix truesize underestimation
From: Shirley Ma <mashirle@us.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
In-Reply-To: <20120502034144.11782.88947.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120502034144.11782.88947.stgit@amd-6168-8-1.englab.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 10:26:49 -0700
Message-ID: <1337102809.8220.10.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051517-7282-0000-0000-0000090D2107
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 11:41 +0800, Jason Wang wrote:
> As the skb fragment were pinned/built from user pages, we should
> account the page instead of length for truesize.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/macvtap.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index bd4a70d..7cb2684 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -519,6 +519,7 @@ static int zerocopy_sg_from_iovec(struct sk_buff
> *skb, const struct iovec *from,
>                 struct page *page[MAX_SKB_FRAGS];
>                 int num_pages;
>                 unsigned long base;
> +               unsigned long truesize;
> 
>                 len = from->iov_len - offset;
>                 if (!len) {
> @@ -533,10 +534,11 @@ static int zerocopy_sg_from_iovec(struct sk_buff
> *skb, const struct iovec *from,
>                     (num_pages > MAX_SKB_FRAGS -
> skb_shinfo(skb)->nr_frags))
>                         /* put_page is in skb free */
>                         return -EFAULT;
> +               truesize = size * PAGE_SIZE;

Here should be truesize = size * PAGE_SIZE - offset, right?

>                 skb->data_len += len;
>                 skb->len += len;
> -               skb->truesize += len;
> -               atomic_add(len, &skb->sk->sk_wmem_alloc);
> +               skb->truesize += truesize;
> +               atomic_add(truesize, &skb->sk->sk_wmem_alloc);
>                 while (len) {
>                         int off = base & ~PAGE_MASK;
>                         int size = min_t(int, len, PAGE_SIZE - off);
> 
> 

