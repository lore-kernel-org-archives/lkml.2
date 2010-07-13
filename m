Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0GMBSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:18:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39239 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab0GMBST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=lSzGmwTF+WQWT8Z5ukpkFmNayjqb9F7KfxmORoOQGKVI74sZkC4ZVO2DsGtTmDfkXm
         6lspHms7qQFeeZ9RuuO57oLBgm5LAmiz6rbqKfUPYMofK0Ie6Vw4xXZCDxS9jJpxp5rh
         hYTao7wNVqv/z3c7MQG5ru3skGUfLgopDK0Bs=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100712124904.d05242d2.akpm@linux-foundation.org>
References: <1278672607.1335.3.camel@mola> <20100712124904.d05242d2.akpm@linux-foundation.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 13 Jul 2010 09:17:58 +0800
Message-ID: <AANLkTik3qDmpRS9HwFFzCfyHMrUd9ZnaR1A39jUo0cbt@mail.gmail.com>
Subject: Re: [PATCH] edd: fix possible memory leak in edd_init() error path
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        David Teigland <teigland@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "Hans J. Koch" <hjk@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/13 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 09 Jul 2010 18:50:07 +0800
> Axel Lin <axel.lin@gmail.com> wrote:
>
>> The error may happen at any iteration of the for loop,
>> this patch properly unregisters already registed edd_devices in error path.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/firmware/edd.c |   23 ++++++++++++++++-------
>>  1 files changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
>> index 110e24e..b75082c 100644
>> --- a/drivers/firmware/edd.c
>> +++ b/drivers/firmware/edd.c
>> @@ -744,7 +744,7 @@ static inline int edd_num_devices(void)
>>  static int __init
>>  edd_init(void)
>>  {
>> -     unsigned int i;
>> +     int i;
>>       int rc=0;
>>       struct edd_device *edev;
>>
>> @@ -760,21 +760,30 @@ edd_init(void)
>>       if (!edd_kset)
>>               return -ENOMEM;
>>
>> -     for (i = 0; i < edd_num_devices() && !rc; i++) {
>> +     for (i = 0; i < edd_num_devices(); i++) {
>>               edev = kzalloc(sizeof (*edev), GFP_KERNEL);
>> -             if (!edev)
>> -                     return -ENOMEM;
>> +             if (!edev) {
>> +                     rc = -ENOMEM;
>> +                     goto out;
>> +             }
>>
>>               rc = edd_device_register(edev, i);
>>               if (rc) {
>>                       kfree(edev);
>> -                     break;
>> +                     goto out;
>>               }
>>               edd_devices[i] = edev;
>>       }
>>
>> -     if (rc)
>> -             kset_unregister(edd_kset);
>> +     return 0;
>> +
>> +out:
>> +     while (--i >= 0) {
>> +             edev = edd_devices[i];
>> +             if (edev)
>
> This test is unneeded?

right. a revised version is on the way.

Regards,
Axel

>
>> +                     edd_device_unregister(edev);
>> +     }
>> +     kset_unregister(edd_kset);
>>       return rc;
>>  }
>
>
