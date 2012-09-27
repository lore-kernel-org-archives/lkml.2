Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2I0DMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 23:12:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43654 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab2I0DL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 23:11:58 -0400
Date: Wed, 26 Sep 2012 20:09:16 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 07/57] power: ab8500_bm: Detect removed charger
Message-ID: <20120927030916.GD8836@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-8-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-8-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:04AM -0600, mathieu.poirier@linaro.org wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>

No description forced me to look into this more closely. :-)

> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  drivers/power/ab8500_charger.c |  122 +++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 121 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index a7d0c3a..f7bba07 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -66,6 +66,11 @@
>  #define MAIN_CH_NOK			0x01
>  #define VBUS_DET			0x80
>  
> +#define MAIN_CH_STATUS2_MAINCHGDROP		0x80
> +#define MAIN_CH_STATUS2_MAINCHARGERDETDBNC	0x40
> +#define USB_CH_VBUSDROP				0x40
> +#define USB_CH_VBUSDETDBNC			0x01
> +
>  /* UsbLineStatus register bit masks */
>  #define AB8500_USB_LINK_STATUS		0x78
>  #define AB8500_STD_HOST_SUSP		0x18
> @@ -80,6 +85,8 @@
>  /* Step up/down delay in us */
>  #define STEP_UDELAY			1000
>  
> +#define CHARGER_STATUS_POLL 10 /* in ms */
> +
>  /* UsbLineStatus register - usb types */
>  enum ab8500_charger_link_status {
>  	USB_STAT_NOT_CONFIGURED,
> @@ -201,6 +208,10 @@ struct ab8500_charger_usb_state {
>   * @check_usbchgnotok_work:	Work for checking USB charger not ok status
>   * @kick_wd_work:		Work for kicking the charger watchdog in case
>   *				of ABB rev 1.* due to the watchog logic bug
> + * @ac_charger_attached_work:	Work for checking if AC charger is still
> + *				connected
> + * @usb_charger_attached_work:	Work for checking if USB charger is still
> + *				connected
>   * @ac_work:			Work for checking AC charger connection
>   * @detect_usb_type_work:	Work for detecting the USB type connected
>   * @usb_link_status_work:	Work for checking the new USB link status
> @@ -237,6 +248,8 @@ struct ab8500_charger {
>  	struct delayed_work check_hw_failure_work;
>  	struct delayed_work check_usbchgnotok_work;
>  	struct delayed_work kick_wd_work;
> +	struct delayed_work ac_charger_attached_work;
> +	struct delayed_work usb_charger_attached_work;
>  	struct work_struct ac_work;
>  	struct work_struct detect_usb_type_work;
>  	struct work_struct usb_link_status_work;
> @@ -347,6 +360,15 @@ static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
>  		dev_dbg(di->dev, "USB connected:%i\n", connected);
>  		di->usb.charger_connected = connected;
>  		sysfs_notify(&di->usb_chg.psy.dev->kobj, NULL, "present");
> +
> +		if (connected) {
> +			queue_delayed_work(di->charger_wq,
> +					   &di->usb_charger_attached_work,
> +					   HZ);
> +		} else {
> +			cancel_delayed_work_sync
> +					(&di->usb_charger_attached_work);
> +		}

While at it... this seem to be quite inconsistent (sometimes you wrap '('
sometimes not).

>  	}
>  }
>  
> @@ -1703,6 +1725,81 @@ static void ab8500_charger_ac_work(struct work_struct *work)
>  	sysfs_notify(&di->ac_chg.psy.dev->kobj, NULL, "present");
>  }
>  
> +static void ab8500_charger_usb_attached_work(struct work_struct *work)
> +{
> +	int i;
> +	int ret;
> +	u8 statval;
> +	struct ab8500_charger *di = container_of(work,
> +					 struct ab8500_charger,
> +					 usb_charger_attached_work.work);
> +
> +	for (i = 0 ; i < 10; i++) {

Unneeded space before ';'. Why 10?..

> +		ret = abx500_get_register_interruptible(di->dev,
> +						AB8500_CHARGER,
> +						AB8500_CH_USBCH_STAT1_REG,
> +						&statval);
> +		if (ret < 0) {
> +			dev_err(di->dev, "ab8500 read failed %d\n",
> +				__LINE__);
> +			goto reschedule;
> +		}
> +		if ((statval & (USB_CH_VBUSDROP |
> +				USB_CH_VBUSDETDBNC)) !=
> +		    (USB_CH_VBUSDROP | USB_CH_VBUSDETDBNC))
> +			goto reschedule;
> +
> +		msleep(CHARGER_STATUS_POLL);
> +	}
> +
> +	(void) ab8500_charger_usb_en(&di->usb_chg, 0, 0, 0);

"(void) " is probably not needed. If the function returns something,
why don't we check the result? Maybe we should turn it into void,
and just print some warning inside it?..

> +
> +	return;
> +reschedule:
> +	queue_delayed_work(di->charger_wq,
> +			   &di->usb_charger_attached_work,
> +			   HZ);
> +}
> +
> +static void ab8500_charger_ac_attached_work(struct work_struct *work)
> +{
> +
> +	int i;
> +	int ret;
> +	u8 statval;
> +	struct ab8500_charger *di = container_of(work,
> +					 struct ab8500_charger,
> +					 ac_charger_attached_work.work);
> +
> +	for (i = 0 ; i < 10; i++) {

unneeded space before ';', mysterious 10.

> +		ret = abx500_get_register_interruptible(di->dev,
> +							AB8500_CHARGER,
> +							AB8500_CH_STATUS2_REG,
> +							&statval);
> +		if (ret < 0) {
> +			dev_err(di->dev, "ab8500 read failed %d\n",
> +				__LINE__);
> +			goto reschedule;
> +		}
> +		if ((statval & (MAIN_CH_STATUS2_MAINCHGDROP |
> +				MAIN_CH_STATUS2_MAINCHARGERDETDBNC)) !=
> +		     (MAIN_CH_STATUS2_MAINCHGDROP |
> +		      MAIN_CH_STATUS2_MAINCHARGERDETDBNC))

This is unreadable. How about

	int mainch = MAIN_CH_STATUS2_MAINCHGDROP |
		     MAIN_CH_STATUS2_MAINCHARGERDETDBNC;

	...
	if ((statval & mainch) != mainch)
		goto reschedule;

> +			goto reschedule;
> +
> +		msleep(CHARGER_STATUS_POLL);
> +	}
> +
> +	(void) ab8500_charger_ac_en(&di->ac_chg, 0, 0, 0);

(void) unneeded.

[...]
> +	INIT_DELAYED_WORK(&di->ac_charger_attached_work,
> +			  ab8500_charger_ac_attached_work);
> +	INIT_DELAYED_WORK(&di->usb_charger_attached_work,
> +			  ab8500_charger_usb_attached_work);
> +

The amount of workqueues in this driver makes me wonder: does it make
sense to just move things into one workqueue, name it
ab8500_charger_update(), and so it will work as finite-state-machine,
managing all the charging states?

I'm not saying that you should change it in this series, but please do
consider this for the future at least, because the current logic would be
hard to impossible to debug, and it adds lots of workqueue churn.

>  	/*
>  	 * For ABB revision 1.0 and 1.1 there is a bug in the watchdog
>  	 * logic. That means we have to continously kick the charger
> @@ -2826,6 +2933,19 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, di);
>  
> +	ch_stat = ab8500_charger_detect_chargers(di);
> +
> +	if ((ch_stat & AC_PW_CONN) == AC_PW_CONN) {
> +		queue_delayed_work(di->charger_wq,
> +					   &di->ac_charger_attached_work,
> +					   HZ);
> +	}
> +	if ((ch_stat & USB_PW_CONN) == USB_PW_CONN) {
> +		queue_delayed_work(di->charger_wq,
> +					   &di->usb_charger_attached_work,
> +					   HZ);
> +	}
> +
>  	return ret;
>  
>  free_irq:
> -- 
> 1.7.5.4
