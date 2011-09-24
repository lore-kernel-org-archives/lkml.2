Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab1IXQvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 12:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab1IXQvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 12:51:13 -0400
Date: Sat, 24 Sep 2011 18:50:01 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>, linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20110924165001.GB10001@redhat.com>
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
 <20110902233806.GA22157@elie>
 <20110905091918.GC2221@redhat.com>
 <265f56a4dc9f5d3edeca3d101e445353@imap.dd24.net>
 <20110908084913.GB2195@redhat.com>
 <20110908161955.GA9171@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908161955.GA9171@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 06:19:56PM +0200, Stanislaw Gruszka wrote:
> On Thu, Sep 08, 2011 at 10:49:13AM +0200, Stanislaw Gruszka wrote:
> > On Mon, Sep 05, 2011 at 09:42:01AM +0000, Christoph Anton Mitterer wrote:
> > > On Mon, 5 Sep 2011 11:19:18 +0200, Stanislaw Gruszka <sgruszka@redhat.com>
> > > wrote:
> > > > this look like firmware hang. This happen just after module load, that's
> > > > good news, because it allow to log relative small amount debug messages
> > > > to see what possibly driver do wrong to crash firmware.
> > > Note, that the effects of - usually but not always - frozen system while
> > > the errors are printed (sometimes keyboard input seems still be possible
> > > during that) ... happen over and over again... say about every  10 minutes
> > > or so.
> > > Not just the first time the modules is loaded.
> > > Is the firmware loaded over and over again?
> > I think is not, but even if is, kernel should not crash. Can you grab
> > crash logs using photo camera, serial cable or netconsole, to allow to 
> > see where exactly crash happen and fix it.
> > 
> > > > Please configure syslog to log kernel debug messages.
> > > Will mail it later.
> > 
> > Firmware hang seems to happen when REPLY_LEDS_CMD command is send.
> > No idea if attached patch could help or not, but is worth to try it.
> > It prevent to send LED command asynchronously, when possibly some
> > other commands are pending in firmware.
> > 
> > If it does not help, please provide the same way captured debug
> > messages from 2.6.38 kernel, where drivers works. I'll compare
> > it with broken driver logs to figure out what broken driver
> > do differently.
> 
> Sorry, forgot attch the patch, do it now.

Any feedback here?

Stanislaw

> diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-led.c b/drivers/net/wireless/iwlegacy/iwl-3945-led.c
> index abd9235..127ffd6 100644
> --- a/drivers/net/wireless/iwlegacy/iwl-3945-led.c
> +++ b/drivers/net/wireless/iwlegacy/iwl-3945-led.c
> @@ -52,8 +52,7 @@ static int iwl3945_send_led_cmd(struct iwl_priv *priv,
>  		.id = REPLY_LEDS_CMD,
>  		.len = sizeof(struct iwl_led_cmd),
>  		.data = led_cmd,
> -		.flags = CMD_ASYNC,
> -		.callback = NULL,
> +		.flags = CMD_SYNC,
>  	};
>  
>  	return iwl_legacy_send_cmd(priv, &cmd);
> diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-led.c b/drivers/net/wireless/iwlegacy/iwl-4965-led.c
> index 26d324e..2545c19 100644
> --- a/drivers/net/wireless/iwlegacy/iwl-4965-led.c
> +++ b/drivers/net/wireless/iwlegacy/iwl-4965-led.c
> @@ -51,8 +51,7 @@ iwl4965_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
>  		.id = REPLY_LEDS_CMD,
>  		.len = sizeof(struct iwl_led_cmd),
>  		.data = led_cmd,
> -		.flags = CMD_ASYNC,
> -		.callback = NULL,
> +		.flags = CMD_SYNC,
>  	};
>  	u32 reg;
>  
> diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
> index 9c786ed..2623c79 100644
> --- a/drivers/net/wireless/iwlegacy/iwl-dev.h
> +++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
> @@ -1211,6 +1211,8 @@ struct iwl_priv {
>  	struct delayed_work alive_start;
>  	struct delayed_work scan_check;
>  
> +	struct work_struct led_work;
> +
>  	/* TX Power */
>  	s8 tx_power_user_lmt;
>  	s8 tx_power_device_lmt;
> diff --git a/drivers/net/wireless/iwlegacy/iwl-led.c b/drivers/net/wireless/iwlegacy/iwl-led.c
> index bda0d61..2152d87 100644
> --- a/drivers/net/wireless/iwlegacy/iwl-led.c
> +++ b/drivers/net/wireless/iwlegacy/iwl-led.c
> @@ -106,13 +106,6 @@ static int iwl_legacy_led_cmd(struct iwl_priv *priv,
>  		.id = IWL_LED_LINK,
>  		.interval = IWL_DEF_LED_INTRVL
>  	};
> -	int ret;
> -
> -	if (!test_bit(STATUS_READY, &priv->status))
> -		return -EBUSY;
> -
> -	if (priv->blink_on == on && priv->blink_off == off)
> -		return 0;
>  
>  	if (off == 0) {
>  		/* led is SOLID_ON */
> @@ -126,24 +119,25 @@ static int iwl_legacy_led_cmd(struct iwl_priv *priv,
>  	led_cmd.off = iwl_legacy_blink_compensation(priv, off,
>  				priv->cfg->base_params->led_compensation);
>  
> -	ret = priv->cfg->ops->led->cmd(priv, &led_cmd);
> -	if (!ret) {
> -		priv->blink_on = on;
> -		priv->blink_off = off;
> -	}
> -	return ret;
> +	return priv->cfg->ops->led->cmd(priv, &led_cmd);
>  }
>  
>  static void iwl_legacy_led_brightness_set(struct led_classdev *led_cdev,
>  				   enum led_brightness brightness)
>  {
>  	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv, led);
> -	unsigned long on = 0;
> +	unsigned long on = (brightness > 0) ? IWL_LED_SOLID : 0;
>  
> -	if (brightness > 0)
> -		on = IWL_LED_SOLID;
> +	if (!test_bit(STATUS_READY, &priv->status))
> +		return;
> +
> +	if (priv->blink_on == on && priv->blink_off == 0)
> +		return;
> +
> +	priv->blink_on = on;
> +	priv->blink_off = 0;
>  
> -	iwl_legacy_led_cmd(priv, on, 0);
> +	queue_work(priv->workqueue, &priv->led_work);
>  }
>  
>  static int iwl_legacy_led_blink_set(struct led_classdev *led_cdev,
> @@ -152,7 +146,28 @@ static int iwl_legacy_led_blink_set(struct led_classdev *led_cdev,
>  {
>  	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv, led);
>  
> -	return iwl_legacy_led_cmd(priv, *delay_on, *delay_off);
> +	if (!test_bit(STATUS_READY, &priv->status))
> +		return -EBUSY;
> +
> +	if (priv->blink_on == *delay_on && priv->blink_off == *delay_off)
> +		return 0;
> +
> +	/* FIXME: Need spinlock to sync with possibly currently running led work? */
> +	priv->blink_on = *delay_on;
> +	priv->blink_off = *delay_off;
> +
> +	queue_work(priv->workqueue, &priv->led_work);
> +	
> +	return 0;
> +}
> +
> +static void iwl_legacy_bg_led(struct work_struct *work)
> +{
> +	struct iwl_priv *priv = container_of(work, struct iwl_priv, led_work);
> +
> +	mutex_lock(&priv->mutex);
> +	iwl_legacy_led_cmd(priv, priv->blink_on, priv->blink_off);
> +	mutex_unlock(&priv->mutex);
>  }
>  
>  void iwl_legacy_leds_init(struct iwl_priv *priv)
> @@ -160,6 +175,8 @@ void iwl_legacy_leds_init(struct iwl_priv *priv)
>  	int mode = led_mode;
>  	int ret;
>  
> +	INIT_WORK(&priv->led_work, iwl_legacy_bg_led);
> +
>  	if (mode == IWL_LED_DEFAULT)
>  		mode = priv->cfg->led_mode;
>  
> @@ -202,5 +219,7 @@ void iwl_legacy_leds_exit(struct iwl_priv *priv)
>  
>  	led_classdev_unregister(&priv->led);
>  	kfree(priv->led.name);
> +
> +	cancel_work_sync(&priv->led_work);
>  }
>  EXPORT_SYMBOL(iwl_legacy_leds_exit);

