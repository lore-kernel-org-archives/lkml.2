Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab0CTEvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 00:51:54 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47897 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0CTEvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 00:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qrSI/dRVALMMG7A4tddIHrJlSR2QWrCZDXkHOJYgKiMSuJeLlUUVYHMAFDpA9jvU8q
         97ogwE/gnc7pcL9ixgFZ8lPeUVCYyYjWnfgbpCWGz6yhntYJuZGypUuNxWFJOrYpSL+Y
         RR2PX6Ey2ey+iTMQt0UHdJDP8MvUcQcyW2et8=
Date: Sat, 20 Mar 2010 05:51:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100320045150.GM5085@nowhere>
References: <4BA1C141.8050409@dcl.info.waseda.ac.jp> <20100318211633.GG5103@nowhere> <20100319010857.GC23020@Krystal> <20100319012337.GA22095@nowhere> <20100319013658.GB28456@Krystal> <20100319022659.GC22095@nowhere> <20100319024042.GB28941@Krystal> <20100319030611.GE22095@nowhere> <20100319125600.GA12211@Krystal> <20100319160041.GA2658@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319160041.GA2658@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 12:00:41PM -0400, Jason Baron wrote:
> On Fri, Mar 19, 2010 at 08:56:00AM -0400, Mathieu Desnoyers wrote:
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > On Thu, Mar 18, 2010 at 10:40:42PM -0400, Mathieu Desnoyers wrote:
> > > > Well, the use-case that drove the asm goto implementation _is_ the tracepoints.
> > > > ;)
> > > > 
> > > > > 
> > > > > But, looking at __DO_TRACE:
> > > > > 
> > > > > 	if (it_func) {						\
> > > > > 		do {						\
> > > > > 			((void(*)(proto))(*it_func))(args);	\
> > > > > 		} while (*(++it_func));				\
> > > > > 	}
> > > > > 
> > > > > I would expect the compiler not to load the parameters in the stack
> > > > > before first checking the branch.
> > > > 
> > > > Note that you have to put that in its full context. It's a macro expanded within
> > > > a static inline function. The initial parameters are passed to the static
> > > > inline, not directly as "args" here. So parameters with side-effects have to be
> > > > evaluated before their result can be passed to the static inline function, so in
> > > > that sense their evaluation cannot be moved into the conditional branch.
> > > 
> > > 
> > > Evaluation yeah, I agree. A function passed as an argument is
> > > going to be evaluated indeed, or whatever thing that has a side effect.
> > > But there is nothing here that need to setup the parameters to the stack
> > > right before the true tracepoint call, not until we passed the branch check
> > > once.
> > > 
> > >  
> > > > > So, the fact that parameters are not loaded before we know we'll call
> > > > > the tracepoint is something we already have or is it something that the jump
> > > > > label brings in the package somehow?
> > > > 
> > > > It's standard compiler optimization behavior.
> > > 
> > > 
> > > Sure. My doubt is: currently with the upstream version, does the
> > > compiler tend to load the parameters to the stack before the branch is
> > > checked? Or is this a magic that jmp labels bring for whatever reason?
> > 
> > Even without the static jump patching, the compiler takes care of putting the
> > stack setup after the branch is checked. That worked with a standard test on a
> > variable, with immediate values and should still work with asm gotos.
> 
> right. stack setup happens after the branch is checked for asm gotos as
> well. However, as mentioned functions as parameters, which have side-effects
> need to be evaluated in the off case, there's nothing to be done about
> that as its a correctness issue.
> 
> Hoever, constructs like a->b, do evaluated even in the disabled case.
> This could be solved via macros, see my proposed patch set: 
> http://marc.info/?l=linux-kernel&m=124276710606872&w=2
> 
> However, the conclusion of the thread was that this should be done in
> the compiler, and as such I filed a bug with gcc about this issue.
> 
> I'll re-post an updated jump label series shortly.


Ok, thanks guys for these informations.

