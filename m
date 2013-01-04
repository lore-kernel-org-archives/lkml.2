Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3ADIpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:45:53 -0500
Received: from mail-ia0-f194.google.com ([209.85.210.194]:60965 "EHLO
	mail-ia0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3ADIpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:45:50 -0500
MIME-Version: 1.0
In-Reply-To: <1357232337.10284.67.camel@gandalf.local.home>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
	<1357207949-3349-2-git-send-email-kpark3469@gmail.com>
	<20130103103815.GL2631@n2100.arm.linux.org.uk>
	<CA+KhAHbmjD7zTw+wcw84Abg3V1dD=0Ea4kUpYdGENQf1UOWphw@mail.gmail.com>
	<1357220165.10284.30.camel@gandalf.local.home>
	<20130103141301.GQ2631@n2100.arm.linux.org.uk>
	<1357229038.10284.46.camel@gandalf.local.home>
	<20130103162359.GR2631@n2100.arm.linux.org.uk>
	<1357232337.10284.67.camel@gandalf.local.home>
Date: Fri, 4 Jan 2013 17:45:49 +0900
Message-ID: <CA+KhAHYbDU0Ajr5uPEjPxX2ECitvnK2ENOjmqjC=3G657GvG7w@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
From: Keun-O Park <kpark3469@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, fweisbec@gmail.com,
        mingo@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sahara <keun-o.park@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 1:58 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2013-01-03 at 16:23 +0000, Russell King - ARM Linux wrote:
>> On Thu, Jan 03, 2013 at 11:03:58AM -0500, Steven Rostedt wrote:
>> > On Thu, 2013-01-03 at 14:13 +0000, Russell King - ARM Linux wrote:
>> > > In summary, from what I can see in the patch, the reason why the ifdefs
>> > > are the way they are, and the reason the warning is there has not been
>> > > addressed; these patches just seem to be aimed just at removing a #warning
>> > > statement to make the warning go away.
>> >
>> > You're correct that this patch does not solve any of theses issues. Now,
>> > I'm thinking that ftrace has matured where these issues don't exist, and
>> > where they do, it will only cause noise in the trace than anything
>> > serious. But, this needs to be looked deeper to make sure.
>>
>> Looking back in the archives, it seems that we had a problem with ftrace
>> and the unwinder polluting the trace information:
>>
>> http://lists.arm.linux.org.uk/lurker/message/20090604.201745.1c41ee6c.en.html
>>
>> There's quite a bit of discussion in that thread about this which details
>> why we came up with what we have today.
>
> Thanks for the link. In fact, I see I was even involved :-)
>
> http://lists.arm.linux.org.uk/lurker/message/20090609.213448.b4e4d096.en.html
>
> Just as I explained, the problem isn't a recursion bug, but just noise
> in the trace.
>
> Some of what is called by unwind_frame() will always be traced, and I
> wouldn't want 'notrace' annotation on those.
>
> If anything, I would just suggest another config option that lets the
> user decide if they don't mind the messiness of the trace for the added
> benefit of where the latency output came from.
>
> Also, it's rather trivial to make the entire unwind.c not traced, by
> adding in the Makefile:
>
> CFLAGS_REMOVE_unwind.o = -pg
>
> But that only stops the tracing of the unwind_*. Looks to be a lot of
> those. But it wont stop the tracing of:
>
>  kernel_text_address <-unwind_frame
>  core_kernel_text <-unwind_frame
>  search_index <-unwind_frame
>  etc.
>
> Heck, the user could just keep those from being traced by doing:
>
>  echo kernel_text_address core_kernel_text search_index > \
>    /sys/kernel/debug/tracing/set_ftrace_notrace
>
> If DYNAMIC_FTRACE is defined.
>
> -- Steve
>
>

With "CFLAGS_REMOVE_unwind.o = -pg" and with CONFIG_PROVE_LOCKING
turned on, I confirmed that
there's no trace output like Steve mentioned.
However, if I turn off CONFIG_PROVE_LOCKING, "irqsoff" and
"preemptirqsoff" ftracer prints these lines :

kernel_text_address <-unwind_frame
core_kernel_text <-unwind_frame
search_index <-unwind_frame

While I investigated the reason, I just found out there's two function
with same name, trace_hardirqs_off.
One in kernel/trace/trace_irqsoff.c and another in kernel/lockdep.c.
And both symbols are exported.
I am wondering whether it is intentionally maintained code to
manipulate ftrace and lockdep or not.
I guess it's probably not.

-- Kpark
