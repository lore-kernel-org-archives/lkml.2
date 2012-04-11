Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab2DKVWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:22:53 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34318 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab2DKVWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:22:51 -0400
Date: Wed, 11 Apr 2012 14:22:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        linux-input@vger.kernel.org,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH] input: da9052: fix mem leak in da9052_onkey_probe()
Message-ID: <20120411212244.GB27562@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1204112249110.2137@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204112249110.2137@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 10:56:10PM +0200, Jesper Juhl wrote:
> If, in drivers/input/misc/da9052_onkey.c::da9052_onkey_probe(), the
> call to either kzalloc() or input_allocate_device() fails then we will
> return -ENOMEM from the function without freeing the other allocation
> that may have succeeded, thus we leak either the memory allocated for
> 'onkey' or the memory allocated for 'input_dev' if one succeeds and
> the other fails.
> Fix that by jumping to the 'err_free_mem' label at the end of the
> function that properly cleans up rather than returning directly.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

I must have messed up error hanlding path when collapsing the 2 memory
allocations; applied, thank Jesper.

> ---
>  drivers/input/misc/da9052_onkey.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/misc/da9052_onkey.c b/drivers/input/misc/da9052_onkey.c
> index 34aebb8..3c843cd 100644
> --- a/drivers/input/misc/da9052_onkey.c
> +++ b/drivers/input/misc/da9052_onkey.c
> @@ -95,7 +95,8 @@ static int __devinit da9052_onkey_probe(struct platform_device *pdev)
>  	input_dev = input_allocate_device();
>  	if (!onkey || !input_dev) {
>  		dev_err(&pdev->dev, "Failed to allocate memory\n");
> -		return -ENOMEM;
> +		error = -ENOMEM;
> +		goto err_free_mem;
>  	}
>  
>  	onkey->input = input_dev;
> -- 
> 1.7.10
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 

-- 
Dmitry
