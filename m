Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1AGNVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:21:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63379 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1AGNVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:21:14 -0500
MIME-Version: 1.0
In-Reply-To: <4D26D866.40906@suse.cz>
References: <20110106215404.GA30624@kroah.com> <1294352605-31906-34-git-send-email-gregkh@suse.de>
 <4D26D866.40906@suse.cz>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 7 Jan 2011 14:20:58 +0100
Message-ID: <AANLkTimmtkOhEtRmzFxFS8Z_36Dcys+higaiVJXEr-=7@mail.gmail.com>
Subject: Re: [PATCH 34/36] tty: add 'active' sysfs attribute to tty0 and
 console device
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 10:09, Jiri Slaby <jslaby@suse.cz> wrote:
> On 01/06/2011 11:23 PM, Greg Kroah-Hartman wrote:
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -3232,9 +3232,45 @@ static int __init tty_class_init(void)
>>  postcore_initcall(tty_class_init);
>>
>>  /* 3/2004 jmc: why do these devices exist? */
>> -
>>  static struct cdev tty_cdev, console_cdev;
>>
>> +static ssize_t show_cons_active(struct device *dev,
>> +                             struct device_attribute *attr, char *buf)
>> +{
>> +     struct console *cs[16];
>> +     int i = 0;
>> +     struct console *c;
>> +     ssize_t count = 0;
>> +
>> +     acquire_console_sem();
>> +     for (c = console_drivers; c; c = c->next) {
>
> This should be:
> for_each_console(c)
> like somebody already suggested.

That's exported now? It was local to printk.c at least that time.

Anyway, the only sensible change here is to convert that home-grown
->next thing to a proper kernel linked list, and use the common
iterators instead of doing it on our own, or export new custom ones.

>> +             if (!c->device)
>> +                     continue;
>
> Why are consoles without devices ignored here?

It's a common pattern all over the place. What is a "console without a
device" that would be interesting here?

> Other than that there are 2 build warnings, see below.
>
>> -     device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
>> +     tty0dev = device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
>> +     if (IS_ERR(tty0dev))
>> +             tty0dev = NULL;
>> +     else
>> +             device_create_file(tty0dev, &dev_attr_active);
>
> drivers/tty/vt/vt.c: In function ‘vty_init’:
> drivers/tty/vt/vt.c:2997:21: warning: ignoring return value of
> ‘device_create_file’, declared with attribute warn_unused_result

The code doesn't even check device_create(). :)

Anyway we actually don't want to check the return value of
file_create(), it's a non-fatal error, if it ever happens.

What's the preferred way to do that:
  int ignore = device_create_file()
?

Kay
