Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775Ab2BNJBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:01:35 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6623 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759679Ab2BNJBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:01:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 14 Feb 2012 01:01:32 -0800
Message-ID: <4F3A2274.5080000@nvidia.com>
Date: Tue, 14 Feb 2012 14:29:32 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "dunlap@xenotime.net" <dunlap@xenotime.net>, "lrg@ti.com" <lrg@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1 2/3] Documentation: gpio: Add details of open-drain
 configuration
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com> <1329114588-15430-3-git-send-email-ldewangan@nvidia.com> <20120213211809.GI11077@ponder.secretlab.ca> <20120213220656.GA11931@opensource.wolfsonmicro.com>
In-Reply-To: <20120213220656.GA11931@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 February 2012 03:36 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
>> Implicitly, the gpio api already supports open-drain and several drivers
>> make use of it.  Instead of being a separate flag; users who need open
>> drain will set the pin to input.  For example, see the i2c-gpio driver.
>> I'm not convinced this is needed; but my opinion could be swayed.
> The actual idea is to provide support for doing the switch to input to
> drivers that just want to set a logic level and don't (at their level)
> care one way or another if it's a CMOS or open drain output but instead
> leaves it up to board configuration which mode is used.  Laxman posted a
> patch for doing this to a regulator driver but looking at it the code
> for emulating open drain while also maintaining support for regular CMOS
> is fiddly enough that it seemed like it should be factored out of the
> individual drivers.
>

Implementing open-drain handling in every gpio client (like 
i2c-gpio/regulator/fixed.c) is just duplicating the code everywhere. 
Also it leaves to have such implementation buggy which is in following 
piece of code (taken from i2c-gpio.c)

         if (pdata->sda_is_open_drain) {
                 gpio_direction_output(pdata->sda_pin, 1);
                 bit_data->setsda = i2c_gpio_setsda_val;
         } else {
                 gpio_direction_input(pdata->sda_pin);
                 bit_data->setsda = i2c_gpio_setsda_dir;
         }

Header says
  * @sda_is_open_drain: SDA is configured as open drain, i.e. the pin
  *      isn't actively driven high when setting the output value high.
  *      gpio_get_value() must return the actual pin state even if the
  *      pin is configured as an output.

And hence the check should be
if (!pdata->sda_is_open_drain) {
:::::
}


All these can be avoided by supporting open-drain flag and handling in 
gpio library.

>> Also, you should include a patch to make i2c-gpio.c use this new
>> functionality as a proof-of-concept.  You may not be able to test it,
>> but it will make it a lot easier to justify merging by showing how it
>> cleans up a gpio user.

I can do the cleanup in i2c-gpio also which will reduce lots of code if 
this change in gpiolib is acceptable and fine with everyone.
Let me know if patch regulator/fixed.c V1 is sufficient or not to 
justify. I will create the patch for i2c-gpio  also.


