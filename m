Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1GZFz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:55:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41857 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1GZFzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:55:22 -0400
MIME-Version: 1.0
In-Reply-To: <1311651932.24377.15.camel@Joe-Laptop>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
 <1311630170-26057-25-git-send-email-jim.cromie@gmail.com> <1311651932.24377.15.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 25 Jul 2011 23:54:51 -0600
Message-ID: <CAJfuBxx_aWCGPKmnpz0Zj60sFmOAKL1NNBQ5=ekQxAAqVT+Few@mail.gmail.com>
Subject: Re: [PATCH 24/25] dynamic_debug: drop pr_fmt() from dynamic_pr_debug
To: Joe Perches <joe@perches.com>
Cc: jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 9:45 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2011-07-25 at 15:42 -0600, Jim Cromie wrote:
>> dynamic_pr_debug can add module, function, file, and line selectively,
>> theres no need to also add them via macro.  Moreover, adding them
>> via the macro, which is useful for pr_info and friends, causes
>> pr_debug to double-print those fields added by the flag-settings.
> []
>> -             __dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);\
>> +             __dynamic_pr_debug(&descriptor, fmt, ##__VA_ARGS__);    \
>
> Hey Jim.
>
> Thinking about a bit more, maybe it's possible to use
> another test to see if the current pr_fmt is:
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> and not add pr_fmt when appropriate.
>
> I tried this once.  I recall it worked without adding any
> new string dependencies.   It did depend on __builtin_strcmp.
>
> +#define _first_macro_arg(arg1, args...) arg1
> +#define first_macro_arg(arg1, args...) _first_macro_arg(arg1)
> +
> +#define define_kernel_printk_level(level, fmt, ...)                    \
> +do {                                                                   \
> +       if (__builtin_strcmp(first_macro_arg(pr_fmt(fmt)),              \
> +                            KBUILD_MODNAME ": " fmt))                  \
> +               printk(level pr_fmt(fmt), ##__VA_ARGS__);               \
> +       else                                                            \
> +               printk(level fmt, ##__VA_ARGS__);                       \
> +} while (0)
>
>
>
>

hi Joe,

In case it wasnt clear, the idea was to leave pr_fmt as is for use
with pr_info, etc.
Providing another, separate macro for the purpose would seem most
straightforward:

#define pr_dbg_fmt ( fmt )   fmt

>> -             __dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);\
>> +             __dynamic_pr_debug(&descriptor, pr_dbg_fmt(fmt), ##__VA_ARGS__);    \

would this address your concerns ?

It doesnt allow arbitrary insertion of extra punctuation, etc between
file, func, module, line, nor rearrange the ordering, but thats
probably overkill.
