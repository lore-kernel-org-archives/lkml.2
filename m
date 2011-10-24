Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab1JXQNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 12:13:55 -0400
Received: from mail.fuel7.com ([74.222.0.51]:39184 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874Ab1JXQNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 12:13:54 -0400
Message-ID: <4EA58EC0.7080502@fuel7.com>
Date: Mon, 24 Oct 2011 11:13:52 -0500
From: Kyle Manna <kyle.manna@fuel7.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 6/6] mfd: TPS65910: Improve regulator init data
References: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com> <1318962388-26151-7-git-send-email-kyle.manna@fuel7.com> <20111019140027.GH18713@sirena.org.uk>
In-Reply-To: <20111019140027.GH18713@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2011 09:00 AM, Mark Brown wrote:
> On Tue, Oct 18, 2011 at 01:26:28PM -0500, Kyle Manna wrote:
>> Improve the interface between platform code/board files to the TPS65910
> Again, *always* CC maintainers on patches.

This was an oversight on my part.

>
>> regulators.  The TWL4030/6030 code was used as an example interface.
> This isn't a good sign...

I've reviewed other PMICs (ie Wolfson Micro ;) ) and will post an 
updated series with an interface similar to what is used there.  The new 
approach makes more sense and keeps the code/patch small.

>
>> This improved interface will allow use of the regulators without
>> specifying all the constraints. Also gets rid of an assumption that
>> the platform pass in an array of correct size and was unchecked.
> You've not described the changes between the two interfaces.  Note that
> empty constraints should be absolutely fine with the API.
>
>> +	if (init_data->constraints.name)
>> +		pmic->desc[i].name = init_data->constraints.name;
>> +	else
>> +		pmic->desc[i].name = info[i].name;
> No, this is broken.  The name of the regulator is a fixed property of
> the device and isn't something that ought to be overridden per system.

Understood.

>
>> +	/* TPS65910 and TPS65911 Regulators */
>> +	rdev = add_regulator(pmic, info, TPS65910_REG_VRTC,
>> +			pmic_plat_data->vrtc);
>> +	if (IS_ERR(rdev))
>> +		return PTR_ERR(rdev);
>> +	rdev = add_regulator(pmic, info, TPS65910_REG_VIO,
>> +			pmic_plat_data->vio);
>> +
>> +	if (IS_ERR(rdev))
>> +		return PTR_ERR(rdev);
>> +
>> +	rdev = add_regulator(pmic, info, TPS65910_REG_VDD1,
>> +			pmic_plat_data->vdd1);
>> +	if (IS_ERR(rdev))
>> +		return PTR_ERR(rdev);
> This looks like a regression - we've gone from looping over an array
> which is nice and simple to explicit code for each individual regulator
> giving us lots of repetitive code...

Will be revised.
>> -err_unregister_regulator:
>> -	while (--i>= 0)
>> -		regulator_unregister(pmic->rdev[i]);
>> -	kfree(pmic->rdev);
> ...and loosing all our cleanup if things go wrong which isn't great
> either.

