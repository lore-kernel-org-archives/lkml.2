Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1BNQxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:53:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58829 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab1BNQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=pa7YhKhzZkyC4TK/RN1JPpqrJ5BcxE8TdyV823pB/M0DJzjupwMsCJ0mx6Yze3wgwL
         7NP580IVHrvlJ5GYUho47fknAqePNa19HTK9P0eQ1Ck57HaVJc9iImOpwXUxar5kv/HB
         YzBFA86nR8PM1pqSSqDz3+lisXcrD0wt9qKPY=
From: Marek Vasut <marek.vasut@gmail.com>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 5/5] drivers/i2c/busses/i2c-nuc900.c: Convert release_resource to release_region/release_mem_region
Date: Mon, 14 Feb 2011 17:56:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: ben-linux@fluff.org, kernel-janitors@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>, Dave Airlie <airlied@linux.ie>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1297599132-7226-1-git-send-email-julia@diku.dk> <1297599132-7226-6-git-send-email-julia@diku.dk>
In-Reply-To: <1297599132-7226-6-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141756.19068.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 February 2011 13:12:12 Julia Lawall wrote:
> Request_region should be used with release_region, not release_resource.
> 
> The result of request_mem_region is no longer stored.  Instead the field
> ioarea is used to store a pointer to the resource structure that contains
> the start address.  This is the information that is needed later in
> nuc900_i2c_remove to release the region.  The field ioarea is also printed
> in some debugging code.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,E;
> @@
> (
> *x = request_region(...)
> 
> *x = request_mem_region(...)
> )
> ... when != release_region(x)
>     when != x = E
> * release_resource(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> Not compiled due to incompatible architecture.
> 
>  drivers/i2c/busses/i2c-nuc900.c |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-nuc900.c
> b/drivers/i2c/busses/i2c-nuc900.c index 7243426..97b16b7 100644
> --- a/drivers/i2c/busses/i2c-nuc900.c
> +++ b/drivers/i2c/busses/i2c-nuc900.c
> @@ -568,15 +568,13 @@ static int __devinit nuc900_i2c_probe(struct
> platform_device *pdev) goto err_clk;
>  	}
> 
> -	i2c->ioarea = request_mem_region(res->start, resource_size(res),
> -					 pdev->name);
> -
> -	if (i2c->ioarea == NULL) {
> +	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {

I prefer the original version here -- it's clearer and also, doesn't the new 
version violate line-over-80 principle ?

>  		dev_err(&pdev->dev, "cannot request IO\n");
>  		ret = -ENXIO;
>  		goto err_clk;
>  	}
> 
> +	i2c->ioarea = res;
>  	i2c->regs = ioremap(res->start, resource_size(res));
> 
>  	if (i2c->regs == NULL) {
> @@ -645,8 +643,7 @@ static int __devinit nuc900_i2c_probe(struct
> platform_device *pdev) iounmap(i2c->regs);
> 
>   err_ioarea:
> -	release_resource(i2c->ioarea);
> -	kfree(i2c->ioarea);
> +	release_mem_region(res->start, resource_size(res));
> 
>   err_clk:
>  	clk_disable(i2c->clk);
> @@ -665,6 +662,7 @@ static int __devinit nuc900_i2c_probe(struct
> platform_device *pdev) static int __devexit nuc900_i2c_remove(struct
> platform_device *pdev) {
>  	struct nuc900_i2c *i2c = platform_get_drvdata(pdev);
> +	struct resource *res = i2c->ioarea;

No need for this ...
> 
>  	i2c_del_adapter(&i2c->adap);
>  	free_irq(i2c->irq, i2c);
> @@ -674,8 +672,7 @@ static int __devexit nuc900_i2c_remove(struct
> platform_device *pdev)
> 
>  	iounmap(i2c->regs);
> 
> -	release_resource(i2c->ioarea);
> -	kfree(i2c->ioarea);

... the i2c pointer is still available here, why introducing struct resource 
*res. release_mem_region() looks like a sane change to me though.

> +	release_mem_region(res->start, resource_size(res));
>  	kfree(i2c);
> 
>  	return 0;
