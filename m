Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1CNOHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:07:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab1CNOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:07:33 -0400
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=u2_5ZAQ68KIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=w1DaJl7zj12HNWzAuV0A:9 a=hAY4_PuGj8YHOQu6YyoA:7 a=rUD7nDIBCanixhGV-OET1-tXNOgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] tracing - putting cond_resched into tace_pipe loop
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110313145811.GA30558@redhat.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
	 <1299970786-8075-3-git-send-email-jolsa@redhat.com>
	 <20110313145811.GA30558@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 10:07:31 -0400
Message-ID: <1300111651.9910.87.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-13 at 15:58 +0100, Oleg Nesterov wrote:
> On 03/12, Jiri Olsa wrote:
> >
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -3237,10 +3237,23 @@ waitagain:
> >  		 * One of the trace_seq_* functions is not used properly.
> >  		 */
> >  		WARN_ON(iter->seq.full);
> > +
> > +		/*
> > +		 * There's a chance this loop might get quite tight,
> > +		 * causing latency in non preemptive kernel.
> > +		 */
> > +		cond_resched();
> > +		if (signal_pending(current)) {
> > +			sret = -EINTR;
> > +			break;
> 
> First of all: I do not pretend I understand this code ;) Still, a
> couple of nits.
> 
> -EINTR doesn't look exactly right, I'd suggest -ERESTARTSYS. The same
> for tracing_wait_pipe() btw, I think it should be fixed.

Yeah, the tracing_wait_pipe() could be changed. I probably copied that
from someplace else in the kernel ;)

> 
> 
> 
> I wonder if it makes sense to simply "break" if signal_pending(), it
> is possible we already have something to report via trace_seq_to_user().
> Then we could do
> 
> 	-	if (sret == -EBUSY)
> 	-		goto waitagain;
> 	+	if (sret == -EBUSY) {
> 	+		if (!signal_pending())
> 	+			goto waitagain;
> 	+		sret = -ERESTARTSYS;
> 	+	}
> 
> Or we can change tracing_wait_pipe() to check signal_pending()
> uncondditionally, I dunno.
> 
> Up to you, but note that otherwise the logic looks a bit strange.
> Suppose that signal_pending() is already true when we call
> tracing_wait_pipe(). In this case we are going to do the "unnecessary"
> work and then return EINTR/ERESTART. This is correct, the next
> invocation does trace_seq_to_user() before anything else, just
> looks a bit strange.

I'm not sure that this needs the signal_pending() or the break, or even
the cond_resched(). Perhaps the first patch fixes the bug. But that
while loop does not block, and it should just spin enough to fill a
page. If it is not filling the page then that's a bug.

Jiri,

Can you reproduce the bug with just he first patch? Actually, I can
reproduce it on vanilla, I'll apply your first patch and see if that
fixes things. If not, then we need to find out why and fix those.

-- Steve


