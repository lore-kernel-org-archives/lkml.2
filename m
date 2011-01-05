Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab1AEL7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 06:59:25 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38693 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1AEL7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:59:23 -0500
Date: Wed, 5 Jan 2011 06:59:08 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 2/5] trace event skb fix unassigned field
Message-ID: <20110105115908.GA4434@hmsreliant.think-freely.org>
References: <E1PaGZY-0001EI-BD@smtp.tuxdriver.com>
 <20110104235418.GD2911@nowhere>
 <20110105004038.GB9737@Krystal>
 <20110105004903.GF2911@nowhere>
 <20110105012123.GA10416@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105012123.GA10416@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.1 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 08:21:23PM -0500, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Tue, Jan 04, 2011 at 07:40:38PM -0500, Mathieu Desnoyers wrote:
> > > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > > On Tue, Jan 04, 2011 at 06:46:06PM -0500, nhorman@tuxdriver.com wrote:
> > > > > Acked- by: Neil Horman <nhorman@tuxdriver.com>
> > > > > 
> > > > > 
> > > > > Sent from my Verizon Wireless Phone
> > > > > 
> > > > > ----- Reply message -----
> > > > > From: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > > > > Date: Tue, Jan 4, 2011 6:16 pm
> > > > > Subject: [RFC patch 2/5] trace event skb fix unassigned field
> > > > > To: "LKML" <linux-kernel@vger.kernel.org>
> > > > > Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Ingo Molnar" <mingo@elte.hu>, "Neil Horman" <nhorman@tuxdriver.com>, "Thomas Gleixner" <tglx@linutronix.de>
> > > > > 
> > > > > 
> > > > > The field "protocol" in event kfree_skb is left unassigned if skb is NULL,
> > > > > leaving its trace output as garbage. Assign the value to 0 when skb is NULL
> > > > > instead.
> > > > 
> > > > Hm, if the skb is already null, we probably shouldn't send any trace.
> > > > 
> > > > What about using TP_CONDITION() ?
> > > 
> > > Hrm, let's see. It's been introduced by commit
> > > 5cb3d1d9d34ac04bcaa2034139345b2a5fea54c1
> > > by Zhaolei.
> > > 
> > > Event at the time of that commit, the only caller looked like:
> > > 
> > > void kfree_skb(struct sk_buff *skb)
> > > {
> > >         if (unlikely(!skb))
> > >                 return;
> > >         if (likely(atomic_read(&skb->users) == 1))
> > >                 smp_rmb();
> > >         else if (likely(!atomic_dec_and_test(&skb->users)))
> > >                 return;
> > >         trace_kfree_skb(skb, __builtin_return_address(0));
> > >         __kfree_skb(skb);
> > > }
> > > EXPORT_SYMBOL(kfree_skb);
> > > 
> > > So it already checks for a null pointer before calling the tracepoint. This
> > > leads me to wonder why why this check was added in the first place ?
> > 
> > Likely for no strong reasons :)
> > 
> > So I guess we can remove the check from the tracepoint?
> 
> Yep, leading to this patch instead:
> 
> trace event skb remove duplicate null-pointer check
> 
> The check for NULL skb in the kfree_skb trace event is a duplicate from the
> check already done in its only caller, kfree_skb(). Remove this duplicate check.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Neil Horman <nhorman@tuxdriver.com>
> ---
>  include/trace/events/skb.h |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Index: linux-2.6-lttng/include/trace/events/skb.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/trace/events/skb.h
> +++ linux-2.6-lttng/include/trace/events/skb.h
> @@ -25,9 +25,7 @@ TRACE_EVENT(kfree_skb,
>  
>  	TP_fast_assign(
>  		__entry->skbaddr = skb;
> -		if (skb) {
> -			__entry->protocol = ntohs(skb->protocol);
> -		}
> +		__entry->protocol = ntohs(skb->protocol);
>  		__entry->location = location;
>  	),
>  
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
> 
