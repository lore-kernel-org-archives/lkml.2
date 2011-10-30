Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab1J3J5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 05:57:49 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:58322 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932481Ab1J3J5s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 05:57:48 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org Mailing List" 
	<linux-kernel@vger.kernel.org>
CC: Eric Miao <eric.y.miao@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Date: Sun, 30 Oct 2011 02:57:44 -0700
Subject: Re: [PATCH] power: max8925_power:  No temperature interrupts if
  temperature not connected (RESEND)
Thread-Topic: [PATCH] power: max8925_power:  No temperature interrupts if
  temperature not connected (RESEND)
Thread-Index: AcyW6mAF7N8xPq70S7+5QrusdPkxUA==
Message-ID: <C5176C36-6AE7-446B-A07A-F1F651C1B6EF@marvell.com>
References: <991AD77B-B073-4B05-8F23-5EF9A569483C@marvell.com>
In-Reply-To: <991AD77B-B073-4B05-8F23-5EF9A569483C@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



RESEND

On Aug 24, 2011, at 2:45 PM, Philip Rakity wrote:

> 
> Brownstone does not have temperature reading circuit hooked up.
> This leads to spurious interrupts.
> 
> Allow the platform layer to indicate no temperature circuit
> and do not activate interrupts if no temperature control is set
> 
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> ---
> drivers/power/max8925_power.c |   12 ++++++++----
> include/linux/mfd/max8925.h   |    1 +
> 2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> index a70e16d..dba07f3 100644
> --- a/drivers/power/max8925_power.c
> +++ b/drivers/power/max8925_power.c
> @@ -78,6 +78,7 @@ struct max8925_power_info {
> 	unsigned		batt_detect:1;	/* detecing MB by ID pin */
> 	unsigned		topoff_threshold:2;
> 	unsigned		fast_charge:3;
> +	unsigned		no_temp_support:1;
> 
> 	int (*set_charger) (int);
> };
> @@ -116,7 +117,7 @@ static irqreturn_t max8925_charger_handler(int irq, void *data)
> 	case MAX8925_IRQ_VCHG_DC_F:
> 		info->ac_online = 0;
> 		__set_charger(info, 0);
> -		dev_dbg(chip->dev, "Adapter is removal\n");
> +		dev_dbg(chip->dev, "Adapter removed\n");
> 		break;
> 	case MAX8925_IRQ_VCHG_USB_R:
> 		info->usb_online = 1;
> @@ -126,7 +127,7 @@ static irqreturn_t max8925_charger_handler(int irq, void *data)
> 	case MAX8925_IRQ_VCHG_USB_F:
> 		info->usb_online = 0;
> 		__set_charger(info, 0);
> -		dev_dbg(chip->dev, "USB is removal\n");
> +		dev_dbg(chip->dev, "USB removed\n");
> 		break;
> 	case MAX8925_IRQ_VCHG_THM_OK_F:
> 		/* Battery is not ready yet */
> @@ -370,8 +371,10 @@ static __devinit int max8925_init_charger(struct max8925_chip *chip,
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_OVP, "usb-ovp");
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_F, "usb-remove");
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_R, "usb-insert");
> -	REQUEST_IRQ(MAX8925_IRQ_VCHG_THM_OK_R, "batt-temp-in-range");
> -	REQUEST_IRQ(MAX8925_IRQ_VCHG_THM_OK_F, "batt-temp-out-range");
> +	if (!info->no_temp_support) {
> +		REQUEST_IRQ(MAX8925_IRQ_VCHG_THM_OK_R, "batt-temp-in-range");
> +		REQUEST_IRQ(MAX8925_IRQ_VCHG_THM_OK_F, "batt-temp-out-range");
> +	}
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_SYSLOW_F, "vsys-high");
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_SYSLOW_R, "vsys-low");
> 	REQUEST_IRQ(MAX8925_IRQ_VCHG_RST, "charger-reset");
> @@ -478,6 +481,7 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
> 	info->topoff_threshold = pdata->topoff_threshold;
> 	info->fast_charge = pdata->fast_charge;
> 	info->set_charger = pdata->set_charger;
> +	info->no_temp_support = pdata->no_temp_support;
> 
> 	max8925_init_charger(chip, info);
> 	return 0;
> diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
> index 5259dfe..69ec8f0 100644
> --- a/include/linux/mfd/max8925.h
> +++ b/include/linux/mfd/max8925.h
> @@ -223,6 +223,7 @@ struct max8925_power_pdata {
> 	unsigned	batt_detect:1;
> 	unsigned	topoff_threshold:2;
> 	unsigned	fast_charge:3;	/* charge current */
> +	unsigned	no_temp_support:1; /* set if no temperature detect */
> };
> 
> /*
> -- 
> 1.7.6
> 
> 

