Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0HYCCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 22:02:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0HYCCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 22:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eAdODHemBV/qC/VGnagZq1yilmN9XOmc6TXStJsOhoiDVK0qQC1jZDeQABBgkcg+bm
         vt/haURkEyJUTG9FOAJw==
MIME-Version: 1.0
In-Reply-To: <1282682357.2605.3219.camel@laptop>
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
	<AANLkTi=QuD7v1PP9PaJt_Dz1N-JKC1e6km1TE_YE6iJk@mail.gmail.com>
	<1282682357.2605.3219.camel@laptop>
Date: Tue, 24 Aug 2010 19:02:04 -0700
Message-ID: <AANLkTi=FO3fx4F16CUXAzdKYTNoPjZaLfUvsqBJzAPV1@mail.gmail.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time accounting
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
        ikael Starvik <starvik@axis.com>, dhowells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 1:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-08-24 at 12:20 -0700, Venkatesh Pallipadi wrote:
>
>
>> - I started looking as not accounting this time to tasks themselves.
>> This was really tricky as things are tightly tied to scheduler
>> vruntime to get it right.
>
> I'm not exactly sure where that would get complicated, simply treat
> interrupts the same as preemptions by other tasks and things should
> basically work out rather straight forward from that.
>

Atleast the way I tried it turned out to be messy. Keep track of time
at si and hi
and remove it from update_curr delta. I did it that way as I didn't
want to take rq lock
on hi si path. Doing it as preemption with put_prev/pick_next would be
expensive. No?
Or you meant it some other way?

>> I am not even sure I got it totally right
>> :(, but I did play with the patch a bit. And noticed there were
>> multiple issues. 1) A silly case as in of two tasks on one CPU, one
>> task totally CPU bound and another task doing network recv. This is
>> how task and softirq time looks like for this (10s samples)
>> (loop)  (nc)
>> 503 9   502 301
>> 502 8   502 303
>> 502 9   501 302
>> 502 8   502 302
>> 503 9   501 302
>> Now, when I did "not account si time to task", the loop task ended up
>> getting a lot less CPU time and doing less work as nc task doing rcv
>> got more CPU share, which was not right thing to do. IIRC, I had
>> something like <300 centiseconds for loop after the change (with si
>> activity increasing due to higher runtime of nc task).
>
> Well, that actually makes sense and I wouldn't call it wrong.

I meant, that will make nc run for more than its fair share.

>
>> 2) Also, a minor problem of breaking current userspace API for
>> tasks/cgroup stats assume that irq times are included.
>
> Is that actually specified or simply assumed because our implementation
> always had that bug? I would really call not accounting irq time to
> tasks a bug-fix.

Agree about this. This should not be a big deal either way.

>> So, even though it seems accounting irq time as "system time" seems
>> the right thing to do, it can break scheduling in many ways. May be
>> hardirq can be accounted as system time. But, dealing with softirq is
>> tricky as they can be related to the task.
>
> I haven't yet seen any scheduler breakage here, it will divide time
> differently, but not in a broken way, if the system consumes 1/3rd of
> the time, there's only 2/3rd left to fairly distribute between tasks, so
> something like, 1/3-loop 1/3-nc 1/3-softirq makes perfect sense.
>
> You'd get exactly the same kind of thing if you replace (soft)irq with a
> FIFO task.
>

But, FIFO in that case would be some unrelated task taking away CPU.
Here one task can take more than its share due to si.

Also, network RFS will try to get softirq to the right CPU thats
running this task. So, this will be sort of common case where task
with softirq will run faster and other non-si tasks will run slower
with a change like this.

> The whole schizo softirq infrastructure (hardirq tails and tasks) is a
> pain though, I would really love to rid the kernel of it, but I've got
> no idea how to do something like that given that things like the whole
> network subsystem are tightly woven into it.
>
>> Figuring out si time and accouting to the right task is a non-starter.
>> There are so many different ways in which si will come into picture.
>> finding and accounting it to right task will be almost impossible.
>
> Agreed, hence:
>
>> So, why not do the simple things first. Do not disturb any existing
>> scheduling decisions, account accurate hi and si times system wide,
>> per task, per cgroup (with as less overhead as possible). Give this
>> info to users and admin programs and they may make a higher level
>> sense of this.
>>
>> Having looked at both the options, I feel having these export is an
>> immediate first step.
>
> This is where I strongly disagree, providing an interface that cannot
> possibly be implemented correctly just so you can fudge something (still
> not sure what from userspace) seems a very bad idea indeed.
>

I don't think correctness is a problem. TSC is pretty good for this
purpose on current hardware. I agree that usability is debatable.

The use case I mentioned is some management application trying to find
interference/slowness for a task/task group because some other si
intensive task or flood ping on that CPU, getting to know that from
si/hi time for task and what it "expects it to be". Yes this is vague.
But, I think you agree that problem of si/hi interference on unrelated
task exists today. And providing this interface was the quick way to
give some hint to management apps about such problem. But. other
alternative of making si and hi time as "system time" will help this
use case as well, as the user will notice lower exec_time in that
case.

If you strongly think that the right way is to make both si and hi
"system time" and that will not cause unfairness and slowdown for some
unrelated tasks, I can try to cleanup the patch I had for that and
send it out. I am afraid though, it will cause some regression and we
will end up back at square one after a month or so. :(

Thanks,
Venki
