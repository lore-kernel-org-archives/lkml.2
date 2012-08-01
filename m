Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab2HAIP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 04:15:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5071 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab2HAIPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 04:15:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 01 Aug 2012 01:15:53 -0700
Message-ID: <5018E62C.7010908@nvidia.com>
Date: Wed, 1 Aug 2012 17:17:48 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: add devm_pwm_get() and devm_pwm_put()
References: <1343806629-14397-1-git-send-email-acourbot@nvidia.com> <20120801080453.GJ29673@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20120801080453.GJ29673@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 01 Aug 2012 05:04:53 PM JST, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Wed, Aug 01, 2012 at 04:37:09PM +0900, Alexandre Courbot wrote:
>> Add resource managed variants of pwm_get() and pwm_put() for
>> convenience. Code is largely inspired by the equivalent devm functions
>> of the regulator framework.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>   Documentation/driver-model/devres.txt |  4 +++
>>   Documentation/pwm.txt                 |  5 +--
>>   drivers/pwm/core.c                    | 57 +++++++++++++++++++++++++++++++++++
>>   include/linux/pwm.h                   |  3 ++
>>   4 files changed, 67 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
>> index 950856b..43cff70 100644
>> --- a/Documentation/driver-model/devres.txt
>> +++ b/Documentation/driver-model/devres.txt
>> @@ -284,3 +284,7 @@ CLOCK
>>   PINCTRL
>>     devm_pinctrl_get()
>>     devm_pinctrl_put()
>> +
>> +PWM
>> +  devm_pwm_get()
>> +  devm_pwm_put()
>> diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
>> index 554290e..4719c12 100644
>> --- a/Documentation/pwm.txt
>> +++ b/Documentation/pwm.txt
>> @@ -35,8 +35,9 @@ Using PWMs
>>   Legacy users can request a PWM device using pwm_request() and free it
>>   after usage with pwm_free().
>>
>> -New users should use the pwm_get() function and pass to it the consumer
>> -device or a consumer name. pwm_put() is used to free the PWM device.
>> +New users should use the pwm_get() or devm_pwm_get() function and pass to it the
>> +consumer device or a consumer name. pwm_put() or devm_pwm_put() is used to free
>> +the PWM device.
>
> I think I'd prefer the original text with an additional line mentioning
> the managed variants.
>
>>
>>   After being requested a PWM has to be configured using:
>>
>> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
>> index ecb7690..5a5e19b 100644
>> --- a/drivers/pwm/core.c
>> +++ b/drivers/pwm/core.c
>> @@ -624,6 +624,63 @@ out:
>>   }
>>   EXPORT_SYMBOL_GPL(pwm_put);
>>
>> +static void devm_pwm_release(struct device *dev, void *res)
>> +{
>> +	pwm_put(*(struct pwm_device **)res);
>> +}
>> +
>> +/**
>> + * devm_pwm_get() - Resource managed pwm_get()
>
> This is missing parameter descriptions here.

This is because the documentation for this function just refers to 
pwm_get(), and the parameters are the same. I think it's better to avoid 
duplicating documentation as much as possible as this makes two 
maintenance points instead of one.

>
>> + *
>> + * This works are pwm_get() but the acquired pwm will automatically be released
>
> "works like"? Also "acquired PWM" or "acquired PWM device".

Ooops, yes. I really should proof-read what I write. Twice.

>
>> + * on driver detach. See pwm_get() for more details.
>> + */
>> +struct pwm_device *devm_pwm_get(struct device *dev, const char *consumer)
>> +{
>> +	struct pwm_device **ptr, *pwm;
>> +
>> +	ptr = devres_alloc(devm_pwm_release, sizeof(**ptr), GFP_KERNEL);
>> +	if (!ptr)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	pwm = pwm_get(dev, consumer);
>> +	if (!IS_ERR(pwm)) {
>> +		*ptr = pwm;
>> +		devres_add(dev, ptr);
>> +	} else {
>> +		devres_free(ptr);
>> +	}
>> +
>> +	return pwm;
>> +}
>> +EXPORT_SYMBOL_GPL(devm_pwm_get);
>> +
>> +static int devm_pwm_match(struct device *dev, void *res, void *data)
>> +{
>> +	struct pwm_device **p = res;
>> +
>> +	if (WARN_ON(!p || !*p))
>> +		return 0;
>> +
>> +	return *p == data;
>> +}
>> +
>> +/**
>> + * devm_pwm_put() - Resource managed pwm_put()
>> + *
>> + * Releases a pwm previously allocated using devm_pwm_get. Calling this function
>> + * is usually not needed as the devm-allocated pwm will automatically be
>> + * released on driver detach.
>> + */
>
> Same comments as for devm_pwm_get().
>
>> +void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
>> +{
>> +	int ret;
>> +
>> +	ret = devres_release(dev, devm_pwm_release, devm_pwm_match, pwm);
>> +	WARN_ON(ret);
>> +}
>> +EXPORT_SYMBOL_GPL(devm_pwm_put);
>> +
>>   #ifdef CONFIG_DEBUG_FS
>>   static void pwm_dbg_show(struct pwm_chip *chip, struct seq_file *s)
>>   {
>> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
>> index 21d076c..af9c39a 100644
>> --- a/include/linux/pwm.h
>> +++ b/include/linux/pwm.h
>> @@ -123,7 +123,10 @@ struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
>>   					 const char *label);
>>
>>   struct pwm_device *pwm_get(struct device *dev, const char *consumer);
>> +struct pwm_device *devm_pwm_get(struct device *dev, const char *consumer);
>> +
>>   void pwm_put(struct pwm_device *pwm);
>> +void devm_pwm_put(struct device *dev, struct pwm_device *pwm);
>
> Can the managed variants be grouped together, please?

Sure.

Thanks,
Alex.
