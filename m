Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1E3XU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 19:20:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11073 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1E3XUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 19:20:55 -0400
Date: Tue, 31 May 2011 01:13:02 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
cc: Andre Bartke <andre.bartke@googlemail.com>, devel@linuxdriverproject.org,
        mchehab@redhat.com, devel@driverdev.osuosl.org,
        Andre Bartke <andre.bartke@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: altera-stapl: Fix memory leak of
 altera_init()
In-Reply-To: <201105310111.18056.PeterHuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.1105310107450.8346@swampdragon.chaosbits.net>
References: <1306788304-21794-1-git-send-email-andre.bartke@gmail.com> <201105310111.18056.PeterHuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1547594237-1306797182=:8346"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1547594237-1306797182=:8346
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 31 May 2011, Peter Hüwe wrote:

> Am Montag 30 Mai 2011, 22:45:04 schrieb Andre Bartke:
> > In case kzalloc() fails the second or third time
> > we should free the previous allocated resources.
> 
> Good catch!
> Personally I prefer putting the cleanup logic to the bottom, maybe like this - but that's just personal preference.
> 

Another alternative would be something like this:

        key = kzalloc(33 * sizeof(char), GFP_KERNEL);
        value = kzalloc(257 * sizeof(char), GFP_KERNEL);
        astate = kzalloc(sizeof(struct altera_state), GFP_KERNEL);
	if (!astate || !value || ! key) {
		kfree(astate);
		kfree(value);
		kfree(key);
		return -ENOMEM;
	}

Ohh and btw, in your suggestion (below), why don't you initialize 'retval' 
to -ENOMEM and then set it to zero once after all the allocations have 
completed? That would remove the need to set it to -ENOMEM 3 times before 
the goto's... Sure, you are seting it 3 times in error paths and my 
suggestion would introduce a retval=0; in the normal path, but the code 
would be shorter and more readable IMHO.

/Jesper Juhl


> >From 1a13a1d7a2bad26f050ecc342741b6c07cac2b8a Mon Sep 17 00:00:00 2001
> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Tue, 31 May 2011 00:54:27 +0200
> Subject: [PATCH] staging: altera-stapl: Fix memory leak of altera_init()
> 
> In case kzalloc() fails the second or third time
> we should free the previous allocated resources.
> In order to keep one return point and to keep the cleanup code to one
> place, some reordering was necessary.
> 
> Also while at it, removed the *sizeof(char) - to quote Linus:
> "" Also removed the silly "* sizeof(u8)".  If that isn't 1, we have way
>    deeper problems than a simple multiplication can fix. """
> 
> Reported-by: Andre Bartke <andre.bartke@gmail.com>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/staging/altera-stapl/altera.c |   33 +++++++++++++++++++++------------
>  1 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/altera-stapl/altera.c b/drivers/staging/altera-stapl/altera.c
> index 05aad35..09392ce 100644
> --- a/drivers/staging/altera-stapl/altera.c
> +++ b/drivers/staging/altera-stapl/altera.c
> @@ -2430,16 +2430,23 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
>  	int index = 0;
>  	s32 offset = 0L;
>  	s32 error_address = 0L;
> +	int retval = 0;
>  
> -	key = kzalloc(33 * sizeof(char), GFP_KERNEL);
> -	if (!key)
> -		return -ENOMEM;
> -	value = kzalloc(257 * sizeof(char), GFP_KERNEL);
> -	if (!value)
> -		return -ENOMEM;
> +	key = kzalloc(33, GFP_KERNEL);
> +	if (!key) {
> +		retval = -ENOMEM;
> +		goto out;
> +	}
> +	value = kzalloc(257, GFP_KERNEL);
> +	if (!value) {
> +		retval = -ENOMEM;
> +		goto free_key;
> +	}
>  	astate = kzalloc(sizeof(struct altera_state), GFP_KERNEL);
> -	if (!astate)
> -		return -ENOMEM;
> +	if (!astate) {
> +		retval = -ENOMEM;
> +		goto free_value;
> +	}
>  
>  	astate->config = config;
>  	if (!astate->config->jtag_io) {
> @@ -2518,10 +2525,12 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
>  	} else if (exec_result)
>  		printk(KERN_ERR "%s: error %d\n", __func__, exec_result);
>  
> -	kfree(key);
> -	kfree(value);
>  	kfree(astate);
> -
> -	return 0;
> +free_value:
> +	kfree(value);
> +free_key:
> +	kfree(key);
> +out:
> +	return retval;
>  }
>  EXPORT_SYMBOL(altera_init);
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1547594237-1306797182=:8346--
