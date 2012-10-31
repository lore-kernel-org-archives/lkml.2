Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935448Ab2JaLUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:20:00 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52932 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934387Ab2JaLT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLF2tgLDn0pcTaisd0N4c+4Jxi=gmV1qK+7MSc6=QoyBkA@mail.gmail.com>
References: <1347461277-25302-1-git-send-email-elezegarcia@gmail.com>
	<tip-8781915ad2716adcd8cd5cc52cee791fc8b00fdf@git.kernel.org>
	<CAOJsxLF2tgLDn0pcTaisd0N4c+4Jxi=gmV1qK+7MSc6=QoyBkA@mail.gmail.com>
Date: Wed, 31 Oct 2012 08:19:57 -0300
Message-ID: <CALF0-+Vv0mS6ENOpG4x6-922XEik5JM=4+5A+5ZWVtgZmNyJBA@mail.gmail.com>
Subject: Re: [tip:perf/core] trace: Move trace event enable from fs_initcall
 to core_initcall
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Wed, Oct 31, 2012 at 4:04 AM, Pekka Enberg <penberg@kernel.org> wrote:
> Hi Ezequiel,
>
> On Thu, Sep 27, 2012 at 8:49 AM, tip-bot for Ezequiel Garcia
> <elezegarcia@gmail.com> wrote:
>> Commit-ID:  8781915ad2716adcd8cd5cc52cee791fc8b00fdf
>> Gitweb:     http://git.kernel.org/tip/8781915ad2716adcd8cd5cc52cee791fc8b00fdf
>> Author:     Ezequiel Garcia <elezegarcia@gmail.com>
>> AuthorDate: Wed, 12 Sep 2012 11:47:57 -0300
>> Committer:  Steven Rostedt <rostedt@goodmis.org>
>> CommitDate: Mon, 24 Sep 2012 14:13:02 -0400
>>
>> trace: Move trace event enable from fs_initcall to core_initcall
>>
>> This patch splits trace event initialization in two stages:
>>  * ftrace enable
>>  * sysfs event entry creation
>>
>> This allows to capture trace events from an earlier point
>> by using 'trace_event' kernel parameter and is important
>> to trace boot-up allocations.
>>
>> Note that, in order to enable events at core_initcall,
>> it's necessary to move init_ftrace_syscalls() from
>> core_initcall to early_initcall.
>>
>> Link: http://lkml.kernel.org/r/1347461277-25302-1-git-send-email-elezegarcia@gmail.com
>>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> So what's still needed for perf to be able to trace early boot slab
> allocations like kmemtrace used to be able to do?
>

Steven suggested [1] it would be possible to create some sort
of static ring buffer, and use it to trace early events.
Later on, this static buffer should be copied into the "real" one.

Since this patch, ftrace is enabled at core_initcall.
It's an improvement, but we still loose events.
For instance, in a probe kernel we loose 800k bytes,
and 20k allocations, compared to accounting from boot up.

To be able to use ftrace (and therefore perf) for long run tracing,
you need to consider ring buffer overrun.
In my tests, I had to set a bigger buffer,
which severely impacts performance.

IMHO, this makes ftrace unsuitable for very long run tests
with "verbose" events; unless you put an user daemon
or something popping events, preventing overrun.

    Ezequiel

[1] https://lkml.org/lkml/2012/8/17/253
