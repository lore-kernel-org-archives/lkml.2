Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab0CaIB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:01:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36843 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab0CaIBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DfPzgmrQASM1BKFF3JGR5gV0NYDYfWyybuQDKV3UJnvX2FQt8r8XrKTDHC/UDHG/na
         cQhR5T6WH3dBOxFNT0reAs5pZKWZa+9jbCvn1HWNLMLQEaGxPev6P2H4OVkd0Reudj3O
         QG1SZYQKrGwHGi1ekb6OnzXSyJlAO1xrAXUDk=
Date: Wed, 31 Mar 2010 10:01:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHv3 0/2] tracing: function graph output for
	preempt/irqs-off tracers
Message-ID: <20100331080154.GA5229@nowhere>
References: <1269606723-12439-1-git-send-email-jolsa@redhat.com> <1269615239.19685.78.camel@gandalf.stny.rr.com> <20100329111701.GC1715@jolsa> <1269875347.19685.4492.camel@gandalf.stny.rr.com> <20100329152154.GF1715@jolsa> <1269877299.19685.4527.camel@gandalf.stny.rr.com> <20100331073738.GA2152@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331073738.GA2152@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 09:37:38AM +0200, Jiri Olsa wrote:
> On Mon, Mar 29, 2010 at 11:41:39AM -0400, Steven Rostedt wrote:
> > On Mon, 2010-03-29 at 17:21 +0200, Jiri Olsa wrote:
> > 
> > > > Understand what I'm trying to ask?
> > > 
> > > ok, so what you mean is:
> > > - dont clear the max_tr and 
> > > - add function graph events.
> > > 
> > > So when the tracing_enabled and display-graph are disabled we will
> > > get events output rather than 'unknown event' output... right?
> > 
> > Right, although when the display-graph is disabled, we lose the /* */
> > but that's fine.
> 
> ok, I have it done, but found another issue..
> 
> It's the tracer_flags which governs the tracer output. As I'm using
> the function_graph tracer output functions, they follow function_graph
> tracer's flags settings..
> 
> My first idea was a change that would allow tracer using flags
> of other tracers.. so, when enabling irqsoff tracer the function_graph
> tracer's options would become available.
> 
> I made the patch but got to the set_flag function which can be overloaded
> by tracer. So I'd need to remember the flags's tracer, and it does
> not seem right.. :)
> 
> any ideas?
> 
> thanks,
> jirka


Hehe :)

I don't think we need such a feature. I doubt anybody
is going to play with the options granularity of the function
graph tracer there.

We should rather focus on what is useful to display for irqsoff
tracing, which means we need every function graph options set except
funcgraph-overrun that is only there to debug the tracer
itself (I haven't tried it for a while BTW).

What you can do is to save the function graph tracer options
when the irqsoff tracer starts, then overwrite them, and eventually
restore the previous values when the irqsoff reset callback is called.

Or preferably...

Another solution, a bit more proper, is to sanitize a bit the function
graph tracer printing helpers by pushing the options as a parameter to
them.

So the function graph tracer can call them by passing the function graph
tracer options, and the irqsoff tracer or any other tracer can call them
with its own options.

