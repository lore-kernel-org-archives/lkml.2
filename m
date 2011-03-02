Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab1CBH4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:56:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36000 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599Ab1CBH4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:56:45 -0500
Date: Wed, 2 Mar 2011 08:56:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, amit.kucheria@linaro.org,
        rusty@rustcorp.com.au, tglx@linutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V6 0/2] tracing, perf: cpu hotplug trace events
Message-ID: <20110302075625.GC15665@elte.hu>
References: <AANLkTinbYWQxde2jTcAtyYQGvGgt2Lmtnph=voj=haXF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinbYWQxde2jTcAtyYQGvGgt2Lmtnph=voj=haXF@mail.gmail.com>
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


* Vincent Guittot <vincent.guittot@linaro.org> wrote:

> This patchset adds some tracepoints for tracing cpu state and for
> profiling the plug and unplug sequence.
> 
> Some SMP arm platform uses cpu hotplug feature for improving their
> power saving because they can go into their deepest idle state only in
> mono core mode. In addition, running into mono core mode makes the
> cpuidle job easier and more efficient which also results in the
> improvement of power saving of some use cases. As the plug state of a
> cpu can impact the cpuidle behavior, it's interesting to trace this
> state and to correlate it with cpuidle traces.
> Then, cpu hotplug is known to be an expensive operation which also
> takes a variable time depending of other processes' activity (from
> hundreds ms up to few seconds). These traces have shown that the arch
> part stays almost constant on arm platform whatever the cpu load is,
> whereas the plug duration increases.
> 
> ---
>  include/trace/events/cpu_hotplug.h |  103 ++++++++++++++++++++++++++++++++++++
>  kernel/cpu.c                       |   18 ++++++
>  2 files changed, 121 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/cpu_hotplug.h

Why not do something much simpler and fit these into the existing power:* events:

     power:cpu_idle
     power:cpu_frequency
     power:machine_suspend
     power:cpu_idle
     power:cpu_frequency
     power:machine_suspend

in an intelligent way?

CPU hotplug is really a 'soft' form of suspend and tools using power events could 
thus immediately use CPU hotplug events as well.

A suitable new 'state' value could be used to signal CPU hotplug events:

 enum {
        POWER_NONE = 0,
        POWER_CSTATE = 1,
        POWER_PSTATE = 2,
 };

POWER_HSTATE for hotplug-state, or so.

This would also express the design arguments that others have pointed out in the 
prior discussion: that CPU hotplug is really a power management variant, and that in 
the long run it could be done via regular idle as well. When that happens, the above 
unified event structure makes it all even simpler - analysis tools will just 
continue to work fine.

Thanks,

	Ingo
