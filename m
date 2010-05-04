Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab0EDLdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:33:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39052 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab0EDLdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:33:00 -0400
Date: Tue, 4 May 2010 13:32:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf, ftrace and MCEs
Message-ID: <20100504113227.GA14067@elte.hu>
References: <20100501181212.GA25352@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100501181212.GA25352@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Hi,
> 
> so I finally had some spare time to stare at perf/ftrace code and ponder on 
> how to use those facilities for MCE collecting and reporting. Btw, I have to 
> say, it took me quite a while to understand what goes where - my suggestion 
> to anyone who tries to understand how perf/ftrace works is to do make 
> <file.i> where there is at least one trace_XXX emit record function call and 
> start untangling code paths from there.
> 
> So anyway, here are some questions I had, I just as well may've missed 
> something so please correct me if I'm wrong:
> 
> 1. Since machine checks can happen at any time, we need to have the MCE 
> tracepoint (trace_mce_record() in <include/trace/events/mce.h>) always 
> enabled. This, in turn, means that we need the ftrace/perf infrastructure 
> always compiled in (lockless ring buffer, perf_event.c stuff) on any x86 
> system so that MCEs can be handled at anytime. Is this going to be ok to be 
> enabled on _all_ machines, hmmm... I dunno, maybe only a subset of those 
> facilites at least.

Yeah - and this happens on x86 anyway so you can rely on it.

> 2. Tangential to 1., we need that "thin" software layer prepared for 
> decoding and reporting them as early as possible. event_trace_init() is an 
> fs_initcall and executed too late, IMHO. The ->perf_event_enable in the 
> ftrace_event_call is enabled even later on the perf init path over the 
> sys_perf_even_open which is at userspace time. In our case, this is going be 
> executed by the error logging and decoding daemon I guess.

We could certainly move bits of this initialization earlier.

Also we could add the notion of 'persistent' events that dont have a 
user-space process attached to them - and which would buffer to a certain 
degree. Such persistent events could be initialized during bootup and the 
daemon could pick up the events later on.

In-kernel actions/policy could work off the callback mechanism. (See for 
example how the new NMI watchdog code in tip:perf/nmi makes use of it - or how 
the hw-breakpoints code utilizes it.) These would work even if there's no 
user-space daemon attached (or if the daemon has been stopped). So i dont see 
a significant design problem here - it's all natural extensions of existing 
perf facilities and could be used for other purposes as well.

> 3. Since we want to listen for MCEs all the time, the concept of enabling 
> and disabling those events does not apply in the sense of performance 
> profiling. [...]

Correct.

> [...] IOW, MCEs need to be able to be logged to the ring buffer at any time. 
> I guess this is easily done - we simply enable MCE events at the earliest 
> moment possible and disable them on shutdown; done.
> 
> So yeah, some food for thought but what do you guys think?

Note that it doesnt _have to_ go to the ftrace ring-buffer. If the daemon (or 
whatever facility picking up the events) keeps a global (per cpu) MCE perf 
event enabled all the time then it might be doing that regardless of ftrace.

Some decoupling from ftrace could be done here easily. I'd suggest to not 
worry about it - once we have the MCE event code we can certainly reshape the 
underlying support code to be more readily available/configurable. (or even 
built-in) This is not really a significant design issue.

To start with this, a quick initial prototype could use the 'perf trace' live 
mode tracing script. (See latest -tip, 'perf trace --script <script-name>' and 
'perf record -o -' to activate live mode.)

Note that there's also 'perf inject' now, which can be used to simulate rare 
events and test the daemon's reactions to it. (Right now perf-inject is only 
used to inject certain special build-id events, but it can be used for the 
injection of MCE events as well.)

Thanks,

	Ingo
