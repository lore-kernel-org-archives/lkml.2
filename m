Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2K0Myp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:54:45 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:37754 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2K0Myn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:54:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<20121126171539.GZ15971@htj.dyndns.org>
	<CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
Date: Tue, 27 Nov 2012 13:54:41 +0100
Message-ID: <CAKfTPtBZ+c8+XvUQatXbbbHOiBCBpacsRh0a0XYyM=G9QE657Q@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        Arvind.Chauhan@arm.com, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2012 06:19, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi Tejun,
>
> On 26 November 2012 22:45, Tejun Heo <tj@kernel.org> wrote:
>> On Tue, Nov 06, 2012 at 04:08:45PM +0530, Viresh Kumar wrote:
>
>> I'm pretty skeptical about this.  queue_work() w/o explicit CPU
>> assignment has always guaranteed that the work item will be executed
>> on the same CPU.  I don't think there are too many users depending on
>> that but am not sure at all that there are none.  I asked you last
>> time that you would at the very least need to audit most users but it
>> doesn't seem like there has been any effort there.
>
> My bad. I completely missed/forgot that comment from your earlier mails.
> Will do it.
>
>> That said, if the obtained benefit is big enough, sure, we can
>> definitely change the behavior, which isn't all that great to begin
>> with, and try to shake out the bugs quicky by e.g. forcing all work
>> items to execute on different CPUs, but you're presenting a few
>> percent of work items being migrated to a different CPU from an
>> already active CPU, which doesn't seem like such a big benefit to me
>> even if the migration target CPU is somewhat more efficient.  How much
>> powersaving are we talking about?
>
> Hmm.. I actually implemented the problem discussed here:
> (I know you have seen this earlier :) )
>
> http://www.linuxplumbersconf.org/2012/wp-content/uploads/2012/08/lpc2012-sched-timer-workqueue.pdf
>
> Specifically slides: 12 & 19.
>
> I haven't done much power calculations with it and have tested it more from
> functionality point of view.
>
> @Vincent: Can you add some comments here?

Sorry for this late reply.

We have faced some situations on TC2 (as an example) where the tasks
are running in the LITTLE cluster whereas some periodic works stay on
the big cluster so we can have one cluster that wakes up for tasks and
another one that wakes up for work. We would like to consolidate the
behaviour of the work with the tasks behaviour.

Sorry, I don't have relevant figures as the patches are used with
other ones which also impact the power consumption.

This series introduces the possibility to run a work on another CPU
which is necessary if we want a better correlation of task and work
scheduling on the system. Most of the time the queue_work is used when
a driver don't mind the CPU on which you want to run whereas it looks
like it should be used only if you want to run locally. We would like
to solve this point with the new interface that is proposed by viresh

Vincent

>
> --
> viresh
