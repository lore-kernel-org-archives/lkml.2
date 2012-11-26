Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2KZTdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:33:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab2KZTdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:33:44 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=j9wofRDAjcQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M7XXC4kVkb4A:10 a=uBdfXsve8v62yWFhLtwA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353958423.6276.54.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] cputime: Rename thread_group_times to
 thread_group_cputime_adjusted
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 26 Nov 2012 14:33:43 -0500
In-Reply-To: <CAFTL4hxxE8Ggw4Ae-VfgBZ8rtoOMpUQnmSGUado1gxeruwQ9rg@mail.gmail.com>
References: <1353680484-7302-1-git-send-email-fweisbec@gmail.com>
	 <1353680484-7302-3-git-send-email-fweisbec@gmail.com>
	 <1353956163.6276.46.camel@gandalf.local.home>
	 <CAFTL4hxxE8Ggw4Ae-VfgBZ8rtoOMpUQnmSGUado1gxeruwQ9rg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 20:24 +0100, Frederic Weisbecker wrote:
> 2012/11/26 Steven Rostedt <rostedt@goodmis.org>:
> > On Fri, 2012-11-23 at 15:21 +0100, Frederic Weisbecker wrote:
> >> We have thread_group_cputime() and thread_group_times(). The naming
> >> doesn't provide enough information about the difference between
> >> these two APIs.
> >>
> >> To lower the confusion, rename thread_group_times() to
> >> thread_group_cputime_adjusted(). This name better suggests that
> >> it's a version of thread_group_cputime() that does some stabilization
> >> on the raw cputime values. ie here: scale on top of CFS runtime
> >> stats and bound lower value for monotonicity.
> >
> > But, thread_group_times() does not do any type of adjustment. It only
> > retrieves the cpu times:
> >
> > void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
> > {
> >         struct task_cputime cputime;
> >
> >         thread_group_cputime(p, &cputime);
> >
> >         *ut = cputime.utime;
> >         *st = cputime.stime;
> > }
> 
> This is the CONFIG_VIRT_CPU_ACCOUNTING only version. It also needs
> some monotonicity guard IMO but that's another issue.
> But please look at the other version.

Yeah, I just noticed. That turkey juice is still having an affect on
me ;-)

> 
> > It retrieves the current times, it doesn't adjust them.
> >
> > I'm thinking the current name is more accurate.

OK, let's take a look at the other version now:

void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
{
        struct signal_struct *sig = p->signal;
        struct task_cputime cputime;
        cputime_t rtime, utime, total;

        thread_group_cputime(p, &cputime);

        total = cputime.utime + cputime.stime;
        rtime = nsecs_to_cputime(cputime.sum_exec_runtime);

        if (total)
                utime = scale_utime(cputime.utime, rtime, total);
        else
                utime = rtime;

        sig->prev_utime = max(sig->prev_utime, utime);
        sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);

        *ut = sig->prev_utime;
        *st = sig->prev_stime;
}

So this version also updates the task's signal->prev_[us]times as well. 

I guess I'll wait for you to explain to me more about what is going
on :-)

-- Steve


