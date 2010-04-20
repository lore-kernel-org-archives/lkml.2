Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0DTFH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 01:07:56 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:43923 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0DTFHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 01:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XDqRBTVV6pFm87VrXMc4FNs83DKtmNwmc83K3N2aJT0vu42POqJLYLk6BXq6ZDefIm
         cdeSYHv3c5PYc61P/PRSwcroj6yRLsLjJL08Rc0Y8BKr6Ib9Jzjvqx2CC/oleDfIEmq3
         FU8AKkIjsYqq+Vzpr4yD2yZNvufSFagCnaPJw=
Subject: Re: request to add trace off and trace on with events
From: Tom Zanussi <tzanussi@gmail.com>
To: rostedt@goodmis.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271707444.10448.12.camel@gandalf.stny.rr.com>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 20 Apr 2010 00:07:50 -0500
Message-Id: <1271740070.6381.41.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 16:04 -0400, Steven Rostedt wrote:
> Hi Tom,
> 
> Could you add a way to do a call to tracing_on() or tracing_off() via
> the filters. I would like to do something like:
> 
> 
> echo 'if (pid == 1234) traceoff' > events/sched/sched_wakeup/filter
> 
> Where, if the sched_wakeup event is hit with pid == 1234 it will turn
> tracing off.
> 
> I would also like to do just:
> 
> echo 'traceoff' > events/sched/sched_wakeup/filter
> 
> to disable tracing every time the event is hit.
> 
> Perhaps you can just add a call back where the kernel could register
> something to be called if a command is used in the filter.
> 
> register_event_command("traceoff", trace_off_cb);
> 
> where the trace_off_cb is a function that is called by the event if the
> traceoff command is hit. This would allow other commands to be added
> later.
> 
> Would something like this be doable, I was looking at the code, and it
> certain looks feasible, but it would take me longer to implement it than
> it would you :-)
> 

If this was all you wanted to do, I think it would be pretty simple to
just pluck off the 'if' and the 'command' from the ends of the filter
string and hook it up to the command callback.

If neither of those were present and you just had a bare filter string,
it would invoke the 'default command' which would do just what it does
now - log it into the trace buffer.

Putting just the 'command' into the filter would also work - it would
always match and unconditionally invoke the command.

The 'if' syntax kind of limits it to a single command per filter though.
If you kept it as an expression e.g.

traceoff(pid == 1234)

or to make it more readable

traceoff_if(pid == 1234)

then you could maybe do things like nesting to fire multiple commands
per hit:

traceoff(logevent((pid == 1234))

That's seems like kind of a stretch, though, and implies chaining.  

Maybe something like:

traceoff,logevent if (pid == 1234)

would be more intuitive (or not).

Anyway, all of these would be pretty easily doable by simply
preprocessing the filter string.  Adding it properly to the parser would
be a little more work, and probably the way to go especially considering
that this wouldn't be the last feature that would be added ;-)

But I think Frederic's idea of decoupling the filters from the triggers
is probably better anyway, and it also allows for different triggers to
be associated with different filters, which the above can't do...

Tom

> Thanks,
> 
> -- Steve
> 
> 

