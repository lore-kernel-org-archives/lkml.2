Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2KCRpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 13:45:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63739 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2KCRpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 13:45:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121102182926.GA18824@kroah.com>
References: <1351836952-3389-1-git-send-email-luca.clementi@gmail.com>
	<20121102182926.GA18824@kroah.com>
Date: Sat, 3 Nov 2012 10:45:07 -0700
Message-ID: <CAERW5OyUN_RCOsihCOUnWwAxFA4ODiqX-=i9x=zEcHXczVNCGA@mail.gmail.com>
Subject: Re: [PATCH] Staging: Android: logger: module_exit implementationg
From: Luca Clementi <luca.clementi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 11:29 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 01, 2012 at 11:15:52PM -0700, Luca Clementi wrote:
>> Created the module_exit for the android logger so that
>> it can be loaded and unloaded as a module. Fixed
>> module_init and some other minor issues.
>
> That's doing more than one thing here at once, care to break it up?
> Yeah, I know it seems funny for such a small patch, but it helps.
>

Sure, no problem.

> Also, now that you've added this, the logger driver still can't be built
> as a module, as the build system isn't changed to let that happen,
> right?

The Kconfig declares this as a module, although since there is not a
module_exit
it was possible to compile it as a module and load it but then it was
not possible
to rmmod it.

drivers/staging/android/Kconfig:

config ANDROID_LOGGER
        tristate "Android log driver"
        default n
....

So the alternative is to put the ANDROID_LOGGER to bool.

> Also, why do you want to build this as a module?

Since the original developer declared it as module I thought that was
the final goal,
but it was left unfinished only for time reason.

>> Signed-off-by: Luca Clementi <luca.clementi@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Brian Swetland <swetland@google.com>
>> ---
>>  drivers/staging/android/logger.c |   30 +++++++++++++++++++++++++++++-
>>  1 file changed, 29 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
>> index 1d5ed47..050be01 100644
>> --- a/drivers/staging/android/logger.c
>> +++ b/drivers/staging/android/logger.c
>> @@ -676,4 +676,32 @@ static int __init logger_init(void)
>>  out:
>>       return ret;
>>  }
>> -device_initcall(logger_init);
>> +
>> +static void __exit logger_exit(void)
>> +{
>> +     struct logger_log *current_log, *next_log;
>> +
>> +     list_for_each_entry_safe(current_log, next_log, &log_list, logs) {
>> +             /* we have to delete all the entry inside log_list */
>> +             ret = misc_deregister(&current_log->misc);
>> +             if (unlikely(ret)) {
>> +                     pr_err("failed to deregister misc device for log '%s'!\n",
>> +                                     current_log->misc.name);
>> +             }
>> +             pr_info("removed loggger '%s'\n", current_log->misc.name);
>
> Is that message really needed?

I'll remove it.

>> +             vfree(current_log->buffer);
>> +             kfree(current_log->misc.name);
>> +             kfree(current_log);
>> +     }
>> +
>> +     return;
>> +}
>> +
>> +
>> +module_init(logger_init);
>
> Is module_init() the same "level" as device_initcall()?  Did you test
> this out in an Android system?

Honestly I haven't tested it on Android, but in include/linux/init.h there is:

#define module_init(x)  __initcall(x);
...
#define __initcall(fn) device_initcall(fn)

Which lead me to think that there is not much difference between the two call.

>> +module_exit(logger_exit);
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Brian Swetland, <swetland@google.com>");
>> +MODULE_DESCRIPTION("Android Logger");
>> +
>> +
>
> What's with the unneeded trailing empty lines?
>

I can fix them and change the author as per request of Brian.

Should I make the requested fixes or do you prefer to change the
Kconfig to a bool?

Thanks for the comment,
Luca
