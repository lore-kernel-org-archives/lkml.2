Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2A0CVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:21:40 -0500
Received: from mail2.nsc.com ([12.238.8.132]:45634 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754686Ab2A0CVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:21:38 -0500
X-WSS-ID: 0LYFQJY-0A-0BF-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Arun MURTHY" <arun.murthy@stericsson.com>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Thu, 26 Jan 2012 18:21:25 -0800
Subject: RE: [PATCH 1/4] leds-lp5521: add 'name' in the
 lp5521_led_config
Thread-Topic: [PATCH 1/4] leds-lp5521: add 'name' in the
 lp5521_led_config
Thread-Index: AczYZ8yVBSJYBleRQuSZif3IIM5wFAEMgoeA
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6E9F5@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633CD5AD1LS9962348-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Arun, Srinidhi, Linus and Andrew on CC

> -----Original Message-----
> From: Kim, Milo
> Sent: Sunday, January 22, 2012 3:09 AM
> To: 'linux-kernel@vger.kernel.org'; 'rpurdie@rpsys.net'
> Subject: [PATCH 1/4] leds-lp5521: add 'name' in the lp5521_led_config
> 
> The name of each led channel can be configurable.
> For the compatibility, the name is set to default value(xx:channelN)
> when 'name' is not defined.
> 
> * kernel patch based on 3.0.1
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  Documentation/leds/leds-lp5521.txt |    6 ++++++
>  drivers/leds/leds-lp5521.c         |   11 ++++++++---
>  include/linux/leds-lp5521.h        |    1 +
>  3 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/leds/leds-lp5521.txt
> b/Documentation/leds/leds-lp5521.txt
> index c4d8d15..f48ab75 100644
> --- a/Documentation/leds/leds-lp5521.txt
> +++ b/Documentation/leds/leds-lp5521.txt
> @@ -43,17 +43,23 @@ Format: 10x mA i.e 10 means 1.0 mA
>  example platform data:
> 
>  Note: chan_nr can have values between 0 and 2.
> +The name of each channel can be configurable.
> +If the name field is not defined, the default name will be set to
> 'xxxx:channelN'
> +(XXXX : pdata->label or i2c client name, N : channel number)
> 
>  static struct lp5521_led_config lp5521_led_config[] = {
>          {
> +		.name = "red",
>                  .chan_nr        = 0,
>                  .led_current    = 50,
>  		.max_current    = 130,
>          }, {
> +		.name = "green",
>                  .chan_nr        = 1,
>                  .led_current    = 0,
>  		.max_current    = 130,
>          }, {
> +		.name = "blue",
>                  .chan_nr        = 2,
>                  .led_current    = 0,
>  		.max_current    = 130,
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index cc1dc48..c0e7c10 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -617,10 +617,15 @@ static int __devinit lp5521_init_led(struct
> lp5521_led *led,
>  		return -EINVAL;
>  	}
> 
> -	snprintf(name, sizeof(name), "%s:channel%d",
> -			pdata->label ?: client->name, chan);
>  	led->cdev.brightness_set = lp5521_set_brightness;
> -	led->cdev.name = name;
> +	if (pdata->led_config[chan].name) {
> +		led->cdev.name = pdata->led_config[chan].name;
> +	} else {
> +		snprintf(name, sizeof(name), "%s:channel%d",
> +			pdata->label ?: client->name, chan);
> +		led->cdev.name = name;
> +	}
> +
>  	res = led_classdev_register(dev, &led->cdev);
>  	if (res < 0) {
>  		dev_err(dev, "couldn't register led on channel %d\n", chan);
> diff --git a/include/linux/leds-lp5521.h b/include/linux/leds-lp5521.h
> index fd548d2..e675b8d 100644
> --- a/include/linux/leds-lp5521.h
> +++ b/include/linux/leds-lp5521.h
> @@ -26,6 +26,7 @@
>  /* See Documentation/leds/leds-lp5521.txt */
> 
>  struct lp5521_led_config {
> +	char		*name;
>  	u8		chan_nr;
>  	u8		led_current; /* mA x10, 0 if led is not connected */
>  	u8		max_current;
> --
> 1.7.4.1
> 
> Best Regards,
> Milo (Woogyom) Kim
> Texas Instruments Incorporated

