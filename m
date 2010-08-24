Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0HXTUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:20:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20167 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0HXTU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vJViQ42t5MQB+VfHCAxIZWcgMZXPTgA0/OjJCDsIwQnFA01vq8ERsp6FKkW5YKRFZp
         AQNLBRJjsUis+OUorhPg==
MIME-Version: 1.0
In-Reply-To: <1282650835.2605.2629.camel@laptop>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	<20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	<AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
	<20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
	<AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
	<1282636286.2605.2307.camel@laptop>
	<20100824080515.GK4684@balbir.in.ibm.com>
	<1282640953.2605.2428.camel@laptop>
	<20100824113801.GO4684@balbir.in.ibm.com>
	<1282650835.2605.2629.camel@laptop>
Date: Tue, 24 Aug 2010 12:20:21 -0700
Message-ID: <AANLkTi=QuD7v1PP9PaJt_Dz1N-JKC1e6km1TE_YE6iJk@mail.gmail.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time accounting
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 4:53 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-08-24 at 17:08 +0530, Balbir Singh wrote:
>>
>> The point is for containers it is more likely to give the right answer
>> and so on. Yes, the results are not 100% accurate.
>
> Consider one group heavily dirtying pages, it stuffs the IO queues full
> and gets blocked on IO completion. Since the CPU is then free to
> schedule something else we start running things from another group,
> those IO completions will come in while we run other group and get
> accounted to other group -- FAIL.
>
> s/group/task/ etc..
>
> That just really doesn't work, accounting async work, esp stuff that is
> not under software control it very tricky indeed.
>
> So what are you wanting to do, and why. Do you really need accounting
> madness?

(long email alert)
I have two different answers for why we ended up with this madness.

My personal take on why we need this and the actual flow why I ended
up with this patchset.

- Current /proc/stat hardirq and softirq time reporting is broken for
most archs as it does tick sampling. Hardirq time specifically is
further broken due to interrupts being disabled during irq -
http://kerneltrap.org/mailarchive/linux-kernel/2010/5/25/4574864

OK. Lets fix /proc/stat. But, that doesn't seem enough. We should also
not account this time to tasks themselves.

- I started looking as not accounting this time to tasks themselves.
This was really tricky as things are tightly tied to scheduler
vruntime to get it right. I am not even sure I got it totally right
:(, but I did play with the patch a bit. And noticed there were
multiple issues. 1) A silly case as in of two tasks on one CPU, one
task totally CPU bound and another task doing network recv. This is
how task and softirq time looks like for this (10s samples)
(loop)  (nc)
503 9   502 301
502 8   502 303
502 9   501 302
502 8   502 302
503 9   501 302
Now, when I did "not account si time to task", the loop task ended up
getting a lot less CPU time and doing less work as nc task doing rcv
got more CPU share, which was not right thing to do. IIRC, I had
something like <300 centiseconds for loop after the change (with si
activity increasing due to higher runtime of nc task).
2) Also, a minor problem of breaking current userspace API for
tasks/cgroup stats assume that irq times are included.

So, even though it seems accounting irq time as "system time" seems
the right thing to do, it can break scheduling in many ways. May be
hardirq can be accounted as system time. But, dealing with softirq is
tricky as they can be related to the task.

Figuring out si time and accouting to the right task is a non-starter.
There are so many different ways in which si will come into picture.
finding and accounting it to right task will be almost impossible.

So, why not do the simple things first. Do not disturb any existing
scheduling decisions, account accurate hi and si times system wide,
per task, per cgroup (with as less overhead as possible). Give this
info to users and admin programs and they may make a higher level
sense of this. In the above silly example, user will probably know
that loop is CPU bound where as nc will have net rcv si's and can
decide when to sub si time and when not to.

Thats how I ended up with this patchset.


The other point of view for why this is needed comes from management
apps. Apps which do a higher level task/task group distribution across
different systems and manage them over time, monitoring/resource
allocating/migrating/etc.
There are times when a task/task groups are getting some hi/si
"interference" from some other task/task group currently active on the
system or even -ping flood- kind of activity that you mentioned. These
problems are happening now and tasks end up running slow when such
interference happens with exec run time still being normal. So,
management app has no clue on whats going wrong. One can argue that
this is same as interference with cache conflict etc. But, for hi/si
case, we in OS, should be able to handle things better. We should
either signal such interference to the app, or reflect proper exec
time. That brings us back to debate of should we report them at all or
transparently account them as system time and remove it from all
tasks.


Having looked at both the options, I feel having these export is an
immediate first step. That helps users who are currently having this
problem and wouldn't hurt much the users who don't see any problem
(CONFIG option). Hardware irqs are probably best accounted as system
time. But, there are potential issues doing the same with softirqs.
Longer term we may be able to deal with them all in a clean way. But,
that doesn't affect the short term solution, as we will just have
these new exports end up as zero if and when we get to this full
solution.

Adding stuff to sched_rt_avg_update. Yes, thats another step in the
direction and I have the patch for that. That does take care load
balance. But, I think removing both hi and si from the task right away
will expose more oddities than it will solve....


Thanks,
Venki
