Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1DLTNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:13:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54616 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab1DLTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:13:22 -0400
Message-ID: <4DA4A44D.5020208@linaro.org>
Date: Tue, 12 Apr 2011 13:13:17 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ohad@wizery.com, lee.jones@linaro.org, patches@linaro.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 1/2] ux500: Adding support for u8500 Hsem functionality
 V2
References: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org> <201104121946.01618.arnd@arndb.de>
In-Reply-To: <201104121946.01618.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-12 11:46 AM, Arnd Bergmann wrote:
> On Monday 11 April 2011, mathieu.poirier@linaro.org wrote:
>> From: Mathieu J. Poirier<mathieu.poirier@linaro.org>
>>
>> This is the second spin on STE's Hsem driver that is implemented
>> through the hwspinlock scheme.  More specifically:
>>
>>   More comments have been added in the code.
>>   Cleanup of included header files.
>>   One of the original contributor's name corrected.
>>   Calls to 'pm_runtime_disable'restored.
>>
>> Signed-off-by: Mathieu Poirier<mathieu.poirier@linaro.org>
> Looks very nice overall, just a few small details I noticed:
>
>> +
>> +#define HSEM_REGISTER_OFFSET		0x08
>> +
>> +#define HSEM_CTRL_REG			0x00
>> +#define HSEM_ICRALL			0x90
>> +#define HSEM_PROTOCOL_1			0x01
>> +
>> +#define to_u8500_hsem(lock)	\
>> +	container_of(lock, struct u8500_hsem, lock)
>> +
>> +struct u8500_hsem {
>> +	struct hwspinlock lock;
>> +	void __iomem *addr;
>> +};
> It seems inconsistent to name it sem instead of spinlock.
>
This is a good point and I've been going back and forth on that one.  
TI's implementation is based on 'spinlock' but in this case there is not 
a single mention of a 'spinlock' in the CPU's reference manual, leaving 
potential users to wonder if spinlock == hsem.  I think using 'hsem' 
makes more sense here.
>> +struct u8500_hsem_state {
>> +	void __iomem *io_base;		/* Mapped base address */
>> +};
> If you make that one data structure, you only need a single allocation:
>
> struct u8500_hsem_state {
> 	void __iomem *io_base;
> 	struct u8500_hsem hsem[U8500_MAX_SEMAPHORE];
> }
I don't see the real advantage in doing a single allocation - the 
dynamic allocation method is also used in 'omap_hwspinlock.c'.  Is 
modification mandatory to get the driver accepted ?
>> +
>> +	for (i = 0; i<  U8500_MAX_SEMAPHORE; i++) {
>> +		u8500_lock = kzalloc(sizeof(*u8500_lock), GFP_KERNEL);
>> +		if (!u8500_lock) {
>> +			ret = -ENOMEM;
>> +			goto free_locks;
>> +		}
>> +
>> +		u8500_lock->lock.dev =&pdev->dev;
>> +		u8500_lock->lock.owner = THIS_MODULE;
>> +		u8500_lock->lock.id = i;
>> +		u8500_lock->lock.ops =&u8500_hwspinlock_ops;
>> +		u8500_lock->addr = io_base + offset + sizeof(u32) * i;
>> +
>> +		ret = hwspin_lock_register(&u8500_lock->lock);
>> +		if (ret) {
>> +			kfree(u8500_lock);
>> +			goto free_locks;
>> +		}
>> +	}
> When you do that, this can be a single allocation.
If you don't mind, I will let Ohad and friends deal with the API 
improvement.

> Thinking about it some more, it may actually be worthwhile to still improve
> the API here: I think the owner field should be part of the operations structure,
> because it is constant. It would also be nice to have a "private" pointer
> in struct hwspinlock, so you don't need to wrap it if you don't want to.
>
> Finally, the hwspin_lock_register could take the specific values as arguments
> instead of requiring you to fill it out first.
>
> 	Arnd
>
Thanks for the review,
Mathieu.

