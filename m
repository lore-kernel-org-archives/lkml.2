Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0LTW1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:27:42 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27683 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0LTW1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:27:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67617739"
Message-ID: <4D0FD85C.1020307@codeaurora.org>
Date: Mon, 20 Dec 2010 14:27:40 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Update consumer state only after set voltage
 succeeds.
References: <1292625868-26862-1-git-send-email-skannan@codeaurora.org> <20101220123903.GE26706@rakim.wolfsonmicro.main>
In-Reply-To: <20101220123903.GE26706@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/10 04:39, Mark Brown wrote:
> On Fri, Dec 17, 2010 at 02:44:28PM -0800, Saravana Kannan wrote:
>
>>   static int regulator_check_consumers(struct regulator_dev *rdev,
>> +				     struct regulator *ignore,
>>   				     int *min_uV, int *max_uV)
>
> This feels really invasive, and prone to robustness issues as we're just
> randomly not checking one of the consumers on a single call, meaning we
> skip some checking some of the time.  It's not going to make the code
> more maintainable.

I agree it looks a bit odd and I'm willing to do the code reorg if there 
is a better way. But I definitely wouldn't call this as randomly 
ignoring a consumer. We are just avoiding the consumer that's changing 
the range from "voting twice". We already send the new request thru 
min/max params.

We will also need the option of not including the calling consumer when 
computing the min/max for the next patch. See below.

Do you have any suggestions for a better way to compute the min/max 
while leaving out a single consumer? I'm very much open to do that.

Would something like below be better?

regulator_check_consumers_except(rdev, ignore, min, max)
{
  ...
}

regulator_check_consumers(rdev, min, max)
{
  regulator_check_consumer(rdev, NULL, min, max);
}

>
>> -	regulator->min_uV = min_uV;
>> -	regulator->max_uV = max_uV;
>> -
>> -	ret = regulator_check_consumers(rdev,&min_uV,&max_uV);
>> +	ret = regulator_check_consumers(rdev, regulator,&min_uV,&max_uV);
>>   	if (ret<  0)
>>   		goto out;
>>
>>   	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
>> +	if (!ret) {
>> +		regulator->min_uV = min_uV;
>> +		regulator->max_uV = max_uV;
>> +	}
>
> If you're going to do something probably unwinding the assignment on
> error would cover it.

It would, but the next patch was going to be to optimize out the call to 
the regulator driver if the votes of the calling consumer doesn't make a 
difference. To do that, we will need to compute the voltage range with 
and without the calling consumer's min/max and then figure out if the 
change in the calling consumer's min/max makes a difference.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
