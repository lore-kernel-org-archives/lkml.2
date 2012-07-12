Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2GLFWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:22:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58532 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2GLFWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:22:31 -0400
Message-ID: <4FFE5F0F.8020904@gmail.com>
Date: Thu, 12 Jul 2012 15:22:23 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Toshiaki Yamane <yamanetoshi@gmail.com>
CC: greg@kroah.com, willy@meta-x.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] panel: Use pr_err(...) rather than printk(KERN_ERR
 ...)
References: <1342060541-9648-1-git-send-email-yamanetoshi@gmail.com>
In-Reply-To: <1342060541-9648-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/12 12:35, Toshiaki Yamane wrote:
> This change is inspired by checkpatch.

Your changelog needs to describe all of the changes you are making. The
subject line only describes one. This patch is doing the following:

 - Converting printk(KERN_ERR to pr_err
 - Adding __func__ prefixes to printk lines
 - Refactoring split printk strings onto a single line

There are a few other printks in this file which could be converted to
pr_* to make the code more consistent. Perhaps a follow up patch?

Typically for a sub-sequent version of a patch/series you should list
the changes since the last round. Put these below the --- so that they
don't become part of the change log, e.g.:

  Signed-off-by: Your name/email here
  ---

  Changes since v2:
    - Some stuff

  Changes since v1:
    - Some other stuff

Some more comments below.

~Ryan

> 
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
> ---
>  drivers/staging/panel/panel.c |   42 +++++++++++++++++-----------------------
>  1 files changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> index 7365089..a6d71fd 100644
> --- a/drivers/staging/panel/panel.c
> +++ b/drivers/staging/panel/panel.c
> @@ -34,6 +34,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +

If you are going to print __func__ on each line, you can do:

  #define pr_fmt(fmt) KBUILD_MODNAME "%s: " fmt, __func__

Do you really need to print the function name out everywhere though?

>  #include <linux/module.h>
>  
>  #include <linux/types.h>
> @@ -1987,10 +1989,9 @@ static struct logical_input *panel_bind_key(char *name, char *press,
>  	struct logical_input *key;
>  
>  	key = kzalloc(sizeof(struct logical_input), GFP_KERNEL);
> -	if (!key) {
> -		printk(KERN_ERR "panel: not enough memory\n");
> +	if (!key)
>  		return NULL;
> -	}
> +
>  	if (!input_name2mask(name, &key->mask, &key->value, &scan_mask_i,
>  			     &scan_mask_o)) {
>  		kfree(key);
> @@ -2030,10 +2031,9 @@ static struct logical_input *panel_bind_callback(char *name,
>  	struct logical_input *callback;
>  
>  	callback = kmalloc(sizeof(struct logical_input), GFP_KERNEL);
> -	if (!callback) {
> -		printk(KERN_ERR "panel: not enough memory\n");
> +	if (!callback)
>  		return NULL;
> -	}
> +
>  	memset(callback, 0, sizeof(struct logical_input));
>  	if (!input_name2mask(name, &callback->mask, &callback->value,
>  			     &scan_mask_i, &scan_mask_o))
> @@ -2110,10 +2110,8 @@ static void panel_attach(struct parport *port)
>  		return;
>  
>  	if (pprt) {
> -		printk(KERN_ERR
> -		       "panel_attach(): port->number=%d parport=%d, "
> -		       "already registered !\n",
> -		       port->number, parport);
> +		pr_err("%s: port->number=%d parport=%d, already registered !\n",
> +		       __func__, port->number, parport);

Nitpick - Could remove the space before the '!'. The original has it
that, so no big deal if you want to leave it.

>  		return;
>  	}
>  
> @@ -2122,16 +2120,14 @@ static void panel_attach(struct parport *port)
>  				       /*PARPORT_DEV_EXCL */
>  				       0, (void *)&pprt);
>  	if (pprt == NULL) {
> -		pr_err("panel_attach(): port->number=%d parport=%d, "
> -		       "parport_register_device() failed\n",
> -		       port->number, parport);
> +		pr_err("%s: port->number=%d parport=%d, parport_register_device() failed\n",
> +		       __func__, port->number, parport);
>  		return;
>  	}
>  
>  	if (parport_claim(pprt)) {
> -		printk(KERN_ERR
> -		       "Panel: could not claim access to parport%d. "
> -		       "Aborting.\n", parport);
> +		pr_err("%s: could not claim access to parport%d. Aborting.\n",
> +		       __func__, parport);
>  		goto err_unreg_device;
>  	}
>  
> @@ -2165,10 +2161,8 @@ static void panel_detach(struct parport *port)
>  		return;
>  
>  	if (!pprt) {
> -		printk(KERN_ERR
> -		       "panel_detach(): port->number=%d parport=%d, "
> -		       "nothing to unregister.\n",
> -		       port->number, parport);
> +		pr_err("%s: port->number=%d parport=%d, nothing to unregister.\n",
> +		       __func__, port->number, parport);
>  		return;
>  	}
>  
> @@ -2278,8 +2272,8 @@ int panel_init(void)
>  	init_in_progress = 1;
>  
>  	if (parport_register_driver(&panel_driver)) {
> -		printk(KERN_ERR
> -		       "Panel: could not register with parport. Aborting.\n");
> +		pr_err("%s: could not register with parport. Aborting.\n",
> +		       __func__);
>  		return -EIO;
>  	}
>  
> @@ -2291,8 +2285,8 @@ int panel_init(void)
>  			pprt = NULL;
>  		}
>  		parport_unregister_driver(&panel_driver);
> -		printk(KERN_ERR "Panel driver version " PANEL_VERSION
> -		       " disabled.\n");
> +		pr_err("%s: Panel driver version " PANEL_VERSION " disabled.\n",
> +		       __func__);

You can drop "Panel" from the string here, since pr_fmt will prefix the
string with "panel: "

>  		return -ENODEV;
>  	}
>  
> 


