Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0H0KZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 06:25:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:35625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab0H0KZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 06:25:21 -0400
Message-ID: <4C779111.8000803@kernel.org>
Date: Fri, 27 Aug 2010 12:18:57 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jeffrey Carlyle <jeff.carlyle@motorola.com>
CC: torvalds@osdl.org, linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        OLUSANYA SOYANNWO <c23746@motorola.com>, Hu Tao <taohu@motorola.com>
Subject: Re: [PATCH] scatterlist: prevent invalid free when alloc fails
References: <AANLkTimoCn9uWQ1NTJAhRu7cq1MA+oo6E5p30zeXA3f1@mail.gmail.com>
In-Reply-To: <AANLkTimoCn9uWQ1NTJAhRu7cq1MA+oo6E5p30zeXA3f1@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 10:24:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

First of all, the patch is line-wrapped.  Please check your email
settings.

On 08/26/2010 06:04 PM, Jeffrey Carlyle wrote:
> When alloc fails, free_table is being called. Depending on the number of
> bytes requested, we determine if we are going to call _get_free_page()
> or kmalloc(). When alloc fails, our math is wrong (due to sg_size - 1),
> and the last buffer is wrongfully assumed to have been allocated by
> kmalloc. Hence, kfree gets called and a panic occurs.
> 
> This fix sets the end marker and allows the proper freeing of the
> buffers.
> 
> Signed-off-by: Olusanya Soyannwo <c23746@motorola.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Signed-off-by: Jeffrey Carlyle <jeff.carlyle@motorola.com>
> ---
>  lib/scatterlist.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index a5ec428..acf2c6e 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -163,7 +163,7 @@ void __sg_free_table(struct sg_table *table,
> unsigned int max_ents,
>  		return;
> 
>  	sgl = table->sgl;
> -	while (table->orig_nents) {
> +	while (table->orig_nents && sgl) {
>  		unsigned int alloc_size = table->orig_nents;
>  		unsigned int sg_size;

Why is this change necessary?

> @@ -227,6 +227,7 @@ int __sg_alloc_table(struct sg_table *table,
> unsigned int nents,
>  {
>  	struct scatterlist *sg, *prv;
>  	unsigned int left;
> +	unsigned int total_alloc = 0;
> 
>  #ifndef ARCH_HAS_SG_CHAIN
>  	BUG_ON(nents > max_ents);
> @@ -248,8 +249,14 @@ int __sg_alloc_table(struct sg_table *table,
> unsigned int nents,
>  		left -= sg_size;
> 
>  		sg = alloc_fn(alloc_size, gfp_mask);
> -		if (unlikely(!sg))
> +		if (unlikely(!sg)) {
> +			table->orig_nents = total_alloc;
> +			/* mark the end of previous entry */
> +			sg_mark_end(&prv[alloc_size - 1]);

prv[alloc_size - 1] is already marked as end by sg_init_table() during
the previous iteration.  Also, prv can be NULL at this point.  AFAICS,
the only thing necessary would be "if (prv) table->nents++", no?

Thanks.

-- 
tejun
