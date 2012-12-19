Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2LSTvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:51:36 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:32824 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LSTv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:51:28 -0500
Message-ID: <50D21A5F.4040604@linux.vnet.ibm.com>
Date: Thu, 20 Dec 2012 01:19:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com> <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <50D0CCB3.10105@linux.vnet.ibm.com> <20121219163900.GA18516@redhat.com> <50D2047A.1040606@linux.vnet.ibm.com> <20121219191436.GA25829@redhat.com>
In-Reply-To: <20121219191436.GA25829@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121919-4790-0000-0000-0000061D8B62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 12:44 AM, Oleg Nesterov wrote:
> On 12/19, Srivatsa S. Bhat wrote:
>>
>> BTW, there is a small problem with the synchronize_sched() approach:
>> We can't generalize the synchronization scheme as a generic percpu rwlock
>> because the writer's role is split into 2, the first part (the one having
>> synchronize_sched()) which should be run in process context, and the
>> second part (the rest of it), which can be run in atomic context.
> 
> Yes,
> 
>> That is, needing the writer to be able to sleep (due to synchronize_sched())
>> will make the locking scheme unusable (in other usecases) I think. And
>> the split (blocking and non-blocking part) itself seems hard to express
>> as a single writer API.
> 
> I do not think this is the problem.
> 
> We need 2 helpers for writer, the 1st one does synchronize_sched() and the
> 2nd one takes rwlock. A generic percpu_write_lock() simply calls them both.
>

Ah, that's the problem no? Users of reader-writer locks expect to run in
atomic context (ie., they don't want to sleep). We can't expose an API that
can make the task go to sleep under the covers!
(And that too, definitely not with a name such as "percpu_write_lock_irqsave()"
... because we are going to be interrupt-safe as well, in the second part...).
 
> In fact I think that the 1st helper should not do synchronize_sched(),
> and (say) cpu_hotplug_begin() should call it itself. Because if we also
> change cpu_hotplug_begin() to use percpu_rw_sem we do not want to do
> synchronize_sched() twice. But lets ignore this for now.
> 

Yeah, let's ignore this for now, else I'll get all confused ;-)

> But,
> 
>> Hmmm.. so what do we do? Shall we say "We anyway have to do smp_rmb() in the
>> reader in the fast path. Instead let's do a full smp_mb() and get rid of
>> the synchronize_sched() in the writer, and thereby expose this synchronization
>> scheme as generic percpu rwlocks?" Or should we rather use synchronize_sched()
>> and keep this synchronization scheme restricted to CPU hotplug only?
> 
> Oh, I do not know ;)
> 
> To me, the main question is: can we use synchronize_sched() in cpu_down?
> It is slow.
>

Haha :-) So we don't want smp_mb() in the reader, *and* also don't want
synchronize_sched() in the writer! Sounds like saying we want to have the cake
and eat it too ;-) :P

But seriously speaking, I understand that its a bit of a hard choice to make.
On one side, we can avoid synchronize_sched() at the writer, but have to bear
the burden of smp_mb() at the reader even in the fastpath, when no writer is active.
On the other side, we can make the reader avoid smp_mb(), but the writer has to
suffer a full synchronize_sched(). But an important point is that, at the writer
side, we already wait for so many mutex locks and stuff, like in the CPU_DOWN_PREPARE
stage (as determined by the callbacks). So adding a synchronize_sched() to the mix
shouldn't make it noticeably bad, isn't it?

(I'm not arguing in favor of using synchronize_sched(). I'm just trying to point
out that using it might not be as bad as we think it is, in the CPU hotplug case.
And moreover, since I'm still not convinced about the writer API part if use
synchronize_sched(), I'd rather avoid synchronize_sched().)

Regards,
Srivatsa S. Bhat

