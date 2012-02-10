Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab2BJKlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:41:15 -0500
Received: from bues.ch ([80.190.117.144]:60807 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab2BJKlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:41:14 -0500
Date: Fri, 10 Feb 2012 11:40:58 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: chunkeey@web.de, jcmvbkbc@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] p54spi: Convert driver to use asynchronous firmware
 loading
Message-ID: <20120210114058.771f0e27@milhouse>
In-Reply-To: <4f346d61.3S6x22TS5RH2gGO5%Larry.Finger@lwfinger.net>
References: <4f346d61.3S6x22TS5RH2gGO5%Larry.Finger@lwfinger.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Feb 2012 19:05:37 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Index: wireless-testing-new/drivers/net/wireless/p54/p54spi.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/p54/p54spi.c
> +++ wireless-testing-new/drivers/net/wireless/p54/p54spi.c
> @@ -163,25 +163,41 @@ static int p54spi_spi_write_dma(struct p
>  	return 0;
>  }
>  
> -static int p54spi_request_firmware(struct ieee80211_hw *dev)
> +
> +static void p54s_load_firmware_cb(const struct firmware *firmware,
> +				  void *context)
>  {
> +	struct ieee80211_hw *dev = context;
>  	struct p54s_priv *priv = dev->priv;
>  	int ret;
>  
> -	/* FIXME: should driver use it's own struct device? */
> -	ret = request_firmware(&priv->firmware, "3826.arm", &priv->spi->dev);
> -
> -	if (ret < 0) {
> -		dev_err(&priv->spi->dev, "request_firmware() failed: %d", ret);
> -		return ret;
> +	if (!firmware) {
> +		/* alternate firmware not found */
> +		dev_err(&priv->spi->dev, "Firmware loading failed\n");
> +		return;
>  	}
> +	complete(&priv->fw_loaded);
> +	priv->firmware = firmware;
>  
>  	ret = p54_parse_firmware(dev, priv->firmware);
> -	if (ret) {
> +	if (ret)
>  		release_firmware(priv->firmware);
> +}
> +
> +static int p54spi_request_firmware(struct ieee80211_hw *dev)
> +{
> +	struct p54s_priv *priv = dev->priv;
> +	int ret;
> +
> +	init_completion(&priv->fw_loaded);
> +	/* FIXME: should driver use it's own struct device? */
> +	ret = request_firmware_nowait(THIS_MODULE, 1, "3826.arm",
> +				      &priv->spi->dev, GFP_KERNEL, dev,
> +				      p54s_load_firmware_cb);
> +	if (ret < 0) {
> +		dev_err(&priv->spi->dev, "request_firmware() failed: %d", ret);
>  		return ret;
>  	}
> -
>  	return 0;
>  }

I think we need a wait_for_completion in op_start. We need to make sure firmware load is finished.
It might currently work, though, because we have the other fw_comp completion.
Please also rename your new completion to fw_requested or something like this to avoid
confusion with the real fw-loaded completion.

Also, what about eeprom request?

> @@ -681,6 +697,7 @@ static int __devexit p54spi_remove(struc
>  {
>  	struct p54s_priv *priv = dev_get_drvdata(&spi->dev);
>  
> +	wait_for_completion(&priv->fw_loaded);
>  	p54_unregister_common(priv->hw);
>  
>  	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
> Index: wireless-testing-new/drivers/net/wireless/p54/p54spi.h
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/p54/p54spi.h
> +++ wireless-testing-new/drivers/net/wireless/p54/p54spi.h
> @@ -120,6 +120,7 @@ struct p54s_priv {
>  
>  	enum fw_state fw_state;
>  	const struct firmware *firmware;
> +	struct completion fw_loaded;
>  };
>  
>  #endif /* P54SPI_H */
> 



-- 
Greetings, Michael.
