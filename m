Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2KTByP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:54:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6074 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2KTByO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:54:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 Nov 2012 17:54:12 -0800
Message-ID: <50AAE2BF.2000909@nvidia.com>
Date: Tue, 20 Nov 2012 07:24:07 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com> <Pine.LNX.4.64.1211190900110.11024@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211190900110.11024@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 November 2012 04:22 PM, Guennadi Liakhovetski wrote:
>
> Hi Laxman
>
> drivers in the tree. Well, I came to two conclusions so far: (1) The
> current regulator API is not very well suitable for such regulators. I
> would imagine, one would need two methods: for setting the "normal" and
> the DVS voltage. Instead of this drivers are trying to be smart at
> guessing, which voltage the user is trying to set now... (2) Drivers do
> this in different ways and at least out of the 2 drivers I looked at both
> have bugs and different ones at that. I'll send a separate email,
> describing what I found suspicious in them.
>
> Of course, all the above was just my DVS-newbie impression, which can very
> well be absolutely wrong.
>

If there is multipel VOUT register for single vout then these registers 
are generally selected by the input pin of device.
In a given system, you can connect the gpios pin to this input pins to 
select the proper VOUT register.
The register update through i2c consume more time and changing the gpio 
state is comparatively less.
So if you have let say 4 voltages 1.10, 1.11, 1.12, 1.13 and having 4 
VOUT register. Then program these vout val to vout reg like 1.10 to 
vout_reg0, 1.11 to vout_reg1 etc.
Now for changing voltage between these will just require to change the 
gpio pin state, not the register update and so it will be faster. You 
can achive the voltage change by gpio pin state change.

Now if your DVS have more volatge scaling then you can use the LRU 
mechanism to use the vout register for this new value.



>> +     max->dev =&client->dev;
>> +     max->desc.name = id->name;
>> +     max->desc.id = 0;
> Don't you have to be able to process multiple such devices?

Not really require as device have only one output. The different devices 
will have different registrations and so does not matter here.




>> +     max->enable_external_control = pdata->enable_ext_control;
>> +     max->dvs_gpio = pdata->dvs_gpio;
>> +     max->curr_gpio_val = pdata->dvs_def_state;
>> +     max->curr_vout_reg = MAX8973_VOUT + pdata->dvs_def_state;
>> +     max->lru_index[0] = max->curr_vout_reg;
> Here you actually need an offset within your register address space, so,
> should be
>
> +       max->lru_index[0] = pdata->dvs_def_state;


Yaah, seems some issue if vout_base is not zero. But really dont require 
here as MAX8973_VOUT is 0 in this case.


