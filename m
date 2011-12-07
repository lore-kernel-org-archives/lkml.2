Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1LGIeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:34:20 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40708 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1LGIeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:34:18 -0500
MIME-Version: 1.0
In-Reply-To: <8739cxjit8.fsf@rustcorp.com.au>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
 <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com> <1323198694-7186-19-git-send-email-jim.cromie@gmail.com>
 <8739cxjit8.fsf@rustcorp.com.au>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 7 Dec 2011 01:33:45 -0700
Message-ID: <CAJfuBxyJe4NbN7GDk4Si5A0mN2C6NFSPrbOsFt-pGs84DFZ1nA@mail.gmail.com>
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param $module.dyndbg
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jbaron@redhat.com, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 6:01 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue,  6 Dec 2011 12:11:28 -0700, jim.cromie@gmail.com wrote:
>> From: Jim Cromie <jim.cromie@gmail.com>
>>
>> Rework Thomas Renninger's $module.ddebug boot-time debugging feature,
>> from https://lkml.org/lkml/2010/9/15/397
>
> This worked out pretty neatly.  Thanks!
>

It did.  Almost like you planned it.

> A few questions from your patches:
>
>> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
>> index 7e3c53a..b77f43b 100644
>> --- a/include/linux/dynamic_debug.h
>> +++ b/include/linux/dynamic_debug.h
>> @@ -39,11 +39,16 @@ struct _ddebug {
>>  int ddebug_add_module(struct _ddebug *tab, unsigned int n,
>>                               const char *modname);
>>
>> +struct kernel_param;
>> +
>>  #if defined(CONFIG_DYNAMIC_DEBUG)
>>  extern int ddebug_remove_module(const char *mod_name);
>> +
>>  extern __printf(2, 3)
>>  int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
>
> struct kernel_param def belongs in future patch?  And whitespace change
> is kind of annoying.

kernel-param not needed - was part of old way.
whitespace cleaned out too.


>
>> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
>> index 7939f63..91bd56a 100644
>> --- a/include/linux/moduleparam.h
>> +++ b/include/linux/moduleparam.h
>> @@ -292,7 +292,7 @@ extern int parse_args(const char *name,
>>                     char *args,
>>                     const struct kernel_param *params,
>>                     unsigned num,
>> -                   int (*unknown)(char *param, char *val));
>> +                   int (*unknown)(char *param, char *val, const char *modname));
>
> Do you really want the modname here, or a struct module?  I wonder if we
> should make this a standard opaque void *.  Of course, we'd have to
> modify parse_args callers, but you're abusing "name" arg here a bit
> anyway.
>

I thought about the possible abuse, but then saw existing uses:

linux-2.6]$ grep parse_args init/main.c
	parse_args("early options", cmdline, NULL, 0, do_early_param);
	parse_args("Booting kernel", static_command_line, __start___param,

"Booting kernel" isnt quite a name either.

wrt using a struct module arg, Id prefer not.
what I need is the name, so that the ddebug-queries being passed
can leave out the module name and thus be shorter and less redundant

forex:
foo.dyndbg=" func bar +p ; func buz +p ; func bang +p "

would otherwize need "module foo" in each of the 4 rules, which would
be tedious.
Since its been given already by user, and already available in load_module()'s
existing call to parse_args(), it seems straightforward to alter the
cb sig, and pass it down.



>> @@ -2893,7 +2893,8 @@ static struct module *load_module(void __user *umod,
>>         mutex_unlock(&module_mutex);
>>
>>         /* Module is ready to execute: parsing args may do that. */
>> -     err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
>> +     err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
>> +                      ddebug_dyndbg_param_cb);
>>         if (err < 0)
>>                 goto unlink;
>
> You have to
>

?? You left this thought unfinished.


>
>
>> @@ -510,8 +510,7 @@ asmlinkage void __init start_kernel(void)
>>       printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
>>       parse_early_param();
>>       parse_args("Booting kernel", static_command_line, __start___param,
>> -                __stop___param - __start___param,
>> -                &unknown_bootoption);
>> +                __stop___param - __start___param, &unknown_bootoption);
>>
>>       jump_label_init();
>
> Gratuitous whitespace change.
>

undone.

>> +int ddebug_dyndbg_param_cb(char *param, char* val, const char* modname)
>> +{
>> +     if (strcmp(param, "dyndbg")) {
>> +             pr_warn("bogus param %s=%s received for %s\n",
>> +                     param, val, modname);
>> +             return -EINVAL;
>> +     }
>
> This is already done in parse_args(); don't add a pr_warn here.
>

OK yes.  I'll change rc to -ENOENT.


> Thanks,
> Rusty.


thanks.
