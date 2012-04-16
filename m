Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2DPH6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:58:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab2DPH6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:58:23 -0400
Date: Mon, 16 Apr 2012 10:58:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, xma@us.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 3/6] macvtap: zerocopy: validate vector length before
 pinning user pages
Message-ID: <20120416075831.GA9920@redhat.com>
References: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
 <20120416060807.14140.96229.stgit@intel-e5620-16-2.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416060807.14140.96229.stgit@intel-e5620-16-2.englab.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 02:08:07PM +0800, Jason Wang wrote:
> Currently we do not validate the vector length before calling
> get_user_pages_fast(), host stack would be easily overflowed by
> malicious guest driver who give us a descriptor with length greater
> than MAX_SKB_FRAGS. Solve this problem by checking the free entries
> before trying to pin user pages.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

We could handle this by copying and linearising some fragments.
That would be better.

> ---
>  drivers/net/macvtap.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 7cb2684..d197a78 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -529,6 +529,8 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
>  		}
>  		base = (unsigned long)from->iov_base + offset;
>  		size = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >> PAGE_SHIFT;
> +		if (i + size >= MAX_SKB_FRAGS)
> +			return -EFAULT;
>  		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
>  		if ((num_pages != size) ||
>  		    (num_pages > MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags))
