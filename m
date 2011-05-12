Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1ELVnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:43:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63117 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab1ELVnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j3wpP8FfwMh/exksR1tmvpld8pTsefH5YGdk9b6rg3B4ezumtxjLteExLL/7H9sXVE
         aOWxNeIRs2HxOV5+1YmXZ5XVJKRlqlYYyOTb1Yi3HpI+zgjZTZW1YcI0m1isiQoDsVsz
         EW0Ft/ZTg2LJkJCjQpPkGh+ywjB6MpmoSrhHw=
Date: Thu, 12 May 2011 23:43:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] x86: Make the x86-64 stacktrace code safely
 callable from scheduler
Message-ID: <20110512214336.GE7410@nowhere>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
 <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
 <20110512212810.GA17596@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512212810.GA17596@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:28:10PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Avoid potential scheduler recursion and deadlock from the
> > stacktrace code by avoiding rescheduling when we re-enable
> > preemption.
> > 
> > This robustifies some scheduler trace events like sched switch
> > when they are used to produce callchains in perf or ftrace.
> 
> > -	put_cpu();
> > +
> > +	/* We want stacktrace to be computable anywhere, even in the scheduler */
> > +	preempt_enable_no_resched();
> 
> So what happens if a callchain profiling happens to be interrupted by a hardirq 
> and the interrupt reschedules the current task? We'll miss the reschedule, 
> right?
> 
> preempt_enable_no_resched() is not a magic 'solve scheduler recursions' bullet 
> - it's to be used only if something else will guarantee the preemption check! 
> But nothing guarantees it here AFAICS.
> 
> A better fix would be to use local_irq_save()/restore().

Good point, but then lockdep itself might trigger a stacktrace from local_irq_save,
leading to a stacktrace recursion.

I can use raw_local_irq_disable(), or may be have a stacktrace recursion protection.
I fear the second solution could lead us to potentially lose useful information
if a stacktrace interrupts another one. Ok these are extreme cases...
