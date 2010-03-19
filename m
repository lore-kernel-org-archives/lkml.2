Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0CSM4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 08:56:07 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42137 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751838Ab0CSM4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 08:56:05 -0400
Date: Fri, 19 Mar 2010 08:56:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100319125600.GA12211@Krystal>
References: <20100317013236.GB5258@nowhere> <20100317095230.GD17146@elte.hu> <4BA1C141.8050409@dcl.info.waseda.ac.jp> <20100318211633.GG5103@nowhere> <20100319010857.GC23020@Krystal> <20100319012337.GA22095@nowhere> <20100319013658.GB28456@Krystal> <20100319022659.GC22095@nowhere> <20100319024042.GB28941@Krystal> <20100319030611.GE22095@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319030611.GE22095@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:45:02 up 55 days, 15:22,  5 users,  load average: 0.98, 0.97,
	0.92
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Thu, Mar 18, 2010 at 10:40:42PM -0400, Mathieu Desnoyers wrote:
> > Well, the use-case that drove the asm goto implementation _is_ the tracepoints.
> > ;)
> > 
> > > 
> > > But, looking at __DO_TRACE:
> > > 
> > > 	if (it_func) {						\
> > > 		do {						\
> > > 			((void(*)(proto))(*it_func))(args);	\
> > > 		} while (*(++it_func));				\
> > > 	}
> > > 
> > > I would expect the compiler not to load the parameters in the stack
> > > before first checking the branch.
> > 
> > Note that you have to put that in its full context. It's a macro expanded within
> > a static inline function. The initial parameters are passed to the static
> > inline, not directly as "args" here. So parameters with side-effects have to be
> > evaluated before their result can be passed to the static inline function, so in
> > that sense their evaluation cannot be moved into the conditional branch.
> 
> 
> Evaluation yeah, I agree. A function passed as an argument is
> going to be evaluated indeed, or whatever thing that has a side effect.
> But there is nothing here that need to setup the parameters to the stack
> right before the true tracepoint call, not until we passed the branch check
> once.
> 
>  
> > > So, the fact that parameters are not loaded before we know we'll call
> > > the tracepoint is something we already have or is it something that the jump
> > > label brings in the package somehow?
> > 
> > It's standard compiler optimization behavior.
> 
> 
> Sure. My doubt is: currently with the upstream version, does the
> compiler tend to load the parameters to the stack before the branch is
> checked? Or is this a magic that jmp labels bring for whatever reason?

Even without the static jump patching, the compiler takes care of putting the
stack setup after the branch is checked. That worked with a standard test on a
variable, with immediate values and should still work with asm gotos.

I already did some presentations around these question. You can refer to my OLS
2008 slides, where I proposed static jump patching (ancestor of the asm gotos,
where I did the liveness analysis myself in the back of the compiler; good
enough for a prototype ;) ). Slide 11 discusses the branch vs stack setup
question:

http://lttng.org/files/slides/desnoyers-talk-ols2008.pdf

Even more in Sections 8.1, 8.2 and 8.3 of my thesis:

http://lttng.org/files/thesis/desnoyers-dissertation-2009-12-v27.pdf

8.1 Kernel Markers
8.2 Tracepoints
8.3 Immediate Values

Thanks,

Mathieu

> 
> Thanks.
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
