Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3AHEDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 23:03:33 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:44962 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3AHEDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 23:03:31 -0500
MIME-Version: 1.0
In-Reply-To: <1357597795.5190.10.camel@gandalf.local.home>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<20121126171539.GZ15971@htj.dyndns.org>
	<CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
	<CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
	<20130104150928.GC15633@mtj.dyndns.org>
	<CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
	<1357565303.10284.73.camel@gandalf.local.home>
	<CAKohpom9DxoojtcpMfmyGeUcEw8=tsS4n+TFMRV3+9_UBaod7g@mail.gmail.com>
	<1357597795.5190.10.camel@gandalf.local.home>
Date: Tue, 8 Jan 2013 09:33:31 +0530
Message-ID: <CAKohpokNeZjvvEcfb+vAjkpAdZqPAusckVET8QgRk_BwwfpsJw@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>, Vincent Guittot <vincent.guittot@linaro.org>,
        pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 8 January 2013 03:59, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2013-01-07 at 23:29 +0530, Viresh Kumar wrote:
>
>> > By default, I would suggest for cache locality,
>> > that we try to keep it on the same CPU. But if there's a better CPU to
>> > run on, it runs there.
>>
>> That would break our intention behind this routine. We should run
>> it on a cpu which we think is the best one for it power/performance wise.
>
> If you are running on a big.Little box sure. But for normal (read x86 ;)
> systems, it should probably stay on the current CPU.

But that's not the purpose of this new call. If the caller want it to be on
local cpu, he must not use this call. It is upto the core routine
(sched_select_cpu()
in our case) to decide where to launch it. If we need something special for x86,
we can hack this routine.

Even for non bigLITTLE systems, we may want to run a work on non-idle cpu and
so we can't guarantee local cpu here.

>> So, i would like to call the sched_select_cpu() routine from this routine to
>> get the suggested cpu.
>
> Does the caller need to know? Or if you have a big.LITTLE setup, it
> should just work automagically?

Caller wouldn't know, he just needs to trust on sched_select_cpu() to give the
most optimum cpu.

Again, it is not only for big LITTLE, but for any SMP system, where we
don't want
an idle cpu to do this work.

>> I don't think we need it :(
>> It would be a new API, with zero existing users. And so, whomsoever uses
>> it, should know what exactly he is doing :)
>
> Heh, you don't know kernel developers well do you? ;-)

I agree with you, but we don't need to care for foolish new code here.

> Once a new API is added to the kernel tree, it quickly becomes
> (mis)used.

Its true with all pieces of code in kernel and we really don't need to take
care of such users here :)
