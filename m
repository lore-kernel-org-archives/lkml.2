Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2BMVyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:54:33 -0500
Received: from bues.ch ([80.190.117.144]:38405 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab2BMVyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:54:31 -0500
Date: Mon, 13 Feb 2012 21:57:23 +0000
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, chunkeey@web.de,
        Max Filippov <jcmvbkbc@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [RFC/RFT 5/5] p54spi: Load firmware from work queue and not
 from probe routine
Message-ID: <20120213215723.565e8a8d@Nokia-N900>
In-Reply-To: <1329161826-11135-6-git-send-email-Larry.Finger@lwfinger.net>
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
	<1329161826-11135-6-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; arm-unknown-linux-gnueabi)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 13:37:06 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Drivers that load firmware from their probe routine have problems with the
> latest versions of udev as they get timeouts while waiting for user
> space to start. The problem is fixed by loading the firmware and starting
> mac80211 from a delayed_work queue. By using this method, most of the
> original code is preserved.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> This one is compile-tested only.
> 
> Larry
> ---
>  drivers/net/wireless/p54/p54spi.c |   38 ++++++++++++++++++++++++++----------
>  drivers/net/wireless/p54/p54spi.h |    1 +
>  2 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
> index 7faed62..87c2634 100644
> --- a/drivers/net/wireless/p54/p54spi.c
> +++ b/drivers/net/wireless/p54/p54spi.c
> @@ -595,6 +595,30 @@ static void p54spi_op_stop(struct ieee80211_hw *dev)
>  	cancel_work_sync(&priv->work);
>  }
>  
> +static void p54s_load_firmware(struct work_struct *work)
> +{
> +	struct p54s_priv *priv = container_of(to_delayed_work(work),
> +				 struct p54s_priv, firmware_load);
> +	struct ieee80211_hw *hw = priv->hw;
> +	int ret;
> +
> +	ret = p54spi_request_firmware(hw);
> +	if (ret < 0)
> +		goto err_free_common;
> +
> +	ret = p54spi_request_eeprom(hw);
> +	if (ret)
> +		goto err_free_common;
> +
> +	ret = p54_register_common(hw, &priv->spi->dev);
> +	if (ret)
> +		goto err_free_common;
> +	return;
> +
> +err_free_common:
> +	dev_err(&priv->spi->dev, "Failed to read firmware\n");
> +}
> +
>  static int __devinit p54spi_probe(struct spi_device *spi)
>  {
>  	struct p54s_priv *priv = NULL;
> @@ -658,17 +682,9 @@ static int __devinit p54spi_probe(struct spi_device *spi)
>  	priv->common.stop = p54spi_op_stop;
>  	priv->common.tx = p54spi_op_tx;
>  
> -	ret = p54spi_request_firmware(hw);
> -	if (ret < 0)
> -		goto err_free_common;
> -
> -	ret = p54spi_request_eeprom(hw);
> -	if (ret)
> -		goto err_free_common;
> -
> -	ret = p54_register_common(hw, &priv->spi->dev);
> -	if (ret)
> -		goto err_free_common;
> +	/* setup and start delayed work to load firmware */
> +	INIT_DELAYED_WORK(&priv->firmware_load, p54s_load_firmware);
> +	schedule_delayed_work(&priv->firmware_load, HZ);

Why delay it one second?
That seems arbitrary. Just use a non-delayed workqueue. That should be good enough.

>  
>  	return 0;
>  
> diff --git a/drivers/net/wireless/p54/p54spi.h b/drivers/net/wireless/p54/p54spi.h
> index dfaa62a..5f7714b 100644
> --- a/drivers/net/wireless/p54/p54spi.h
> +++ b/drivers/net/wireless/p54/p54spi.h
> @@ -120,6 +120,7 @@ struct p54s_priv {
>  
>  	enum fw_state fw_state;
>  	const struct firmware *firmware;
> +	struct delayed_work firmware_load;
>  };
>  
>  #endif /* P54SPI_H */

I think we have to cancel the work in the remove handler. Just in case the device was removed
before fw load wq could run.

-- 
Greetings, Michael.
