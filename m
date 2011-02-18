Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab1BRTxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:53:41 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:53276 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1BRTxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:53:37 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACddXk2rR7Hu/2dsb2JhbACmJ3OfTJszhV4EhQuHBoM6
X-IronPort-AV: E=Sophos;i="4.62,188,1297036800"; 
   d="scan'208";a="663150268"
Message-ID: <4D5ECE3E.4040407@cisco.com>
Date: Fri, 18 Feb 2011 12:53:34 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        acme@ghostprotocols.net, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and report
References: <1298008433-22911-1-git-send-email-daahern@cisco.com> <1298008433-22911-4-git-send-email-daahern@cisco.com> <20110218070657.GA11404@elte.hu> <4D5E8204.2090501@cisco.com> <20110218175926.GA3445@nowhere> <4D5EB564.6030504@cisco.com> <20110218192433.GA5658@nowhere>
In-Reply-To: <20110218192433.GA5658@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 12:24, Frederic Weisbecker wrote:
>> We want not only context-switch events, but the stack trace at the
>> switch. For example, with the stack trace you can see preemption -- when
>> a process got booted by another and where the booted process is at the
>> time. You can see not only which system call caused an ap to block
>> (e.g., an ioctl) but the full code path leading to the block.
> 
> You can recognize preemption a the context switch tracepoint: if the state
> of the scheduled out task is R (TASK_RUNNING), which means it doesn't go
> to sleep but gets preempted, with an explicit preemption point like cond_resched(),
> or a more implicit one: spin_unlock(), preempt_enable(), an interrupt, ...
> Or it has been woken up while it was about to sleep, but it doesn't make much
> difference.
> 
> If you want to know when a process is booted by another you can use the
> fork tracepoint, or sched:wake_up_new, etc...
> 
> And you can use syscall tracepoints to get the syscalls you want.
> 
> I don't see much the point for you to use stacktraces. But if you
> do, then rather add this support to perf script, in our scripting
> framework.

It's more the simplicity of what we are using today. 1 command, 1 event
being monitored:

  perf record -ag -e cs -c 1

A wealth of information. That command shows preemption, stack traces
only for context-switches (not all of the syscalls which is
overwhelming) and opens the door for other analysis. One data set.
Simple. Focused.

> 
> Because what you've done is basically to add tracing support to
> perf report. But we have perf script for that already. It only focuses
> on tracepoint events but they are those people are interested in
> because they show logical events in the kernel. I guess
> people are not interested in cpu-cycles overflows events or so as
> they don't show a state change in the kernel.

I have always referred to this as pretty printing each sample recorded
as opposed to summarizing into a histogram. With that approach you have
dictated the analysis of the data - a histogram summary. By printing
each sample with address-symbol conversions we can look at it in
whatever angle we need to make sense of it.

David


> 
> Well, yeah I can understand if one considers the software events,
> that makes meaningful events from the kernel. But these software events
> support have been a mistake in perf. You should rather use the
> tracepoint events instead.
>  
>> That data along with the gettimeofday timestamp has allowed us to
>> resolve performance issues such as a system call taking longer than
>> expected during a specific sequence of events or a process getting
>> preempted and not scheduled for N seconds. etc., etc.
> 
> That's about the same here. If you really need this, you need to add
> the support in perf script to handle that on tracepoint events.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
