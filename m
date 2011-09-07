Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab1IGX34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:29:56 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46798 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab1IGX3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:29:54 -0400
Date: Wed, 7 Sep 2011 16:29:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Sung <penmount.touch@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Input: penmount - add PenMount 6000 support
Message-ID: <20110907232947.GB32566@core.coreip.homeip.net>
References: <1315290961-23570-1-git-send-email-penmount.touch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315290961-23570-1-git-send-email-penmount.touch@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Tue, Sep 06, 2011 at 02:36:01PM +0800, John Sung wrote:
> Add support for PenMount 6000 touch controller.
> 
> Signed-off-by: John Sung <penmount.touch@gmail.com>
> ---
>  drivers/input/touchscreen/penmount.c |   58 +++++++++++++++++++++++++++++-----
>  1 files changed, 50 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
> index 3342c6d..b60796b 100644
> --- a/drivers/input/touchscreen/penmount.c
> +++ b/drivers/input/touchscreen/penmount.c
> @@ -33,7 +33,7 @@ MODULE_LICENSE("GPL");
>   * Definitions & global arrays.
>   */
>  
> -#define	PM_MAX_LENGTH	5
> +#define	PM_MAX_LENGTH	6
>  
>  /*
>   * Per-touchscreen data.
> @@ -45,6 +45,7 @@ struct pm {
>  	int idx;
>  	unsigned char data[PM_MAX_LENGTH];
>  	char phys[32];
> +	unsigned char packetsize;
>  };
>  
>  static irqreturn_t pm_interrupt(struct serio *serio,
> @@ -55,20 +56,48 @@ static irqreturn_t pm_interrupt(struct serio *serio,
>  
>  	pm->data[pm->idx] = data;
>  
> -	if (pm->data[0] & 0x80) {
> -		if (PM_MAX_LENGTH == ++pm->idx) {
> -			input_report_abs(dev, ABS_X, pm->data[1] * 128 + pm->data[2]);
> -			input_report_abs(dev, ABS_Y, pm->data[3] * 128 + pm->data[4]);
> -			input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
> -			input_sync(dev);
> -			pm->idx = 0;
> +	switch (pm->dev->id.product) {
> +	case 0x9000:
> +		if (pm->data[0] & 0x80) {
> +			if (pm->packetsize == ++pm->idx) {
> +				input_report_abs(dev, ABS_X, pm->data[1] * 128 + pm->data[2]);
> +				input_report_abs(dev, ABS_Y, pm->data[3] * 128 + pm->data[4]);
> +				input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
> +				input_sync(dev);
> +				pm->idx = 0;
> +			}
>  		}
> +		break;
> +	case 0x6000:
> +		if ((pm->data[0] == 0x70) || (pm->data[0] == 0x30)) {

Should it be:

		if ((pm->data[0] & 0xbf) == 0x30)

to avoid 2 comparisons and branches?

> +			if (pm->packetsize == ++pm->idx) {
> +				input_report_abs(dev, ABS_X, pm->data[2] * 256 + pm->data[1]);
> +				input_report_abs(dev, ABS_Y, pm->data[4] * 256 + pm->data[3]);
> +				input_report_key(dev, BTN_TOUCH, (pm->data[0] == 0x70));
> +				input_sync(dev);
> +				pm->idx = 0;
> +			}
> +		}
> +		break;
>  	}
>  
>  	return IRQ_HANDLED;
>  }
>  
>  /*
> + * pm_enable() sends command that can enable the PenMount 6000 controller
> + */
> +
> +static void pm_enable(struct serio *serio)
> +{
> +	int i = 0;
> +	unsigned char command[6] = { 0xF1, 0x00, 0x00, 0x00, 0x00, 0x0E };
> +
> +	for (i = 0; i < 6; i++)
> +		serio_write(serio, command[i]);
> +}

Initializing a device connected to a serport serio port is actually task
of inputattach utility.

Thanks.

-- 
Dmitry
