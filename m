Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1BUVOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:14:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40379 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1BUVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:14:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tMxn2EbeVsbthG4ak33kplSH3Ka18DlGWOB8w8BZDABaYV3eP+qcrnUrndDwo+HfgH
         5MPiaDxEmeKnMIKE5OV/EMlr85PWAcRKOZK+34GZFBSzLpdyL10lbCMU64QJInMmaO/Q
         m6idoKhv7plK5QE/WNfYZYrUgCRoKuXSMIUBM=
Date: Mon, 21 Feb 2011 22:13:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        acme@ghostprotocols.net, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and
 report
Message-ID: <20110221211352.GA3583@nowhere>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
 <1298008433-22911-4-git-send-email-daahern@cisco.com>
 <20110218070657.GA11404@elte.hu>
 <4D5E8204.2090501@cisco.com>
 <20110218175926.GA3445@nowhere>
 <4D5EB564.6030504@cisco.com>
 <20110218192433.GA5658@nowhere>
 <4D5ECE3E.4040407@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5ECE3E.4040407@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 12:53:34PM -0700, David Ahern wrote:
> 
> 
> On 02/18/11 12:24, Frederic Weisbecker wrote:
> >> We want not only context-switch events, but the stack trace at the
> >> switch. For example, with the stack trace you can see preemption -- when
> >> a process got booted by another and where the booted process is at the
> >> time. You can see not only which system call caused an ap to block
> >> (e.g., an ioctl) but the full code path leading to the block.
> > 
> > You can recognize preemption a the context switch tracepoint: if the state
> > of the scheduled out task is R (TASK_RUNNING), which means it doesn't go
> > to sleep but gets preempted, with an explicit preemption point like cond_resched(),
> > or a more implicit one: spin_unlock(), preempt_enable(), an interrupt, ...
> > Or it has been woken up while it was about to sleep, but it doesn't make much
> > difference.
> > 
> > If you want to know when a process is booted by another you can use the
> > fork tracepoint, or sched:wake_up_new, etc...
> > 
> > And you can use syscall tracepoints to get the syscalls you want.
> > 
> > I don't see much the point for you to use stacktraces. But if you
> > do, then rather add this support to perf script, in our scripting
> > framework.
> 
> It's more the simplicity of what we are using today. 1 command, 1 event
> being monitored:
> 
>   perf record -ag -e cs -c 1
> 
> A wealth of information. That command shows preemption, stack traces
> only for context-switches (not all of the syscalls which is
> overwhelming) and opens the door for other analysis. One data set.
> Simple. Focused.

Right. Then why not adding support to stacktraces in perf script?
Seems it's the only missing thing to achieve what you want.

> > Because what you've done is basically to add tracing support to
> > perf report. But we have perf script for that already. It only focuses
> > on tracepoint events but they are those people are interested in
> > because they show logical events in the kernel. I guess
> > people are not interested in cpu-cycles overflows events or so as
> > they don't show a state change in the kernel.
> 
> I have always referred to this as pretty printing each sample recorded
> as opposed to summarizing into a histogram. With that approach you have
> dictated the analysis of the data - a histogram summary. By printing
> each sample with address-symbol conversions we can look at it in
> whatever angle we need to make sense of it.

I'm not dictating any analysis. You can can just launch
perf script without script and it will display the events,
like you want.

Just try:

perf record -a -e sched:sched_switch
perf script

You can extend it to print addresses or symbols or even stacktraces.
It just seems to me the right place to do so. Not perf report that is
about histograms.
