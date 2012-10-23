Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab2JWJS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:18:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57379 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab2JWJS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:18:26 -0400
Message-ID: <508660D4.9030507@ti.com>
Date: Tue, 23 Oct 2012 11:18:12 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com> <20121022155028.GA13791@core.coreip.homeip.net>
In-Reply-To: <20121022155028.GA13791@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dimitry,

On 10/22/2012 05:50 PM, Dmitry Torokhov wrote:
> Hi Sourav,
> 
> On Mon, Oct 22, 2012 at 06:43:00PM +0530, Sourav Poddar wrote:
>> Adapt keypad to use pinctrl framework.
>>
>> Tested on omap4430 sdp with 3.7-rc1 kernel.
> 
> I do not see anything in the driver that would directly use pinctrl. Is
> there a better place to select default pin configuration; maybe when
> instantiating platform device?

Why?
The devm_pinctrl_get_select_default is using the pinctrl.
That's why it is named "get_select_default" and not "get" only.
This API ensure that the pin will be set to the default state, and this
is all we need to do during the probe.

There is no point to change the mux if the driver is not probed, because
potentially the pin can be use be another driver.
So probe is the right place to do that for my point of view. Moreover
with DT we don't have that board static config like we had before to do
that kind of pin mux init.

But, maybe I'm missing your point.

Regards,
Benoit


> 
> Thanks.
> 
>>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>> ---
>> v1->v2
>> - Added "PROBE_DEFER" check 
>>  drivers/input/keyboard/omap4-keypad.c |   11 +++++++++++
>>  1 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
>> index c05f98c..502b832 100644
>> --- a/drivers/input/keyboard/omap4-keypad.c
>> +++ b/drivers/input/keyboard/omap4-keypad.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/input.h>
>>  #include <linux/slab.h>
>>  #include <linux/pm_runtime.h>
>> +#include <linux/pinctrl/consumer.h>
>>  
>>  #include <linux/platform_data/omap4-keypad.h>
>>  
>> @@ -76,6 +77,7 @@ enum {
>>  
>>  struct omap4_keypad {
>>  	struct input_dev *input;
>> +	struct pinctrl	*pins;
>>  
>>  	void __iomem *base;
>>  	unsigned int irq;
>> @@ -298,6 +300,15 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>>  		goto err_release_mem;
>>  	}
>>  
>> +	keypad_data->pins = devm_pinctrl_get_select_default(&pdev->dev);
>> +	if (IS_ERR(keypad_data->pins)) {
>> +		if (PTR_ERR(keypad_data->pins) == -EPROBE_DEFER)
>> +			return -EPROBE_DEFER;
>> +
>> +		dev_warn(&pdev->dev, "did not get pins for keypad error: %li\n",
>> +					PTR_ERR(keypad_data->pins));
>> +		keypad_data->pins = NULL;
>> +	}
>>  
>>  	/*
>>  	 * Enable clocks for the keypad module so that we can read
>> -- 
>> 1.7.1
>>
> 

