Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab0HHPBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:01:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53170 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0HHPBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V8BCH8a8zyYDGBt7bmTTsi/C9MkYyNjaUYqkmdeLiQUbdE84zs1K8QR0kLQBdfepY2
         4Mj1VD89EwUd0MNXAFCE/VBn7amd0wmxQYbAnI5aSQ2+MYxzKJGkWjslz5N0PVUD2lic
         IrYxZMRL2OOOKvkGB16CCjU9H5SHEauL0Z8cg=
MIME-Version: 1.0
In-Reply-To: <201008081658.19790.arnd@arndb.de>
References: <AANLkTi=G9+wqWhJmX7QarQXeSw-8qASXMrz6mKvbBNw2@mail.gmail.com>
	<201008081658.19790.arnd@arndb.de>
Date: Sun, 8 Aug 2010 16:01:29 +0100
Message-ID: <AANLkTi=Fhjx4p00N_-6392hAG7=B0FqApedLj2sriKvL@mail.gmail.com>
Subject: Re: [2.6.35 patch] add missing unlock_kernel calls...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Roger Lucas <vt8231@hiddenengine.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2010 15:58, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 08 August 2010, Daniel J Blueman wrote:
>> Hi Roger,
>>
>> Here is a fix for 2.6.36-rc1:
>>
>> Ensure the BKL is dropped along all paths.
>>
>> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>>
>> diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
>> index c24d2fa..53263e7 100644
>> --- a/drivers/hid/usbhid/hiddev.c
>> +++ b/drivers/hid/usbhid/hiddev.c
>> @@ -271,16 +271,18 @@ static int hiddev_open(struct inode *inode,
>> struct file *file)
>>       lock_kernel();
>>       i = iminor(inode) - HIDDEV_MINOR_BASE;
>>
>> -     if (i >= HIDDEV_MINORS || i < 0 || !hiddev_table[i])
>> +     if (i >= HIDDEV_MINORS || i < 0 || !hiddev_table[i]) {
>> +             unlock_kernel();
>>               return -ENODEV;
>> +     }
>>
>> -     if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL)))
>> +     if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL))) {
>> +             unlock_kernel();
>>               return -ENOMEM;
>> -     mutex_init(&list->thread_lock);
>> +     }
>>
>> +     mutex_init(&list->thread_lock);
>>       list->hiddev = hiddev_table[i];
>> -
>> -
>>       file->private_data = list;
>>
>>       /*
>
> This should no longer be needed, since the BKL is not taken
> in this code any more.

All the more better then, thanks to your BKL removal patches.

Thanks,
  Daniel
-- 
Daniel J Blueman
