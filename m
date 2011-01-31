Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab1AaVas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:30:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57443 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab1AaVaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:30:46 -0500
MIME-Version: 1.0
In-Reply-To: <of-i2c-doc@mdm.bga.com>
References: <1296487551-30938-3-git-send-email-thomas@wytron.com.tw> <of-i2c-doc@mdm.bga.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 31 Jan 2011 14:29:57 -0700
X-Google-Sender-Auth: V1ZIZz2yGiXJx1PhkM3w7AtJcAE
Message-ID: <AANLkTimoaJKy-WTTHmRXFMmM6=e7uvzhjwRcDtNqGAPj@mail.gmail.com>
Subject: Re: [3/3,v2] i2c-gpio: add devicetree support
To: Milton Miller <miltonm@bga.com>
Cc: Thomas Chou <thomas@wytron.com.tw>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Albert Herranz <albert_herranz@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 2:14 PM, Milton Miller <miltonm@bga.com> wrote:
> On Mon, 31 Jan 2011 about 15:25:51 -0000, Thomas Chou wrote:
>
>> This patch is based on an earlier patch from Albert Herranz,
>> http://git.infradead.org/users/herraa1/gc-linux-2.6.git/commit/
>> 9854eb78607c641ab5ae85bcbe3c9d14ac113733
>>
>> The dts binding is modified as Grant suggested. The of probing
>> is merged inline instead of a separate file. It uses the newer
>> of gpio probe.
>
>> @@ -172,6 +227,8 @@ err_request_sda:
>>  err_alloc_bit_data:
>>       kfree(adap);
>>  err_alloc_adap:
>> +     if (!pdev->dev.platform_data)
>> +             kfree(pdata);
>
> This looks better with the code move to the function above, but
> I don't like the condition on this free here ...
>
>>       return ret;
>>  }
>>
>> @@ -179,23 +236,33 @@ static int __devexit i2c_gpio_remove(struct platform_device *pdev)
>>  {
>>       struct i2c_gpio_platform_data *pdata;
>>       struct i2c_adapter *adap;
>> +     struct i2c_algo_bit_data *bit_data;
>>
>>       adap = platform_get_drvdata(pdev);
>> -     pdata = pdev->dev.platform_data;
>> +     bit_data = adap->algo_data;
>> +     pdata = bit_data->data;
>>
>>       i2c_del_adapter(adap);
>>       gpio_free(pdata->scl_pin);
>>       gpio_free(pdata->sda_pin);
>>       kfree(adap->algo_data);
>>       kfree(adap);
>> +     if (!pdev->dev.platform_data)
>> +             kfree(pdata);
>
> and especially here ... it seems unrelated.
>
> Looking at devices/base/platform.c, how about just allocating the
> initial platform data struct on the stack in i2c_gpio_of_probe
> and then calling platform_device_add_data?  That way the pdev
> is responsible for freeing the data.

No, *do not* use platform_device_add_data().  It stores the pointer in
pdev->dev.platform_data which gets freed when the last reference to
the device is dropped (it gets removed from the bus).  Thomas wants
something that gets freed when the driver is unbound.

Driver code must never modify the pdev->dev.platform_data pointer.
Doing so causes all kinds of lifecycle ambiguity which messes up
driver unbinding/rebinding and module load/unload.  When a driver
needs a modifiable copy of platform data, then it must include a copy
of the platform_data in the driver private data structure.  It should
be straight forward to refactor this driver to do so.

g.
