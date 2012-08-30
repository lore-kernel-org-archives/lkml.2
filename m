Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2H3NgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 09:36:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58682 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2H3NgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 09:36:23 -0400
Message-ID: <503F6C52.6030100@suse.cz>
Date: Thu, 30 Aug 2012 15:36:18 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120815 Thunderbird/15.0
MIME-Version: 1.0
To: Baodong Chen <chenbdchenbd@gmail.com>
CC: gregkh@linuxfoundation.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:fixed code to fit tty_driver's kref filed fixed
 code to fit tty_driver's kref filed for drivers/staging/net/pc300_tty.c
References: <1346074458-2659-1-git-send-email-chenbdchenbd@gmail.com>
In-Reply-To: <1346074458-2659-1-git-send-email-chenbdchenbd@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 03:34 PM, Baodong Chen wrote:

Sorry, I do not get this change. You should not touch tty_driver.kref at
all.

And what is the patch good for?

> Signed-off-by: Baodong Chen <chenbdchenbd@gmail.com>
> ---
>  drivers/staging/net/pc300_tty.c |   55 ++++++++++++++++++++++-----------------
>  1 files changed, 31 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/staging/net/pc300_tty.c b/drivers/staging/net/pc300_tty.c
> index 4709f42..91ada93 100644
> --- a/drivers/staging/net/pc300_tty.c
> +++ b/drivers/staging/net/pc300_tty.c
> @@ -46,6 +46,8 @@
>  #include <linux/slab.h>
>  #include <linux/if.h>
>  #include <linux/skbuff.h>
> +#include <linux/kref.h>
> +
>  /* TTY includes */
>  #include <linux/tty.h>
>  #include <linux/tty_flip.h>
> @@ -134,12 +136,26 @@ static void cpc_tty_signal_on(pc300dev_t *pc300dev, unsigned char);
>  static int pc300_tiocmset(struct tty_struct *, unsigned int, unsigned int);
>  static int pc300_tiocmget(struct tty_struct *);
>  
> +static void cpc_tty_do_unreg_driver(struct kref *ref);
> +
>  /* functions called by PC300 driver */
>  void cpc_tty_init(pc300dev_t *dev);
>  void cpc_tty_unregister_service(pc300dev_t *pc300dev);
>  void cpc_tty_receive(pc300dev_t *pc300dev);
>  void cpc_tty_trigger_poll(pc300dev_t *pc300dev);
>  
> +static void cpc_tty_do_unreg_driver(struct kref *ref)
> +{
> +	struct tty_driver *drv = container_of(ref, struct tty_driver, kref);
> +	int ret;
> +
> +	cpc_tty_unreg_flag = 0;
> +
> +	res = tty_unregister_driver(drv);
> +	if (res)
> +		CPC_TTY_DBG("unregister the tty driver error=%d\n", res);
> +}
> +
>  /*
>   * PC300 TTY clear "signal"
>   */
> @@ -239,6 +255,8 @@ void cpc_tty_init(pc300dev_t *pc300dev)
>  		/* interface routines from the upper tty layer to the tty driver */
>  		tty_set_operations(&serial_drv, &pc300_ops);
>  
> +		kref_init(&serial_drv.kref);
> +
>  		/* register the TTY driver */
>  		if (tty_register_driver(&serial_drv)) { 
>  			printk("%s-tty: Failed to register serial driver! ",
> @@ -408,13 +426,9 @@ static void cpc_tty_close(struct tty_struct *tty, struct file *flip)
>  
>  	CPC_TTY_DBG("%s: TTY closed\n",cpc_tty->name);
>  	
> -	if (!serial_drv.refcount && cpc_tty_unreg_flag) {
> -		cpc_tty_unreg_flag = 0;
> -		CPC_TTY_DBG("%s: unregister the tty driver\n", cpc_tty->name);
> -		if ((res=tty_unregister_driver(&serial_drv))) { 
> -			CPC_TTY_DBG("%s: ERROR ->unregister the tty driver error=%d\n",
> -							cpc_tty->name,res);
> -		}
> +	if (cpc_tty_unreg_flag) {
> +		CPC_TTY_DBG("%s: checking unregister the tty driver...\n", cpc_tty->name);
> +		kref_put(&serial_drv.kref, cpc_tty_do_unreg_driver);
>  	}
>  	return; 
>  } 
> @@ -644,13 +658,9 @@ static void cpc_tty_hangup(struct tty_struct *tty)
>  		CPC_TTY_DBG("%s: TTY is not opened\n",cpc_tty->name);
>  		return ;
>  	}
> -	if (!serial_drv.refcount && cpc_tty_unreg_flag) {
> -		cpc_tty_unreg_flag = 0;
> -		CPC_TTY_DBG("%s: unregister the tty driver\n", cpc_tty->name);
> -		if ((res=tty_unregister_driver(&serial_drv))) { 
> -			CPC_TTY_DBG("%s: ERROR ->unregister the tty driver error=%d\n",
> -							cpc_tty->name,res);
> -		}
> +	if (cpc_tty_unreg_flag) {
> +		CPC_TTY_DBG("%s: checking unregister the tty driver...\n", cpc_tty->name);
> +		kref_put(&serial_drv.kref, cpc_tty_do_unreg_driver);
>  	}
>  	cpc_tty_signal_off(cpc_tty->pc300dev, CTL_DTR);
>  }
> @@ -1043,19 +1053,16 @@ void cpc_tty_unregister_service(pc300dev_t *pc300dev)
>  		return; 
>  	}
>  
> -	if (--cpc_tty_cnt == 0) { 
> -		if (serial_drv.refcount) {
> -			CPC_TTY_DBG("%s: unregister is not possible, refcount=%d",
> -							cpc_tty->name, serial_drv.refcount);
> +	if (--cpc_tty_cnt == 0) {
> +		CPC_TTY_DBG("%s: checking unregister the tty driver...\n",
> +				cpc_tty->name);
> +		res = kref_put(&serial_drv.kref, cpc_tty_do_unreg_driver);
> +		if (0 == res) {
> +			CPC_TTY_DBG("%s: unregister is not possible\n",
> +					cpc_tty->name);
>  			cpc_tty_cnt++;
>  			cpc_tty_unreg_flag = 1;
>  			return;
> -		} else { 
> -			CPC_TTY_DBG("%s: unregister the tty driver\n", cpc_tty->name);
> -			if ((res=tty_unregister_driver(&serial_drv))) { 
> -				CPC_TTY_DBG("%s: ERROR ->unregister the tty driver error=%d\n",
> -								cpc_tty->name,res);
> -			}
>  		}
>  	}
>  	CPC_TTY_LOCK(pc300dev->chan->card,flags);
> 


-- 
js
suse labs
