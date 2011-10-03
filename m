Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab1JCSkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:40:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab1JCSjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:39:55 -0400
Date: Mon, 3 Oct 2011 20:40:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-net: Prevent NULL dereference
Message-ID: <20111003184037.GA22427@redhat.com>
References: <1317220855-9352-1-git-send-email-levinsasha928@gmail.com>
 <1317220855-9352-2-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317220855-9352-2-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 05:40:55PM +0300, Sasha Levin wrote:
> This patch prevents a NULL dereference when the user has passed a length
> longer than an actual buffer to virtio-net.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  drivers/net/virtio_net.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index bde0dec..4a53d2a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -208,12 +208,22 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  		return NULL;
>  	}
>  
> -	while (len) {
> +	while (len && page) {
>  		set_skb_frag(skb, page, offset, &len);
>  		page = (struct page *)page->private;
>  		offset = 0;
>  	}
>  
> +	/*
> +	 * This is the case where we ran out of pages in our linked list, but
> +	 * supposedly have more data to read.

Again, let's clarify that this only happens with broken devices.

> +	 */	
> +	if (len > 0) {
> +		pr_debug("%s: missing data to assemble skb\n", skb->dev->name);
> +		dev_kfree_skb(skb);
> +		return NULL;
> +	}
> +
>  	if (page)
>  		give_pages(vi, page);
>  
> -- 
> 1.7.6.1
