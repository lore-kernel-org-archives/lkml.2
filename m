Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1CNPHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:07:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1CNPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:07:52 -0400
Date: Mon, 14 Mar 2011 16:07:46 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing - putting cond_resched into tace_pipe loop
Message-ID: <20110314150746.GA4453@jolsa.brq.redhat.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
 <1299970786-8075-3-git-send-email-jolsa@redhat.com>
 <20110313145811.GA30558@redhat.com>
 <1300111651.9910.87.camel@gandalf.stny.rr.com>
 <20110314141853.GB1936@jolsa.brq.redhat.com>
 <1300112926.9910.100.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300112926.9910.100.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 10:28:46AM -0400, Steven Rostedt wrote:
> On Mon, 2011-03-14 at 15:18 +0100, Jiri Olsa wrote:
> 
> 
> > > I'm not sure that this needs the signal_pending() or the break, or even
> > > the cond_resched(). Perhaps the first patch fixes the bug. But that
> > > while loop does not block, and it should just spin enough to fill a
> > > page. If it is not filling the page then that's a bug.
> > 
> > well, if there are no "event lost" messages and the flags are set
> > to the "bin or raw" and you trace events only, then the page
> > is not be filled.
> > 
> > But as there'll be allways lost events, the page will be populated
> > and it will get out of the loop.
> 
> There's two loops, I'm talking about the inner one, which will break out
> when there are no events left to process.
> 
> The "waitagain" calls into tracing_wait_pipe which has the
> signal_pending() attribute. It should also block, or return -EAGAIN if
> the caller is not blocking.
> 
> > 
> > > 
> > > Jiri,
> > > 
> > > Can you reproduce the bug with just he first patch? Actually, I can
> > > reproduce it on vanilla, I'll apply your first patch and see if that
> > > fixes things. If not, then we need to find out why and fix those.
> > 
> > The first patch fixies the 'lost evets' trace, so the loop is escaped
> > when the page is full.
> > (I was going to send some change for first patch WARN_ON -> WARN_ONCE)
> 
> Yes, I was going to recommend doing that too.
> 
> > 
> > I think in case there are no 'lost events' and we have the conditions
> > I describe, we need the cond_resched call.
> 
> No we don't.

ok, probably I'm missing something, but here's the path that dont produce
any data and will keeps us in the inner loop:
(assuming events only, disabled context info and no event lost)

while (trace_find_next_entry_inc(iter) != NULL)
..
	print_trace_line(iter);
		...
		if (trace_flags & TRACE_ITER_BIN)
	                return print_bin_fmt(iter);
			...
			print_bin_fmt
				return event ?event->funcs->binary(iter, 0, event) : TRACE_TYPE_HANDLED;

...


now, "event->funcs->binary" is trace_nop_print, which is defined as:

	enum print_line_t trace_nop_print(struct trace_iterator *iter, int
	flags,
					  struct trace_event *event)
	{
		return TRACE_TYPE_HANDLED;
	}


So we get back the the while loop with no data added and with
TRACE_TYPE_HANDLED return code, which will keep us in the loop.

Not sure this is bug or feature :)

jirka

> 
> As for non preempt kernels, honestly, I don't care about latencies. If
> you are worried about latencies, don't run a non preempt kernel. I do
> care if it goes into an infinite loop, or never processes signals, which
> would be a bug. But long running times in the kernel on a non preempt
> kernel. Well, that's just part of the game.
> 
> -- Steve
> 
> > 
> > I'll send new patch version shortly.
> > 
> > thanks,
> > jirka
> > > 
> > > -- Steve
> > > 
> > > 
> 
> 
