Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1AEAkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:40:43 -0500
Received: from mail.openrapids.net ([64.15.138.104]:56673 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750957Ab1AEAkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:40:41 -0500
Date: Tue, 4 Jan 2011 19:40:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Cc: "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 2/5] trace event skb fix unassigned field
Message-ID: <20110105004038.GB9737@Krystal>
References: <E1PaGZY-0001EI-BD@smtp.tuxdriver.com> <20110104235418.GD2911@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104235418.GD2911@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:37:33 up 42 days,  5:40,  5 users,  load average: 0.07, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Tue, Jan 04, 2011 at 06:46:06PM -0500, nhorman@tuxdriver.com wrote:
> > Acked- by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > 
> > Sent from my Verizon Wireless Phone
> > 
> > ----- Reply message -----
> > From: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > Date: Tue, Jan 4, 2011 6:16 pm
> > Subject: [RFC patch 2/5] trace event skb fix unassigned field
> > To: "LKML" <linux-kernel@vger.kernel.org>
> > Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Ingo Molnar" <mingo@elte.hu>, "Neil Horman" <nhorman@tuxdriver.com>, "Thomas Gleixner" <tglx@linutronix.de>
> > 
> > 
> > The field "protocol" in event kfree_skb is left unassigned if skb is NULL,
> > leaving its trace output as garbage. Assign the value to 0 when skb is NULL
> > instead.
> 
> Hm, if the skb is already null, we probably shouldn't send any trace.
> 
> What about using TP_CONDITION() ?

Hrm, let's see. It's been introduced by commit
5cb3d1d9d34ac04bcaa2034139345b2a5fea54c1
by Zhaolei.

Event at the time of that commit, the only caller looked like:

void kfree_skb(struct sk_buff *skb)
{
        if (unlikely(!skb))
                return;
        if (likely(atomic_read(&skb->users) == 1))
                smp_rmb();
        else if (likely(!atomic_dec_and_test(&skb->users)))
                return;
        trace_kfree_skb(skb, __builtin_return_address(0));
        __kfree_skb(skb);
}
EXPORT_SYMBOL(kfree_skb);

So it already checks for a null pointer before calling the tracepoint. This
leads me to wonder why why this check was added in the first place ?

Mathieu

> 
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Neil Horman <nhorman@tuxdriver.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  include/trace/events/skb.h |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > Index: linux-2.6-lttng/include/trace/events/skb.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/trace/events/skb.h
> > +++ linux-2.6-lttng/include/trace/events/skb.h
> > @@ -25,9 +25,7 @@ TRACE_EVENT(kfree_skb,
> >  
> >  	TP_fast_assign(
> >  		__entry->skbaddr = skb;
> > -		if (skb) {
> > -			__entry->protocol = ntohs(skb->protocol);
> > -		}
> > +		__entry->protocol = skb ? ntohs(skb->protocol) : 0;
> >  		__entry->location = location;
> >  	),
> >  
> > 
> > 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
