Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab2ATLUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:20:38 -0500
Received: from mail2.nsc.com ([12.238.8.132]:56499 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751733Ab2ATLUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:20:37 -0500
X-WSS-ID: 0LY3GU7-0A-5F2-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Lars-Peter Clausen" <lars@metafoo.de>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Fri, 20 Jan 2012 03:20:11 -0800
Subject: RE: [PATCH 7/7] leds-lm3530: enhanced arithmetic operation
Thread-Topic: [PATCH 7/7] leds-lm3530: enhanced arithmetic operation
Thread-Index: AczXTdWoeLb/fJYgTSyRk+zQjPWHXgAEn4PA
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD356C@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812C6D0D7@EXMAIL03.scwf.nsc.com>
 <4F19267C.7010307@metafoo.de>
In-Reply-To: <4F19267C.7010307@metafoo.de>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630792651LS9818753-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason why dividing by two is only 7-bits of brightness value in the LM3530 register.

Bit7 | bit6 | bit5 | bit4 | bit3 | bit2 | bit1 | bit0
------------------------------------------------------
 N/A |        LED Brightness Data (Bits[6:0])
------------------------------------------------------

So maximum value is limited to 127.

And we can think the alternative is '(brt_val & 0x7F)' - taking off the MSB to make it 7bits.
But the result is unexpected because value 128 and 255 has same brightness.
Brightness should be changed step by step, so appropriate method is dividing by two.

For the bit arithmetic and division, is it safe to predict same results ?
As you told, gcc makes same operation for that.(The objdump shows the same assembly code.)
But I think that using bit arithmetic is good habit.

Thanks,
Milo -

-----Original Message-----
From: Lars-Peter Clausen [mailto:lars@metafoo.de] 
Sent: Friday, January 20, 2012 5:32 PM
To: Kim, Milo
Cc: Linus Walleij; shreshthakumar.sahu@stericsson.com; linux-kernel@vger.kernel.org; rpurdie@rpsys.net
Subject: Re: [PATCH 7/7] leds-lm3530: enhanced arithmetic operation

On 01/20/2012 02:52 AM, Kim, Milo wrote:
> Use shift operation rather than 'divide-by-2'.

The compiler will already take of this for you.

But why is the divide by two necessary anyway? This sort of looks like
max_brightness is not set properly and the code compensates for it by
ignoring the lsb.

> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> 
> diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
> index 51c1f6c..e0b1ba8 100644
> --- a/drivers/leds/leds-lm3530.c
> +++ b/drivers/leds/leds-lm3530.c
> @@ -249,12 +249,12 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
>  
>  		/* set the brightness in brightness control register*/
>  		err = i2c_smbus_write_byte_data(drvdata->client,
> -				LM3530_BRT_CTRL_REG, brt_val / 2);
> +				LM3530_BRT_CTRL_REG, brt_val >> 1);
>  		if (err)
>  			dev_err(&drvdata->client->dev,
>  				"Unable to set brightness: %d\n", err);
>  		else
> -			drvdata->brightness = brt_val / 2;
> +			drvdata->brightness = brt_val >> 1;
>  
>  		if (brt_val == 0 && !pdata->is_vin_always_on) {
>  			err = regulator_disable(drvdata->regulator);


