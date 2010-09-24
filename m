Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab0IXQiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:38:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44018 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab0IXQh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p+H50+44FK+BbwszYPtr8VULDvLGyQQgnJ1tvuZ2NM9gr5vyjhiNRoMXapXrDtpJdv
         BMTUAV4WX4T2pe6SfEUxavuYTvPs3CGEnjf35gpMTZ9uMA/rHHfTcxvI6rfGlBbuOz4y
         mSmZ2nJ6oUdbANUo38p+CrgXCbCskjm77x6U0=
Message-ID: <4C9CD3E0.6060000@gmail.com>
Date: Fri, 24 Sep 2010 19:37:52 +0300
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Darius Augulis <augulis.darius@gmail.com>
CC: Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [RESEND PATCH] serial: samsung: fix device name
References: <20100923190212.18863.25678.stgit@darius-desktop>	<4C9BE577.4050504@fluff.org> <AANLkTi=S8v19iT1DC=6Nh9BEgRvKzyzKTKoJmS0Bw1Fb@mail.gmail.com>
In-Reply-To: <AANLkTi=S8v19iT1DC=6Nh9BEgRvKzyzKTKoJmS0Bw1Fb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 09:57 AM, Darius Augulis wrote:
> Hi,
>
> On Fri, Sep 24, 2010 at 2:40 AM, Ben Dooks<ben-linux@fluff.org>  wrote:
>> On 23/09/10 20:15, Darius Augulis wrote:
>>> Swap device and driver names in serial/samsung.c
>>
>> This is far too short, please see the notes below on trying
>> to make this more informative.
>>
>>> Signed-off-by: Darius Augulis<augulis.darius@gmail.com>
>>> ---
>>>
>>> This patch was submitted about 3 months ago, but still not merged.
>>> There was another similar patch from Joonyoung Shim
>>> <jy0922.shim@samsung.com>  and was discussed here:
>>> http://marc.info/?l=linux-serial&m=127416101222281&w=2.
>>> Joonyoung Shim acked my patch and other people on ARM mailing list
>>> acked it. The maintainer, Ben Dooks, still not responding for
>>> a long time. Another maintainer, Kukjin Kim, refused to merge
>>> it without Ben's review.
>>> I would like to ask somebody pick up this bugfix.
>>
>> I belive last time this was brought up I asked about the affect
>> this has on the userspace. The following issues would be helpful
>> or essential to have noted in the header about the effect of this.
>>
>> - Does it change the /dev name of the device? if so I would thinl
>>   carefully about applying it, as it would be a change in the way
>>   that userspace sees the kernel.
>
> It does - now devices are named /dev/s3c2410_serial, and patch changes
> its name to /dev/ttySAC
>
>>
>> - Does it change the kernel output itself? A note on what diffeences
>>   can be seen in things like dmesg would be helpful.
>
> It does. Serial driver reports device names when probing, so there
> will appear ttySACx instead of
> s3c2410_serialx.
>
>>
>> - Are there any other side effects
>>
>> - Why is this a bug? Maybe the previous points will explain what is
>>   going on, but if not, then a reasonably concise description of
>>   what is going on here.
>
> This is bug, because of several points:
>
> 1. Because it contradicts kernel documentation. Please read
> Documentation/arm/Samsung-S3C24XX/Overview.txt line 196.
> This should be enough to apply this patch.
>
> 2. Because s3c2410_serial isn't correct name for serial device node.
> It's name of Samsung serial driver.
>
> 3. Because now almost all userspace systems workaround it by creating symlink
> /dev/ttySACx>  /dev/s3c2410_serialx and only then put some getty on
> created symlink, not on original device.
> Systems which don't create this symlink, fail to boot at all, because
> of wrong console name. Good example is Buildroot.

I had similar issue with buildroot too, because in /etc/securetty it is
defained as ttySAC0

4. For console in kernel boot command line you must enter console=ttySACx.
Why it sould be different in userspace?

For me it seems taht this bug was not noticed earlier, because most embedded
systems were using static device nodes and ttySACx was used in these cases.
	
>>
>>>   drivers/serial/samsung.c |    4 ++--
>>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
>>> index b1156ba..25c0d0f 100644
>>> --- a/drivers/serial/samsung.c
>>> +++ b/drivers/serial/samsung.c
>>> @@ -883,10 +883,10 @@ static struct uart_ops s3c24xx_serial_ops = {
>>>
>>>   static struct uart_driver s3c24xx_uart_drv = {
>>>        .owner          = THIS_MODULE,
>>> -     .dev_name       = "s3c2410_serial",
>>> +     .driver_name    = "s3c2410_serial",
>>>        .nr             = CONFIG_SERIAL_SAMSUNG_UARTS,
>>>        .cons           = S3C24XX_SERIAL_CONSOLE,
>>> -     .driver_name    = S3C24XX_SERIAL_NAME,
>>> +     .dev_name       = S3C24XX_SERIAL_NAME,
>>>        .major          = S3C24XX_SERIAL_MAJOR,
>>>        .minor          = S3C24XX_SERIAL_MINOR,
>>>   };
>>>
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>>
>

