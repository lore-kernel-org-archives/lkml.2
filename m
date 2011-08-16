Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1HPPHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:07:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38162 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab1HPPHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAC9WiBitmuvZOS74UY1E-=y+6hpm6_OgaR9E6wrHhdvARt2uJA@mail.gmail.com>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
	<20110731110641.GG2209@sun>
	<CAC9WiBgg+To8ggUvTqxOCy2hgb=XQCRH6D_0HFy4sEEoF8R0rw@mail.gmail.com>
	<20110731153225.GJ2209@sun>
	<1312196702.2617.445.camel@laptop>
	<CAC9WiBitmuvZOS74UY1E-=y+6hpm6_OgaR9E6wrHhdvARt2uJA@mail.gmail.com>
Date: Tue, 16 Aug 2011 17:07:45 +0200
Message-ID: <CAC9WiBgpMFQjCMxp7TFHXEm6RKDbUwfMiOpx2SGp=vR_QZzKng@mail.gmail.com>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
From: Francis Moreau <francis.moro@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Mon, Aug 15, 2011 at 10:37 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello Peter,
>
> Sorry for the loooonnng delay but summer rest :)
>
> On Mon, Aug 1, 2011 at 1:05 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Sun, 2011-07-31 at 19:32 +0400, Cyrill Gorcunov wrote:
>>
>>> > >> I'm seeing those kernel message when resuming:
>>> > >>
>>> > >> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
>>> > >> [  524.973288] Do you have a strange power saving mode enabled?
>>> > >> [  524.973289] Dazed and confused, but trying to continue
>>> > >>
>>> > >> I don't know if it's important or not because the system seems to work
>>> > >> after but maybe it worths to report
>>
>> So I guess the problem is the NMI watchdog and suspend stuff not
>> shutting things down properly..
>>
>> Argh, the PM notifier muck runs before the hotplug notifiers and it
>> doesn't avoid hotplug races on its own.. what crap.
>>
>> something like the below perhaps, compile tested only.. does it work?
>
> Thanks for the fix, I'm going to give it a test and report in 2 days.
>

I'm trying to test the fix but have to stick with the 3.0 kernel and
your patch seems to be based on 3.1.

So I had to backport a couple of patches otherwise I'm getting the
following error:

  CC      kernel/events/core.o
kernel/events/core.c: In function ‘perf_pm_resume_cpu’:
kernel/events/core.c:7342: error: implicit declaration of function
‘perf_ctx_lock’
kernel/events/core.c:7350: error: implicit declaration of function
‘perf_ctx_unlock’
kernel/events/core.c: In function ‘perf_pm_suspend_cpu’:
kernel/events/core.c:7370: error: implicit declaration of function
‘perf_event_sched_in’

Here are the patches that I backported on top of 3.0:

 perf: Collect the schedule-in rules in one function
 perf: Change and simplify ctx::is_active semantics
 perf: Simplify and fix __perf_install_in_context()
 perf: Remove task_ctx_sched_in()
 perf: Optimize event scheduling locking
 perf: Clean up 'ctx' reference counting
 perf: Optimize ctx_sched_out()

After the second suspend/resume sequence I still have the same warning
except that the reason has changed to '2d':

 kernel:[  404.091393] Uhhuh. NMI received for unknown reason 2d on CPU 0.
 kernel:[  404.091394] Do you have a strange power saving mode enabled?
 kernel:[  404.091396] Dazed and confused, but trying to continue

Thanks
-- 
Francis
