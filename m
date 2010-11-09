Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0KIGfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 01:35:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43716 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab0KIGf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 01:35:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t6xAt9R27dW7yLAU+v1DFnnqSlP0+bCA21JSq/q193zZlyqZzToFSqpmKnILsAHLvm
         h1uuSC49iCxC3bsOyKSTcV1bcJF35DPcP8T5txFga6pdtRFxNqQGlR1LkRuBpV10KbJJ
         uxSlKbOuGonWxwFhYlRI3lZXxwM3y0ty6VTZY=
Date: Mon, 8 Nov 2010 22:35:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Helge Deller <deller@gmx.de>
Subject: Re: [PATCH RFC] serio HIL MLC: don't deref null, don't leak and
 return proper error
Message-ID: <20101109063520.GA10502@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1011072024100.26247@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011072024100.26247@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 08:36:33PM +0100, Jesper Juhl wrote:
> Hi,
> 
> While reviewing various users of kernel memory allocation functions I came 
> across drivers/input/serio/hil_mlc.c::hil_mlc_register() and noticed that
>  - it calls kzalloc() buf fails to check for a NULL return before use.
>  - it makes several allocations and if one fails it doesn't free the 
>    previous ones.
>  - It doesn't return -ENOMEM in the failed memory allocation case (it just 
>    crashes).
> This patch corrects all of the above and also reworks the only caller of 
> this function that I could find 
> (drivers/input/serio/hp_sdc_mlc.c::hp_sdc_mlc_out()) so that it now checks 
> the return value of hil_mlc_register() and properly propagate it on 
> failure and I also restructured the code to remove some labels and goto's 
> to make it, IMHO nicer to read.
> 
> I have no hardware to test, so please review carefully and let me know if 
> I've done something completely stupid. Please don't merge this RFC patch 
> unless at least one or more people who know this code and can actually 
> test it have ACK'ed it.

I think Helge Deller (CCed) used to have access to such hardware...

> 
> Ohh and please do CC me on replies.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  hil_mlc.c    |    5 +++++
>  hp_sdc_mlc.c |   18 +++++++++---------
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
> index e5624d8..bfd3865 100644
> --- a/drivers/input/serio/hil_mlc.c
> +++ b/drivers/input/serio/hil_mlc.c
> @@ -932,6 +932,11 @@ int hil_mlc_register(hil_mlc *mlc)
>  		hil_mlc_copy_di_scratch(mlc, i);
>  		mlc_serio = kzalloc(sizeof(*mlc_serio), GFP_KERNEL);
>  		mlc->serio[i] = mlc_serio;
> +		if (!mlc->serio[i]) {
> +			for (; i >= 0; i--)
> +				kfree(mlc->serio[i]);
> +			return -ENOMEM;
> +		}
>  		snprintf(mlc_serio->name, sizeof(mlc_serio->name)-1, "HIL_SERIO%d", i);
>  		snprintf(mlc_serio->phys, sizeof(mlc_serio->phys)-1, "HIL%d", i);
>  		mlc_serio->id			= hil_mlc_serio_id;
> diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
> index 7d2b820..d50f067 100644
> --- a/drivers/input/serio/hp_sdc_mlc.c
> +++ b/drivers/input/serio/hp_sdc_mlc.c
> @@ -305,6 +305,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
>  static int __init hp_sdc_mlc_init(void)
>  {
>  	hil_mlc *mlc = &hp_sdc_mlc;
> +	int err;
>  
>  #ifdef __mc68000__
>  	if (!MACH_IS_HP300)
> @@ -323,22 +324,21 @@ static int __init hp_sdc_mlc_init(void)
>  	mlc->out = &hp_sdc_mlc_out;
>  	mlc->priv = &hp_sdc_mlc_priv;
>  
> -	if (hil_mlc_register(mlc)) {
> +	err = hil_mlc_register(mlc);
> +	if (err) {
>  		printk(KERN_WARNING PREFIX "Failed to register MLC structure with hil_mlc\n");
> -		goto err0;
> +		return err;
>  	}
>  
>  	if (hp_sdc_request_hil_irq(&hp_sdc_mlc_isr)) {
>  		printk(KERN_WARNING PREFIX "Request for raw HIL ISR hook denied\n");
> -		goto err1;
> +		if (hil_mlc_unregister(mlc))
> +			printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
> +				"This is bad.  Could cause an oops.\n");
> +		return -EBUSY;
>  	}
> +
>  	return 0;
> - err1:
> -	if (hil_mlc_unregister(mlc))
> -		printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
> -			"This is bad.  Could cause an oops.\n");
> - err0:
> -	return -EBUSY;
>  }
>  
>  static void __exit hp_sdc_mlc_exit(void)
> 
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
> 

-- 
Dmitry
