Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab0JOPDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab0JOPDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:03:33 -0400
Date: Fri, 15 Oct 2010 11:02:56 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH 7/7] perf: Optimize sw events
Message-ID: <20101015150256.GB2822@redhat.com>
References: <20101014203404.222133139@chello.nl> <20101014203625.609332490@chello.nl> <1287134043.29097.1331.camel@twins> <1287154627.29097.1524.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287154627.29097.1524.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 04:57:07PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-15 at 11:16 +0200, Peter Zijlstra wrote:
> > On Thu, 2010-10-14 at 22:34 +0200, Peter Zijlstra wrote:
> > 
> > > Index: linux-2.6/include/linux/perf_event.h
> > > ===================================================================
> > > --- linux-2.6.orig/include/linux/perf_event.h
> > > +++ linux-2.6/include/linux/perf_event.h
> > > @@ -1013,15 +1013,17 @@ static inline void perf_fetch_caller_reg
> > >  static inline void
> > >  perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
> > >  {
> > > -	if (atomic_read(&perf_swevent_enabled[event_id])) {
> > > -		struct pt_regs hot_regs;
> > > +	struct pt_regs hot_regs;
> > >  
> > > -		if (!regs) {
> > > -			perf_fetch_caller_regs(&hot_regs);
> > > -			regs = &hot_regs;
> > > -		}
> > > -		__perf_sw_event(event_id, nr, nmi, regs, addr);
> > > +	JUMP_LABEL(&perf_swevent_enabled[event_id], have_event);
> > > +	return;
> > > +
> > > +have_event:
> > > +	if (!regs) {
> > > +		perf_fetch_caller_regs(&hot_regs);
> > > +		regs = &hot_regs;
> > >  	}
> > > +	__perf_sw_event(event_id, nr, nmi, regs, addr);
> > >  }
> > >  
> > 
> > OK, so it appears I only compile tested this bit without jump_label
> > support, with that bit added back this horribly fails to compile like:
> > 
> > In file included from /usr/src/linux-2.6/arch/x86/mm/fault.c:13:
> > /usr/src/linux-2.6/include/linux/perf_event.h: In function ‘perf_sw_event.clone.0’:
> > /usr/src/linux-2.6/include/linux/perf_event.h:1018: warning: asm operand 0 probably doesn’t match constraints
> > /usr/src/linux-2.6/include/linux/perf_event.h:1018: error: impossible constraint in ‘asm’
> > 
> 
> Ah, figured it out, it needs __attribute__((always_inline)), otherwise
> we end up with multiple keys for one label, which will clealy not work.
> 

ah...cool! that should work. ignore my other suggestions...

thanks,

-Jason

