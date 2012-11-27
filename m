Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2K0Pf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:35:57 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62951 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2K0Pfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:35:55 -0500
MIME-Version: 1.0
In-Reply-To: <1354028699.6276.83.camel@gandalf.local.home>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<1354022770.6276.63.camel@gandalf.local.home>
	<CAKohpok5toHdxxjBU+bPJwkZt9Sv-QGY8o8X6HErza1WT-DWOA@mail.gmail.com>
	<1354024743.6276.79.camel@gandalf.local.home>
	<CAKfTPtD6T8oTHFeB82NFDOt6anAL=23vaShsDws0c7812=GkFQ@mail.gmail.com>
	<1354028699.6276.83.camel@gandalf.local.home>
Date: Tue, 27 Nov 2012 16:35:53 +0100
Message-ID: <CAKfTPtBq+zAp4aqSTxPSk5+upPgZgxza=oMCDLKk9Mfr9k2yqQ@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, pjt@google.com,
        paul.mckenney@linaro.org, tglx@linutronix.de, tj@kernel.org,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2012 16:04, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-11-27 at 15:55 +0100, Vincent Guittot wrote:
>> On 27 November 2012 14:59, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Tue, 2012-11-27 at 19:18 +0530, Viresh Kumar wrote:
>> >> On 27 November 2012 18:56, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >> > A couple of things. The sched_select_cpu() is not cheap. It has a double
>> >> > loop of domains/cpus looking for a non idle cpu. If we have 1024 CPUs,
>> >> > and we are CPU 1023 and all other CPUs happen to be idle, we could be
>> >> > searching 1023 CPUs before we come up with our own.
>> >>
>> >> Not sure if you missed the first check sched_select_cpu()
>> >>
>> >> +int sched_select_cpu(unsigned int sd_flags)
>> >> +{
>> >> +       /* If Current cpu isn't idle, don't migrate anything */
>> >> +       if (!idle_cpu(cpu))
>> >> +               return cpu;
>> >>
>> >> We aren't going to search if we aren't idle.
>> >
>> > OK, we are idle, but CPU 1022 isn't. We still need a large search. But,
>> > heh we are idle we can spin. But then why go through this in the first
>> > place ;-)
>>
>> By migrating it now, it will create its activity and wake up on the
>> right CPU next time.
>>
>> If migrating on any CPUs seems a bit risky, we could restrict the
>> migration on a CPU on the same node. We can pass such contraints on
>> sched_select_cpu
>>
>
> That's assuming that the CPUs stay idle. Now if we move the work to
> another CPU and it goes idle, then it may move that again. It could end
> up being a ping pong approach.
>
> I don't think idle is a strong enough heuristic for the general case. If
> interrupts are constantly going off on a CPU that happens to be idle
> most of the time, it will constantly be moving work onto CPUs that are
> currently doing real work, and by doing so, it will be slowing those
> CPUs down.
>

I agree that idle is probably not enough but it's the heuristic that
is currently used for selecting a CPU for a timer and the timer also
uses sched_select_cpu in this series. So in order to go step by step,
a common interface has been introduced for selecting a CPU and this
function uses the same algorithm than the timer already do.
Once we agreed on an interface, the heuristic could be updated.


> -- Steve
>
>
