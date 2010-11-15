Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0KOOZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:25:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48759 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab0KOOZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:25:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ox2Y+nsHf0hGxe9GLWlYcGdNxc/lCQkPNsDE1mWl9jHciX+c63uhiN++UDBvKIOoko
         IRQNfw9iNi5/ipZdONZMe+sA3k3X2B7YXpiVtgUxuonY4h8OhoLqHTOILjxRSdT/cRfL
         wenixdUGjheuZZMuorDVWWdTnpZ7hpkpHb+qI=
Message-ID: <4CE142B8.4090602@suse.cz>
Date: Mon, 15 Nov 2010 15:24:56 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il> <4CE0FE71.6000303@suse.cz> <20101115100838.GA3649@jasper.tkos.co.il> <4CE10B32.8090705@suse.cz> <20101115134025.GB3649@jasper.tkos.co.il>
In-Reply-To: <20101115134025.GB3649@jasper.tkos.co.il>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 02:40 PM, Baruch Siach wrote:
> On Mon, Nov 15, 2010 at 11:28:02AM +0100, Jiri Slaby wrote:
>> On 11/15/2010 11:08 AM, Baruch Siach wrote:
>>> Thanks for reviewing. See my response to your comments below.
>>>
>>> On Mon, Nov 15, 2010 at 10:33:37AM +0100, Jiri Slaby wrote:
>>>> On 11/15/2010 09:23 AM, Baruch Siach wrote:
>>>>> --- /dev/null
>>>>> +++ b/drivers/misc/altera_as.c
>>>>> @@ -0,0 +1,349 @@
>>>> ...
>>>>> +struct altera_as_device {
>>>>> +	unsigned id;
>>>>> +	struct device *dev;
>>>>> +	struct miscdevice miscdev;
>>>>> +	struct mutex open_lock;
>>>>> +	struct gpio gpios[AS_GPIO_NUM];
>>>>> +};
>>>>> +
>>>>> +/*
>>>>> + * The only functions updating this array are .probe/.remove, which are
>>>>> + * serialized. Hence, no locking is needed here.
>>>>> + */
>>>>> +static struct {
>>>>> +	int minor;
>>>>
>>>> Why you need minor here? It's in drvdata->miscdev.minor.
>>>
>>> I use the minor field to lookup the drvdata pointer in get_as_dev(), which I 
>>> use is altera_as_open().  I do this because I have no access to the 'struct 
>>> device' pointer from the .open method. Do you know a better way?
>>>
>>>>> +	struct altera_as_device *drvdata;
>>>>> +} altera_as_devs[AS_MAX_DEVS];
>>>>
>>>> You don't need the struct at all.
>>>> static struct altera_as_device *drvdata[AS_MAX_DEVS];
>>>> should be enough.
>>>
>>> See above.
>>
>> The answer to you previous question is here. You can just have a global
>> array of struct altera_as_device.
> 
> This static array would occupy sizeof(struct altera_as_device) * AS_MAX_DEVS 
> == 128 (for 32bit) * 16 == 2KB unconditionally.

No, it is an array of pointers.

>>>>> +static int __init altera_as_probe(struct platform_device *pdev)
>>>>> +{
>>>> ...
>>>>> +	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
>>>>> +	drvdata->miscdev.name = kasprintf(GFP_KERNEL, "altera_as%d",
>>>>> +			pdata->id);
>>>>> +	if (drvdata->miscdev.name == NULL)
>>>>> +		return -ENOMEM;
>>>>> +	drvdata->miscdev.fops = &altera_as_fops;
>>>>> +	if (misc_register(&drvdata->miscdev) < 0) {
>>>>
>>>> Hmm, how many devices can be in the system?
>>>
>>> Up to AS_MAX_DEVS, currently 16.
>>>
>>>> This doesn't look like the right way.
>>>
>>> What is the right way then?
>>
>> Ok, so for that count it definitely deserves its own major to not eat up
>> misc device space.
> 
> A previous version of this driver[1] did just that. It was Greg KH who 
> suggested[2] to use the misc class.
> 
> [1] http://article.gmane.org/gmane.linux.kernel/1057434
> [2] http://article.gmane.org/gmane.linux.kernel/1058627

Ok, citing in-place:
<cite1>
Please don't create your own class just for a single driver.  Just use
the misc class interface instead, as all you really want/need here is a
character device node, right?
</cite1>

The "miscdevice" is intended for people who want only a single device
per system (singleton) and it is designed that way. There can be only up
to 64 dynamic minors. Here you allow up to 16 devices out of box...

<cite2>
And as discussed at the Plumbers conference this past week, we don't
want to add any new 'struct class' implementations to the kernel from
now on, as it's the overall wrong thing to do.
</cite2>

Well, how do people notify udev about their character devices then? Any
pointers to the discussion?

>>>>> +		kfree(drvdata->miscdev.name);
>>>>> +		return -ENODEV;
>>>>> +	}
>>>>> +	altera_as_devs[pdata->id].minor = drvdata->miscdev.minor;
>>>>> +	altera_as_devs[pdata->id].drvdata = drvdata;
>>>>
>>>> So now the device is usable without the mutex and gpios inited?
>>>
>>> I was thinking that the device lock which is being held during the .probe run, 
>>> prevents the device from being open. After all I can still return -EGOAWAY at 
>>> this point. Am I wrong?
>>>
>>> If so, I'll reorder this code.
>>
>> This cannot be done easily. You need to set drvdata prior to minor and
>> after all the assignments here. The former because in get_as_dev you
>> test minor and return drvdata.
> 
> When drvdata is not set it contains NULL. The .open method then just returns 
> -ENODEV. So moving the drvdata assignment to the end of .probe should plug all 
> race scenarios without any additional locking, isn't it?

How do you ensure gpios and drvdata to be in the memory before minor?
(Compilers and processors may reorder.)

regards,
-- 
js
suse labs
