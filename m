Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2CVRSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:18:13 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:28740 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2CVRSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:18:11 -0400
Message-ID: <4F6B5ED1.1080300@tilera.com>
Date: Thu, 22 Mar 2012 13:18:09 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <linaro-sched-sig@lists.linaro.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-13-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1203210953220.20482@router.home> <CAOtvUMdkU92t0nj9OXsnzCenuOyjb12x6s11xR_GGJu1aJJ7GA@mail.gmail.com>
In-Reply-To: <CAOtvUMdkU92t0nj9OXsnzCenuOyjb12x6s11xR_GGJu1aJJ7GA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/2012 3:38 AM, Gilad Ben-Yossef wrote:
> On Wed, Mar 21, 2012 at 4:54 PM, Christoph Lameter <cl@linux.com> wrote:
>> On Wed, 21 Mar 2012, Frederic Weisbecker wrote:
>>
>>> If RCU is waiting for the current CPU to complete a grace
>>> period, don't turn off the tick. Unlike dynctik-idle, we
>>> are not necessarily going to enter into rcu extended quiescent
>>> state, so we may need to keep the tick to note current CPU's
>>> quiescent states.
>> Is there any way for userspace to know that the tick is not off yet due to
>> this? It would make sense for us to have busy loop in user space that
>> waits until the OS has completed all processing if that avoids future
>> latencies for the application.
>>
> I previously suggested having the user register to receive a signal
> when the tick
> is turned off. Since the tick is always turned off the user task is
> the current task
> by design, *I think* you can simply mark the signal pending when you
> turn the tick off.
>
> The user would register a signal handler to set a flag when it is
> called and then busy
> loop waiting for a flag to clear.

This sounds plausible, but the kernel would have to know that the tick not
only was stopped currently, but also would still be stopped when the signal
handler's sigreturn syscall was performed.  The problem we've seen is that
it's sometimes somewhat nondeterministic when the kernel might decide it
needed some more ticking, once you let kernel code start to run.  For
example, for RCU ops the kernel can choose to ignore the nohz cpuset cores
when they're running userspace code only, but as soon as they get back into
the kernel for any reason, you may need to schedule a grace period, and so
just returning from the "you have no more ticks!" signal handler ends up
causing ticks to be scheduled.

The approach we took for the Tilera dataplane mode was to have a syscall
that would hold the task in the kernel until any ticks were done, and only
then return to userspace.  (This is the same set_dataplane() syscall that
also offers some flags to control and debug the dataplane stuff in general;
in fact the "hold in kernel" support is a mode we set for all syscalls, to
keep things deterministic.)  This way the "busy loop" is done in the
kernel, but in fact we explicitly go into idle until the next tick, so it's
lower-power.

An alternative approach, not so good for power but at least avoiding the
"use the kernel to avoid the kernel" aspect of signals, would be to
register a location in userspace that the kernel would write to when it
disabled the tick, and userspace could then just spin reading memory.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

