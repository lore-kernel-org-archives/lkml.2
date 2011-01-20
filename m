Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab1ATOq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:46:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:49097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab1ATOqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:46:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IcAhQU+bzDlGYqJ73Ny1yNlTU4lzOV7QkXvbXWjErZDYtV1TQVuWKsf+wD8TSLRbW4
         fYQgYczQT8gekYRnUmFA==
MIME-Version: 1.0
In-Reply-To: <1295534345.28776.175.camel@laptop>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
	<1295534345.28776.175.camel@laptop>
Date: Thu, 20 Jan 2011 15:46:51 +0100
Message-ID: <AANLkTimBypM3rr4QS3NcnAXcXUH-2-fE7mKG12NuX1Vv@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com, Paul Menage <menage@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Note that I also had to drop my optimization which was handling cgroup switch
from perf_event_task_sched_out() (and which had to deal with PF_EXITING).
I realized there was an issue in sampling mode during context switch. If you are
measuring at the kernel level, then you may get samples from the previous task
(which may not be in your cgroup) if a counter overflows in the middle
of the context
switch because you've switched cgroup before "current" is actually
updated. Thus,
the perf_event interrupt handler associates the sample to the old tasks.

So now, I switch out everything from perf_event_task_sched_out() and
wait until perf_event_task_sched_in() to re-examine the situation for the
new task. That's the only way to maintain consistency with "current".


On Thu, Jan 20, 2011 at 3:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-01-20 at 15:30 +0200, Stephane Eranian wrote:
>> @@ -4259,8 +4261,20 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>>
>>         /* Reassign the task to the init_css_set. */
>>         task_lock(tsk);
>> +       /*
>> +        * we mask interrupts to prevent:
>> +        * - timer tick to cause event rotation which
>> +        *   could schedule back in cgroup events after
>> +        *   they were switched out by perf_cgroup_sched_out()
>> +        *
>> +        * - preemption which could schedule back in cgroup events
>> +        */
>> +       local_irq_save(flags);
>> +       perf_cgroup_sched_out(tsk);
>>         cg = tsk->cgroups;
>>         tsk->cgroups = &init_css_set;
>> +       perf_cgroup_sched_in(tsk);
>> +       local_irq_restore(flags);
>>         task_unlock(tsk);
>>         if (cg)
>>                 put_css_set_taskexit(cg);
>
> So you too need a callback on cgroup change there.. Li, Paul, any chance
> we can fix this cgroup_subsys::exit callback? The scheduler code needs
> to do funny thing because its in the wrong place as well.
>
