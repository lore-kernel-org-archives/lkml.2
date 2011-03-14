Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1CNOTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:19:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab1CNOS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:18:59 -0400
Date: Mon, 14 Mar 2011 15:18:53 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing - putting cond_resched into tace_pipe loop
Message-ID: <20110314141853.GB1936@jolsa.brq.redhat.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
 <1299970786-8075-3-git-send-email-jolsa@redhat.com>
 <20110313145811.GA30558@redhat.com>
 <1300111651.9910.87.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300111651.9910.87.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 10:07:31AM -0400, Steven Rostedt wrote:
> On Sun, 2011-03-13 at 15:58 +0100, Oleg Nesterov wrote:
> > On 03/12, Jiri Olsa wrote:
> > >
> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -3237,10 +3237,23 @@ waitagain:
> > >  		 * One of the trace_seq_* functions is not used properly.
> > >  		 */
> > >  		WARN_ON(iter->seq.full);
> > > +
> > > +		/*
> > > +		 * There's a chance this loop might get quite tight,
> > > +		 * causing latency in non preemptive kernel.
> > > +		 */
> > > +		cond_resched();
> > > +		if (signal_pending(current)) {
> > > +			sret = -EINTR;
> > > +			break;
> > 
> > First of all: I do not pretend I understand this code ;) Still, a
> > couple of nits.
> > 
> > -EINTR doesn't look exactly right, I'd suggest -ERESTARTSYS. The same
> > for tracing_wait_pipe() btw, I think it should be fixed.
> 
> Yeah, the tracing_wait_pipe() could be changed. I probably copied that
> from someplace else in the kernel ;)
> 
> > 
> > 
> > 
> > I wonder if it makes sense to simply "break" if signal_pending(), it
> > is possible we already have something to report via trace_seq_to_user().
> > Then we could do
> > 
> > 	-	if (sret == -EBUSY)
> > 	-		goto waitagain;
> > 	+	if (sret == -EBUSY) {
> > 	+		if (!signal_pending())
> > 	+			goto waitagain;
> > 	+		sret = -ERESTARTSYS;
> > 	+	}
> > 
> > Or we can change tracing_wait_pipe() to check signal_pending()
> > uncondditionally, I dunno.
> > 
> > Up to you, but note that otherwise the logic looks a bit strange.
> > Suppose that signal_pending() is already true when we call
> > tracing_wait_pipe(). In this case we are going to do the "unnecessary"
> > work and then return EINTR/ERESTART. This is correct, the next
> > invocation does trace_seq_to_user() before anything else, just
> > looks a bit strange.
> 
> I'm not sure that this needs the signal_pending() or the break, or even
> the cond_resched(). Perhaps the first patch fixes the bug. But that
> while loop does not block, and it should just spin enough to fill a
> page. If it is not filling the page then that's a bug.

well, if there are no "event lost" messages and the flags are set
to the "bin or raw" and you trace events only, then the page
is not be filled.

But as there'll be allways lost events, the page will be populated
and it will get out of the loop.

> 
> Jiri,
> 
> Can you reproduce the bug with just he first patch? Actually, I can
> reproduce it on vanilla, I'll apply your first patch and see if that
> fixes things. If not, then we need to find out why and fix those.

The first patch fixies the 'lost evets' trace, so the loop is escaped
when the page is full.
(I was going to send some change for first patch WARN_ON -> WARN_ONCE)

I think in case there are no 'lost events' and we have the conditions
I describe, we need the cond_resched call.

I'll send new patch version shortly.

thanks,
jirka
> 
> -- Steve
> 
> 
