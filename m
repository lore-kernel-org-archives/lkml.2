Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0KOK2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:28:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36550 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab0KOK2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:28:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=h4pJN8Wo2DTaZlS996Jn+BlHlyFS4ObMRk4Bi9KyVk+f6p2RhCKRBbRELiPvjuOml8
         Z7qnN588KKFsKNuiuBkvzAAX/YZBPCbp4HTIGxL9Y8k8HpGQI73AHYouEgrNTQtHmUiH
         sIiuj9PjYr8lW0NfbHdY5++m+ZAt7FOROCirk=
Message-ID: <4CE10B32.8090705@suse.cz>
Date: Mon, 15 Nov 2010 11:28:02 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il> <4CE0FE71.6000303@suse.cz> <20101115100838.GA3649@jasper.tkos.co.il>
In-Reply-To: <20101115100838.GA3649@jasper.tkos.co.il>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 11:08 AM, Baruch Siach wrote:
> Hi Jiri,
> 
> Thanks for reviewing. See my response to your comments below.
> 
> On Mon, Nov 15, 2010 at 10:33:37AM +0100, Jiri Slaby wrote:
>> On 11/15/2010 09:23 AM, Baruch Siach wrote:
>>> --- /dev/null
>>> +++ b/drivers/misc/altera_as.c
>>> @@ -0,0 +1,349 @@
>> ...
>>> +struct altera_as_device {
>>> +	unsigned id;
>>> +	struct device *dev;
>>> +	struct miscdevice miscdev;
>>> +	struct mutex open_lock;
>>> +	struct gpio gpios[AS_GPIO_NUM];
>>> +};
>>> +
>>> +/*
>>> + * The only functions updating this array are .probe/.remove, which are
>>> + * serialized. Hence, no locking is needed here.
>>> + */
>>> +static struct {
>>> +	int minor;
>>
>> Why you need minor here? It's in drvdata->miscdev.minor.
> 
> I use the minor field to lookup the drvdata pointer in get_as_dev(), which I 
> use is altera_as_open().  I do this because I have no access to the 'struct 
> device' pointer from the .open method. Do you know a better way?
> 
>>> +	struct altera_as_device *drvdata;
>>> +} altera_as_devs[AS_MAX_DEVS];
>>
>> You don't need the struct at all.
>> static struct altera_as_device *drvdata[AS_MAX_DEVS];
>> should be enough.
> 
> See above.

The answer to you previous question is here. You can just have a global
array of struct altera_as_device.

>>> +static int altera_as_open(struct inode *inode, struct file *file)
>>> +{
>>> +	int ret;
>>> +	struct altera_as_device *drvdata = get_as_dev(iminor(inode));
>>> +
>>> +	if (drvdata == NULL)
>>> +		return -ENODEV;
>>> +	file->private_data = drvdata;
>>> +
>>> +	ret = mutex_trylock(&drvdata->open_lock);
>>> +	if (ret == 0)
>>> +		return -EBUSY;
>>> +
>>> +	ret = gpio_request_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
>>> +	if (ret < 0) {
>>> +		mutex_unlock(&drvdata->open_lock);
>>> +		return ret;
>>> +	}
>>
>> So leaving to userspace with mutex held. This is *wrong*. use
>> test_and_set_bit or alike instead.
> 
> Can you explain why this is wrong? I don't mind doing test_and_set_bit 
> instead, I'm just curious.

The mutex has an owner which it expects to unlock it. For example if you
fork a process which already opened the device, you have a problem. This
is a technical point. Another point is that it's ugly to leave to
userspace with any lock.

>>> +static int __init altera_as_probe(struct platform_device *pdev)
>>> +{
>> ...
>>> +	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
>>> +	drvdata->miscdev.name = kasprintf(GFP_KERNEL, "altera_as%d",
>>> +			pdata->id);
>>> +	if (drvdata->miscdev.name == NULL)
>>> +		return -ENOMEM;
>>> +	drvdata->miscdev.fops = &altera_as_fops;
>>> +	if (misc_register(&drvdata->miscdev) < 0) {
>>
>> Hmm, how many devices can be in the system?
> 
> Up to AS_MAX_DEVS, currently 16.
> 
>> This doesn't look like the right way.
> 
> What is the right way then?

Ok, so for that count it definitely deserves its own major to not eat up
misc device space.

>>> +		kfree(drvdata->miscdev.name);
>>> +		return -ENODEV;
>>> +	}
>>> +	altera_as_devs[pdata->id].minor = drvdata->miscdev.minor;
>>> +	altera_as_devs[pdata->id].drvdata = drvdata;
>>
>> So now the device is usable without the mutex and gpios inited?
> 
> I was thinking that the device lock which is being held during the .probe run, 
> prevents the device from being open. After all I can still return -EGOAWAY at 
> this point. Am I wrong?
> 
> If so, I'll reorder this code.

This cannot be done easily. You need to set drvdata prior to minor and
after all the assignments here. The former because in get_as_dev you
test minor and return drvdata. The latter because you use open_lock &
gpios after playing with minor & drvdata.

Technically, it can be done with a use of barriers, but I don't
recommend it as drivers should not use barriers at all. You should
introduce some locking here (it introduces barriers on its own).

So move the assignment to altera_as_devs below the mutex_init & gpios
setup and lock it appropriately. Then add a lock to get_as_dev.

>>> +	mutex_init(&drvdata->open_lock);
>>> +
>>> +	drvdata->id = pdata->id;
>>> +
>>> +	drvdata->gpios[ASIO_DATA].gpio		= pdata->data;
>>> +	drvdata->gpios[ASIO_DATA].flags		= GPIOF_IN;
>>> +	drvdata->gpios[ASIO_DATA].label		= "as_data";
>> ...
>>> +	drvdata->gpios[ASIO_NCE].gpio		= pdata->nce;
>>> +	drvdata->gpios[ASIO_NCE].flags		= GPIOF_OUT_INIT_HIGH;
>>> +	drvdata->gpios[ASIO_NCE].label		= "as_nce";
>>> +
>>> +	dev_info(drvdata->dev, "Altera Cyclone Active Serial driver\n");
>>> +
>>> +	return 0;
>>> +}

regards,
-- 
js
suse labs
