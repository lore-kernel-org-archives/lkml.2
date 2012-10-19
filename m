Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab2JSWOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:14:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47334 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab2JSWOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:14:20 -0400
Message-ID: <5081D0B3.2060204@gmail.com>
Date: Sat, 20 Oct 2012 09:14:11 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] gpiolib: Refactor gpio_export
References: <507DF099.1010504@gmail.com> <CACRpkdbgrDZ+mzy4YaGtyHTm-P2nsEL6bwB7WS=OsZ1VF4crmQ@mail.gmail.com>
In-Reply-To: <CACRpkdbgrDZ+mzy4YaGtyHTm-P2nsEL6bwB7WS=OsZ1VF4crmQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/10/12 21:07, Linus Walleij wrote:

> On Wed, Oct 17, 2012 at 1:41 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> 
>> The gpio_export function uses nested if statements and the status
>> variable to handle the failure cases. This makes the function logic
>> difficult to follow. Refactor the code to abort immediately on failure
>> using goto. This makes the code slightly longer, but significantly
>> reduces the nesting and number of split lines and makes the code easier
>> to read.
>>
>> Signed-off-by: Ryan Mallon
> 
> Very good initiative!
> 
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -702,68 +702,74 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>>  {
>>         unsigned long           flags;
>>         struct gpio_desc        *desc;
>> -       int                     status = -EINVAL;
>> +       int                     status;
>>         const char              *ioname = NULL;
>> +       struct device           *dev;
>>
>>         /* can't export until sysfs is available ... */
>>         if (!gpio_class.p) {
>>                 pr_debug("%s: called too early!\n", __func__);
>> -               return -ENOENT;
>> +               status = -ENOENT;
>> +               goto fail;
> 
> Why bother with all the goto:s here since there are no resources
> to clean up? Just pr_debug() and return -ENOENT; is good enough.
> 
> I don't quite see the point.

I did it this way just so that there would be a single exit point.
I don't mind either way, so I'll update the ones without any
clean up to simply return.

> Arguably this should be pr_err() or something BTW, just debug()
> may hide serious bugs.


Not sure about that. User-space can check the return code if it
wants to find out why the call failed. We shouldn't 
unconditionally spam the log with error messages on sysfs 
access since it makes an easy DoS vector on the syslog. The
pr_debug messages I think are really for people who are 
developing on gpiolib.

~Ryan
