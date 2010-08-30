Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab0H3QAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:00:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:39667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab0H3QAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:00:35 -0400
Message-ID: <4C7BD595.6080102@kernel.org>
Date: Mon, 30 Aug 2010 18:00:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jeffrey Carlyle <jeff.carlyle@motorola.com>
CC: OLUSANYA SOYANNWO <olusanya.soyannwo@motorola.com>,
        linux-kernel@vger.kernel.org, Hu Tao <taohu@motorola.com>,
        jaxboe@fusionio.com, torvalds@osdl.org
Subject: Re: [PATCH v2] scatterlist: prevent invalid free when alloc fails
References: <4C784B04.7060604@kernel.org> <20100830154825.E4E2560255F@il93ubuntu.localdomain>
In-Reply-To: <20100830154825.E4E2560255F@il93ubuntu.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 16:00:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/30/2010 05:01 PM, Jeffrey Carlyle wrote:
> When alloc fails, free_table is being called. Depending on the number of
> bytes requested, we determine if we are going to call _get_free_page()
> or kmalloc(). When alloc fails, our math is wrong (due to sg_size - 1),
> and the last buffer is wrongfully assumed to have been allocated by
> kmalloc. Hence, kfree gets called and a panic occurs.
> 
> Signed-off-by: Jeffrey Carlyle <jeff.carlyle@motorola.com>
> Signed-off-by: Olusanya Soyannwo <c23746@motorola.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <jaxboe@fusionio.com>

Supposing it's verified to fix the same issue,

  Acked-by: Tejun Heo <tj@kernel.org>

trivial suggestions below,

> ---
>  lib/scatterlist.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index a5ec428..9bc637f 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -248,8 +248,14 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
>  		left -= sg_size;
>  
>  		sg = alloc_fn(alloc_size, gfp_mask);
> -		if (unlikely(!sg))
> +		if (unlikely(!sg)) {
> +			/*
> +			 * Adjust entry count so that proper free function is
> +			 * used in sg_kfree.
> +			 */

I think it would be better why the adjustment is necessary.  IOW,
something like "Adjust entry count to reflect that the last entry of
the previous table won't be used for linkage.  Without this,
sg_kfree() may get confused."

Thanks.

-- 
tejun
