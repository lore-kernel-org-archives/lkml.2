Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1G0Ver (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:34:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65488 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1G0Veq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:34:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-rpXrAZ6bAtWiy+rCaWEmRCwzMmNrqsRWQChM9nkdofiw@mail.gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
 <1311630170-26057-4-git-send-email-jim.cromie@gmail.com> <CAO+b5-rpXrAZ6bAtWiy+rCaWEmRCwzMmNrqsRWQChM9nkdofiw@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 27 Jul 2011 15:34:15 -0600
Message-ID: <CAJfuBxzq67UM7i+EmDzdFCWfbEPM2cGad1Ed4cfCP5+v2QVgwg@mail.gmail.com>
Subject: Re: [PATCH 03/25] dynamic_debug: use pr_debug instead of pr_info
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 1:08 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> Replace almost all occurrences of "if (verbose) pr_info()" with
>> pr_debug(), and get full control of output at each callsite.
>> Leave a few sites unaltered:
>>
>> 1st also uses pr_cont(), and theres no pr_debug_cont().
>> 2nd is in ddebug_add_module(), which is called during arch_init,
>> too early for callsite to be enabled when called.
>>
>> 3rd, pr_debug doesnt work in dynamic_debug_init(), its too early.
>> Also move the print ddebug_setup_string prior to parsing, since
>> afterwards it's been chopped up with '\0's, and only 1st word is seen.
>>

>
> Changing pr_info() into pr_debug() inside the dynamic_debug
> implementation seems like a really bad idea to me. Such changes make
> it hard to find out via source code reading whether or not there is a
> risk that invoking one of these pr_debug() macros will cause infinite
> recursion.
>
> Bart.
>

By inspection, all the pr_debug-ish code macros down to

 430int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 431{
 432        va_list args

which uses raw printk, KERN_DEBUG, KERN_CONT only.
This is the "print-path" that Jason mentioned.

IOW, this is more like "eating your own dogfood" than "eating your own tail"

WRT earlier discussion (Joe, Jason):

> I think these should be pr_debug.
> I know you're only using the current style.
>
> Jason, any reason these can not be converted?
>

it should be ok, although we have to be careful not to use them in the
printing path, since that will cause a recursion.

Also, if there is an issue with the dynamic debug code, it makes it more
of a pain to debug :)


All conversions were to flag-management code
The conversion was painless, and just worked,
except for init code, where I used pr_info.

wrt "pain to debug", Id suggest that "eating your own dogfood"
provides an early test, especially when combined with following
to enable the selftest at boot.

    ddebug_query="module dynamic_debug +p ; module dynamic_debug line
815-940 =_"
