Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab0JSOAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:00:51 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42698 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750822Ab0JSOAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:00:50 -0400
Date: Tue, 19 Oct 2010 10:00:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
Message-ID: <20101019140047.GA19077@Krystal>
References: <4C724298.4050509@jp.fujitsu.com> <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org> <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins> <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com> <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6> <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:42:10 up 26 days, 17:44,  3 users,  load average: 0.39, 0.24,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Tue, 19 Oct 2010, Mathieu Desnoyers wrote:
> 
> > * Thomas Gleixner (tglx@linutronix.de) wrote:
> > > With the addition of trace_softirq_raise() the softirq tracepoint got
> > > even more convoluted. Why the tracepoints take two pointers to assign
> > > an integer is beyond my comprehension.
> > > 
> > > But adding an extra case which treats the first pointer as an unsigned
> > > long when the second pointer is NULL including the back and forth
> > > type casting is just horrible.
> > > 
> > > Convert the softirq tracepoints to take a single unsigned int argument
> > > for the softirq vector number and fix the call sites.
> > 
> > Well, there was originally a reason for this oddness. The in __do_softirq(),
> > "h - softirq_ve"c computation was not needed outside of the tracepoint handler
> > in the past, but it now seems to be required with the new inlined
> > "kstat_incr_softirqs_this_cpu()".
> 
> Dudes, a vector computation is hardly a performance problem in that
> function and definitely not an excuse for designing such horrible
> interfaces.

In this specific case, I think you are right. But things are not that trivial,
and you know it. We have to consider:

- Extra instruction cache footprint
- Added register pressure
- Added computation overhead of the added substraction
- Frequency of code execution

for all target architectures when we add tracepoints to performance sensitive
code paths. As a general policy, we try to keep these at the lowest possible
level, so that all tracepoints will be compiled into distro kernels without
perceivable _overall_ performance overhead. It's not something that should be
looked at only on a tracepoint-by-tracepoint overhead basis, but rather by
looking at the overall system degradation that adding 300 tracepoints would
cause.

So I agree with you that it's a trade-off between interface cleanness and
performance. When they were introduced, Tracepoint handlers were barely seen as
citizen of the kernel code base, so all that mattered was to keep the
"tracepoints off" case clean and fast. Now that tracepoint handlers seems to be
increasingly accepted as part of the kernel code base, I agree that taking into
account oddness performed in this handler becomes more important. It ends up
being a question of balance between oddness inside the tracepoint handler and
performance overhead in the off-case. The increased acceptance of the tracepoint
code-base has shifted this balance slightly in favor of cleanness.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
