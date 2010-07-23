Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0GWFfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:35:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45807 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab0GWFe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:34:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [RFC PATCH v3 1/5] irq: add tracepoint to softirq_raise
Cc: kosaki.motohiro@jp.fujitsu.com, Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kaneshige.kenji@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, laijs@cn.fujitsu.com,
        scott.a.mcmillan@intel.com, rostedt@goodmis.org,
        eric.dumazet@gmail.com, fweisbec@gmail.com,
        mathieu.desnoyers@polymtl.ca
In-Reply-To: <20100721135654.GE21259@hmsreliant.think-freely.org>
References: <20100721215836.86F9.A69D9226@jp.fujitsu.com> <20100721135654.GE21259@hmsreliant.think-freely.org>
Message-Id: <20100723140656.88A2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 23 Jul 2010 14:34:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jul 21, 2010 at 10:01:34PM +0900, KOSAKI Motohiro wrote:
> > > > >>  #endif /*  _TRACE_IRQ_H */
> > > > >> diff --git a/kernel/softirq.c b/kernel/softirq.c
> > > > >> index 825e112..6790599 100644
> > > > >> --- a/kernel/softirq.c
> > > > >> +++ b/kernel/softirq.c
> > > > >> @@ -215,9 +215,9 @@ restart:
> > > > >>  			int prev_count = preempt_count();
> > > > >>  			kstat_incr_softirqs_this_cpu(h - softirq_vec);
> > > > >>  
> > > > >> -			trace_softirq_entry(h, softirq_vec);
> > > > >> +			trace_softirq_entry(h - softirq_vec);
> > > > >>  			h->action(h);
> > > > >> -			trace_softirq_exit(h, softirq_vec);
> > > > >> +			trace_softirq_exit(h - softirq_vec);
> > > > > 
> > > > > You're loosing information here by reducing the numbers of parameters in this
> > > > > tracepoint.  How many other tracepoint scripts rely on having both pointers
> > > > > handy?  Why not just do the pointer math inside your tracehook instead?
> > > > 
> > > > In __raise_softirq_irqoff macro there is no method to refer softirq_vec, so it
> > > > can't use softirq DECLARE_EVENT_CLASS as is.
> > > > Currently,  there is no script using softirq_entry or softirq_exit.
> > > > 
> > > That shouldn't matter, just pass in NULL for softirq_vec in
> > > __raise_softirq_irqoff as the second argument to the trace function.  You may
> > > need to fix up the class definition so that the assignment or printk doesn't try
> > > to dereference that pointer when its NULL, but thats easy enough, and it avoids
> > > breaking any other perf scripts floating out there.
> > 
> > please see 5 lines above. we already have 'h - softirq_vec' calculation in
> > this function. so, Sanagi-san's change don't makes any overhead.
> > 
> > So, if the overhead is zero, I'd prefer simplest tracepoint definition :)
> > 
> I never complained about performance here, I complained about information loss.
> You have a tracepoint that provides two arguments here, and you're eliminating
> one of them.  That will potentially break other users of this tracepoint.  I
> understand we don't normally care about that with tracepoints as much, but if we
> can avoid it, why don't we?

I see. I have no objection.

Thanks.



