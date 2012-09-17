Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab2IQT6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 15:58:18 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58257 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2IQT6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 15:58:16 -0400
Message-ID: <505780D6.3020500@kernel.org>
Date: Mon, 17 Sep 2012 20:58:14 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: inkern: put the IIO device when mem alloc gets
 failed
References: <A874F61F95741C4A9BA573A70FE3998F41EF50A5@DQHE02.ent.ti.com> <5056EE95.6050101@metafoo.de> <A874F61F95741C4A9BA573A70FE3998F41EF5120@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF5120@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 10:57 AM, Kim, Milo wrote:
>>>  drivers/iio/inkern.c |    5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
>>> index 13748c0..aff034b 100644
>>> --- a/drivers/iio/inkern.c
>>> +++ b/drivers/iio/inkern.c
>>> @@ -132,7 +132,7 @@ struct iio_channel *iio_channel_get(const char
>> *name, const char *channel_name)
>>>
>>>  	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
>>>  	if (channel == NULL)
>>> -		return ERR_PTR(-ENOMEM);
>>> +		goto error_no_mem;
>>>
>>>  	channel->indio_dev = c->indio_dev;
>>>
>>> @@ -151,6 +151,9 @@ error_no_chan:
>>>  	iio_device_put(c->indio_dev);
>>>  	kfree(channel);
>>>  	return ERR_PTR(-EINVAL);
>>> +error_no_mem:
>>> +	iio_device_put(c->indio_dev);
>>> +	return ERR_PTR(-ENOMEM);
>>>  }
>>>  EXPORT_SYMBOL_GPL(iio_channel_get);
>>>
>>
>> If you do it that way, you don't really need the goto, something like
>>
>> error_no_chan:
>>   	kfree(channel);
>> error_no_mem:
>> 	iio_device_put(c->indio_dev);
>> 	return ret
>>
>> would be better in my opinion. With ret being initialized in the if
>> branch
>> before the goto.
> 
> Thanks for your opinion. I was hesitating before sending ;) 
> 
> The reason why this patch need separate goto statement is as below.
>  
> There are two different types when requesting the channel.
> One is a pointer of iio_channel, the other is the error.
> So return type will be two - allocated iio_channel and integer.
> For simplicity, I would use just one return variable when it runs successfully.
> In error cases, do return as explicit name such like ERR_PTR() rather than
> saving into local integer.
> 
I can see your point, but Lars-Peter's way is the more commonly used approach
so lets go with the ancient arguement of making it look like what those
reading the code expect to see ;)

> Just my two cents.
> But your code has better readability.
> 
> Thank you.
> 
> Best Regards,
> Milo
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
