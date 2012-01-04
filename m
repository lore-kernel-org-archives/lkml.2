Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2ADKGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 05:06:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54919 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2ADKGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 05:06:45 -0500
MIME-Version: 1.0
In-Reply-To: <1325175685.24045.5.camel@gandalf.stny.rr.com>
References: <CALZhoSRVNp=Sj2u2GHiQhuHOEdrfiM58KzG+RutvJV=8CoCpTQ@mail.gmail.com>
	<CAH+eYFDb4r235jAGjr7j5R5C+9YK9WeXXjVZGWQUB=330sOi0Q@mail.gmail.com>
	<1325175685.24045.5.camel@gandalf.stny.rr.com>
Date: Wed, 4 Jan 2012 18:06:44 +0800
Message-ID: <CALZhoSSiigBR=4qUzyuijC3d3Dy=Dg5pUMRB+i7FwBR31-ERZg@mail.gmail.com>
Subject: Re: ftrace performance impact with different configuration
From: Lei Wen <adrian.wenl@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rabin Vincent <rabin@rab.in>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Fri, Dec 30, 2011 at 12:21 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-12-29 at 21:12 +0530, Rabin Vincent wrote:
>> On Thu, Dec 29, 2011 at 14:08, Lei Wen <adrian.wenl@gmail.com> wrote:
>> > 2. Seem dynamic ftrace also could involve some penalty for the running
>> > system, although it patching the running kernel with nop stub...
>> >
>> > For the second item, is there anyone done some research before that
>> > could zero the cost for the running system when the tracing is not
>> > enabled yet?
>>
>> One thing that needs to be fixed (for ARM) is that for the new-style
>> mcounts, the nop that's currently being done is not really a nop -- it
>> removes the function call, but there is still an unnecessary push/pop
>> sequence.  This should be modified to have the push {lr} removed too.
>> (Two instructions replaced instead of one.)
>
>
> Unfortunately you can't do this, at least not when the kernel is
> preemptible.
>
> Say we have:
>
>        push lr
>        call mcount
>
> then we convert it to:
>
>        nop
>        nop
>
> The conversion to nop should not be an issue, and this is what would be
> done when the system boots up. But then we enable tracing, some low
> priority task could have been preempted after executing the first nop,
> and we call stop machine to do the conversions (if no stop machine, then
> lets just say a higher prio task is running while we do the
> conversions). Then we add both the push lr and call back. But when that
> lower priority task gets scheduled in again, it would have looked like
> it ran:
>
>        nop
>        call mcount
>
> Since the call to mcount requires that the lr was pushed, this process
> will crash when the return is done and we never saved the lr.
>
> If you don't like the push. the best thing you can do is convert to:
>
>        jmp 1f
>        call mcount
> 1:
>
> This may not be as cheap as two nops, but it may be better than a push.
>
I do this conversion as you suggestion, but seem it still cannot fully
solve the performance
downgrade...

Here is the updated data with arm-eabi-4.4.3 toolchain in ARMv5 platform:

With no ftrace and no debugfs built in:
tcp: 161 /185 udp: 277 /180
With no ftrace but with debugfs built in:
tcp: 154 /185 udp:278 /183
With ftrace built in(no other changes):
tcp: 130 /163 udp:253 /140
With ftrace buit in but with mcount fix:
tcp: 135 /167 udp:258 /150
With ftrace built in but with mcount fix and no tracepoint:     tcp:
148 /170 udp: 267 / 161
With ftrace built in but with no tracepoint
tcp:  140 /165 udp: 267 /157

The mcount fix is referring to patching push {lr} to jmp 1f.
While no tracepoint means NULL the __DECLARE_TRACE, so that tracepoint
itself would not incur penalty, as current we don't have jump label
support yet officially.

It seems from the data the jmp fix would improve around 5~10 Mbit, but
even the most optimize combination, there is still a gap between "With
ftrace built in but with mcount fix and no tracepoint" and "With no
ftrace but with debugfs built in".

Do you have further suggestion on this?

Thanks,
Lei
