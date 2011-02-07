Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1BGQwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:52:41 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:45795 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754402Ab1BGQwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:52:39 -0500
Message-ID: <4D5023A4.3020209@metafoo.de>
Date: Mon, 07 Feb 2011 17:53:56 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] ASoC: Samsung: neo1973_gta02: Fix bluetooth DAI registration
References: <1297033463-14577-1-git-send-email-lars@metafoo.de> <1297033463-14577-6-git-send-email-lars@metafoo.de> <20110207115906.GD10564@opensource.wolfsonmicro.com>
In-Reply-To: <20110207115906.GD10564@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 12:59 PM, Mark Brown wrote:
> On Mon, Feb 07, 2011 at 12:04:22AM +0100, Lars-Peter Clausen wrote:
>> This patch fixes two issues with the bluethooth DAI registration:
>> * The DAI has to be registered only after the sound device has been added.
> 
> This isn't a problem, components in the system can be registered in any
> order.

By device I mean the soc-core platform device, which has to exist before a dai can be
registered with that device.

> 
>> * Currently the DAI is registered with snd_soc_register_dai which causes it to
>>   be named after the device it was registered for. Which is in this case the
>>   "soc-audio" device. (Ab)use snd_soc_register_dais which causes the DAI to be
>>   named after the DAI driver, which is what we want in this case.
> 
> This doesn't tie up with your change which...
> 
>> -	/* register bluetooth DAI here */
>> -	ret = snd_soc_register_dai(&neo1973_gta02_snd_device->dev, &bt_dai);
>> -	if (ret)
>> -		goto err_put_device;
> 
>> +	/* register bluetooth DAI here */
>> +	ret = snd_soc_register_dais(&neo1973_gta02_snd_device->dev, &bt_dai, 1);
>>  	if (ret)
>> -		goto err_unregister_dai;
>> +		goto err_unregister_device;
> 
> ...uses the same device in both cases and looking briefly at the code
> both register functions just use the dev that was passed in.

The difference between the two is that snd_soc_register_dais calls fmt_multiple_name,
but snd_soc_register_dai uses fmt_single_name. The later uses the name of device for
which the dai is registered to generate the dai_device name, while the former uses
the name of the dai_driver.
So by calling snd_soc_register_dai the bluetooth dai_device will be name "soc-core"
instead of "bluetooth-dai". So currently there is no match between the dai_link and
the dai_device, as a result the sound card is not instantiated.

> In any
> case, we clearly shouldn't be applying patches which bodge around the
> core.

Well the alternative would be a patch looking like this:

-	.cpu_dai_name = "bluetooth-dai",
+	.cpu_dai_name = "soc-core",

Which isn't really nice either.

- Lars
