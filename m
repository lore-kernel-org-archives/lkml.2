Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0JSO2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:28:31 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42669 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751845Ab0JSO23 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:28:29 -0400
Date: Tue, 19 Oct 2010 10:28:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
Message-ID: <20101019142820.GA14520@Krystal>
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org> <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins> <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com> <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6> <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6> <1287496495.16971.372.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:13:07 up 26 days, 18:15,  5 users,  load average: 0.20, 0.18,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Tue, 19 Oct 2010, Steven Rostedt wrote:
> 
> > On Tue, 2010-10-19 at 15:41 +0200, Thomas Gleixner wrote:
> > > On Tue, 19 Oct 2010, Mathieu Desnoyers wrote:
> > 
> > > Dudes, a vector computation is hardly a performance problem in that
> > > function and definitely not an excuse for designing such horrible
> > > interfaces.
> > 
> > Yes, now we can be a bit more liberal. But when these tracepoints were
> > going in, people were watching to make sure they have practically zero
> > impact when tracing was disabled.
> > 
> > Now that people are more use to tracepoints, they are more understanding
> > to have cleaner code over that extra few more lines of machine code in
> > the fast path.
> 
> The vector computation is compared to the extra tracing induced jumps
> probably not even measurable. Stop defending horrible coding with
> handwavy performance and impact arguments.

>From the moment markers and tracepoints infrastructures were merged, the
performance overhead target has been assuming we would eventually be merging
"asm goto jump labels", which replace the load+test+branch with a no-op.

So compared to a 5 bytes no-op added to the fast path, this vector computation
can be expected to have a higher performance impact, because skipping a no-op on
modern architectures (x86 at least) adds technically zero cycles. Agreed, there
is still the impact on I$, extra register pressure, some leaf functions becoming
non-leaf, and added function call (which imply external side-effect, thus acting
like a barrier()). But saying that all we do is to provide handwavy performance
and impact arguments is a bit much.

Until the asm goto are more widely deployed and until gcc 4.5 is more widely
used, there are some instrumentation sites I am relunctant to consider to
instrument with tracepoints (e.g. all system call entry/exit sites). However,
we should not use the cost of the current load+test+branch tracepoint behavior
as an excuse for adding extra performance impact to kernel code, because when it
will be replaced by asm gotos, all that will be left is the performance impact
inappropriately justified as insignificant compared to the impact of the old
tracepoint scheme.

Thanks,

Mathieu

> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
