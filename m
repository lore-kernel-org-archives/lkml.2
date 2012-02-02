Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2BBNSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:18:20 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:57335 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab2BBNST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:18:19 -0500
Message-ID: <4F2A8D11.9010705@ti.com>
Date: Thu, 02 Feb 2012 15:18:09 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20120106 Thunderbird/9.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 7/7] MFD: TWL6040: Add regulator support for VIO, V2V1 supplies
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com> <1328185019-29575-8-git-send-email-peter.ujfalusi@ti.com> <20120202125250.GJ7428@opensource.wolfsonmicro.com>
In-Reply-To: <20120202125250.GJ7428@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 02:52 PM, Mark Brown wrote:
> On Thu, Feb 02, 2012 at 02:16:59PM +0200, Peter Ujfalusi wrote:
> 
>> +	twl6040->vio = regulator_get(&client->dev, "vio");
>> +	if (IS_ERR(twl6040->vio)) {
>> +		ret = PTR_ERR(twl6040->vio);
>> +		dev_err(&client->dev, "Failed to request VIO supply: %d\n",
>> +			ret);
>> +		goto regulator_get_err;
>> +	}
>> +	twl6040->v2v1 = regulator_get(&client->dev, "v2v1");
>> +	if (IS_ERR(twl6040->v2v1)) {
>> +		ret = PTR_ERR(twl6040->v2v1);
>> +		dev_err(&client->dev, "Failed to request V2V1 supply: %d\n",
>> +			ret);
>> +		regulator_put(twl6040->vio);
>> +		goto regulator_get_err;
>> +	}
> 
> Looks like you want regulator_bulk_get() here.  Or (better yet though
> it'd be a potential issue for merge via MFD and the benefits aren't that
> exciting since you still need to disable) devm_regulator_bulk_get().

I need separate control for the two power source since we can hit
different power levels depending on which is powered/not powered:
power down: vio, v2v1 is OFF
deep sleep: vio is ON, v2v1 is OFF
sleep/power on: vio, v2v1 is ON

And we have certain sequence to move between power states.

> 
>> +	ret = regulator_enable(twl6040->vio);
>> +	if (ret != 0) {
>> +		dev_err(&client->dev, "Failed to enable VIO: %d\n", ret);
>> +		goto power_err;
>> +	}
>> +	ret = regulator_enable(twl6040->v2v1);
>> +	if (ret != 0) {
>> +		dev_err(&client->dev, "Failed to enable V2V1: %d\n", ret);
>> +		regulator_disable(twl6040->vio);

I disable the vio here, if the v2v1 enable fails.

>> +		goto power_err;
>> +	}
> 
> Similarly regulator_bulk_enable() here, and it'll fix...
> 
>>  gpio1_err:
>> +	regulator_disable(twl6040->v2v1);
>> +	regulator_disable(twl6040->vio);
> 
> ...the fact that if you fail to enable the v2.1 regulator you don't
> disable vio.

It is handled within the if(){}
With the devm_regulator this will be much nicer for sure.

-- 
Péter
