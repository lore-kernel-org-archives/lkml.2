Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1AGPM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:12:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64719 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1AGPM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WM73TNg+7+UZaclxgRBUnsQ94Mvzrc9hqKPViHjhLV4U1wHoJP9GreRfzTUeyvCxQH
         ZQ28IEHhX2iEXoidBmozYMbl1uJnqu+TUknV9y2lAD2zNfQu8pREx8ZcN/dZ0SLNc6ax
         /orEG8UwkHrznzaI3qrtsGPvy1w4dCEkhzcOE=
Message-ID: <4D272D55.3040807@suse.cz>
Date: Fri, 07 Jan 2011 16:12:21 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/36] tty: add 'active' sysfs attribute to tty0 and console
 device
References: <20110106215404.GA30624@kroah.com> <1294352605-31906-34-git-send-email-gregkh@suse.de> <4D26D866.40906@suse.cz> <AANLkTimmtkOhEtRmzFxFS8Z_36Dcys+higaiVJXEr-=7@mail.gmail.com>
In-Reply-To: <AANLkTimmtkOhEtRmzFxFS8Z_36Dcys+higaiVJXEr-=7@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 02:20 PM, Kay Sievers wrote:
> On Fri, Jan 7, 2011 at 10:09, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 01/06/2011 11:23 PM, Greg Kroah-Hartman wrote:
>>> --- a/drivers/tty/tty_io.c
>>> +++ b/drivers/tty/tty_io.c
>>> @@ -3232,9 +3232,45 @@ static int __init tty_class_init(void)
>>>  postcore_initcall(tty_class_init);
>>>
>>>  /* 3/2004 jmc: why do these devices exist? */
>>> -
>>>  static struct cdev tty_cdev, console_cdev;
>>>
>>> +static ssize_t show_cons_active(struct device *dev,
>>> +                             struct device_attribute *attr, char *buf)
>>> +{
>>> +     struct console *cs[16];
>>> +     int i = 0;
>>> +     struct console *c;
>>> +     ssize_t count = 0;
>>> +
>>> +     acquire_console_sem();
>>> +     for (c = console_drivers; c; c = c->next) {
>>
>> This should be:
>> for_each_console(c)
>> like somebody already suggested.
> 
> That's exported now? It was local to printk.c at least that time.
> 
> Anyway, the only sensible change here is to convert that home-grown
> ->next thing to a proper kernel linked list, and use the common
> iterators instead of doing it on our own, or export new custom ones.

Perhaps -- I didn't look into the code if there is something which
blocked this to be done years ago. I doubt there is...

>>> +             if (!c->device)
>>> +                     continue;
>>
>> Why are consoles without devices ignored here?
> 
> It's a common pattern all over the place. What is a "console without a
> device" that would be interesting here?

For example parport console. The question is whether you are interested
in consoles without ttys in systemd and other potential users.

>> Other than that there are 2 build warnings, see below.
>>
>>> -     device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
>>> +     tty0dev = device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
>>> +     if (IS_ERR(tty0dev))
>>> +             tty0dev = NULL;
>>> +     else
>>> +             device_create_file(tty0dev, &dev_attr_active);
>>
>> drivers/tty/vt/vt.c: In function ‘vty_init’:
>> drivers/tty/vt/vt.c:2997:21: warning: ignoring return value of
>> ‘device_create_file’, declared with attribute warn_unused_result
> 
> The code doesn't even check device_create(). :)
> 
> Anyway we actually don't want to check the return value of
> file_create(), it's a non-fatal error, if it ever happens.

Ok, but we don't want to introduce new warnings.

> What's the preferred way to do that:
>   int ignore = device_create_file()

I think the usual workaround in C is casting to void.

regards,
-- 
js
suse labs
