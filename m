Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab0FKXX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 19:23:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46133 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0FKXXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 19:23:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6010"; a="44206503"
Message-ID: <4C12C567.3060704@codeaurora.org>
Date: Fri, 11 Jun 2010 16:23:19 -0700
From: Greg Bean <gbean@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: akpm@linux-foundation.org, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 2/2] gpio: msm7200a: Add irq support to msm-gpiolib.
References: <1276286332-13515-1-git-send-email-gbean@codeaurora.org>	 <1276286332-13515-3-git-send-email-gbean@codeaurora.org> <1276297949.4134.3.camel@m0nster>
In-Reply-To: <1276297949.4134.3.camel@m0nster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	/*
>> +	 * Under no circumstances should a line be held on a gpiochip
>> +	 * which hasn't finished probing.
>> +	 */
>> +	BUG_ON(gpiochip_remove(&msm_gpio->gpio_chip)<  0);
>> +err_post_malloc:
>
> It looks like some of this should go in the prior patch. Like this
> BUG_ON() above.

I would argue against that.  If you look at the previous patch, you'll 
see that the last thing that probe() does is gpiochip_add, which means 
it never has a need to call gpiochip_remove(), and thus no need to 
complain if gpiochip_remove behaves unexpectedly.

>> @@ -160,12 +360,16 @@ err:
>>   static int msm_gpio_remove(struct platform_device *dev)
>>   {
>>   	struct msm_gpio_dev *msm_gpio = platform_get_drvdata(dev);
>> -	int ret = gpiochip_remove(&msm_gpio->gpio_chip);
>> +	int ret;
>>
>> -	if (ret == 0)
>> -		kfree(msm_gpio);
>> +	ret = gpiochip_remove(&msm_gpio->gpio_chip);
>> +	if (ret<  0)
>> +		return ret;
>>
>> -	return ret;
>> +	free_irq(msm_gpio->irq_summary, msm_gpio);
>> +	kfree(msm_gpio);
>> +
>> +	return 0;
>>   }
>
> Also some of the code here (msm_gpio_remove) seems like it's cleaning up
> the prior patch to some degree. So it should potentially get moved into
> that patch.

Point taken.  There is definitely some stuff in here that is just 
"housecleaning" - I will sort that out.

---
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
