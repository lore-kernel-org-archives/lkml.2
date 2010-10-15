Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0JOOSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab0JOOSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:18:54 -0400
Date: Fri, 15 Oct 2010 10:18:16 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH 7/7] perf: Optimize sw events
Message-ID: <20101015141816.GA2822@redhat.com>
References: <20101014203404.222133139@chello.nl> <20101014203625.609332490@chello.nl> <1287134043.29097.1331.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287134043.29097.1331.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 11:14:03AM +0200, Peter Zijlstra wrote:
> > Index: linux-2.6/include/linux/perf_event.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/perf_event.h
> > +++ linux-2.6/include/linux/perf_event.h
> > @@ -1013,15 +1013,17 @@ static inline void perf_fetch_caller_reg
> >  static inline void
> >  perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
> >  {
> > -	if (atomic_read(&perf_swevent_enabled[event_id])) {
> > -		struct pt_regs hot_regs;
> > +	struct pt_regs hot_regs;
> >  
> > -		if (!regs) {
> > -			perf_fetch_caller_regs(&hot_regs);
> > -			regs = &hot_regs;
> > -		}
> > -		__perf_sw_event(event_id, nr, nmi, regs, addr);
> > +	JUMP_LABEL(&perf_swevent_enabled[event_id], have_event);
> > +	return;
> > +
> > +have_event:
> > +	if (!regs) {
> > +		perf_fetch_caller_regs(&hot_regs);
> > +		regs = &hot_regs;
> >  	}
> > +	__perf_sw_event(event_id, nr, nmi, regs, addr);
> >  }
> >  
> 
> OK, so it appears I only compile tested this bit without jump_label
> support, with that bit added back this horribly fails to compile like:
> 
> In file included from /usr/src/linux-2.6/arch/x86/mm/fault.c:13:
> /usr/src/linux-2.6/include/linux/perf_event.h: In function ‘perf_sw_event.clone.0’:
> /usr/src/linux-2.6/include/linux/perf_event.h:1018: warning: asm operand 0 probably doesn’t match constraints
> /usr/src/linux-2.6/include/linux/perf_event.h:1018: error: impossible constraint in ‘asm’
> 
> 
> The relevant snippet from the .i file reads:
> 
> static inline void
> perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
> {
>  struct pt_regs hot_regs;
> 
>  do { asm goto("1:" ".byte 0xe9 \n\t .long 0\n\t" ".pushsection __jump_table,  \"a\" \n\t" " " ".quad" " " "1b, %l[" "have_event" "], %c0 \n\t" ".popsection \n\t" : : "i" (&perf_swevent_enabled[event_id]) : : have_event); } while (0);
>  return;
> 
> have_event:
>  if (!regs) {
>   perf_fetch_caller_regs(&hot_regs);
>   regs = &hot_regs;
>  }
>  __perf_sw_event(event_id, nr, nmi, regs, addr);
> }
> 
> 
> Anybody got any clue as to why this goes splat?
> 

Couple issues here. The key value: "&perf_swevent_enabled[event_id]"
is determined at run-time, so we can't associated the jump label with
keys that are run-time dependent. The second thing is that there is
array indexing, so essentially the jump label code would need to be
smart enough to associated the correct index with each instance of
'perf_sw_event' - unfortunately its not that smart :(

So, two possible suggestions:

1)

I see that PERF_COUNT_SW_MAX is 9. So, we could explicitly split out the
9 cases into 9 separate inline functions where the keys would be:

&perf_swevent_enabled[PERF_COUNT_SW_CPU_CLOCK]
&perf_swevent_enabled[PERF_COUNT_SW_TASK_CLOCK]

this probably wouldn't look to ugly if there was a macro that took each
software id, and spit out the appropriate inline. I see there aren't
that many 'perf_sw_event()' calls either to update.

2)

If you could define a single global variable that was set if any of the
indexes of the perf_swevent_enabled[] array were set. This potentially
woulnd't be as efficient as #1 as it would create false positives.

thanks,

-Jason

