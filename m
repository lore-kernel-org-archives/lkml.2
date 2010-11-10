Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0KJOlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:41:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47878 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab0KJOk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:40:59 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=2Zzf6Ss2cq4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QyXUC8HyAAAA:8 a=ZSXMO6ofZsTuCrRqA7UA:9 a=L5z_xZgNSeWnRYZOJ1CUSpQoYa8A:4 a=PUjeQqilurYA:10 a=dGJ0OcVc7YAA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101110101450.GA18481@elte.hu>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 09:40:56 -0500
Message-ID: <1289400056.12418.139.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 11:14 +0100, Ingo Molnar wrote:
> * Luck, Tony <tony.luck@intel.com> wrote:
> 
> > Taking a cue from the tracing session from the previous day (where the "perf" vs. 
> > "ftrace" vs. "lttng" war was ended by proposing a new tracing methodology that 
> > would overcome the shortcomings of both of the merged subsystems while also 
> > addressing the requirements of the lttng users) [...]
> 
> Well, the direction is that we are unifying ftrace and perf events and we are 
> actively phasing out individual ftrace plugins as matching events become available 
> (we already removed a few).
> 
> Most new tools use the perf syscall and tool writers have expressed the very 
> understandable desire that all events (and their reporting facility) be enumerated 
> and accessible via a unified API/ABI.
> 
> While it often seems easier for subsystems to just do their own ad-hoc 
> logging/reporting in the short run (every subsystem tends to think it has its own 
> very specific requirements for logging - while users/tool-authors can only shake 
> their head in disbelief when looking at the myriads of incompatible and inconsistent 
> facilities). The tooling requirement for unification is strong here and can not be 
> ignored.

Hi Ingo,

The thing that was brought up at KS was the problems between the way
perf and ftrace get their data. We have two buffer systems and two
interfaces for that. Forget the debugfs for now, the ftrace ring buffer
was designed for fast high speed tracing, with or without a reader. The
perf buffer was designed for analyzing a specific task (although it can
do more, but for a single task it shines).

The format of data that ftrace uses and the format perf uses is also
currently incompatible.

Linus said flat out that if he gets one complaint that a tool breaks
because a format change or an ABI disappears, he will revert the patch
that did that change immediately.

During the tracing summit at Linux Plumbers, Thomas stated that we have
two choices.

1) We can keep the status-quo and just have two separate interfaces
(whether both would be supported by the perf user tool was not
discussed)

2) We come up with a new syscall (or syscalls) that can be designed for
both the needs of perf and ftrace. This syscall would be kept out of
mainline until everyone was happy with it. After we are happy with it
and have tools that work well with it, we will push it to mainline. Then
the old interfaces would still be supported but nothing new added to
them. And all new development would be with the new syscall(s) and
eventually we deprecate the old interface. This would truly unify ftrace
and perf.

The second option was agreed upon by myself, Thomas, Frederic, and
Peter, and it was OK'd by Linus.

What do you think about it?

-- Steve

> 
> > [...] we explored whether the solution would be to define a new "system health" 
> > subsystem that could be used by any part of the kernel to report hardware issues 
> > in a coherent way so that end users would have a single place to look for all 
> > error information.
> 
> Note that Boris has been working on extending perf events into this area as well, 
> see this recent submission of patches on lkml:
> 
>   [PATCH 20/20] ras: Add RAS daemon
> 
> One thing is clear: any 'health subsystem' should not do its own flavor of error 
> reporting - instead we want to unify various forms of event logging into a common 
> facility.
> 
> RAS/EDAC could do its own hardware-specific settings via a separate subsystem - 
> although even many of those can be expressed via their respective events. (and we 
> are open on the perf events side to give callbacks/facilities for such use)
> 
> The synergies of unified event reporting are very strong.
> 
> Thanks,
> 
> 	Ingo


