Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532Ab2LHTRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 14:17:34 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5422 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965519Ab2LHTRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 14:17:33 -0500
Message-ID: <50C3924B.1050300@cavium.com>
Date: Sat, 08 Dec 2012 11:17:31 -0800
From: Aaron Williams <Aaron.Williams@cavium.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        "Williams, Aaron" <Aaron.Williams@caviumnetworks.com>
Subject: Re: Incrementing module reference count
References: <50C2947F.5030706@cavium.com> <20121208114453.GC11662@liondog.tnic>
In-Reply-To: <20121208114453.GC11662@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2012 19:17:32.0745 (UTC) FILETIME=[AC51DB90:01CDD578]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2012 03:44 AM, Borislav Petkov wrote:
> On Fri, Dec 07, 2012 at 05:14:39PM -0800, Aaron Williams wrote:
>> Hi,
>>
>> I have a kernel module which other modules register with in order to
>> export access functions. So far I have everything working but I want
>> to prevent a module that is registered with my module from unloading
>> since now my module is dependent on the other module.
>>
>> Is there a way I can cause the reference count of the module
>> registering with my module to increase? I tried calling get_device
>> with the device structure of the module that is registering but that
>> does not seem to work.
>>
>> For example, I have the following function:
>>
>> /**
>>  * Adds a mapping of a device node to a memory accessor
>>  *
>>  * @param[in] dev - device
>>  * @param[in] macc - memory accessor
>>  *
>>  * @returns 0 for success or -ENOMEM
>>  */
>> int of_memory_accessor_register(struct device *dev,
>>                 struct memory_accessor *macc)
>> {
>>     struct of_macc_entry *mentry;
>>
>>     mentry = kmalloc(sizeof(*mentry), GFP_KERNEL);
>>     if (mentry == NULL)
>>         return -ENOMEM;
>>
>>     mentry->dev = dev;
>>     mentry->macc = macc;
>>
>>     mutex_lock(&lock);
>>
>>     get_device(dev);
>>     list_add(&(mentry->list), &macc_list);
>>
>>     mutex_unlock(&lock);
>>
>>     return 0;
>> }
>> EXPORT_SYMBOL(of_memory_accessor_register);
>>
>> Basically my module is used for things like serial EEPROMs and
>> whatnot so that external modules can find the accessor functions
>> based on the device tree. In my case I am updating the Vitesse
>> VSC848X driver so that it can read the SFP module when it is plugged
>> in using the AT24 I2C EEPROM module. I want to prevent the at24
>> module from unloading while other modules in turn are using it. The
>> at24 module does not export any symbols.
> From a quick code scan, at24 has this:
>
> 	static struct i2c_driver at24_driver = {
> 	        .driver = {
> 	                .name = "at24",
> 	                .owner = THIS_MODULE,
> 	        },
> 	        .probe = at24_probe,
> 	        .remove = __devexit_p(at24_remove),
> 	        .id_table = at24_ids,
> 	};
>
> and then you could do:
>
> 	try_module_get(at24_driver.driver->owner);
>
> from your code. AFAICT, of course.
>
> HTH.
Thank you.

try_module_get is what I needed.

I got it working. I designed my solution to be generic so it's not tied
to just the at24 driver. I added a memory accessor module which is
basically a registry. The at24 driver registers with it and then the
Vitesse PHY driver calls it to gain access to the at24 driver. Only when
the Vitesse driver gets the memory accessor the reference count for the
at24 driver is incremented.

My solution can work with any module that provides memory accessor
functions.

I still have some cleanup to do since my work was done with an older 2.6
kernel.

-Aaron

