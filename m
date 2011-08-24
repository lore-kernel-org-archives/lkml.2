Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1HXNjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:39:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:59395 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1HXNjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:39:09 -0400
Message-ID: <4E54FEF4.1010109@windriver.com>
Date: Wed, 24 Aug 2011 09:39:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] video: ep93xx-fb: add missing include of linux/module.h
References: <1313937545.13671.5.camel@phoenix> <4E5197B8.8020608@gmail.com> <4E519AC7.3030001@gmail.com> <CAF+7xWkezyMrnt-_0EVtNWtAB2v7pceATB8HEbdC8oqOY0camw@mail.gmail.com> <4E51A34C.6060207@gmail.com> <ADE657CA350FB648AAC2C43247A983F001F388575258@AUSP01VMBX24.collaborationhost.net> <4E52EAB3.4090201@gmail.com>
In-Reply-To: <4E52EAB3.4090201@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-22 07:48 PM, Ryan Mallon wrote:
> On 23/08/11 02:40, H Hartley Sweeten wrote:
>> On Sunday, August 21, 2011 5:31 PM, Ryan Mallon wrote:
>>> On 22/08/11 10:06, Axel Lin wrote:
>>>> 2011/8/22 Ryan Mallon<rmallon@gmail.com>:
>>>>> On 22/08/11 09:41, Ryan Mallon wrote:
>>>>>> On 22/08/11 00:39, Axel Lin wrote:
>>>>>>> ep93xx-fb.c uses interfaces from linux/module.h,
>>>>>>> so it should include that file.  This patch fixes below build errors.
>>>>>> What actually changed to make these files broken? Did some other header
>>>>>> previously include module.h for us? How many other drivers are broken?
>>>>>>
>>>>>> Anyway, the change is okay.
>>>>>>
>>>>>> Acked-by: Ryan Mallon<rmallon@gmail.com>
>>>>> Actually, having a second look at this it does not look right.
>>>>>
>>>>> drivers/video/ep93xx-fb.c includes linux/platform.h (as its first include),
>>>>> which includes linux/driver.h, which includes linux/module.h.

For the record, this is exactly what we are trying to fix -- relying on
implicit and non-obvious include chaining.  If you are writing a modular
driver, you should include module.h explicitly.

>>>>>
>>>>> Just tested on Linus' latest tree and both this driver and the ep93xx
>>>>> backlight driver build fine. What kernel version are you using?
>>>>>
>>>>> ~Ryan
>>>> hi Ryan,
>>>>
>>>> The patch is against linux-next tree.
>>>> I got build error for ep93xx-fb.c and ep93xx_bl.c on linux-next tree.
>>>> ( next-20110819 )
>>> Ok, I see now. The change which caused the breakage is fdb697c:
>>> "include: replace linux/module.h with "struct module" wherever
>>> possible". How many other drivers got broken now that device.h does not
>>> include module.h?
>> Probably a lot...  Which is one of the reasons linux-next exists.. . ;-)
> 
> Does anybody know how we can quickly determine which drivers are broken 
> short of doing an allyesconfig? I tried to do some quick tricks by 
> passing files which contain THIS_MODULE/MODULE_* through cpp, but I get 
> loads of errors in headers files because I'm missing some config 
> includes. Is there an easy way to get the kbuild arguments for the 
> current .config so I can pass them to cpp?
> 
>> Actually, Paul Gortmaker caused this breakage with the commit.  He should
>> take a deeper look and see what it broke.  From his commit:
>>
>>      Most of the implicit dependencies on module.h being present by
>>      these headers pulling it in have been now weeded out, so we can
>>      finally make this change with hopefully minimal breakage.
> 
> Quick glance:
> 
> ryanm@kiwi:linux-2.6$ grep -lR "^MODULE_" drivers/  | xargs grep -L 
> "linux/module.h\|linux/moduleloader.h\|linux/miscdevice.h\|linux/regmap.h\|linux/irq.h"  
> | wc -l
> 579

This can be misleading because subsystems may have a common header that
includes module.h, and then all the C files include that common header.
I think the e1000 network driver is one example.

> 
> ryanm@kiwi:linux-2.6$ grep -lR "THIS_MODULE" drivers/ | xargs grep -L 
> "linux/module.h\|linux/moduleloader.h\|linux/miscdevice.h\|linux/regmap.h\|linux/irq.h\|linux/export.h\|acpi/platform/aclinux.h\|xen/xenbus.h"   
> | wc -l
> 399
> 
> Not sure how many of those are really broken though since there may be a 
> few other ways to include module.h/export.h. I would also think there 
> would be a lot more build failure reports if all of those were broken :-).

Exactly.  I've done allyesconfig, allnoconfig, allmodconfig builds for all
the common arch and even half a dozen or so uncommon arch.  Plus in the case
of things like arm and powerpc with board specific config files that are in
arch/*/configs, I've built all those.  So a couple of odd cases like this
which don't get build coverage through any of the above was expected, and
hence the value of being in linux-next for a while.

Thanks all for the report, I'll make sure these files get the proper
include header they need.

Paul.

> 
> ~Ryan
> 
> 
> 
